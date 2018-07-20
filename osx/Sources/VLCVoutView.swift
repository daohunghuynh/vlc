//
//  VLCVoutView.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 31/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

class VLCVoutView : NSView {

    private var p_scrollTimer: Timer?
    private var i_lastScrollWheelDirection: Int = 0
    private var f_cumulatedXScrollValue: Float = 0.0
    private var f_cumulatedYScrollValue: Float = 0.0
    private var f_cumulated_magnification: Float = 0.0
    private var p_vout: UnsafeMutablePointer<vout_thread_t>?

// MARK: - drag & drop support

    deinit {
        if self.p_vout != nil {
            vlc_object_release(p_vout!.as_vlc_object_pointer())
        }
        unregisterDraggedTypes()
    }

    override convenience init(frame frameRect: NSRect) {
        self.init(frame: frameRect)
        registerForDraggedTypes([.fileURL])
    }

    override func draw(_ dirtyRect: NSRect) {
        // Draw black area in case first frame is not drawn yet
        NSColor.black.setFill()
        dirtyRect.fill()
    }

    func addVoutLayer(aLayer: CALayer) {
        if self.layer == nil {
            self.layer = CALayer()
            self.wantsLayer = true
        }

        CATransaction.begin()
        aLayer.isOpaque = true
        aLayer.isHidden = false
        aLayer.bounds = self.layer!.bounds
        self.layer!.addSublayer(aLayer)
        self.needsDisplay = true
        aLayer.setNeedsDisplay()
        var frame = aLayer.bounds
        frame.origin.x = 0.0
        frame.origin.y = 0.0
        aLayer.frame = frame
        CATransaction.commit()
    }

    func removeVoutLayer(aLayer: CALayer) {
        CATransaction.begin()
        aLayer.removeFromSuperlayer()
        CATransaction.commit()
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if (NSDragOperation.generic.rawValue & sender.draggingSourceOperationMask().rawValue) == NSDragOperation.generic.rawValue {
            return .generic
        }
        return NSDragOperation()
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let b_returned = VLCCoreInteraction.instance.performDragOperation(sender: sender)
        self.needsDisplay = true
        return b_returned
    }

    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        self.needsDisplay = true
    }

// MARK: - vout actions

    override func keyDown(with event: NSEvent) {
        var val = vlc_value_t()
        let i_pressed_modifiers: UInt = event.modifierFlags.rawValue
        val.i_int = 0

        if (i_pressed_modifiers & NSEvent.ModifierFlags.shift.rawValue) == NSEvent.ModifierFlags.shift.rawValue {
            val.i_int |= Int64(KEY_MODIFIER_SHIFT)
        }
        if (i_pressed_modifiers & NSEvent.ModifierFlags.control.rawValue) == NSEvent.ModifierFlags.control.rawValue {
            val.i_int |= Int64(KEY_MODIFIER_CTRL)
        }
        if (i_pressed_modifiers & NSEvent.ModifierFlags.option.rawValue) == NSEvent.ModifierFlags.option.rawValue {
            val.i_int |= Int64(KEY_MODIFIER_ALT)
        }
        if (i_pressed_modifiers & NSEvent.ModifierFlags.command.rawValue) == NSEvent.ModifierFlags.command.rawValue {
            val.i_int |= Int64(KEY_MODIFIER_COMMAND)
        }

        let characters = event.charactersIgnoringModifiers?.lowercased()
        if characters != nil, let key = characters?[characters!.startIndex] {
            /* Escape should always get you out of fullscreen */
            if key.unicodeScalars.contains(Unicode.Scalar(0x1b)) {
                let p_playlist = pl_Get(getIntf())
                if var_GetBool(p_playlist?.as_vlc_object_pointer(), "fullscreen") {
                     VLCCoreInteraction.instance.toggleFullscreen()
                }
            }
            /* handle Lion's default key combo for fullscreen-toggle in addition to our own hotkeys */
            else if key.unicodeScalars.contains("f")
                && (i_pressed_modifiers & NSEvent.ModifierFlags.control.rawValue) == NSEvent.ModifierFlags.control.rawValue
                && (i_pressed_modifiers & NSEvent.ModifierFlags.command.rawValue) == NSEvent.ModifierFlags.command.rawValue {
                VLCCoreInteraction.instance.toggleFullscreen()
            } else if self.p_vout != nil {
                val.i_int |= Int64(CocoaKeyToVLC(key.unicodeScalars.first!))
                var_Set(self.p_vout!.pointee.obj.libvlc.as_vlc_object_pointer(), "key-pressed", val)
            }
            else {
//                msg_Dbg(getIntf(), "could not send keyevent to VLC core")
            }
            return
        }
        super.keyDown(with: event)
    }

//    override func performKeyEquivalent(with event: NSEvent) -> Bool {
//        return VLCMain.instance.mainWindow.performKeyEquivalent(with: event)
//    }

    override func mouseDown(with event: NSEvent) {
        if event.type == .leftMouseDown && (event.modifierFlags.rawValue & NSEvent.ModifierFlags.control.rawValue) != NSEvent.ModifierFlags.control.rawValue {
            if event.clickCount == 2 {
                VLCCoreInteraction.instance.toggleFullscreen()
            }
        } else if event.type == .rightMouseDown || (event.type == .leftMouseDown && (event.modifierFlags.rawValue & NSEvent.ModifierFlags.control.rawValue) == NSEvent.ModifierFlags.control.rawValue) {
            NSMenu.popUpContextMenu(VLCMain.instance.mainMenu.voutMenu, with: event, for: self)
        }
        super.mouseDown(with: event)
    }

    override func rightMouseDown(with event: NSEvent) {
        if event.type == .rightMouseDown {
            NSMenu.popUpContextMenu(VLCMain.instance.mainMenu.voutMenu, with: event, for: self)
        }
        super.mouseDown(with: event)
    }

    override func rightMouseUp(with event: NSEvent) {
        if event.type == .rightMouseUp {
            NSMenu.popUpContextMenu(VLCMain.instance.mainMenu.voutMenu, with: event, for: self)
        }
        super.mouseUp(with: event)
    }

    override func mouseMoved(with event: NSEvent) {
//        let ml: NSPoint = self.convert(event.locationInWindow, from: nil)
//        if self.mouse(ml, in: self.bounds) {
//            VLCMain.instance.showFullscreenController()
//        }
//        super.mouseMoved(with: event)
    }

    @objc func resetScrollWheelDirection() {
        self.i_lastScrollWheelDirection = 0
        self.f_cumulatedXScrollValue = 0
        self.f_cumulatedYScrollValue = 0
//        msg_Dbg(getIntf(), "Reset scrolling timer")
    }

    override func scrollWheel(with event: NSEvent) {
        let f_xThreshold = Float(0.8)
        let f_yThreshold = Float(1.0)
        let f_directionThreshold = Float(0.05)

        let p_intf = getIntf()!
        var f_deltaX = Float(event.deltaX)
        var f_deltaY = Float(event.deltaY)

        if event.isDirectionInvertedFromDevice {
            f_deltaX = -f_deltaX
            f_deltaY = -f_deltaY
        }

        let f_deltaXAbs = abs(f_deltaX)
        let f_deltaYAbs = abs(f_deltaY)

        // A mouse scroll wheel has lower sensitivity. We want to scroll at least
        // with every event here.
        let isMouseScrollWheel = event.subtype == NSEvent.EventSubtype.mouseEvent
        if isMouseScrollWheel && f_deltaYAbs < f_yThreshold {
            f_deltaY = f_deltaY > 0 ? f_yThreshold : -f_yThreshold
        }
        if isMouseScrollWheel && f_deltaXAbs < f_xThreshold {
            f_deltaX = f_deltaX > 0 ? f_xThreshold : -f_xThreshold
        }

        /* in the following, we're forwarding either a x or a y event */
        /* Multiple key events are send depending on the intensity of the event */
        /* the opposite direction is being blocked for a couple of milli seconds */
        if f_deltaYAbs > f_directionThreshold {
            if self.i_lastScrollWheelDirection < 0 { // last was a X
                return
            }
            self.i_lastScrollWheelDirection = 1 // Y

            self.f_cumulatedYScrollValue += f_deltaY
            let key: Int32 = self.f_cumulatedYScrollValue < 0 ? KEY_MOUSEWHEELDOWN : KEY_MOUSEWHEELUP

            while abs(self.f_cumulatedYScrollValue) >= f_yThreshold {
                self.f_cumulatedYScrollValue -= (self.f_cumulatedYScrollValue > 0 ? f_yThreshold : -f_yThreshold)
                var_SetInteger(p_intf.pointee.obj.libvlc.as_vlc_object_pointer(), "key-pressed", Int64(key))
//                msg_Dbg(p_intf, "Scrolling in y direction")
            }

        } else if f_deltaXAbs > f_directionThreshold {
            if self.i_lastScrollWheelDirection > 0 { // last was a Y
                return
            }
            self.i_lastScrollWheelDirection = -1 // X

            self.f_cumulatedXScrollValue += f_deltaX
            let key: Int32 = self.f_cumulatedXScrollValue < 0 ? KEY_MOUSEWHEELRIGHT : KEY_MOUSEWHEELLEFT

            while abs(self.f_cumulatedXScrollValue) >= f_xThreshold {
                self.f_cumulatedXScrollValue -= (self.f_cumulatedXScrollValue > 0 ? f_xThreshold : -f_xThreshold)
                var_SetInteger(p_intf.pointee.obj.libvlc.as_vlc_object_pointer(), "key-pressed", Int64(key))
//                msg_Dbg(p_intf, "Scrolling in x direction")
            }
        }

        if self.p_scrollTimer != nil {
            self.p_scrollTimer!.invalidate()
            self.p_scrollTimer = nil
        }
        self.p_scrollTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(resetScrollWheelDirection), userInfo: nil, repeats: false)
    }

// MARK: - Handling of vout related actions

    var voutThread: UnsafeMutablePointer<vout_thread_t>? {
        set {
            assert(self.p_vout == nil)
            self.p_vout = newValue
            vlc_object_hold(self.p_vout!.as_vlc_object_pointer())
        }
        get {
            if self.p_vout != nil {
                vlc_object_hold(self.p_vout!.as_vlc_object_pointer())
                return self.p_vout
            }
            return nil
        }
    }

    func releaseVoutThread() {
        if self.p_vout != nil {
            vlc_object_release(self.p_vout!.as_vlc_object_pointer())
            self.p_vout = nil
        }
    }

// MARK: - Basic view behaviour and touch events handling

    func mouseDownCanMoveWindow() -> Bool {
        if self.p_vout != nil {
            return !var_GetBool(self.p_vout!.as_vlc_object_pointer(), "viewpoint-changeable")
        }
        return true
    }

    func acceptsFirstResponder() -> Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func resignFirstResponder() -> Bool {
        /* while we need to be the first responder most of the time, we need to give up that status when toggling the playlist */
        return true
    }

    override func didAddSubview(_ subview: NSView) {
        self.window?.makeFirstResponder(subview)
    }

    func magnifyWithEvent(with event: NSEvent) {
//        f_cumulated_magnification += [event magnification)

        // This is the result of [NSEvent standardMagnificationThreshold].
        // Unfortunately, this is a private var currently.: API,
//        Float f_threshold = 0.3
//        Bool b_fullscreen = [(VLCVideoWindowCommon *)self.window] fullscreen)
//
//        if ((f_cumulated_magnification > f_threshold && !b_fullscreen) || (f_cumulated_magnification < -f_threshold && b_fullscreen)) {
//            f_cumulated_magnification = 0.0
//            [VLCCoreInteraction.instance.toggleFullscreen)
//        }
    }

    func beginGestureWithEvent(with event: NSEvent) {
        self.f_cumulated_magnification = 0.0
    }
}
