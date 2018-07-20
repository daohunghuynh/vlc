//
//  VLCWindow.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 01/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

class VLCWindow : NSWindow, NSAnimationDelegate {

    private var b_canBecomeKeyWindow: Bool = true
    private var b_isset_canBecomeKeyWindow: Bool = false
    private var b_canBecomeMainWindow: Bool = true
    private var b_isset_canBecomeMainWindow: Bool = false

    var hasActiveVideo:  Bool = false
    var fullscreen:  Bool = false

    override convenience init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
                    backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {

        self.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        /* we don't want this window to be restored on relaunch */
        self.isRestorable = false
    }

    override var canBecomeKey: Bool {
        set {
            self.b_isset_canBecomeKeyWindow = true
            self.b_canBecomeKeyWindow = newValue
        }
        get {
            if self.b_isset_canBecomeKeyWindow {
                return self.b_canBecomeKeyWindow
            }
            return super.canBecomeKey
        }
    }

    override var canBecomeMain: Bool {
        set {
            self.b_isset_canBecomeMainWindow = true
            self.b_canBecomeMainWindow = newValue
        }
        get {
            if self.b_isset_canBecomeMainWindow {
                return self.b_canBecomeMainWindow
            }
            return super.canBecomeMain
        }
    }

    func closeAndAnimate(animate: Bool) {
        // No animation, just close
        if !animate {
            super.close()
            return
        }
      
        // Animate window alpha value
        self.alphaValue = 1.0
        NSAnimationContext.runAnimationGroup(
            { [unowned self] (context: NSAnimationContext) in
                NSAnimationContext.current.duration = 0.9
                self.animator().alphaValue = 0.0
            },
            completionHandler: { [unowned self] in
                self.close()
            })
    }

    func orderOut(_ sender: Any?, animate: Bool) {
        if !animate {
            super.orderOut(sender)
            return
        }
        if self.alphaValue == 0.0 {
            super.orderOut(self)
            return
        }
        
        NSAnimationContext.runAnimationGroup(
            { [unowned self] (context: NSAnimationContext) in
                NSAnimationContext.current.duration = 0.5
                self.animator().alphaValue = 0.0
            },
            completionHandler: { [unowned self] in
                self.orderOut(self)
            })
    }

    func orderFront(_ sender: Any?, animate: Bool) {
        if !animate {
            super.orderFront(sender)
            self.alphaValue = 1.0
            return
        }
      
        if !self.isVisible {
            self.alphaValue = 0.0
            super.orderFront(sender)
        } else if self.alphaValue == 1.0 {
            super.orderFront(self)
            return
        }
      
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        self.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
    }

    func videoView() -> VLCVoutView? {

        let o_subViews = self.contentView!.subviews
        if o_subViews.count > 0 {
            return o_subViews[0] as? VLCVoutView
        }
        return nil
    }

    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        var curScreen: NSScreen! = screen
        if screen == nil {
            curScreen = self.screen
        }
//        let screenRect = curScreen.frame
        let constrainedRect = super.constrainFrameRect(frameRect, to: curScreen)
      
        /*
         * Ugly workaround!
             * With Mavericks, there is a nasty bug resulting in grey bars on top in fullscreen mode.
         * It looks like this is enforced by the os because the window is in the way for the menu bar.
         *
         * According to the documentation, this constraining can be changed by overwriting this
         * method. But in this situation, even the received frameRect is already contrained with the
         * menu bars height substracted. This case is detected here, and the full height is
         * enforced again.
         *
         * See #9469 and radar://15583566
         */
      
//        let inFullscreen = self.fullscreen || (self.respondsToSelector:@selector(inFullscreenTransition)] && [(VLCVideoWindowCommon *)self inFullscreenTransition])

//        if b_inFullscreen && constrainedRect.size.width == screenRect.size.width
//              && constrainedRect.size.height != screenRect.size.height
//              && fabs(screenRect.size.height - constrainedRect.size.height) <= 25.0 {
//
//            msg_Dbg(getIntf(), "Contrain window height %.1f to screen height %.1f",
//                    constrainedRect.size.height, screenRect.size.height)
//            constrainedRect.size.height = screenRect.size.height
//        }
        return constrainedRect
    }
}
