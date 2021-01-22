//
//  VLCVideoWindow.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 01/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

let MIN_VIDEO_HEIGHT = CGFloat(70.0)
let DIST = CGFloat(3.0)

class VLCVideoWindowCommon : VLCWindow, NSWindowDelegate {

    // variables for fullscreen handling
    private var _fullscreenWindow: VLCWindow?
    private var _fullscreen_anim1: NSViewAnimation?
    private var _fullscreen_anim2: NSViewAnimation?
    private var _tempView: NSView!
    private var _originalLevel: NSWindow.Level = NSWindow.Level.normal

    private var _videoViewWasHidden = false
    private var _darkInterface = false
    private var _inFullscreenTransition = false
    private var _windowShouldExitFullscreenWhenFinished = false

    private var _frameBeforeLionFullscreen: NSRect = NSZeroRect
    private var _nativeVideoSize: NSSize = NSZeroSize
    private var _previousSavedFrame: NSRect = NSZeroRect


//    @IBOutlet weak var titlebarView: VLCMainWindowTitleView!
    @IBOutlet weak var videoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoView: VLCVoutView!
    @IBOutlet weak var controlsBar: VLCControlsBar!

    var inFullscreenTransition: Bool {
        return _inFullscreenTransition
    }

    var darkInterface: Bool {
        return _darkInterface
    }

    var windowShouldExitFullscreenWhenFinished: Bool {
        return _windowShouldExitFullscreenWhenFinished
    }

    var nativeVideoSize: NSSize {
        get {
            return _nativeVideoSize
        }
        set {
            _nativeVideoSize = newValue

            let intf = getIntf()!.as_vlc_object_pointer()
            if var_InheritBool(intf, "macosx-video-autoresize") && !var_InheritBool(intf, "video-wallpaper") {
                resizeWindow()
            }
        }
    }

//  MARK: - Init

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect:contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        /* we want to be moveable regardless of our style */
        self.isMovableByWindowBackground = true
        self.canBecomeKey = true

        _tempView = NSView()
        _tempView.autoresizingMask = [.height, .width]
    }

    override func awakeFromNib() {
        self.collectionBehavior = NSWindow.CollectionBehavior.fullScreenPrimary
        super.awakeFromNib()
    }

    override var title: String? {
        set {
            if newValue == nil || newValue.count < 1 {
                return
            }
            super.title = newValue
        }
        get {
            return super.title
        }
    }

// MARK: - zoom / minimize / close

    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(performClose(_:)) || menuItem.action == #selector(performMiniaturize(_:)) || menuItem.action == #selector(performZoom(_:)) {
            return true
        }
        return super.validateMenuItem(menuItem)
    }

    override func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true
    }

    @objc override func performClose(_ sender: Any?) {
        if !self.styleMask.contains(.titled) {
            // TODO
//            NotificationCenter.default.post(name: NSNotification.Name.NSWillBecomeMultiThreaded, object:self)
            close()
        } else {
            super.performClose(sender)
        }
    }

    @objc override func performMiniaturize(_ sender: Any?) {
        if !self.styleMask.contains(.titled) {
            miniaturize(sender)
        } else {
            super.performMiniaturize(sender)
        }
    }

    @objc override func performZoom(_ sender: Any?) {
        if !self.styleMask.contains(.titled) {
            customZoom(sender)
        } else {
            super.performZoom(sender)
        }
    }

    override func zoom(_ sender: Any?) {
        if !self.styleMask.contains(.titled) {
            customZoom(sender)
        } else {
            super.zoom(sender)
        }
    }

    /**
     * Given a proposed frame rectangle, return a modified version
     * which will fit inside the screen.
     *
     * This method is based upon NSWindow.m, part of the GNUstep GUI Library, licensed under LGPLv2+.
     *    Authors:  Scott Christley <scottc@net-community.com>, Venkat Ajjanagadde <venkat@ocbi.com>,
     *              Felipe A. Rodriguez <far@ix.netcom.com>, Richard Frith-Macdonald <richard@brainstorm.co.uk>
     *    Copyright (C) 1996 Free Software Foundation, Inc.
     */
    private func customConstrain(frameRect: NSRect, toScreen screen: NSScreen) -> NSRect {
        var frameRect = frameRect
        let screenRect = screen.visibleFrame

        /* Move top edge of the window inside the screen */
        var difference: CGFloat = NSMaxY(frameRect) - NSMaxY(screenRect)
        if difference > 0 {
            frameRect.origin.y -= difference
        }

        /* If the window is resizable, resize it (if needed) so that the
         bottom edge is on the screen or can be on the screen when the user moves
         the window */
        difference = NSMaxY(screenRect) - NSMaxY(frameRect)
        if self.styleMask.contains(.resizable) {

            var difference2: CGFloat = screenRect.origin.y - frameRect.origin.y
            difference2 -= difference
            // Take in account the space between the top of window and the top of the
            // screen which can be used to move the bottom of the window on the screen
            if difference2 > 0 {
                frameRect.size.height -= difference2
                frameRect.origin.y += difference2
            }

            /* Ensure that resizing doesn't makewindow smaller than minimum */
            difference2 = self.minSize.height - frameRect.size.height
            if difference2 > 0 {
                frameRect.size.height += difference2
                frameRect.origin.y -= difference2
            }
        }
        return frameRect
    }

    /**
     Zooms the receiver.   This method calls the delegate method
     windowShouldZoom:toFrame: to determine if the window should
     be allowed to zoom to full screen.
     *
     * This method is based upon NSWindow.m, part of the GNUstep GUI Library, licensed under LGPLv2+.
     *    Authors:  Scott Christley <scottc@net-community.com>, Venkat Ajjanagadde <venkat@ocbi.com>,
     *              Felipe A. Rodriguez <far@ix.netcom.com>, Richard Frith-Macdonald <richard@brainstorm.co.uk>
     *    Copyright (C) 1996 Free Software Foundation, Inc.
     */
    private func customZoom(_ sender: Any?) {
        var maxRect = self.screen!.visibleFrame
        let currentFrame = self.frame

        if let standardRect = self.delegate?.windowWillUseStandardFrame?(self, defaultFrame: maxRect) {
            maxRect = standardRect
        }
        maxRect = customConstrain(frameRect: maxRect, toScreen: self.screen!)

        // Compare the new frame with the current one
        if (abs(NSMaxX(maxRect) - NSMaxX(currentFrame)) < DIST)
            && (abs(NSMaxY(maxRect) - NSMaxY(currentFrame)) < DIST)
            && (abs(NSMinX(maxRect) - NSMinX(currentFrame)) < DIST)
            && (abs(NSMinY(maxRect) - NSMinY(currentFrame)) < DIST) {
            // Already in zoomed mode, reset user frame, if stored
            if self.frameAutosaveName.rawValue.isEmpty != false {
                setFrame(_previousSavedFrame, display: true, animate: true)
                saveFrame(usingName: self.frameAutosaveName)
            }
            return
        }

        if self.frameAutosaveName.rawValue.isEmpty != false {
            saveFrame(usingName: self.frameAutosaveName)
            _previousSavedFrame = self.frame
        }
        setFrame(maxRect, display: true, animate: true)
    }

// MARK: - Video window resizing logic

    func setWindowLevel(_ state: NSWindow.Level) {
        if var_InheritBool(getIntf()!.as_vlc_object_pointer(), "video-wallpaper") || self.level < .normal {
            return
        }
        if !self.fullscreen && !_inFullscreenTransition {
            self.level = state
        }
        // save it for restore if window is currently minimized or in fullscreen
        _originalLevel = state
    }

    func getWindowRectForProposedVideoViewSize(_ size: NSSize) -> NSRect {
        let windowMinSize: NSSize = self.minSize
        let screenFrame: NSRect = self.screen!.visibleFrame

        let topleftbase = NSMakeRect(0, self.frame.size.height, 0, 0)
        let topleftscreen: NSPoint = convertToScreen(topleftbase).origin

        var width: CGFloat = size.width
        var height: CGFloat = size.height
        if width < windowMinSize.width {
            width = windowMinSize.width
        }
        if height < MIN_VIDEO_HEIGHT {
            height = MIN_VIDEO_HEIGHT
        }

        /* Calculate the window's new size */
        var newFrame = NSRect()
        newFrame.size.width = self.frame.size.width - self.videoView.frame.size.width + width
        newFrame.size.height = self.frame.size.height - self.videoView.frame.size.height + height
        newFrame.origin.x = topleftscreen.x
        newFrame.origin.y = topleftscreen.y - newFrame.size.height

        /* make sure the window doesn't exceed the screen size the window is on */
        if newFrame.size.width > screenFrame.size.width {
            newFrame.size.width = screenFrame.size.width
            newFrame.origin.x = screenFrame.origin.x
        }
        if newFrame.size.height > screenFrame.size.height {
            newFrame.size.height = screenFrame.size.height
            newFrame.origin.y = screenFrame.origin.y
        }
        if newFrame.origin.y < screenFrame.origin.y {
            newFrame.origin.y = screenFrame.origin.y
        }

        let rightScreenPoint: CGFloat = screenFrame.origin.x + screenFrame.size.width
        let rightWindowPoint: CGFloat = newFrame.origin.x + newFrame.size.width
        if rightWindowPoint > rightScreenPoint {
            newFrame.origin.x -= (rightWindowPoint - rightScreenPoint)
        }
        return newFrame
    }

    func resizeWindow() {
        // VOUT_WINDOW_SET_SIZE is triggered when exiting fullscreen. This event is ignored here
        // to avoid interference with the animation.
        if self.fullscreen || _inFullscreenTransition {
            return
        }
        let windowRect = getWindowRectForProposedVideoViewSize(self.nativeVideoSize)
        animator().setFrame(windowRect, display:true)
    }

    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        if !VLCMain.instance.activeVideoPlayback || self.nativeVideoSize.width == 0 || self.nativeVideoSize.height == 0 || sender != self {
            return frameSize
        }
        // needed when entering lion fullscreen mode
        if _inFullscreenTransition || self.fullscreen {
            return frameSize
        }
        if self.videoView.isHidden {
            return frameSize
        }

        var proposedSize = frameSize
        if VLCCoreInteraction.instance.aspectRatioIsLocked {
            let videoWindowFrame = self.frame
            let viewRect = self.videoView.convert(self.videoView.bounds, to: nil)
            let contentRect = self.contentRect(forFrameRect: videoWindowFrame)
            let marginy: CGFloat = viewRect.origin.y + videoWindowFrame.size.height - contentRect.size.height
            let marginx: CGFloat = contentRect.size.width - viewRect.size.width
            proposedSize.height = (frameSize.width - marginx) * self.nativeVideoSize.height / self.nativeVideoSize.width + marginy
        }
        return proposedSize
    }

    func windowWillMiniaturize(_ notification: Notification) {
        // Set level to normal as a workaround for Mavericks bug causing window
        // to vanish from screen, see radar://15473716
        _originalLevel = self.level
        self.level = NSWindow.Level.normal
    }

    func windowDidDeminiaturize(_ notification: Notification) {
        self.level = _originalLevel
    }

// MARK: Lion native fullscreen handling

    func hideControlsBar() {
//    self.controlsBar bottomBarView.isHidden = true)
        self.videoViewBottomConstraint.priority = 1;

    }

    func showControlsBar() {
//    [self.controlsBar bottomBarView.isHidden = false)
        self.videoViewBottomConstraint.priority = 999;
    }

//    private override func becomeKeyWindow() {
//        super.becomeKeyWindow()
//        // change fspanel state for the case when multiple windows are in fullscreen
//        if self.hasActiveVideo && self.fullscreen {
//            VLCMain.instance.mainWindow.fspanel.setActive()
//        } else {
//            VLCMain.instance.mainWindow.fspanel.setNonActive()
//        }
//    }

//func resignKeyWindow() {
//    super.resignKeyWindow)
//
//    [VLCMain.instance.mainWindow.fspanel.setNonActive)
//}

    override func customWindowsToEnterFullScreen(for window: NSWindow) -> [NSWindow]? {
        return window == self ? [window] : nil
    }

    func customWindowsToExitFullScreen(for window: NSWindow) -> [NSWindow]? {
        return window == self ? [window] : nil
    }

    func window(_ window: NSWindow, startCustomAnimationToEnterFullScreenWithDuration duration: TimeInterval) {
        window.styleMask.insert(.fullScreen)
        let screenFrame = window.screen!.frame

        NSAnimationContext.runAnimationGroup(
            { [unowned window] (context: NSAnimationContext) in
                context.duration = 0.5 * duration
                window.animator().setFrame(screenFrame, display: true)
            })
    }

    func window(_ window: NSWindow, startCustomAnimationToExitFullScreenWithDuration duration: TimeInterval) {
        window.styleMask.remove(.fullScreen)
        window.animator().setFrame(_frameBeforeLionFullscreen, display: true, animate: true)

        NSAnimationContext.runAnimationGroup(
            { [unowned window] (context: NSAnimationContext) in
                context.duration = 0.5 * duration
                window.animator().setFrame(_frameBeforeLionFullscreen, display: true, animate: true)
            })
    }

    func windowWillEnterFullScreen(_ notification: Notification) {
        _windowShouldExitFullscreenWhenFinished = VLCMain.instance.activeVideoPlayback

        let currLevel = self.level
        // self.fullscreen and self.b_inFullscreenTransition must not be true yet
        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(NSWindow.Level.normal)
        self.level = NSWindow.Level.normal
        _originalLevel = currLevel

        _inFullscreenTransition = true

        var_SetBool(pl_Get(getIntf()).as_vlc_object_pointer(), "fullscreen", true)

        _frameBeforeLionFullscreen = self.frame

        if self.hasActiveVideo {
            if let p_vout = getVoutForActiveWindow() {
                var_SetBool(p_vout.as_vlc_object_pointer(), "fullscreen", true)
                vlc_object_release(p_vout.as_vlc_object_pointer())
            }
        }

        if self.videoView.isHidden {
            self.hideControlsBar()
        }
        self.isMovableByWindowBackground = false
    }

    func windowDidEnterFullScreen(_ notification: Notification) {
        // Indeed, we somehow can have an "inactive" fullscreen (but a visible window!).
        // But this creates some problems when leaving fs over remote intfs, so activate app here.
        NSApp.activate(ignoringOtherApps: true)
        self.fullscreen = true
        _inFullscreenTransition = false
        let subviews = self.videoView.subviews
        for subview in subviews {
            if let openglview = subview as NSOpenGLView {
                openglview.reshape()
            }
        }
    }

    func windowWillExitFullScreen(_ notification: Notification) {
        _inFullscreenTransition = true
        self.fullscreen = false

        if self.hasActiveVideo {
            var_SetBool(pl_Get(getIntf()).as_vlc_object_pointer(), "fullscreen", false)

            if let p_vout = getVoutForActiveWindow() {
                var_SetBool(p_vout.as_vlc_object_pointer(), "fullscreen", false)
                vlc_object_release(p_vout.as_vlc_object_pointer())
            }
        }

        NSCursor.setHiddenUntilMouseMoves(false)

        if !self.videoView.isHidden {
            self.showControlsBar()
        }
        self.isMovableByWindowBackground = true
    }

    func windowDidExitFullScreen(_ notification: Notification) {
        _inFullscreenTransition = false
        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(_originalLevel)
        self.level = _originalLevel
    }

// MARK: - Fullscreen Logic

    func enterFullscreen(animate: Bool) {
        let intf = getIntf()!.as_vlc_object_pointer()

        var screen = NSScreen.screen(withDisplayID: CGDirectDisplayID(var_InheritInteger(intf, "macosx-vdev")))
        if screen == nil {
            msg_Dbg(getIntf(), "chosen screen isn't present, using current screen for fullscreen mode")
            screen = self.screen
        }
        if screen == nil {
            msg_Dbg(getIntf(), "Using deepest screen")
            screen = NSScreen.deepest
        }
        let screenRect = screen!.frame

//        if (self.controlsBar)
//        [self.controlsBar setFullscreenState:YES];
//        [[[[VLCMain sharedInstance] mainWindow] controlsBar] setFullscreenState:YES];

        let blackout_other_displays = var_InheritBool(intf, "macosx-black")
        if blackout_other_displays {
            screen!.blackoutOtherScreens()
        }

        /* Make sure we don't see the window flashes in float-on-top mode */
        let curLevel = self.level
        // self.fullscreen must not be true yet
        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(NSWindow.Level.normal)
        self.level = NSWindow.Level.normal
        _originalLevel = curLevel // would be overwritten by previous call

        /* Only create the _fullscreen_window if we are not in the middle of the zooming animation */
        if _fullscreenWindow == nil {
            /* We can't change the styleMask of an already created NSWindow, so we create another window, and do eye catching stuff */

            var rect = self.videoView.superview!.convert(self.videoView.frame, to: nil) /* Convert to Window base coord */
            rect.origin.x += self.frame.origin.x
            rect.origin.y += self.frame.origin.y
            _fullscreenWindow = VLCWindow(contentRect: rect, styleMask: NSWindow.StyleMask.borderless, backing: NSWindow.BackingStoreType.buffered, defer: true)
            _fullscreenWindow!.backgroundColor = NSColor.black
            _fullscreenWindow!.canBecomeKey =  true
            _fullscreenWindow!.canBecomeMain = true
            _fullscreenWindow!.hasActiveVideo = true
            _fullscreenWindow!.fullscreen = true

            /* Make sure video view gets visible in case the playlist was visible before */
            _videoViewWasHidden = self.videoView.isHidden
            self.videoView.isHidden = false
            self.videoView.translatesAutoresizingMaskIntoConstraints = true

            if !animate {
                /* We don't animate if we are not visible, instead we
                 * simply fade the display */
                var token: CGDisplayFadeReservationToken = 0

                if blackout_other_displays {
                    CGAcquireDisplayFadeReservation(kCGMaxDisplayReservationInterval, &token)
                    CGDisplayFade(token, 0.5, CGDisplayBlendFraction(kCGDisplayBlendNormal), CGDisplayBlendFraction(kCGDisplayBlendSolidColor), 0, 0, 0, 1)
                }

                NSDisableScreenUpdates()
                self.videoView.superview!.replaceSubview(self.videoView, with: _tempView)
                _tempView.frame = self.videoView.frame
                _fullscreenWindow!.contentView!.addSubview(self.videoView)
                self.videoView.frame = _fullscreenWindow!.contentView!.frame
                self.videoView.autoresizingMask = [.width, .height]
                NSEnableScreenUpdates()

                screen!.setFullscreenPresentationOptions()

                _fullscreenWindow!.setFrame(screenRect, display: true, animate: false)
                _fullscreenWindow!.orderFront(self, animate:true)
                _fullscreenWindow!.level = NSWindow.Level.normal

                if blackout_other_displays {
                    CGDisplayFade(token, 0.3, CGDisplayBlendFraction(kCGDisplayBlendSolidColor), CGDisplayBlendFraction(kCGDisplayBlendNormal), 0, 0, 0, 0)
                    CGReleaseDisplayFadeReservation(token)
                }

                /* Will release the lock */
                self.hasBecomeFullscreen()
                return
            }

            /* Make sure we don't see the self.videoView disappearing of the screen during this operation */
            NSDisableScreenUpdates()
            self.videoView.superview!.replaceSubview(self.videoView, with: _tempView)
            _tempView.frame = self.videoView.frame
            _fullscreenWindow!.contentView!.addSubview(self.videoView)
            self.videoView.frame = _fullscreenWindow!.contentView!.frame
            self.videoView.autoresizingMask = [.width, .height]

            _fullscreenWindow!.makeKeyAndOrderFront(self)
            NSEnableScreenUpdates()
        }

        /* We are in fullscreen (and no animation is running) */
        if self.fullscreen {
            /* Make sure we are hidden */
            self.orderOut(self)
            return
        }

        if _fullscreen_anim1 != nil {
            _fullscreen_anim1!.stop()
        }
        if _fullscreen_anim2 != nil {
            _fullscreen_anim2!.stop()
        }

        screen!.setFullscreenPresentationOptions()

        var dict1: [NSViewAnimation.Key: Any] = [:]
        dict1[ NSViewAnimation.Key.target ] = self
        dict1[ NSViewAnimation.Key.effect ] = NSViewAnimation.EffectName.fadeOut

        var dict2: [NSViewAnimation.Key: Any] = [:]
        dict2[ NSViewAnimation.Key.target ]     = _fullscreenWindow!
        dict2[ NSViewAnimation.Key.startFrame ] = NSValue(rect: _fullscreenWindow!.frame)
        dict2[ NSViewAnimation.Key.endFrame ]   = NSValue(rect: screenRect)

        /* Strategy with NSAnimation allocation:
         - Keep at most 2 animation at a time
         - leaveFullscreen/enterFullscreen are the only responsible for releasing and alloc-ing
         */
        _fullscreen_anim1 = NSViewAnimation(viewAnimations: [dict1])
        _fullscreen_anim2 = NSViewAnimation(viewAnimations: [dict2])

        _fullscreen_anim1!.animationBlockingMode = .nonblocking
        _fullscreen_anim1!.duration = 0.3
        _fullscreen_anim1!.frameRate = 30
        _fullscreen_anim2!.animationBlockingMode = .nonblocking
        _fullscreen_anim2!.duration = 0.2
        _fullscreen_anim2!.frameRate = 30

        _fullscreen_anim2!.delegate = self
        _fullscreen_anim2!.start(when: _fullscreen_anim1!, reachesProgress: 1.0)

        _fullscreen_anim1!.start()
        /* fullscreenAnimation will be unlocked when animation ends */
        _inFullscreenTransition = true
    }

    private func hasBecomeFullscreen() {
        if self.videoView.subviews.count > 0 {
            _fullscreenWindow!.makeFirstResponder(self.videoView.subviews.first)
        }
        _fullscreenWindow!.makeKey()
        _fullscreenWindow!.acceptsMouseMovedEvents = true

        if self.isVisible {
            orderOut(self)
        }
        _inFullscreenTransition = false
        self.fullscreen = true
    }

    func leaveFullscreen(animate: Bool) {
        let blackout_other_displays = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-black")

//        if (self.controlsBar)
//        [self.controlsBar setFullscreenState:NO];
//        [[[[VLCMain sharedInstance] mainWindow] controlsBar] setFullscreenState:NO];

        /* We always try to do so */
        NSScreen.unblackoutScreens()

        self.videoView.window!.makeKeyAndOrderFront(nil)

        /* Don't do anything if o_fullscreen_window is already closed */
        if _fullscreenWindow == nil {
            return
        }

        _fullscreenWindow!.screen!.setNonFullscreenPresentationOptions()

        if _fullscreen_anim1 != nil {
            _fullscreen_anim1!.stop()
            _fullscreen_anim1 = nil
        }
        if _fullscreen_anim2 != nil {
            _fullscreen_anim2!.stop()
            _fullscreen_anim2 = nil
        }

        _inFullscreenTransition = true
        self.fullscreen = false

        if !animate {
            /* We don't animate if we are not visible, instead we
             * simply fade the display */
            let token = UnsafeMutablePointer<CGDisplayFadeReservationToken>.allocate(capacity: 1)

            if blackout_other_displays {
                CGAcquireDisplayFadeReservation(kCGMaxDisplayReservationInterval, token)
                CGDisplayFade(token.pointee, 0.3, CGDisplayBlendFraction(kCGDisplayBlendNormal), CGDisplayBlendFraction(kCGDisplayBlendSolidColor), 0, 0, 0, 1)
            }

            self.alphaValue = 1.0
            orderFront(self)

            /* Will release the lock */
            hasEndedFullscreen()

            if blackout_other_displays {
                CGDisplayFade(token.pointee, 0.5, CGDisplayBlendFraction(kCGDisplayBlendSolidColor), CGDisplayBlendFraction(kCGDisplayBlendNormal), 0, 0, 0, 0)
                CGReleaseDisplayFadeReservation(token.pointee)
            }
            return
        }

        self.alphaValue = 0.0
        orderFront(self)
            self.videoView.window?.orderFront(self)

        var frame = _tempView.superview!.convert(_tempView.frame, to: nil) /* Convert to Window base coord */
        frame.origin.x += self.frame.origin.x
        frame.origin.y += self.frame.origin.y

        var dict2 = [NSViewAnimation.Key: Any]()
        dict2[NSViewAnimation.Key.target] = self
        dict2[NSViewAnimation.Key.effect] = NSViewAnimation.EffectName.fadeIn

        _fullscreen_anim2 = NSViewAnimation(viewAnimations: [dict2])
        _fullscreen_anim2!.animationBlockingMode = .nonblocking
        _fullscreen_anim2!.duration = 0.3
        _fullscreen_anim2!.frameRate = 30
        _fullscreen_anim2!.delegate = self

        var dict1 = [NSViewAnimation.Key: Any]()
        dict1[NSViewAnimation.Key.target] = _fullscreenWindow
        dict1[NSViewAnimation.Key.startFrame] = NSValue(rect: _fullscreenWindow!.frame)
        dict1[NSViewAnimation.Key.endFrame] = NSValue(rect: frame)

        _fullscreen_anim1 = NSViewAnimation(viewAnimations: [dict1])
        _fullscreen_anim1!.animationBlockingMode = .nonblocking
        _fullscreen_anim1!.duration = 0.2
        _fullscreen_anim1!.frameRate = 30
        _fullscreen_anim2!.start(when: _fullscreen_anim1!, reachesProgress: 1.0)

        /* Make sure o_fullscreen_window is the frontmost window */
        _fullscreenWindow!.orderFront(self)

        _fullscreen_anim1!.start()
        /* fullscreenAnimation will be unlocked when animation ends */
    }

    private func hasEndedFullscreen() {
        _inFullscreenTransition = false

        /* This function is private and should be only triggered at the end of the fullscreen change animation */
        /* Make sure we don't see the self.videoView disappearing of the screen during this operation */
        NSDisableScreenUpdates()
        self.videoView.removeFromSuperviewWithoutNeedingDisplay()
        _tempView.superview!.replaceSubview(_tempView, with: self.videoView)
        // TODO Replace tmpView by an existing view (e.g. middle view)
        // TODO Use constraints for fullscreen window, reinstate constraints once the video view is added to the main window again
        self.videoView.frame = _tempView.frame
        if self.videoView.subviews.count > 0 {
            makeFirstResponder(self.videoView.subviews.first)
        }
        self.videoView.isHidden = _videoViewWasHidden

        makeKeyAndOrderFront(self)

        _fullscreenWindow!.orderOut(self)
        NSEnableScreenUpdates()

        _fullscreenWindow = nil

        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(_originalLevel)
        self.level = _originalLevel

        self.alphaValue = CGFloat(config_GetFloat("macosx-opaqueness"))
    }

    func animationDidEnd(_ animation: NSAnimation) {
    //    NSArray *viewAnimations
        guard animation.currentValue >= 1.0 else {
            return
        }

        /* Fullscreen ended or started (we are a delegate only for leaveFullscreen's/enterFullscren's anim2) */
        let viewAnimations = _fullscreen_anim2!.viewAnimations
        if viewAnimations.first?[NSViewAnimation.Key.effect] as? NSViewAnimation.EffectName == NSViewAnimation.EffectName.fadeIn {
            /* Fullscreen ended */
            hasEndedFullscreen()
        } else {
        /* Fullscreen started */
            hasBecomeFullscreen()
        }
    }
}
