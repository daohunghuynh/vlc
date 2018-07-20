//
//  VLCVideoWindow.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 01/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

fileprivate let MIN_VIDEO_HEIGHT = CGFloat(70.0)


class VLCVideoWindow : VLCWindow, NSWindowDelegate {

    // variables for fullscreen handling
    private var o_fullscreen_window: VLCWindow?
    private var o_fullscreen_anim1: NSViewAnimation?
    private var o_fullscreen_anim2: NSViewAnimation?
    private var o_temp_view: NSView!

    private var i_originalLevel: NSWindow.Level = NSWindow.Level.normal

    private var b_video_view_was_hidden: Bool = false
    private var b_darkInterface: Bool = false
    private var b_inFullscreenTransition: Bool = false
    private var b_windowShouldExitFullscreenWhenFinished: Bool = false

    private var frameBeforeLionFullscreen: NSRect = NSZeroRect
    private var o_nativeVideoSize: NSSize = NSZeroSize


    @IBOutlet weak var titlebarView: VLCMainWindowTitleView! // only set in main or detached window
    @IBOutlet weak var videoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var videoView: VLCVoutView!
    @IBOutlet weak var controlsBar: VLCControlsBar!

    var inFullscreenTransition: Bool {
        return self.b_inFullscreenTransition
    }

    var darkInterface: Bool {
        return self.b_darkInterface
    }

    var windowShouldExitFullscreenWhenFinished: Bool {
        return self.b_windowShouldExitFullscreenWhenFinished
    }

    var previousSavedFrame: NSRect = NSZeroRect

    var nativeVideoSize: NSSize {
        get {
            return self.o_nativeVideoSize
        }
        set {
            self.o_nativeVideoSize = newValue

            let intf = getIntf()!.as_vlc_object_pointer()
            if var_InheritBool(intf, "macosx-video-autoresize") && !var_InheritBool(intf, "video-wallpaper") {
                self.resizeWindow()
            }
        }
    }

//  MARK: - Init

    convenience init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
                    backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {

        self.init(contentRect:contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        self.b_darkInterface = config_GetInt("macosx-interfacestyle") != 0
        if self.b_darkInterface {
            self.styleMask = NSWindow.StyleMask(rawValue: NSWindow.StyleMask.RawValue(NSWindow.StyleMask.borderless.rawValue | NSWindow.StyleMask.resizable.rawValue | NSWindow.StyleMask.miniaturizable.rawValue))
        }

        /* we want to be moveable regardless of our style */
        self.isMovableByWindowBackground = true
        self.canBecomeKey = true

        self.o_temp_view = NSView()
        self.o_temp_view.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.height.rawValue | NSView.AutoresizingMask.width.rawValue)
    }

    override func awakeFromNib() {
        self.collectionBehavior = NSWindow.CollectionBehavior.fullScreenPrimary

        if self.b_darkInterface && self.titlebarView != nil {
            self.titlebarView.removeFromSuperview()
            self.titlebarView = nil
        }
        super.awakeFromNib()
    }

    override var title: String {
        set {
            if self.b_darkInterface && self.titlebarView != nil {
                self.titlebarView.setWindowTitle(newValue)
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

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true
    }

    override func performClose(_ sender: Any?) {
        if (self.styleMask.rawValue & NSWindow.StyleMask.titled.rawValue) != NSWindow.StyleMask.titled.rawValue {
//            NotificationCenter.default.post(name: NSNotification.Name.NSWillBecomeMultiThreaded, object:self)
            self.close()
        } else {
            super.performClose(sender)
        }
    }

    override func performMiniaturize(_ sender: Any?) {
        if (self.styleMask.rawValue & NSWindow.StyleMask.titled.rawValue) != NSWindow.StyleMask.titled.rawValue {
            self.miniaturize(sender)
        } else {
            super.performMiniaturize(sender)
        }
    }

    override func performZoom(_ sender: Any?) {
        if (self.styleMask.rawValue & NSWindow.StyleMask.titled.rawValue) != NSWindow.StyleMask.titled.rawValue {
            self.customZoom(sender)
        } else {
            super.performZoom(sender)
        }
    }

    override func zoom(_ sender: Any?) {
        if (self.styleMask.rawValue & NSWindow.StyleMask.titled.rawValue) != NSWindow.StyleMask.titled.rawValue {
            self.customZoom(sender)
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
        if (self.styleMask.rawValue & NSWindow.StyleMask.resizable.rawValue) == NSWindow.StyleMask.resizable.rawValue {

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

    private static let DIST = CGFloat(3.0)

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

        maxRect = self.customConstrain(frameRect: maxRect, toScreen: self.screen!)

        // Compare the new frame with the current one
        if (fabs(NSMaxX(maxRect) - NSMaxX(currentFrame)) < VLCVideoWindow.DIST)
            && (fabs(NSMaxY(maxRect) - NSMaxY(currentFrame)) < VLCVideoWindow.DIST)
            && (fabs(NSMinX(maxRect) - NSMinX(currentFrame)) < VLCVideoWindow.DIST)
            && (fabs(NSMinY(maxRect) - NSMinY(currentFrame)) < VLCVideoWindow.DIST) {
            // Already in zoomed mode, reset user frame, if stored
            if self.frameAutosaveName.rawValue.isEmpty != false {
                self.setFrame(self.previousSavedFrame, display: true, animate: true)
                self.saveFrame(usingName: self.frameAutosaveName)
            }
            return
        }

        if self.frameAutosaveName.rawValue.isEmpty != false {
            self.saveFrame(usingName: self.frameAutosaveName)
            self.previousSavedFrame = self.frame
        }

        self.setFrame(maxRect, display: true, animate: true)
    }

// MARK: - Video window resizing logic

    func setWindowLevel(_ state: NSWindow.Level) {
        if var_InheritBool(getIntf()!.as_vlc_object_pointer(), "video-wallpaper") || self.level < NSWindow.Level.normal {
            return
        }

        if !self.fullscreen && !self.b_inFullscreenTransition {
            self.level = state
        }
        // save it for restore if window is currently minimized or in fullscreen
        self.i_originalLevel = state
    }

    func getWindowRectForProposedVideoViewSize(_ size: NSSize) -> NSRect {

        let windowMinSize: NSSize = self.minSize
        let screenFrame: NSRect = self.screen!.visibleFrame

        let topleftbase = NSMakeRect(0, self.frame.size.height, 0, 0)
        let topleftscreen: NSPoint = self.convertToScreen(topleftbase).origin

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
        if self.fullscreen || self.b_inFullscreenTransition {
            return
        }
        let windowRect = self.getWindowRectForProposedVideoViewSize(self.nativeVideoSize)
        self.animator().setFrame(windowRect, display:true)
    }

    func windowWillResize(_ sender: NSWindow, to proposedFrameSize: NSSize) -> NSSize {
        if !VLCMain.instance.activeVideoPlayback || self.nativeVideoSize.width == 0 || self.nativeVideoSize.height == 0 || sender != self {
            return proposedFrameSize
        }
        // needed when entering lion fullscreen mode
        if self.b_inFullscreenTransition || self.fullscreen {
            return proposedFrameSize
        }
        if self.videoView.isHidden {
            return proposedFrameSize
        }

        var proposedSize = proposedFrameSize
        if VLCCoreInteraction.instance.aspectRatioIsLocked {
            let videoWindowFrame = self.frame
            let viewRect = self.videoView.convert(self.videoView.bounds, to: nil)
            let contentRect = self.contentRect(forFrameRect: videoWindowFrame)
            var marginy: CGFloat = viewRect.origin.y + videoWindowFrame.size.height - contentRect.size.height
            let marginx: CGFloat = contentRect.size.width - viewRect.size.width
            if self.titlebarView != nil && self.b_darkInterface {
                marginy += self.titlebarView!.frame.size.height
            }
            proposedSize.height = (proposedFrameSize.width - marginx) * self.nativeVideoSize.height / self.nativeVideoSize.width + marginy
        }

        return proposedSize
    }

    func windowWillMiniaturize(_ notification: Notification) {
        // Set level to normal as a workaround for Mavericks bug causing window
        // to vanish from screen, see radar://15473716
        self.i_originalLevel = self.level
        self.level = NSWindow.Level.normal
    }

    func windowDidDeminiaturize(_ notification: Notification) {
        self.level = self.i_originalLevel
    }

// MARK: - Key events

    override func flagsChanged(with event: NSEvent) {
        let b_alt_pressed = (event.modifierFlags.rawValue & NSEvent.ModifierFlags.option.rawValue) != 0
        self.titlebarView.informModifierPressed(isOptionKey: b_alt_pressed)
        super.flagsChanged(with: event)
    }

// MARK: Lion native fullscreen handling

    func hideControlsBar() {
//    self.controlsBar bottomBarView.isHidden = true)
//    self.videoViewBottomConstraint.priority = 1
    }

    func showControlsBar() {
//    [self.controlsBar bottomBarView.isHidden = false)
//    self.videoViewBottomConstraint.priority = 999
    }

//func becomeKeyWindow() {
//    super.becomeKeyWindow)
//
//    // change fspanel state for the case when multiple windows are in fullscreen
//    if self.hasActiveVideo&& self.fullscreen] {
//        [VLCMain.instance.mainWindow.fspanel.setActive)
//    else
//        [VLCMain.instance.mainWindow.fspanel.setNonActive)
//}
//
//func resignKeyWindow() {
//    super.resignKeyWindow)
//
//    [VLCMain.instance.mainWindow.fspanel.setNonActive)
//}

    func customWindowsToEnterFullScreen(for window: NSWindow) -> [NSWindow]? {
        return window == self ? [window] : nil
    }

    func customWindowsToExitFullScreen(for window: NSWindow) -> [NSWindow]? {
        return window == self ? [window] : nil
    }

    func window(_ window: NSWindow, startCustomAnimationToEnterFullScreenWithDuration duration: TimeInterval) {

        window.styleMask = NSWindow.StyleMask(rawValue: window.styleMask.rawValue | NSWindow.StyleMask.fullScreen.rawValue)
        let screenFrame = window.screen!.frame

        NSAnimationContext.runAnimationGroup(
            { [unowned window] (context: NSAnimationContext) in
                context.duration = 0.5 * duration
                window.animator().setFrame(screenFrame, display: true)
            })
    }

    func window(_ window: NSWindow, startCustomAnimationToExitFullScreenWithDuration duration: TimeInterval) {

        window.styleMask = NSWindow.StyleMask(rawValue: window.styleMask.rawValue & ~NSWindow.StyleMask.fullScreen.rawValue)
        window.animator().setFrame(self.frameBeforeLionFullscreen, display: true, animate: true)

        NSAnimationContext.runAnimationGroup(
            { [unowned window] (context: NSAnimationContext) in
                context.duration = 0.5 * duration
                window.animator().setFrame(self.frameBeforeLionFullscreen, display: true, animate: true)
            })
    }

    func windowWillEnterFullScreen(_ notification: Notification) {

        self.b_windowShouldExitFullscreenWhenFinished = VLCMain.instance.activeVideoPlayback

        let currLevel = self.level
        // self.fullscreen and self.b_inFullscreenTransition must not be true yet
        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(NSWindow.Level.normal)
        self.level = NSWindow.Level.normal
        self.i_originalLevel = currLevel

        self.b_inFullscreenTransition = true

        var_SetBool(pl_Get(getIntf()).as_vlc_object_pointer(), "fullscreen", true)

        self.frameBeforeLionFullscreen = self.frame

        if self.hasActiveVideo {
            if let p_vout = getVoutForActiveWindow() {
                var_SetBool(p_vout.as_vlc_object_pointer(), "fullscreen", true)
                vlc_object_release(p_vout.as_vlc_object_pointer())
            }
        }

        if self.b_darkInterface {
            self.titlebarView.isHidden = true
            self.videoViewTopConstraint.priority = NSLayoutConstraint.Priority(rawValue: 1)

            // shrink window height
            let titleBarHeight = self.titlebarView.frame.size.height
            var winrect = self.frame

            winrect.size.height = winrect.size.height - titleBarHeight
            self.setFrame(winrect, display:false, animate:false)
        }

//        self.hideControlsBar()
        self.isMovableByWindowBackground = false
    }

    func windowDidEnterFullScreen(_ notification: Notification) {
        // Indeed, we somehow can have an "inactive" fullscreen (but a visible window!).
        // But this creates some problems when leaving fs over remote intfs, so activate app here.
        NSApp.activate(ignoringOtherApps: true)

        self.fullscreen = true
        self.b_inFullscreenTransition = false

        let subviews = self.videoView.subviews
        let count = subviews.count
        for x in 0..<count {
// TODO
            //            if subviews objectAtIndex:x.respondsToSelector:#selector(reshape)] {
//                subviews objectAtIndex:x.reshape)
//            }
        }
    }

    func windowWillExitFullScreen(_ notification: Notification) {
        self.b_inFullscreenTransition = true
        self.fullscreen = false

        if self.hasActiveVideo {
            var_SetBool(pl_Get(getIntf()).as_vlc_object_pointer(), "fullscreen", false)

            if let p_vout = getVoutForActiveWindow() {
                var_SetBool(p_vout.as_vlc_object_pointer(), "fullscreen", false)
                vlc_object_release(p_vout.as_vlc_object_pointer())
            }
        }

        NSCursor.setHiddenUntilMouseMoves(false)
//        VLCMain.instance.mainWindow.fspanel.setNonActive)

        if self.b_darkInterface {
            self.titlebarView.isHidden = false
            self.videoViewTopConstraint.priority = NSLayoutConstraint.Priority(rawValue: 999)

            var winrect = self.frame
            let titleBarHeight = self.titlebarView.frame.size.height
            winrect.size.height = winrect.size.height + titleBarHeight
            self.setFrame(winrect, display:false, animate:false)
        }
//        if !self.videoView.isHidden {
//            self.showControlsBar
//        }

        self.isMovableByWindowBackground = true
    }

    func windowDidExitFullScreen(_ notification: Notification) {
        self.b_inFullscreenTransition = false
        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(self.i_originalLevel)
        self.level = self.i_originalLevel
    }

// MARK: - Fullscreen Logic

    func enterFullscreen(animate: Bool) {

        var screen = NSScreen.screen(withDisplayID: CGDirectDisplayID(var_InheritInteger(getIntf()!.as_vlc_object_pointer(), "macosx-vdev")))

        if screen == nil {
//            msg_Dbg(getIntf(), "chosen screen isn't present, using current screen for fullscreen mode")
            screen = self.screen
        }
        if screen == nil {
//            msg_Dbg(getIntf(), "Using deepest screen")
            screen = NSScreen.deepest
        }

        let screenRect = screen!.frame

        let blackout_other_displays = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-black")
        if blackout_other_displays {
            screen!.blackoutOtherScreens()
        }

        /* Make sure we don't see the window flashes in float-on-top mode */
        let curLevel = self.level
        // self.fullscreen must not be true yet
        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(NSWindow.Level.normal)
        self.level = NSWindow.Level.normal
        self.i_originalLevel = curLevel // would be overwritten by previous call

        /* Only create the o_fullscreen_window if we are not in the middle of the zooming animation */
        if self.o_fullscreen_window == nil {
            /* We can't change the styleMask of an already created NSWindow, so we create another window, and do eye catching stuff */

            var rect = self.videoView.superview!.convert(self.videoView.frame, to: nil) /* Convert to Window base coord */
            rect.origin.x += self.frame.origin.x
            rect.origin.y += self.frame.origin.y
            self.o_fullscreen_window = VLCWindow(contentRect: rect, styleMask: NSWindow.StyleMask.borderless, backing: NSWindow.BackingStoreType.buffered, defer: true)
            self.o_fullscreen_window!.backgroundColor = NSColor.black
            self.o_fullscreen_window!.canBecomeKey =  true
            self.o_fullscreen_window!.canBecomeMain = true
            self.o_fullscreen_window!.hasActiveVideo = true
            self.o_fullscreen_window!.fullscreen = true

            /* Make sure video view gets visible in case the playlist was visible before */
            self.b_video_view_was_hidden = self.videoView.isHidden
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
                self.videoView.superview!.replaceSubview(self.videoView, with: self.o_temp_view)
                self.o_temp_view.frame = self.videoView.frame
                self.o_fullscreen_window!.contentView!.addSubview(self.videoView)
                self.videoView.frame = self.o_fullscreen_window!.contentView!.frame
                self.videoView.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)
                NSEnableScreenUpdates()

                screen!.setFullscreenPresentationOptions()

                self.o_fullscreen_window!.setFrame(screenRect, display: true, animate: false)
                self.o_fullscreen_window!.orderFront(self, animate:true)
                self.o_fullscreen_window!.level = NSWindow.Level.normal

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
            self.videoView.superview!.replaceSubview(self.videoView, with: self.o_temp_view)
            self.o_temp_view.frame = self.videoView.frame
            self.o_fullscreen_window!.contentView!.addSubview(self.videoView)
            self.videoView.frame = self.o_fullscreen_window!.contentView!.frame
            self.videoView.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)

            self.o_fullscreen_window!.makeKeyAndOrderFront(self)
            NSEnableScreenUpdates()
        }

        /* We are in fullscreen (and no animation is running) */
        if self.fullscreen {
            /* Make sure we are hidden */
            self.orderOut(self)
            return
        }

        if self.o_fullscreen_anim1 != nil {
            self.o_fullscreen_anim1!.stop()
        }
        if self.o_fullscreen_anim2 != nil {
            self.o_fullscreen_anim2!.stop()
        }

        screen!.setFullscreenPresentationOptions()

        var dict1: [NSViewAnimation.Key: Any] = [:]
        var dict2: [NSViewAnimation.Key: Any] = [:]

        dict1[ NSViewAnimation.Key.target ] = self
        dict1[ NSViewAnimation.Key.effect ] = NSViewAnimation.EffectName.fadeOut

        dict2[ NSViewAnimation.Key.target ]     = self.o_fullscreen_window!
        dict2[ NSViewAnimation.Key.startFrame ] = NSValue(rect: self.o_fullscreen_window!.frame)
        dict2[ NSViewAnimation.Key.endFrame ]   = NSValue(rect: screenRect)

        /* Strategy with NSAnimation allocation:
         - Keep at most 2 animation at a time
         - leaveFullscreen/enterFullscreen are the only responsible for releasing and alloc-ing
         */
        self.o_fullscreen_anim1 = NSViewAnimation(viewAnimations: [dict1])
        self.o_fullscreen_anim2 = NSViewAnimation(viewAnimations: [dict2])

        self.o_fullscreen_anim1!.animationBlockingMode = .nonblocking
        self.o_fullscreen_anim1!.duration = 0.3
        self.o_fullscreen_anim1!.frameRate = 30
        self.o_fullscreen_anim2!.animationBlockingMode = .nonblocking
        self.o_fullscreen_anim2!.duration = 0.2
        self.o_fullscreen_anim2!.frameRate = 30

        self.o_fullscreen_anim2!.delegate = self
        self.o_fullscreen_anim2!.start(when: self.o_fullscreen_anim1!, reachesProgress: 1.0)

        self.o_fullscreen_anim1!.start()
        /* fullscreenAnimation will be unlocked when animation ends */
        self.b_inFullscreenTransition = true
    }

    private func hasBecomeFullscreen() {
        if self.videoView.subviews.count > 0 {
            self.o_fullscreen_window!.makeFirstResponder(self.videoView.subviews[0])
        }
        self.o_fullscreen_window!.makeKey()
        self.o_fullscreen_window!.acceptsMouseMovedEvents = true

        /* tell the fspanel to move itself to front next time it's triggered */
//        VLCMain.instance.mainWindow.fspanel.setVoutWasUpdated:o_fullscreen_window)
//        VLCMain.instance.mainWindow.fspanel.setActive)

        if self.isVisible {
            self.orderOut(self)
        }
        self.b_inFullscreenTransition = false
        self.fullscreen = true
    }

    func leaveFullscreen(animate: Bool) {
        let blackout_other_displays = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-black")

        /* We always try to do so */
        NSScreen.unblackoutScreens()

        self.videoView.window!.makeKeyAndOrderFront(nil)

        /* Don't do anything if o_fullscreen_window is already closed */
        if self.o_fullscreen_window == nil {
            return
        }

//        [VLCMain.instance.mainWindow.fspanel.setNonActive)
        self.o_fullscreen_window!.screen!.setNonFullscreenPresentationOptions()

        if self.o_fullscreen_anim1 != nil {
            self.o_fullscreen_anim1!.stop()
            self.o_fullscreen_anim1 = nil
        }
        if self.o_fullscreen_anim2 != nil {
            self.o_fullscreen_anim2!.stop()
            o_fullscreen_anim2 = nil
        }

        self.b_inFullscreenTransition = true
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
            self.orderFront(self)

            /* Will release the lock */
            self.hasEndedFullscreen()

            if blackout_other_displays {
                CGDisplayFade(token.pointee, 0.5, CGDisplayBlendFraction(kCGDisplayBlendSolidColor), CGDisplayBlendFraction(kCGDisplayBlendNormal), 0, 0, 0, 0)
                CGReleaseDisplayFadeReservation(token.pointee)
            }

            return
        }

        self.alphaValue = 0.0
        self.orderFront(self)
            self.videoView.window?.orderFront(self)

        var frame = self.o_temp_view.superview!.convert(self.o_temp_view.frame, to: nil) /* Convert to Window base coord */
        frame.origin.x += self.frame.origin.x
        frame.origin.y += self.frame.origin.y

        var dict2 = [NSViewAnimation.Key: Any]()
        dict2[NSViewAnimation.Key.target] = self
        dict2[NSViewAnimation.Key.effect] = NSViewAnimation.EffectName.fadeIn

        self.o_fullscreen_anim2 = NSViewAnimation(viewAnimations: [dict2])
        self.o_fullscreen_anim2!.animationBlockingMode = .nonblocking
        self.o_fullscreen_anim2!.duration = 0.3
        self.o_fullscreen_anim2!.frameRate = 30
        self.o_fullscreen_anim2!.delegate = self

        var dict1 = [NSViewAnimation.Key: Any]()
        dict1[NSViewAnimation.Key.target] = self.o_fullscreen_window
        dict1[NSViewAnimation.Key.startFrame] = NSValue(rect: self.o_fullscreen_window!.frame)
        dict1[NSViewAnimation.Key.endFrame] = NSValue(rect: frame)

        self.o_fullscreen_anim1 = NSViewAnimation(viewAnimations: [dict1])
        self.o_fullscreen_anim1!.animationBlockingMode = .nonblocking
        self.o_fullscreen_anim1!.duration = 0.2
        self.o_fullscreen_anim1!.frameRate = 30
        self.o_fullscreen_anim2!.start(when: self.o_fullscreen_anim1!, reachesProgress: 1.0)

        /* Make sure o_fullscreen_window is the frontmost window */
        self.o_fullscreen_window!.orderFront(self)

        self.o_fullscreen_anim1!.start()
        /* fullscreenAnimation will be unlocked when animation ends */
    }

    private func hasEndedFullscreen() {
        self.b_inFullscreenTransition = false

        /* This function is private and should be only triggered at the end of the fullscreen change animation */
        /* Make sure we don't see the self.videoView disappearing of the screen during this operation */
        NSDisableScreenUpdates()
        self.videoView.removeFromSuperviewWithoutNeedingDisplay()
        self.o_temp_view.superview!.replaceSubview(o_temp_view, with: self.videoView)
        // TODO Replace tmpView by an existing view (e.g. middle view)
        // TODO Use constraints for fullscreen window, reinstate constraints once the video view is added to the main window again
        self.videoView.frame = self.o_temp_view.frame
        if self.videoView.subviews.count > 0 {
            self.makeFirstResponder(self.videoView.subviews.first)
        }
        self.videoView.isHidden = self.b_video_view_was_hidden

        self.makeKeyAndOrderFront(self)

        self.o_fullscreen_window!.orderOut(self)
        NSEnableScreenUpdates()

        self.o_fullscreen_window = nil

        VLCMain.instance.voutController.updateWindowLevelForHelperWindows(self.i_originalLevel)
        self.level = self.i_originalLevel

        self.alphaValue = CGFloat(config_GetFloat("macosx-opaqueness"))
    }

    func animationDidEnd(_ animation: NSAnimation) {
    //    NSArray *viewAnimations
        guard animation.currentValue >= 1.0 else {
            return
        }

        /* Fullscreen ended or started (we are a delegate only for leaveFullscreen's/enterFullscren's anim2) */
        let viewAnimations = self.o_fullscreen_anim2!.viewAnimations
        if viewAnimations.first?[NSViewAnimation.Key.effect] as? NSViewAnimation.EffectName == NSViewAnimation.EffectName.fadeIn {
            /* Fullscreen ended */
            self.hasEndedFullscreen()
        } else {
        /* Fullscreen started */
            self.hasBecomeFullscreen()
        }
    }

// MARK: - Accessibility stuff

//func accessibilityAttributeNames -> NSArray *
//{
//    if !self.b_darkInterface || !self.titlebarView {
//        return super.accessibilityAttributeNames)
//
//    static NSMutableArray *attributes = nil
//    if attributes == nil {
//        attributes = [super.accessibilityAttributeNames.mutableCopy)
//        NSArray *appendAttributes = [NSArray arrayWithObjects:NSAccessibilitySubroleAttribute,
//                                     NSAccessibilityCloseButtonAttribute,
//                                     NSAccessibilityMinimizeButtonAttribute,
//                                     NSAccessibilityZoomButtonAttribute, nil)
//
//        for(NSString *attribute in appendAttributes) {
//            if ![attributes containsObject:attribute] {
//                [attributes addObject:attribute)
//        }
//    }
//    return attributes
//}
//
//func accessibilityAttributeValue: (NSString*)o_attribute_name -> id
//{
//    if self.b_darkInterface && self.titlebarView {
//        VLCMainWindowTitleView *o_tbv = self.titlebarView
//
//        if [o_attribute_name isEqualTo: NSAccessibilitySubroleAttribute] {
//            return NSAccessibilityStandardWindowSubrole
//
//        if [o_attribute_name isEqualTo: NSAccessibilityCloseButtonAttribute] {
//            return o_tbv closeButton.cell)
//
//        if [o_attribute_name isEqualTo: NSAccessibilityMinimizeButtonAttribute] {
//            return o_tbv minimizeButton.cell)
//
//        if [o_attribute_name isEqualTo: NSAccessibilityZoomButtonAttribute] {
//            return o_tbv zoomButton.cell)
//    }
//
//    return super.accessibilityAttributeValue: o_attribute_name)
//}

    private var frameBeforePlayback: NSRect = NSZeroRect

    func videoplayWillBeStarted() {
        if !self.fullscreen {
            self.frameBeforePlayback = self.frame
        }
    }

    func setVideoplayEnabled() {

        let videoPlayback = VLCMain.instance.activeVideoPlayback
        if !videoPlayback {
            if !self.fullscreen && self.frameBeforePlayback.size.width > 0 && self.frameBeforePlayback.size.height > 0 {

                // only resize back to minimum view of this is still desired final state
                let f_threshold_height: CGFloat = MIN_VIDEO_HEIGHT
                if self.frameBeforePlayback.size.height > f_threshold_height /*|| b_minimized_view*/ {
                    if VLCMain.instance.isTerminating {
                        self.setFrame(self.frameBeforePlayback, display: true)
                    } else {
                        self.animator().setFrame(self.frameBeforePlayback, display: true)
                    }
                }
            }

            self.frameBeforePlayback = NSMakeRect(0, 0, 0, 0)
            VLCMain.instance.voutController.updateWindowLevelForHelperWindows(NSWindow.Level.normal)
        }

        if self.hasActiveVideo && self.fullscreen && videoPlayback {
            self.controlsBar.setActive()
//            [self.fspanel setActive]
        } else {
            self.controlsBar.setNonActive()
//            [self.fspanel setNonActive]
        }
    }
}
