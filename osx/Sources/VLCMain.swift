//
//  VLCMain.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 10/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

func _NS(_ s: String?) -> String {
    return s != nil ? s! : ""
}
//#pragma mark VLC Interface Object Callbacks

/*****************************************************************************
 * OpenIntf: initialize interface
 *****************************************************************************/

fileprivate var p_interface_thread: UnsafeMutablePointer<intf_thread_t>?

func getIntf() -> UnsafeMutablePointer<intf_thread_t>? {
    return p_interface_thread
}

func OpenIntf(p_this: UnsafeMutablePointer<vlc_object_t>) -> Int32 {
    return autoreleasepool { () -> Int32 in
        let p_intf = p_this.as_intf_thread_pointer()
        p_interface_thread = p_intf
//        msg_Dbg(p_intf, "Starting macosx interface")

        do {
            Bundle.main.loadNibNamed(NSNib.Name("MainMenu"), owner: VLCMain.instance.mainMenu, topLevelObjects: nil)
//            VLCMain.instance.mainWindow.makeKeyAndOrderFront:nil

//            msg_Dbg(p_intf, "Finished loading macosx interface")
            return VLC_SUCCESS
        } catch {
//            msg_Err(p_intf, "Loading the macosx interface failed. Do you have a valid window server?")
            return VLC_EGENERIC
        }
    }
}

func CloseIntf(p_this: UnsafeMutablePointer<vlc_object_t>) {
    autoreleasepool {
//        msg_Dbg(p_this, "Closing macosx interface")
        VLCMain.instance.applicationWillTerminate(Notification(name: NSApplication.willTerminateNotification, object: nil, userInfo: nil))
        VLCMain.killInstance()

        /*
         * Spinning the event loop here is important to help cleaning up all objects which should be
         * destroyed here. Its possible that main thread selectors (which hold a strong reference
         * to the target object), are still in the queue (e.g. fired from variable callback).
         * Thus make sure those are still dispatched and the references to the targets are
         * cleared, to allow the objects to be released.
         */
//        msg_Dbg(p_this, "Spin the event loop to clean up the interface")
        RunLoop.main.run(until: Date())

        p_interface_thread = nil
    }
}

//    MARK: - Variables Callback

/*****************************************************************************
 * ShowController: Callback triggered by the show-intf playlist variable
 * through the ShowIntf-control-intf, to let us show the controller-win
 * usually when in fullscreen-mode
 *****************************************************************************/
//static int ShowController(vlc_object_t *p_this, const char *psz_variable,
//vlc_value_t old_val, vlc_value_t new_val, void *param)
//{
//    @autoreleasepool {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            intf_thread_t * p_intf = getIntf()
//            if (p_intf) {
//                playlist_t * p_playlist = pl_Get(p_intf)
//                Bool b_fullscreen = var_GetBool(p_playlist, "fullscreen")
//                if (b_fullscreen)
//                VLCMain.instance.showFullscreenController
//
//                else if (!strcmp(psz_variable, "intf-show"))
//                VLCMain.instance.mainWindow.makeKeyAndOrderFront:nil
//            }
//
//            })
//
//        return VLC_SUCCESS
//    }
//}


class VLCMain : NSObject, NSWindowDelegate, NSApplicationDelegate {

    private var p_intf: UnsafeMutablePointer<intf_thread_t>!
    private var launched: Bool = false
    private var b_active_videoplayback: Bool = false
    //    private VLCPrefs *_prefs
    //    private VLCSimplePrefsController *_sprefs
    //    private VLCCoreDialogProvider *_coredialogs
    //    private VLCBookmarksWindowController *_bookmarks
    private var coreinteraction: VLCCoreInteraction!
    //    private VLCResumeDialogController *_resume_dialog
    private var input_manager: VLCInputManager
    //    private VLCPlaylist *_playlist
    //    private VLCLogWindowController *_messagePanelController
    //    private VLCTrackSynchronizationWindowController *_trackSyncPanel
    //    private VLCAudioEffectsWindowController *_audioEffectsPanel
    //    private VLCVideoEffectsWindowController *_videoEffectsPanel
    //    private VLCConvertAndSaveWindowController *_convertAndSaveWindow
    //    private VLCExtensionsManager *_extensionsManager
    //    private VLCInfo *_currentMediaInfoPanel
    private var b_intf_terminating: Bool = false /* Makes sure applicationWillTerminate will be called only once */


    let mainMenu: VLCMainMenu

    let extensionsManager: VLCExtensionsManager

    var voutController: VLCVoutWindowController!

    var inputManager: VLCInputManager {
        return self.input_manager
    }

//@property (nonatomic, readwrite) Bool playlistUpdatedSelectorInQueue
    //- (VLCBookmarksWindowController *)bookmarks
//- (VLCSimplePrefsController *)simplePreferences
//- (VLCPrefs *)preferences
//    let playlist: VLCPlaylist
//- (VLCCoreDialogProvider *)coreDialogProvider
//- (VLCResumeDialogController *)resumeDialog

//- (VLCLogWindowController *)debugMsgPanel
//- (VLCTrackSynchronizationWindowController *)trackSyncPanel
//- (VLCAudioEffectsWindowController *)audioEffectsPanel
//- (VLCVideoEffectsWindowController *)videoEffectsPanel
//- (VLCInfo *)currentMediaInfoPanel

//- (VLCConvertAndSaveWindowController *)convertAndSaveWindow
//- (void)setActiveVideoPlayback:(Bool)b_value
//- (void)applicationWillTerminate(_ notification: Notification)

//    MARK: - Initialization

    static var instance: VLCMain! = VLCMain()

    class func killInstance() {
        instance = nil
    }

    private override init() {
        extensionsManager = VLCExtensionsManager()

        self.p_intf = getIntf()

        self.input_manager = VLCInputManager()
//
//            // first initalize extensions dialog provider, then core dialog
//            // provider which will register both at the core
//            self.coredialogs = VLCCoreDialogProvider()

        self.mainMenu = VLCMainMenu()
//            self.statusBarIcon = [[VLCStatusBarIcon  alloc] init]
//
        self.voutController = VLCVoutWindowController()
//        self.playlist = VLCPlaylist()

//            var_AddCallback(p_intf->obj.libvlc, "intf-toggle-fscontrol", ShowController, (__bridge void *)self)
//            var_AddCallback(p_intf->obj.libvlc, "intf-show", ShowController, (__bridge void *)self)
//
//            // Load them here already to apply stored profiles
//            self.videoEffectsPanel = VLCVideoEffectsWindowController()
//            self.audioEffectsPanel = VLCAudioEffectsWindowController()

//            playlist_t *p_playlist = pl_Get(p_intf)
//            if (NSApp.currentSystemPresentationOptions & NSApplicationPresentationFullScreen)
//            var_SetBool(p_playlist, "fullscreen", true)

        super.init()

        VLCApplication.shared.delegate = self
    }

//    func dealloc -> void
//    {
//    msg_Dbg(getIntf(), "Deinitializing VLCMain object")
//    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        self.coreinteraction = VLCCoreInteraction.instance
//    #ifdef HAVE_SPARKLE
//    SUUpdater.sharedUpdater.setDelegate:self
//#endif
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.launched = true

        self.coreinteraction.updateCurrentlyUsedHotkeys()

        /* Handle sleep notification */
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.computerWillSleep), name: NSWorkspace.willSleepNotification, object: nil)

        /* update the main window */
//        self.mainWindow.updateWindow
//        self.mainWindow.updateTimeSlider
//        self.mainWindow.updateVolumeSlider

        // respect playlist-autostart
        // note that PLAYLIST_PLAY will not stop any playback if already started
        let p_playlist: UnsafeMutablePointer<playlist_t> = pl_Get(getIntf())
//        PL_LOCK;
        let kidsAround = p_playlist.pointee.p_playing.pointee.i_children != 0
        if kidsAround && var_GetBool(p_playlist.as_vlc_object_pointer(), "playlist-autostart") {
            vplaylist_Control(p_playlist, Int32(PLAYLIST_PLAY), 1)
        }
//        PL_UNLOCK;
    }

//    MARK: - Termination

    var isTerminating: Bool {
        return self.b_intf_terminating
    }

    func applicationWillTerminate(_ notification: Notification) {
//    msg_Dbg(getIntf(), "applicationWillTerminate called")
        guard !self.b_intf_terminating else {
            return
        }

        let p_playlist = pl_Get(getIntf()).as_vlc_object_pointer()

        self.b_intf_terminating = true
        self.input_manager.onPlaybackHasEnded(nil)

//    /* save current video and audio profiles */
//    self.videoEffectsPanel.saveCurrentProfileAtTerminate
//    self.audioEffectsPanel.saveCurrentProfileAtTerminate
//
//    /* Save some interface state in configuration, at module quit */
        config_PutInt("random", var_GetBool(p_playlist, "random") ? 1 : 0)
        config_PutInt("loop", var_GetBool(p_playlist, "loop") ? 1 : 0)
        config_PutInt("repeat", var_GetBool(p_playlist, "repeat") ? 1 : 0)

//    var_DelCallback(p_intf->obj.libvlc, "intf-toggle-fscontrol", ShowController, (__bridge void *)self)
//    var_DelCallback(p_intf->obj.libvlc, "intf-show", ShowController, (__bridge void *)self)

        NotificationCenter.default.removeObserver(self)

        // closes all open vouts
        self.voutController = nil
        /* write cached user defaults to disk */
        UserDefaults.standard.synchronize()
    }

//#pragma mark Sparkle delegate

//#ifdef HAVE_SPARKLE
///* received directly before the update gets installed, so let's shut down a bit */
//func updater:(SUUpdater *)updater willInstallUpdate:(SUAppcastItem *)update -> void
//{
//    NSApp.activateIgnoringOtherApps:true
//    self.coreinteraction.stopListeningWithAppleRemote
//    self.coreinteraction.stop
//    }
//
//    /* don't be enthusiastic about an update if we currently play a video */
//    func updaterMayCheckForUpdates:(SUUpdater *)bundle -> Bool
//{
//    if (self.activeVideoPlayback)
//    return false
//
//    return true
//}
//#endif

//    MARK: - Other notification

    /* Listen to the remote in exclusive mode, only when VLC is the active
       application */
    func applicationDidBecomeActive(_ notification: Notification) {
//        if var_InheritBool(self.p_intf.as_vlc_object_pointer(), "macosx-appleremote") == true {
//            self.coreinteraction.startListeningWithAppleRemote()
//        }
    }

    func applicationDidResignActive(_ notification: Notification) {
//        self.coreinteraction.stopListeningWithAppleRemote()
    }

    /* Triggered when the computer goes to sleep */
    @objc func computerWillSleep(_ notification: Notification) {
        self.coreinteraction.pause()
    }

//  MARK: - File opening over dock icon

    func application(_ sender: NSApplication, openFiles filenames: [String]) {

        // Only add items here which are getting dropped to to the application icon
        // or are given at startup. If a file is passed via command line, libvlccore
        // will add the item, but cocoa also calls this function. In this case, the
        // invocation is ignored here.
        var resultItems = filenames

        if self.launched == false {
            let launchArgs: [String] = ProcessInfo.processInfo.arguments

            if launchArgs.count > 0 {
                let launchArgsSet = Set(launchArgs)
                var itemSet = Set(filenames)
                itemSet.subtract(launchArgsSet)
                resultItems = Array<String>(itemSet)
            }
        }

        let o_sorted_names = resultItems.sorted() { lh, rh in lh.lowercased() < rh.lowercased() }
        var o_result: [Dictionary<String, String>] = []
        for i in 0..<o_sorted_names.count {
            if let psz_uri = vlc_path2uri(o_sorted_names[i], "file") {
                let o_dic = ["ITEM_URL" : String(cString: psz_uri)]
                o_result.append(o_dic)
                free(psz_uri)
            }
        }
//        self.playlist.addPlaylistItems(o_result, tryAsSubtitle: true)
    }

    /* When user click in the Dock icon or double click in the finder */
//    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
//        if !flag {
//            self.mainWindow.makeKeyAndOrderFront(self)
//        }
//        return true
//    }

    var activeVideoPlayback: Bool {
        set {
            assert(Thread.isMainThread)

            self.b_active_videoplayback = newValue
//            self.mainWindow?.setVideoplayEnabled()
            // update sleep blockers
            self.input_manager.playbackStatusUpdated()
        }
        get {
            return self.b_active_videoplayback
        }
    }

//  MARK: - Other objects getters

//    func statusBarIcon -> VLCStatusBarIcon *
//        {
//            return self.statusBarIcon
//        }

//                    func debugMsgPanel -> VLCLogWindowController *
//                        {
//                            if (!_messagePanelController)
//                            self.messagePanelController = VLCLogWindowController()
//
//                            return self.messagePanelController
//                        }

//                        func trackSyncPanel -> VLCTrackSynchronizationWindowController *
//                            {
//                                if (!_trackSyncPanel)
//                                self.trackSyncPanel = VLCTrackSynchronizationWindowController()
//
//                                return self.trackSyncPanel
//                            }

//                            func audioEffectsPanel -> VLCAudioEffectsWindowController *
//                                {
//                                    return self.audioEffectsPanel
//                                }

//                                func videoEffectsPanel -> VLCVideoEffectsWindowController *
//                                    {
//                                        return self.videoEffectsPanel
//                                    }

//                                    func currentMediaInfoPanel -> VLCInfo *
//{
//    if (!_currentMediaInfoPanel)
//    self.currentMediaInfoPanel = VLCInfo()
//
//    return self.currentMediaInfoPanel
//    }

//    func bookmarks -> VLCBookmarksWindowController *
//        {
//            if (!_bookmarks)
//            self.bookmarks = VLCBookmarksWindowController()
//
//            return self.bookmarks
//        }

//    lazy var open = VLCOpenWindowController()


//            func convertAndSaveWindow -> VLCConvertAndSaveWindowController *
//                {
//                    if (_convertAndSaveWindow == nil)
//                    self.convertAndSaveWindow = VLCConvertAndSaveWindowController()
//
//                    return self.convertAndSaveWindow
//                }
//
//                func simplePreferences -> VLCSimplePrefsController *
//                    {
//                        if (!_sprefs)
//                        self.sprefs = VLCSimplePrefsController()
//
//                        return self.sprefs
//                    }
//
//                    func preferences -> VLCPrefs *
//                        {
//                            if (!_prefs)
//                            self.prefs = VLCPrefs()
//
//                            return self.prefs
//                        }
//
//                        func playlist -> VLCPlaylist *
//                            {
//                                return self.playlist
//                            }
//
//                            func coreDialogProvider -> VLCCoreDialogProvider *
//                                {
//                                    return self.coredialogs
//                                }
//
//                                func resumeDialog -> VLCResumeDialogController *
//                                    {
//                                        if (!_resume_dialog)
//                                        self.resume_dialog = VLCResumeDialogController()
//
//                                        return self.resume_dialog
//                                    }

}

class VLCApplication : NSApplication {
    override func terminate(_ sender: Any?) {
        self.activate(ignoringOtherApps: true)
        self.stop(sender)
    }
}
