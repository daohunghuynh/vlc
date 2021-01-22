//
//  VLCMainWindow.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 31/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation


//enum VLCPlaylistStateEvent {
//    psUserEvent,
//    psUserMenuEvent,
//    psVideoStartedOrStoppedEvent,
//    psPlaylistItemChangedEvent
//}

class VLCMainWindow: VLCVideoWindowCommon {

    private var _frameBeforePlayback: NSRect = NSZeroRect
    private var _minimized_view: Bool = false


    // MARK: - Initialization

    private func isEvent(_ event: NSEvent, forKey key: String) -> Bool {
//        let key = config_GetPsz(keyString)
        let keyString = String(cString: config_GetPsz(key))
//        FREENULL(key);

        let keyModifiers = NSEvent.ModifierFlags(rawValue: UInt(VLCStringUtility.sharedInstance().vlcModifiers(toCocoa: keyString)))

        if let characters = event.charactersIgnoringModifiers, characters.count > 0 {
            return characters.lowercased() == VLCStringUtility.sharedInstance().vlcKey(to: keyString) &&
                keyModifiers.intersection(.shift)     == event.modifierFlags.intersection(.shift) &&
                keyModifiers.intersection(.control)   == event.modifierFlags.intersection(.control) &&
                keyModifiers.intersection(.command)   == event.modifierFlags.intersection(.command)
        }
        return false
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        var force = false
        // these are key events which should be handled by vlc core, but are attached to a main menu item
        if !isEvent(event, forKey: "key-vol-up") &&
            !isEvent(event, forKey: "key-vol-down") &&
            !isEvent(event, forKey: "key-vol-mute") &&
            !isEvent(event, forKey: "key-jump+short") &&
            !isEvent(event, forKey: "key-jump-short") {
            /* We indeed want to prioritize some Cocoa key equivalent against libvlc,
             so we perform the menu equivalent now. */
            if NSApp.mainMenu!.performKeyEquivalent(with: event) {
                return true
            }
        } else {
            force = true
        }

        let coreInteraction = VLCCoreInteraction.instance
        return coreInteraction.hasDefinedShortcutKey(event: event, force: force) || coreInteraction.keyEvent(event)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        /*
         * General setup
         */

        let defaultCenter = NotificationCenter.default
        let defaults = UserDefaults.standard

        var splitViewShouldBeHidden = false

        self.delegate = self
        self.isRestorable = false
        self.isExcludedFromWindowsMenu = true
        self.acceptsMouseMovedEvents = true
        self.setFrameAutosaveName("mainwindow")

        // Playlist setup
//        VLCPlaylist *playlist = [[VLCMain sharedInstance] playlist];
//        [playlist setOutlineView:(VLCPlaylistView *)_outlineView];
//        [playlist setPlaylistHeaderView:_outlineView.headerView];
//        [self setNextResponder:playlist];

        // (Re)load sidebar for the first time and select first item
//        [self reloadSidebar];


        /*
         * Set up translatable strings for the UI elements
         */

        // Window title
        self.title = "VLC video player"

        /* interface builder action */
        let f_threshold_height = MIN_VIDEO_HEIGHT + self.controlsBar.height

//        if self.contentView.frame.size.height < f_threshold_height {
//            splitViewShouldBeHidden = YES;
//        }

        // Set that here as IB seems to be buggy
        self.contentMinSize = NSMakeSize(604, MIN_VIDEO_HEIGHT)

        /* make sure we display the desired default appearance when VLC launches for the first time */
//        if defaults.object(forKey: "VLCFirstRun") == nil {
//            defaults.set(Date(), forKey: "VLCFirstRun")
//        }

        defaultCenter.addObserver(self, selector: #selector(someWindowWillClose), name: NSWindow.willCloseNotification, object: nil)
        defaultCenter.addObserver(self, selector: #selector(someWindowWillMiniaturize), name: NSWindow.willMiniaturizeNotification, object:nil)
        defaultCenter.addObserver(self, selector: #selector(applicationWillTerminate), name: NSApplication.willTerminateNotification, object: nil)

        /* sanity check for the window size */
        let frame = self.frame
        let screenSize = self.screen!.frame.size
        if screenSize.width <= frame.size.width || screenSize.height <= frame.size.height {
            self.nativeVideoSize = screenSize
            self.resizeWindow()
        }
    }

    // MARK: - appearance management

//    func changePlaylistState(event: VLCPlaylistStateEvent) {
//        // Beware, this code is really ugly
//
////        msg_Dbg(getIntf(), "toggle playlist from state: removed splitview %i, minimized view %i. Event %i", b_splitview_removed, b_minimized_view, event);
//        if !self.isVisible && event == psUserMenuEvent {
//            self.makeKeyAndOrderFront(nil)
//            return
//        }
//
//        var b_activeVideo: Bool = VLCMain.sharedInstance.activeVideoPlayback
//        var b_restored = false
//
//        // ignore alt if triggered through main menu shortcut
//        var b_have_alt_key = NSApp.currentEvent!.modifierFlags.contains(.option)
//        if event == psUserMenuEvent {
//            b_have_alt_key = false
//        }
//
//        // eUserMenuEvent is now handled same as eUserEvent
//        if event == psUserMenuEvent {
//            event = psUserEvent
//        }
//
//        if (!(self.nativeFullscreenMode && self.fullscreen) && !b_splitview_removed && ((b_have_alt_key && b_activeVideo)
//        || (self.nonembedded && event == psUserEvent)
//        || (!b_activeVideo && event == psUserEvent)
//        || (b_minimized_view && event == psVideoStartedOrStoppedEvent))) {
//        // for starting playback, window is resized through resized events
//        // for stopping playback, resize through reset to previous frame
//        [self hideSplitView: event != psVideoStartedOrStoppedEvent];
//        b_minimized_view = NO;
//        } else {
//        if (b_splitview_removed) {
//        if (!self.nonembedded || (event == psUserEvent && self.nonembedded))
//        [self showSplitView: event != psVideoStartedOrStoppedEvent];
//
//        if (event != psUserEvent)
//        b_minimized_view = YES;
//        else
//        b_minimized_view = NO;
//
//        if (b_activeVideo)
//        b_restored = YES;
//        }
//
//        if (!self.nonembedded) {
//        if (([self.videoView isHidden] && b_activeVideo) || b_restored || (b_activeVideo && event != psUserEvent))
//        [self makeSplitViewHidden];
//        else
//        [self makeSplitViewVisible];
//        } else {
//        [_splitView setHidden: NO];
//        [_playlistScrollView setHidden: NO];
//        [self.videoView setHidden: YES];
//        [self showControlsBar];
//        }
//        }
//
//        msg_Dbg(getIntf(), "toggle playlist to state: removed splitview %i, minimized view %i", b_splitview_removed, b_minimized_view);
//    }

    // MARK: - overwritten default functionality

    @objc private func applicationWillTerminate(_ notification: Notification) {
        self.saveFrame(usingName: self.frameAutosaveName)
    }


    @objc private func someWindowWillClose(_ notification: Notification) {
        // hasActiveVideo is defined for VLCVideoWindowCommon and subclasses
        if let window = notification.object as? VLCWindow, window.hasActiveVideo {
            if VLCMain.sharedInstance()!.activeVideoPlayback() {
                VLCCoreInteraction.instance.stop()
            }
        }
    }

    @objc private func someWindowWillMiniaturize(_ notification: Notification) {
        if config_GetInt("macosx-pause-minimized") != 0 {
            if notification.object is VLCVideoWindowCommon || notification.object is VLCDetachedVideoWindow || (notification.object is VLCMainWindow) {
                if VLCMain.sharedInstance()!.activeVideoPlayback() {
                    VLCCoreInteraction.instance.pause()
                }
            }
        }
    }

    // MARK: - Update interface and respond to foreign events

    private func updateTimeSlider() {
        self.controlsBar.updateTimeSlider()
        VLCMain.sharedInstance().voutProvider.updateControlsBars { (controlsBar: VLCControlsBarCommon?) in
            controlsBar?.updateTimeSlider()
        }

        VLCCoreInteraction.instance.updateAtoB()
    }

    private func updateName() {

        if let p_input = pl_CurrentInput(getIntf()) {
            var aString = ""

            if config_GetPsz("video-title") == nil {
                if let format = var_InheritString(getIntf().as_vlc_object_pointer(), "input-title-format") {
                    let formated = vlc_strfinput(p_input, format)
                    free(format)
                    aString = String(cString: formated!)
                    free(formated)
                }
            } else {
                aString = String(cString: config_GetPsz("video-title"))
            }

            let uri = input_item_GetURI(input_GetItem(p_input))

            let o_url = URL(string: String(cString: uri!))!
            if o_url.isFileURL {
                self.representedURL = o_url
                VLCMain.sharedInstance().voutProvider.updateWindows { (o_window: VLCVideoWindowCommon?) in o_window?.representedURL = o_url }
            } else {
                self.representedURL = nil
                VLCMain.sharedInstance().voutProvider.updateWindows { (o_window: VLCVideoWindowCommon?) in
                    o_window?.representedURL = nil
                }
            }
            free(uri)

            if aString.isEmpty {
                if o_url.isFileURL {
                    aString = FileManager.default.displayName(atPath: o_url.path)
                } else {
                    aString = o_url.absoluteString
                }
            }

            if aString.count > 0 {
                self.title = aString
                VLCMain.sharedInstance().voutProvider.updateWindows { (o_window: VLCVideoWindowCommon?) in
                    o_window?.title = aString
                }
            } else {
                self.title = "VLC video player"
                self.representedURL = nil
            }

            vlc_object_release(p_input.as_vlc_object_pointer())
        } else {
            self.title = "VLC video player"
            self.representedURL = nil
        }
    }

    private func updateWindow() {
        self.controlsBar.updateControls()
        VLCMain.sharedInstance().voutProvider.updateControlsBars { (controlsBar: VLCControlsBarCommon?) in
            controlsBar?.updateControls()
        }

        var b_seekable = false

//        playlist_t *p_playlist = pl_Get(getIntf());
//        input_thread_t *p_input = playlist_CurrentInput(p_playlist);
//        if (p_input) {
//            /* seekable streams */
//            b_seekable = var_GetBool(p_input, "can-seek");
//
//            vlc_object_release(p_input);
//        }

        self.updateTimeSlider()

//        PL_LOCK;
//        if VLCMain.sharedInstance] playlist] model] currentRootType] != ROOT_TYPE_PLAYLIST ||
//        [[[[VLCMain sharedInstance] playlist] model] hasChildren])
//        [self hideDropZone];
//        else
//        [self showDropZone];
//        PL_UNLOCK;

//        [self _updatePlaylistTitle];
    }

    private func setPause() {
        self.controlsBar.setPause()
        VLCMain.sharedInstance().voutProvider.updateControlsBars { (controlsBar: VLCControlsBarCommon?) in controlsBar?.setPause() }
    }

    private func setPlay() {
        self.controlsBar.setPlay()
        VLCMain.sharedInstance().voutProvider.updateControlsBars { (controlsBar: VLCControlsBarCommon?) in controlsBar?.setPlay() }
    }

    private func updateVolumeSlider() {
        (self.controlsBar as VLCMainWindowControlsBar).updateVolumeSlider()
    }

    // MARK: - Video Output handling

    private func videoplayWillBeStarted() {
        if !self.fullscreen {
            _frameBeforePlayback = self.frame
        }
    }

    func setVideoplayEnabled() {
        let videoPlayback: Bool = VLCMain.sharedInstance().activeVideoPlayback()
        if !videoPlayback {
            if !self.fullscreen && _frameBeforePlayback.size.width > 0 && _frameBeforePlayback.size.height > 0 {
                // only resize back to minimum view of this is still desired final state
                let f_threshold_height: CGFloat = MIN_VIDEO_HEIGHT
                if _frameBeforePlayback.size.height > f_threshold_height /*|| b_minimized_view*/ {
                    if VLCMain.sharedInstance().isTerminating() {
                        setFrame(_frameBeforePlayback, display: true)
                    } else {
                        animator().setFrame(_frameBeforePlayback, display: true)
                    }
                }
            }

            _frameBeforePlayback = NSMakeRect(0, 0, 0, 0)
            VLCMain.sharedInstance().voutProvider.updateWindowLevel(forHelperWindows: NSWindow.Level.normal.rawValue)
            // restore alpha value to 1 for the case that macosx-opaqueness is set to < 1
            self.alphaValue = 1
        }

        if self.hasActiveVideo && self.fullscreen && videoPlayback {
            self.hideControlsBar()
        } else {
            self.showControlsBar()
        }
    }

    // MARK: - Fullscreen support

    private func showFullscreenController() {
        if let currentWindow = NSApp.keyWindow as? VLCWindow, currentWindow.hasActiveVideo {
            if currentWindow.fullscreen && !currentWindow.videoView().isHidden {
                if VLCMain.sharedInstance().activeVideoPlayback() {
//                [self.fspanel fadeIn];
                }
            }
        }
    }
}
