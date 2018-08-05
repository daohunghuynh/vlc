//
//  VLCMainWindowControlsBar.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 31/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

@objc class VLCControlsBar : NSView {

    private var _pauseImage: NSImage!
    private var _pressedPauseImage: NSImage!
    private var _playImage: NSImage!
    private var _pressedPlayImage: NSImage!

    private var _lastFwdEvent: TimeInterval = NSDate.timeIntervalSinceReferenceDate
    private var _lastBwdEvent: TimeInterval = NSDate.timeIntervalSinceReferenceDate
    private var just_triggered_next: Bool = false
    private var just_triggered_previous: Bool = false

    // @IBOutlet var dropView: VLCDragDropView!
    @IBOutlet var playButton: NSButton!
    @IBOutlet var backwardButton: NSButton!
    @IBOutlet var forwardButton: NSButton!
    @IBOutlet var timeSlider: NSSlider! //VLCSlider!
    @IBOutlet var timeField: NSTextField! //VLCTimeField!
    @IBOutlet var bottomBarView: NSView! //VLCBottomBarView!

//    - (IBAction)fullscreen(_ sender: Any)
//
//    - (void)updateTimeSlider
//    - (void)updateControls
//    - (void)setPause
//    - (void)setPlay
//    - (void)setFullscreenState:(BOOL)b_fullscreen


    override func awakeFromNib() {
        super.awakeFromNib()

//        self.dropView setDrawBorder: false
        self.playButton.toolTip = _NS("Play")
//        self.playButton.cell.accessibilitySetOverrideValue(self.playButton.toolTip, forAttribute: NSAccessibilityDescriptionAttribute)

//        self.backwardButton.toolTip = _NS("Backward")
//        self.backwardButton.cell accessibilitySetOverrideValue:_NS("Seek backward") forAttribute:NSAccessibilityDescriptionAttribute
//        self.backwardButton.cell accessibilitySetOverrideValue:self.backwardButton toolTip] forAttribute:NSAccessibilityTitleAttribute

//        self.forwardButton.toolTip = _NS("Forward")
//        self.forwardButton.cell accessibilitySetOverrideValue:_NS("Seek forward") forAttribute:NSAccessibilityDescriptionAttribute
//        self.forwardButton.cell accessibilitySetOverrideValue:self.forwardButton toolTip] forAttribute:NSAccessibilityTitleAttribute

        self.timeSlider.toolTip = _NS("Position")
//        self.timeSlider.cell.accessibilitySetOverrideValue(_NS("Playback position"), forAttribute:NSAccessibilityDescriptionAttribute)
//        self.timeSlider.cell.accessibilitySetOverrideValue(self.timeSlider.toolTip, forAttribute:NSAccessibilityTitleAttribute)


        self.backwardButton.image = imageFromRes("backward-3btns")
        self.backwardButton.alternateImage = imageFromRes("backward-3btns-pressed")
        _playImage = imageFromRes("play")
        _pressedPlayImage = imageFromRes("play-pressed")
        _pauseImage = imageFromRes("pause")
        _pressedPauseImage = imageFromRes("pause-pressed")
        self.forwardButton.image = imageFromRes("forward-3btns")
        self.forwardButton.alternateImage = imageFromRes("forward-3btns-pressed")

        self.playButton.image = _playImage
        self.playButton.alternateImage = _pressedPlayImage

        var timeFieldTextColor: NSColor
        if !var_InheritBool(getIntf()?.as_vlc_object_pointer(), "macosx-interfacestyle") {
            timeFieldTextColor = NSColor(calibratedRed:0.229, green:0.229, blue:0.229, alpha:100.0)
        } else {
            timeFieldTextColor = NSColor(calibratedRed:0.64, green:0.64, blue:0.64, alpha:100.0)
        }
        self.timeField.textColor = timeFieldTextColor
        self.timeField.font = NSFont.titleBarFont(ofSize: 10.0)
        self.timeField.alignment = .center
        self.timeField.needsDisplay = true
        self.timeField.remainingIdentifier = "DisplayTimeAsTimeRemaining"
//        self.timeField.cell.accessibilitySetOverrideValue:_NS("Playback time")
//                                                forAttribute:NSAccessibilityDescriptionAttribute

        if config_GetInt("macosx-show-playback-buttons") != 0 {
            self.toggleForwardBackwardMode(true)
        }
    }

    var height: CGFloat {
        return self.bottomBarView.frame.size.height
    }

    func setActive() {

    }

    func setNonActive() {

    }

    func toggleForwardBackwardMode(_ b_alt: Bool) {
        if (b_alt == true) {
            /* change the accessibility help for the backward/forward buttons accordingly */
//            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Backward") forAttribute:NSAccessibilityTitleAttribute
//            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Seek backward") forAttribute:NSAccessibilityDescriptionAttribute

//            self.forwardButton.cell accessibilitySetOverrideValue:_NS("Forward") forAttribute:NSAccessibilityTitleAttribute
//            self.forwardButton.cell accessibilitySetOverrideValue:_NS("Seek forward") forAttribute:NSAccessibilityDescriptionAttribute

            self.forwardButton.action = #selector(alternateForward)
            self.backwardButton.action = #selector(alternateBackward)

        } else {
            /* change the accessibility help for the backward/forward buttons accordingly */
//            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Previous") forAttribute:NSAccessibilityTitleAttribute
//            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Go to previous item") forAttribute:NSAccessibilityDescriptionAttribute

//            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Next") forAttribute:NSAccessibilityTitleAttribute
//            self.forwardButton.cell accessibilitySetOverrideValue:_NS("Go to next item") forAttribute:NSAccessibilityDescriptionAttribute

            self.forwardButton.action = #selector(fwd)
            self.backwardButton.action = #selector(bwd)
        }
    }

// MARK: - Button Actions

    @IBAction func play(_ sender: Any) {
        VLCCoreInteraction.instance.playOrPause()
    }

//    @objc func resetPreviousButton() {
//        if NSDate.timeIntervalSinceReferenceDate - self.last_bwd_event >= 0.35 {
//            // seems like no further event occurred, so let's switch the playback item
//            VLCCoreInteraction.instance.previous()
//            self.just_triggered_previous = false
//        }
//    }

    @objc func resetBackwardSkip() {
        // the user stopped skipping, so let's allow him to change the item
        if NSDate.timeIntervalSinceReferenceDate - _lastBwdEvent >= 0.35 {
            self.just_triggered_previous = false
        }
    }

    @IBAction func bwd(_ sender: Any) {
        if !self.just_triggered_previous {
//            just_triggered_previous = true
//            self.perform(#selector(resetPreviousButton), with: nil, afterDelay: 0.40)
        } else {
            if NSDate.timeIntervalSinceReferenceDate - _lastFwdEvent > 0.16 {
                // we just skipped 4 "continous" events, otherwise we are too fast
                VLCCoreInteraction.instance.backwardExtraShort()
                _lastBwdEvent = NSDate.timeIntervalSinceReferenceDate
                self.perform(#selector(resetBackwardSkip), with: nil, afterDelay: 0.40)
            }
        }
    }

//    @objc func resetNextButton() {
//        if NSDate.timeIntervalSinceReferenceDate - self.last_fwd_event >= 0.35 {
//            // seems like no further event occurred, so let's switch the playback item
//            VLCCoreInteraction.instance.next()
//            self.just_triggered_next = false
//        }
//    }

    @objc func resetForwardSkip() {
        // the user stopped skipping, so let's allow him to change the item
        if NSDate.timeIntervalSinceReferenceDate - _lastFwdEvent >= 0.35 {
            self.just_triggered_next = false
        }
    }

    @IBAction func fwd(_ sender: Any) {
        if !self.just_triggered_next {
//            self.just_triggered_next = true
//            self.perform(#selector(resetNextButton), with: nil, afterDelay: 0.40)
        } else {
            if NSDate.timeIntervalSinceReferenceDate - _lastFwdEvent > 0.16 {
                // we just skipped 4 "continous" events, otherwise we are too fast
                VLCCoreInteraction.instance.forwardExtraShort()
                _lastFwdEvent = NSDate.timeIntervalSinceReferenceDate
                self.perform(#selector(resetForwardSkip), with: nil, afterDelay: 0.40)
            }
        }
    }

    // alternative actions for forward / backward buttons when next / prev are activated
    @IBAction func alternateForward(_ sender: Any) {
        VLCCoreInteraction.instance.forwardExtraShort()
    }

    @IBAction func alternateBackward(_ sender: Any) {
        VLCCoreInteraction.instance.backwardExtraShort()
    }

    @IBAction func timeSliderAction(_ sender: Any) {
        var f_updated: Float = 0

        switch NSApp.currentEvent!.type {
            case .leftMouseUp:
                /* Ignore mouse up, as this is a continous slider and
                 * when the user does a single click to a position on the slider,
                 * the action is called twice, once for the mouse down and once
                 * for the mouse up event. This results in two short seeks one
                 * after another to the same position, which results in weird
                 * audio quirks.
                 */
                return
            case .leftMouseDown, .leftMouseDragged:
                f_updated = self.timeSlider.floatValue
            default:
                return
        }

        let p_input: UnsafeMutablePointer<input_thread_t> = playlist_CurrentInput(pl_Get(getIntf()))
        var pos: vlc_value_t

        pos.f_float = f_updated / 10000
        var_Set(p_input.as_vlc_object_pointer(), "position", pos)
        self.timeSlider.floatValue = f_updated

        let o_time = VLCStringUtility.getCurrentTimeAsString(input: p_input, negative:self.timeField.timeRemaining)
        self.timeField.stringValue = o_time
        vlc_object_release(p_input.as_vlc_object_pointer())
    }

    @IBAction func fullscreen(_ sender: Any) {
        VLCCoreInteraction.instance.toggleFullscreen()
    }

// MARK: - Updaters

    func updateTimeSlider() {
        let p_input: UnsafeMutablePointer<input_thread_t>! = playlist_CurrentInput(pl_Get(getIntf()))

        self.timeSlider.isHidden = false

        if p_input == nil {
            // Nothing playing
            self.timeSlider.knobHidden = true
            self.timeSlider.floatValue = 0.0
            self.timeField.stringValue = "00:00"
            self.timeSlider.indefinite = false
            self.timeSlider.isEnabled = false
            return
        }

        self.timeSlider.KnobHidden = false

        var pos: vlc_value_t
        var_Get(p_input.as_vlc_object_pointer(), "position", &pos)
        self.timeSlider.floatValue = 10000 * pos.f_float

        let dur: mtime_t = input_item_GetDuration(input_GetItem(p_input))
        if dur == -1 {
            // No duration, disable slider
            self.timeSlider.isEnabled = false
        } else {
            let inputState: input_state_e = input_GetState(p_input)
            let buffering = inputState == INIT_S || inputState == OPENING_S
            self.timeSlider.Indefinite = buffering
        }

        let time: String = VLCStringUtility.getCurrentTimeAsString(input: p_input, negative: self.timeField.timeRemaining)
        self.timeField.stringValue = time
        self.timeField.needsDisplay = true

        vlc_object_release(p_input.as_vlc_object_pointer())
    }

    func updateControls() {
        var b_plmul = false
        var b_seekable = false
        var b_chapters = false
        var b_buffering = false

        let p_playlist: UnsafeMutablePointer<playlist_t> = pl_Get(getIntf())

        PL_LOCK
        b_plmul = playlist_CurrentSize(p_playlist) > 1
        PL_UNLOCK

        if let p_input = playlist_CurrentInput(p_playlist) {
            let inputState: input_state_e = input_GetState(p_input)
            if inputState == INIT_S || inputState == OPENING_S {
                b_buffering = true
            }

            /* seekable streams */
            b_seekable = var_GetBool(p_input.as_vlc_object_pointer(), "can-seek")

            /* chapters & titles */
            //FIXME! b_chapters = p_input->stream.i_area_nb > 1

            vlc_object_release(p_input.as_vlc_object_pointer())
        }

        self.timeSlider.isEnabled = b_seekable

        self.forwardButton.isEnabled = b_seekable || b_plmul || b_chapters
        self.backwardButton.isEnabled = b_seekable || b_plmul || b_chapters
    }

    func setPause() {
        self.playButton.image = _pauseImage
        self.playButton.alternateImage = _pressedPauseImage
        self.playButton.toolTip = _NS("Pause")
//        self.playButton.cell accessibilitySetOverrideValue:self.playButton toolTip] forAttribute:NSAccessibilityTitleAttribute
    }

    func setPlay() {
        self.playButton.image = _playImage
        self.playButton.alternateImage = _pressedPlayImage
        self.playButton.toolTip = _NS("Play")
//        self.playButton.cell accessibilitySetOverrideValue:self.playButton toolTip] forAttribute:NSAccessibilityTitleAttribute
    }
}
