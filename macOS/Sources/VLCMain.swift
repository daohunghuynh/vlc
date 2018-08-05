//
//  VLCMain.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 10/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

let VLCInputChangedNotification = NSNotification.Name("VLCInputChangedNotification")
let VLCConfigurationChangedNotification = NSNotification.Name("VLCConfigurationChangedNotification")
let VLCMediaKeySupportSettingChangedNotification = NSNotification.Name("VLCMediaKeySupportSettingChangedNotification")


func _NS(_ s: String?) -> String {
    return s != nil ? s! : ""
}

// MARK: - VLC Interface Object Callbacks

/*****************************************************************************
 * OpenIntf: initialize interface
 *****************************************************************************/

fileprivate var p_interface_thread: UnsafeMutablePointer<intf_thread_t>?

func getIntf() -> UnsafeMutablePointer<intf_thread_t>? {
    return p_interface_thread
}

func OpenIntf(p_this: UnsafeMutablePointer<vlc_object_t>) -> Int32 {
    return autoreleasepool { () -> Int32 in
        let p_interface_thread = p_this.as_intf_thread_pointer()
        msg_Dbg(p_intf, "Starting macosx interface")
        do {
            Bundle.main.loadNibNamed(NSNib.Name("MainMenu"), owner: VLCMain.instance.mainMenu, topLevelObjects: nil)
//            VLCMain.instance.mainWindow.makeKeyAndOrderFront:nil

            msg_Dbg(p_intf, "Finished loading macosx interface")
            return VLC_SUCCESS
        } catch {
            msg_Err(p_intf, "Loading the macosx interface failed. Do you have a valid window server?")
            return VLC_EGENERIC
        }
    }
}

func CloseIntf(p_this: UnsafeMutablePointer<vlc_object_t>) {
    autoreleasepool {
        msg_Dbg(p_this, "Closing macosx interface")
        VLCMain.instance.applicationWillTerminate(Notification(name: NSApplication.willTerminateNotification, object: nil, userInfo: nil))
        VLCMain.killInstance()
        /*
         * Spinning the event loop here is important to help cleaning up all objects which should be
         * destroyed here. Its possible that main thread selectors (which hold a strong reference
         * to the target object), are still in the queue (e.g. fired from variable callback).
         * Thus make sure those are still dispatched and the references to the targets are
         * cleared, to allow the objects to be released.
         */
        msg_Dbg(p_this, "Spin the event loop to clean up the interface")
        RunLoop.main.run(until: Date())

        p_interface_thread = nil
    }
}

// MARK: - Variables Callback

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


class VLCMain: NSObject, NSWindowDelegate, NSApplicationDelegate {

    private var _launched: Bool = false
    private var _activeVideoPlayback: Bool = false
    //    private VLCPrefs *_prefs
    //    private VLCSimplePrefsController *_sprefs
    //    private VLCCoreDialogProvider *_coredialogs
    //    private VLCBookmarksWindowController *_bookmarks
    private var _coreinteraction: VLCCoreInteraction!
    private var _resume_dialog: VLCResumeDialogController?
    //    private VLCLogWindowController *_messagePanelController
//    lazy private var _trackSyncPanel: VLCTrackSynchronizationWindowController
    //    private VLCAudioEffectsWindowController *_audioEffectsPanel
    //    private VLCVideoEffectsWindowController *_videoEffectsPanel
    //    private VLCConvertAndSaveWindowController *_convertAndSaveWindow
    //    private VLCInfo *_currentMediaInfoPanel
    private var _intfTerminating: Bool = false // Makes sure applicationWillTerminate will be called only once

    let inputManager: VLCInputManager
    let mainMenu: VLCMainMenu
    let extensionsManager: VLCExtensionsManager
    var voutController: VLCVoutWindowController
    let resumeDialog = VLCResumeDialogController()
//@property (nonatomic, readwrite) Bool playlistUpdatedSelectorInQueue
//- (VLCBookmarksWindowController *)bookmarks
//- (VLCSimplePrefsController *)simplePreferences
//- (VLCPrefs *)preferences
    let playlist: VLCPlaylist
//- (VLCCoreDialogProvider *)coreDialogProvider
//- (VLCLogWindowController *)debugMsgPanel
//- (VLCAudioEffectsWindowController *)audioEffectsPanel
//- (VLCVideoEffectsWindowController *)videoEffectsPanel
//- (VLCInfo *)currentMediaInfoPanel
//- (VLCConvertAndSaveWindowController *)convertAndSaveWindow

// MARK: - Initialization

    static var instance: VLCMain! = VLCMain()

    class func killInstance() {
        instance = nil
    }

    private override init() {
        self.extensionsManager = VLCExtensionsManager()
        self.inputManager = VLCInputManager(withMain: self)
//            // first initalize extensions dialog provider, then core dialog
//            // provider which will register both at the core
//            self.coredialogs = VLCCoreDialogProvider()
        self.mainMenu = VLCMainMenu()
//            self.statusBarIcon = [[VLCStatusBarIcon  alloc] init]
        self.playlist = VLCPlaylist()
        self.voutController = VLCVoutWindowController()

        let p_intf = getIntf()!
//            var_AddCallback(p_intf->obj.libvlc, "intf-toggle-fscontrol", ShowController, (__bridge void *)self)
//            var_AddCallback(p_intf->obj.libvlc, "intf-show", ShowController, (__bridge void *)self)
//
//            // Load them here already to apply stored profiles
//            self.videoEffectsPanel = VLCVideoEffectsWindowController()
//            self.audioEffectsPanel = VLCAudioEffectsWindowController()

        let p_playlist = pl_Get(p_intf)!
        if NSApp.currentSystemPresentationOptions.contains(.fullScreen) {
            var_SetBool(p_playlist.as_vlc_object_pointer(), "fullscreen", true)
        }

        super.init()
        VLCApplication.shared.delegate = self
    }

    deinit {
        msg_Dbg(getIntf(), "Deinitializing VLCMain object")
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        _coreinteraction = VLCCoreInteraction.instance
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        _launched = true
        _coreinteraction.updateCurrentlyUsedHotkeys()

        /* Handle sleep notification */
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.computerWillSleep), name: NSWorkspace.willSleepNotification, object: nil)

        /* update the main window */
//        self.mainWindow.updateWindow
//        self.mainWindow.updateTimeSlider
//        self.mainWindow.updateVolumeSlider

        // respect playlist-autostart
        // note that PLAYLIST_PLAY will not stop any playback if already started
        let p_playlist = pl_Get(getIntf())!
        playlist_Lock(p_playlist)
        let kidsAround = p_playlist.pointee.p_playing.pointee.i_children != 0
        if kidsAround && var_GetBool(p_playlist.as_vlc_object_pointer(), "playlist-autostart") {
            vplaylist_Control(p_playlist, Int32(PLAYLIST_PLAY), 1)
        }
        playlist_Unlock(p_playlist)
    }

// MARK: - Termination

    var isTerminating: Bool {
        return _intfTerminating
    }

    func applicationWillTerminate(_ notification: Notification) {
        let intf = getIntf()!
        msg_Dbg(intf, "applicationWillTerminate called")

        guard !_intfTerminating else {
            return
        }

        _intfTerminating = true
        self.inputManager.onPlaybackHasEnded(nil)

//    /* save current video and audio profiles */
//    self.videoEffectsPanel.saveCurrentProfileAtTerminate
//    self.audioEffectsPanel.saveCurrentProfileAtTerminate

        let p_playlist = pl_Get(intf).as_vlc_object_pointer()
        /* Save some interface state in configuration, at module quit */
        config_PutInt("random", var_GetBool(p_playlist, "random") ? 1 : 0)
        config_PutInt("loop", var_GetBool(p_playlist, "loop") ? 1 : 0)
        config_PutInt("repeat", var_GetBool(p_playlist, "repeat") ? 1 : 0)

//    var_DelCallback(p_intf->obj.libvlc, "intf-toggle-fscontrol", ShowController, (__bridge void *)self)
//    var_DelCallback(p_intf->obj.libvlc, "intf-show", ShowController, (__bridge void *)self)

        NotificationCenter.default.removeObserver(self)
        /* closes all open vouts */
        self.voutController = nil
        /* write cached user defaults to disk */
        UserDefaults.standard.synchronize()
    }

// MARK: - Other notification

    /* Listen to the remote in exclusive mode, only when VLC is the active
       application */
    func applicationDidBecomeActive(_ notification: Notification) {
//        if var_InheritBool(self.p_intf.as_vlc_object_pointer(), "macosx-appleremote") == true {
//            _coreinteraction.startListeningWithAppleRemote()
//        }
    }

    func applicationDidResignActive(_ notification: Notification) {
//        _coreinteraction.stopListeningWithAppleRemote()
    }

    /* Triggered when the computer goes to sleep */
    @objc func computerWillSleep(_ notification: Notification) {
        _coreinteraction.pause()
    }

// MARK: - File opening over dock icon

    func application(_ sender: NSApplication, openFiles filenames: [String]) {

        // Only add items here which are getting dropped to to the application icon
        // or are given at startup. If a file is passed via command line, libvlccore
        // will add the item, but cocoa also calls this function. In this case, the
        // invocation is ignored here.
        var resultItems = filenames

        if _launched == false {
            let launchArgs: [String] = ProcessInfo.processInfo.arguments
            if launchArgs.count > 0 {
                let launchArgsSet = Set(launchArgs)
                var itemSet = Set(filenames)
                itemSet.subtract(launchArgsSet)
                resultItems = Array<String>(itemSet)
            }
        }

        let sortedNames = resultItems.sorted { lh, rh in lh.lowercased() < rh.lowercased() }
        var fileUriList: [Dictionary<String, String>] = []
        for name in sortedNames {
            if let p_uri = vlc_path2uri(name, "file") {
                let dic = ["ITEM_URL" : String(cString: p_uri)]
                fileUriList.append(dic)
                free(p_uri)
            }
        }
        self.playlist.addPlaylistItems(fileUriList, tryAsSubtitle: true)
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

            _activeVideoPlayback = newValue
//            self.mainWindow?.setVideoplayEnabled()
            // update sleep blockers
            self.inputManager.playbackStatusUpdated()
        }
        get {
            return _activeVideoPlayback
        }
    }

// MARK: - Other objects getters

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

//    var trackSyncPanel: VLCTrackSynchronizationWindowController {
//        return _trackSyncPanel
//    }

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
//                            func coreDialogProvider -> VLCCoreDialogProvider *
//                                {
//                                    return self.coredialogs
//                                }
}

class VLCApplication: NSApplication {
    override func terminate(_ sender: Any?) {
        activate(ignoringOtherApps: true)
        stop(sender)
    }
}
