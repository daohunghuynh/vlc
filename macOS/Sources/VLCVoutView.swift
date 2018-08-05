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
    private var _scrollTimer: Timer?
    private var _lastScrollWheelDirection: Int = 0
    private var _cumulatedXScrollValue: Float = 0.0
    private var _cumulatedYScrollValue: Float = 0.0
    private var _cumulatedMagnification: Float = 0.0
    private var _p_vout: UnsafeMutablePointer<vout_thread_t>?

    deinit {
        if _p_vout != nil {
            vlc_object_release(_p_vout!.as_vlc_object_pointer())
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

// MARK: - drag & drop support

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if sender.draggingSourceOperationMask().contains(.generic) {
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
        let pressedModifiers = event.modifierFlags
        val.i_int = 0

        if pressedModifiers.contains(.shift) {
            val.i_int |= Int64(KEY_MODIFIER_SHIFT)
        }
        if pressedModifiers.contains(.control) {
            val.i_int |= Int64(KEY_MODIFIER_CTRL)
        }
        if pressedModifiers.contains(.option) {
            val.i_int |= Int64(KEY_MODIFIER_ALT)
        }
        if pressedModifiers.contains(.command) {
            val.i_int |= Int64(KEY_MODIFIER_COMMAND)
        }

        let characters = event.charactersIgnoringModifiers?.lowercased()
        if let key = characters?[characters!.startIndex] {
            /* Escape should always get you out of fullscreen */
            if key.unicodeScalars.contains(Unicode.Scalar(0x1b)) {
                let p_playlist = pl_Get(getIntf())
                if var_GetBool(p_playlist?.as_vlc_object_pointer(), "fullscreen") {
                     VLCCoreInteraction.instance.toggleFullscreen()
                }
            }
            /* handle Lion's default key combo for fullscreen-toggle in addition to our own hotkeys */
            else if key.unicodeScalars.contains("f")
                && pressedModifiers.contains(.control)
                && pressedModifiers.contains(.command) {
                VLCCoreInteraction.instance.toggleFullscreen()
            } else if _p_vout != nil {
                val.i_int |= Int64(CocoaKeyToVLC(key.unicodeScalars.first!))
                var_Set(_p_vout!.pointee.obj.libvlc.as_vlc_object_pointer(), "key-pressed", val)
            }
            else {
                msg_Dbg(getIntf(), "could not send keyevent to VLC core")
            }
            return
        }
        super.keyDown(with: event)
    }

//    override func performKeyEquivalent(with event: NSEvent) -> Bool {
//        return VLCMain.instance.mainWindow.performKeyEquivalent(with: event)
//    }

    override func mouseDown(with event: NSEvent) {
        if event.type == .leftMouseDown && !event.modifierFlags.contains(.control) {
            if event.clickCount == 2 {
                VLCCoreInteraction.instance.toggleFullscreen()
            }
        } else if event.type == .rightMouseDown || (event.type == .leftMouseDown && event.modifierFlags.contains(.control)) {
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
        _lastScrollWheelDirection = 0
        _cumulatedXScrollValue = 0
        _cumulatedYScrollValue = 0
        msg_Dbg(getIntf(), "Reset scrolling timer")
    }

    override func scrollWheel(with event: NSEvent) {
        let xThreshold = Float(0.8)
        let yThreshold = Float(1.0)
        let directionThreshold = Float(0.05)

        let p_intf = getIntf()!
        var deltaX = Float(event.deltaX)
        var deltaY = Float(event.deltaY)

        if event.isDirectionInvertedFromDevice {
            deltaX = -deltaX
            deltaY = -deltaY
        }

        let deltaXAbs = abs(deltaX)
        let deltaYAbs = abs(deltaY)

        // A mouse scroll wheel has lower sensitivity. We want to scroll at least
        // with every event here.
        let isMouseScrollWheel = event.subtype == NSEvent.EventSubtype.mouseEvent
        if isMouseScrollWheel && deltaYAbs < yThreshold {
            deltaY = deltaY > 0 ? yThreshold : -yThreshold
        }
        if isMouseScrollWheel && deltaXAbs < xThreshold {
            deltaX = deltaX > 0 ? xThreshold : -xThreshold
        }

        /* in the following, we're forwarding either a x or a y event */
        /* Multiple key events are send depending on the intensity of the event */
        /* the opposite direction is being blocked for a couple of milli seconds */
        if deltaYAbs > directionThreshold {
            if _lastScrollWheelDirection < 0 { // last was a X
                return
            }
            _lastScrollWheelDirection = 1 // Y

            _cumulatedYScrollValue += deltaY
            let key: Int32 = _cumulatedYScrollValue < 0 ? KEY_MOUSEWHEELDOWN : KEY_MOUSEWHEELUP

            while abs(_cumulatedYScrollValue) >= yThreshold {
                _cumulatedYScrollValue -= (_cumulatedYScrollValue > 0 ? yThreshold : -yThreshold)
                var_SetInteger(p_intf.pointee.obj.libvlc.as_vlc_object_pointer(), "key-pressed", Int64(key))
//                msg_Dbg(p_intf, "Scrolling in y direction")
            }

        } else if deltaXAbs > directionThreshold {
            if _lastScrollWheelDirection > 0 { // last was a Y
                return
            }
            _lastScrollWheelDirection = -1 // X

            _cumulatedXScrollValue += deltaX
            let key: Int32 = _cumulatedXScrollValue < 0 ? KEY_MOUSEWHEELRIGHT : KEY_MOUSEWHEELLEFT

            while abs(_cumulatedXScrollValue) >= xThreshold {
                _cumulatedXScrollValue -= (_cumulatedXScrollValue > 0 ? xThreshold : -xThreshold)
                var_SetInteger(p_intf.pointee.obj.libvlc.as_vlc_object_pointer(), "key-pressed", Int64(key))
//                msg_Dbg(p_intf, "Scrolling in x direction")
            }
        }

        if _scrollTimer != nil {
            _scrollTimer!.invalidate()
            _scrollTimer = nil
        }
        _scrollTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(resetScrollWheelDirection), userInfo: nil, repeats: false)
    }

// MARK: - Handling of vout related actions

    var voutThread: UnsafeMutablePointer<vout_thread_t>? {
        set {
            assert(_p_vout == nil)
            _p_vout = newValue
            vlc_object_hold(_p_vout!.as_vlc_object_pointer())
        }
        get {
            if _p_vout != nil {
                vlc_object_hold(_p_vout!.as_vlc_object_pointer())
                return _p_vout
            }
            return nil
        }
    }

    func releaseVoutThread() {
        if _p_vout != nil {
            vlc_object_release(_p_vout!.as_vlc_object_pointer())
            _p_vout = nil
        }
    }

// MARK: - Basic view behaviour and touch events handling

    func mouseDownCanMoveWindow() -> Bool {
        if _p_vout != nil {
            return !var_GetBool(_p_vout!.as_vlc_object_pointer(), "viewpoint-changeable")
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
//        f_cumulatedMagnification += [event magnification)

        // This is the result of [NSEvent standardMagnificationThreshold].
        // Unfortunately, this is a private var currently.: API,
//        Float f_threshold = 0.3
//        Bool b_fullscreen = [(VLCVideoWindowCommon *)self.window] fullscreen)
//
//        if ((f_cumulatedMagnification > f_threshold && !b_fullscreen) || (f_cumulatedMagnification < -f_threshold && b_fullscreen)) {
//            f_cumulatedMagnification = 0.0
//            [VLCCoreInteraction.instance.toggleFullscreen)
//        }
    }

    func beginGestureWithEvent(with event: NSEvent) {
        _cumulatedMagnification = 0.0
    }
}
