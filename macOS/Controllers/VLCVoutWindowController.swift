//
//  VLCVoutWindowController.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 02/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

fileprivate let f_min_video_height: CGFloat = 70.0

public class VLCVoutWindowController: NSObject {

    private var _voutWindows: [UnsafeMutablePointer<vout_window_t>: VLCVideoWindow] = [:]
    // private VLCKeyboardBacklightControl *keyboardBacklight

    private var topLeftPoint = NSPoint(0, 0)

    // save the status level if at least one video window is on status level
    private var _statusLevelWindowCounter: UInt = 0
    private var currentWindowLevel: NSWindow.Level = NSWindow.Level.floating

//    init() {
//        atomic_store(&b_intf_starting, true)
//        keyboardBacklight = [[VLCKeyboardBacklightControl alloc] init
//    }

    deinit {
        let keys = _voutWindows.keys
        for key in keys {
            removeVout(forWindow: key)
        }

//        if var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-dim-keyboard") {
//            [keyboardBacklight switchLightsInstantly:true
//        }
    }

    // MARK: - Mouse hiding

    func hideMouse(forWindow: UnsafeMutablePointer<vout_window_t>?) {
        var currentWindow: VLCVideoWindow?
        if forWindow != nil {
            currentWindow = _voutWindows[forWindow]
        }
        if currentWindow == nil {
            return
        }
        if NSPointInRect(currentWindow!.mouseLocationOutsideOfEventStream,
                          currentWindow!.videoView.convert(currentWindow!.videoView.bounds, to: nil)) {
            NSCursor.setHiddenUntilMouseMoves(true)
        }
    }

    private var _currentStatusWindowLevel: NSWindow.Level = .floating

    var currentStatusWindowLevel: NSWindow.Level {
        return _currentStatusWindowLevel
    }

    // MARK: - Methods for vout provider

    func setupVout(forWindow p_wnd: UnsafeMutablePointer<vout_window_t>, withProposedVideoViewPosition videoViewPosition: NSRect) -> VLCVoutView {
        let intf = getIntf()!
//        let windowDecorations = var_InheritBool(intf.as_vlc_object_pointer(), "video-deco")
        let multipleVoutWindows = _voutWindows.count > 0

        // setup detached window with controls
        let o_controller = NSWindowController(windowNibName: NSNib.Name("DetachedVideoWindow"))
        o_controller.loadWindow()

        let newVideoWindow = o_controller.window as VLCVideoWindow
        // no frame autosave for additional vout windows
        if multipleVoutWindows {
            newVideoWindow.setFrameAutosaveName(NSWindow.FrameAutosaveName(""))
        }
        newVideoWindow.delegate = newVideoWindow
        newVideoWindow.level = NSWindow.Level.normal

        let voutView: VLCVoutView! = newVideoWindow.videoView

        let videoViewSize = NSMakeSize(videoViewPosition.size.width, videoViewPosition.size.height)

        // Avoid flashes if video will directly start in fullscreen
        NSDisableScreenUpdates()

        // set (only!) window origin if specified
        var window_rect = newVideoWindow.frame
        if videoViewPosition.origin.x > 0 {
            window_rect.origin.x = videoViewPosition.origin.x
        }
        if videoViewPosition.origin.y > 0 {
            window_rect.origin.y = videoViewPosition.origin.y
        }
        newVideoWindow.setFrame(window_rect, display: true)

        // cascade windows if we have more than one vout
        if multipleVoutWindows {
            if _voutWindows.count == 1 {
                let firstWindow = _voutWindows[_voutWindows.keys.first!]!

                let topleftBaseRect = NSRect(0, firstWindow.frame.size.height, 0, 0)
                self.topLeftPoint = firstWindow.convertToScreen(topleftBaseRect).origin
            }

            self.topLeftPoint = newVideoWindow.cascadeTopLeft(from: self.topLeftPoint)
            newVideoWindow.setFrameTopLeftPoint(self.topLeftPoint)
        }

        // resize window
        newVideoWindow.nativeVideoSize = videoViewSize

        newVideoWindow.makeKeyAndOrderFront(self)

        newVideoWindow.alphaValue = CGFloat(config_GetFloat("macosx-opaqueness"))

        voutView.voutThread = p_wnd.pointee.obj.parent.as_vout_thread_pointer()
        newVideoWindow.hasActiveVideo = true
        _voutWindows[p_wnd] = newVideoWindow

        VLCMain.instance.activeVideoPlayback = true

        if var_InheritBool(intf.as_vlc_object_pointer(), "fullscreen") || var_GetBool(pl_Get(intf).as_vlc_object_pointer(), "fullscreen") {
            // this is not set when we start in fullscreen because of
            // fullscreen settings in video prefs the second time
            var_SetBool(p_wnd.pointee.obj.parent, "fullscreen", true)

            self.setFullscreen(true, forWindow: p_wnd, withAnimation: false)
        }

        NSEnableScreenUpdates()
        return voutView
    }

    func removeVout(forWindow p_wnd: UnsafeMutablePointer<vout_window_t>) {
        if let o_window: VLCVideoWindow = _voutWindows[p_wnd] {

            o_window.videoView.releaseVoutThread()

            // set active video to no BEFORE closing the window and exiting fullscreen
            // (avoid stopping playback due to NSWindowWillCloseNotification, preserving fullscreen state)
            o_window.hasActiveVideo = false

            // prevent visible extra window if in fullscreen
            NSDisableScreenUpdates()

            o_window.close()
            NSEnableScreenUpdates()

            _voutWindows[p_wnd] = nil
            if _voutWindows.count == 0 {
                VLCMain.instance.activeVideoPlayback = false
                _statusLevelWindowCounter = 0
            }
        } else {
            //            msg_Err(getIntf(), "Cannot close nonexisting window")
        }
    }

    func setNativeVideoSize(_ size: NSSize, forWindow p_wnd: UnsafeMutablePointer<vout_window_t>) {
        if let o_window: VLCVideoWindow = _voutWindows[p_wnd] {
            o_window.nativeVideoSize = size
        } else {
            //            msg_Err(getIntf()!.as_vlc_object_pointer(), "Cannot set size for nonexisting window")
        }
    }

    func setWindowLevel(_ i_level: NSWindow.Level, forWindow p_wnd: UnsafeMutablePointer<vout_window_t>) {

        if let o_window: VLCVideoWindow = _voutWindows[p_wnd] {
            // only set level for helper windows to normal if no status vout window exist anymore
            if i_level == NSWindow.Level.statusBar {
                _statusLevelWindowCounter += 1
                // window level need to stay on normal in fullscreen mode
                if o_window.fullscreen == false && o_window.inFullscreenTransition == false {
                    updateWindowLevelForHelperWindows(i_level)
                }
            } else {
                if _statusLevelWindowCounter > 0 {
                    _statusLevelWindowCounter -= 1
                }
                if _statusLevelWindowCounter == 0 {
                    updateWindowLevelForHelperWindows(i_level)
                }
            }
            o_window.setWindowLevel(i_level)

        } else {
            //            msg_Err(getIntf()!.as_vlc_object_pointer(), "Cannot set level for nonexisting window")
        }
    }

    func setFullscreen(_ fullscreen: Bool, forWindow p_wnd: UnsafeMutablePointer<vout_window_t>?, withAnimation animate: Bool) {
        let p_intf = getIntf()

        let p_playlist = pl_Get(p_intf)!
        if var_GetBool(p_playlist.as_vlc_object_pointer(), "fullscreen") != fullscreen {
            var_SetBool(p_playlist.as_vlc_object_pointer(), "fullscreen", fullscreen)
        }

        var o_current_window: VLCVideoWindow?
        if p_wnd != nil {
            o_current_window = _voutWindows[p_wnd]
        }

//        if var_InheritBool(p_intf.as_vlc_object_pointer(), "macosx-dim-keyboard") {
//            [keyboardBacklight switchLightsAsync:!b_fullscreen
//        }

        assert(o_current_window != nil)

        // fullscreen might be triggered twice (vout event)
        // so ignore duplicate events here
        if (fullscreen && !(o_current_window!.fullscreen || o_current_window!.inFullscreenTransition)) ||
           (!fullscreen && o_current_window!.fullscreen) {

            o_current_window!.toggleFullScreen(self)
        }
    }

     // MARK: - Misc methods

    func updateControlsBarsUsingBlock(block: (VLCControlsBar) -> Void) {
        for wnd in _voutWindows.values {
            block(wnd.controlsBar)
        }
    }

    func updateWindowsUsingBlock(windowUpdater: (VLCVideoWindow) -> Void) {
        for wnd in _voutWindows.values {
            windowUpdater(wnd)
        }
    }

    func updateWindowLevelForHelperWindows(_ level: NSWindow.Level) {
        if var_InheritBool(getIntf()!.as_vlc_object_pointer(), "video-wallpaper") {
             return
        }

        self.currentWindowLevel = level
        if level == NSWindow.Level.normal {
            _currentStatusWindowLevel = NSWindow.Level.floating
        } else {
            _currentStatusWindowLevel = level + 1
        }

        let statusWindowLevel: NSWindow.Level = self.currentStatusWindowLevel

        let instance: VLCMain = VLCMain.instance
//        instance.videoEffectsPanel.updateCocoaWindowLevel(statusWindowLevel)
//        instance.audioEffectsPanel.updateCocoaWindowLevel(statusWindowLevel)
//        instance.currentMediaInfoPanel.updateCocoaWindowLevel(statusWindowLevel)
//        instance.bookmarks.updateCocoaWindowLevel(statusWindowLevel)
//        instance.trackSyncPanel.updateCocoaWindowLevel(statusWindowLevel)
//        instance.resumeDialog.updateCocoaWindowLevel(statusWindowLevel)
    }


    // static atomic_bool b_intf_starting = ATOMIC_VAR_INIT(false)
    //
    // static int WindowControl(UnsafeMutablePointer<vout_window_t>, int i_query, va_list)
    //
    public class func WindowOpen(_ p_wnd: UnsafeMutablePointer<vout_window_t>, _ cfg: UnsafePointer<vout_window_cfg_t>) -> Int32 {
        return autoreleasepool { () -> Int32 in

            if cfg.pointee.type != VOUT_WINDOW_TYPE_DUMMY.rawValue
                    && cfg.pointee.type != VOUT_WINDOW_TYPE_NSOBJECT.rawValue {
                return VLC_EGENERIC
            }

            //        msg_Dbg(p_wnd, "Opening video window")
    // TODO
    //        if !atomic_load(&b_intf_starting) {
    //            msg_Err(p_wnd, "Cannot create vout as Mac OS X interface was not found")
    //            return Int(VLC_EGENERIC)
    //        }

            let proposedVideoViewPosition = NSMakeRect(CGFloat(cfg.pointee.x), CGFloat(cfg.pointee.y), CGFloat(cfg.pointee.width), CGFloat(cfg.pointee.height))
            let voutController: VLCVoutWindowController = VLCMain.instance.voutController
    //         __block VLCVoutView *videoView = nil.
            var videoView: VLCVoutView?

            DispatchQueue.main.sync {
                videoView = voutController.setupVoutForWindow(p_wnd, withProposedVideoViewPosition: proposedVideoViewPosition)
            }

            // this method is not supposed to fail
            assert(videoView != nil)

    //         msg_Dbg(getIntf()!.as_vlc_object_pointer(), "returning videoview with proposed position x=%i, y=%i, width=%i, height=%i", cfg.pointee.x, cfg.pointee.y, cfg.pointee.width, cfg.pointee.height)

            p_wnd.pointee.handle.nsobject = CFBridgingRetain(videoView) as! UnsafeMutableRawPointer
            p_wnd.pointee.type = VOUT_WINDOW_TYPE_NSOBJECT.rawValue
            p_wnd.pointee.control = WindowControlObjc
            vout_window_SetFullScreen(p_wnd, cfg.pointee.is_fullscreen)
            return VLC_SUCCESS
        }
    }

    @objc public class func WindowControl(_ p_wnd: UnsafeMutablePointer<vout_window_t>?, i_query: UInt32, args: [Int]) -> Int32 {
        return autoreleasepool { () -> Int32 in

            let voutController: VLCVoutWindowController = VLCMain.instance.voutController
            switch i_query {
            case VOUT_WINDOW_SET_STATE.rawValue:
                let i_state = args[0]
                if (i_state & VOUT_WINDOW_STATE_BELOW) == VOUT_WINDOW_STATE_BELOW {
        //                     msg_Dbg(p_wnd, "Ignore change to VOUT_WINDOW_STATE_BELOW")
                    break
                }
                var i_cooca_level = NSWindow.Level.normal
                if (i_state & VOUT_WINDOW_STATE_ABOVE) == VOUT_WINDOW_STATE_ABOVE {
                     i_cooca_level = NSWindow.Level.statusBar
                }
                DispatchQueue.main.async(execute: {
                    voutController.setWindowLevel(i_cooca_level, forWindow: p_wnd!)
                })

            case VOUT_WINDOW_SET_SIZE.rawValue:
                let i_width  = args[0]
                let i_height = args[1]
                DispatchQueue.main.async(execute: {
                    voutController.setNativeVideoSize(NSSize(CGFloat(i_width), CGFloat(i_height)), forWindow: p_wnd!)
                })

            case VOUT_WINDOW_SET_FULLSCREEN.rawValue:
                if var_InheritBool(getIntf()!.as_vlc_object_pointer(), "video-wallpaper") {
        //                msg_Dbg(p_wnd, "Ignore fullscreen event as video-wallpaper is on")
                    break
                }
                let i_full = args[0] != 0
                DispatchQueue.main.async(execute: {
                    voutController.setFullscreen(i_full, forWindow: p_wnd!, withAnimation: true)
                })

            case VOUT_WINDOW_HIDE_MOUSE.rawValue:
                voutController.hideMouse(forWindow: p_wnd)

            default:
        //            msg_Warn(p_wnd, "unsupported control query: %i", i_query )
                return VLC_EGENERIC
            }
            return VLC_SUCCESS
        }
    }

    public class func WindowClose(_ p_wnd: UnsafeMutablePointer<vout_window_t>) {
        autoreleasepool {
            let voutController: VLCVoutWindowController = VLCMain.instance.voutController
            DispatchQueue.main.async(execute: { [voutController] in
                voutController.removeVout(forWindow: p_wnd)
            })
        }
    }
}
