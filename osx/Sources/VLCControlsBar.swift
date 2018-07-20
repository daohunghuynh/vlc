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

    private var _pauseImage: NSImage
    private var _pressedPauseImage: NSImage
    private var _playImage: NSImage
    private var _pressedPlayImage: NSImage

    private var last_fwd_event: NSTimeInterval
    private var last_bwd_event: NSTimeInterval
    private var just_triggered_next: BOOL
    private var just_triggered_previous: BOOL

    // @IBOutlet var dropView: VLCDragDropView!
    @IBOutlet var playButton: NSButton!
    @IBOutlet var timeSlider: VLCSlider!
    @IBOutlet var timeField: VLCTimeField!
    @IBOutlet var bottomBarView: VLCBottomBarView!

//    - (void)toggleForwardBackwardMode:(BOOL)b_alt;
//
//    - (IBAction)play(_ sender: Any);
//    - (IBAction)bwd(_ sender: Any);
//    - (IBAction)fwd(_ sender: Any);
//
//    - (IBAction)timeSliderAction(_ sender: Any);
//    - (IBAction)fullscreen(_ sender: Any);
//
//    - (void)updateTimeSlider;
//    - (void)updateControls;
//    - (void)setPause;
//    - (void)setPlay;
//    - (void)setFullscreenState:(BOOL)b_fullscreen;


    override func awakeFromNib() {
        super.awakeFromNib()
    
//        _darkInterface = var_InheritBool(getIntf(), "macosx-interfacestyle");
//        _nativeFullscreenMode = var_InheritBool(getIntf(), "macosx-nativefullscreenmode");

//        self.dropView setDrawBorder: NO

        self.playButton.toolTip = _NS("Play")
        self.playButton.cell.accessibilitySetOverrideValue(self.playButton.toolTip, forAttribute: NSAccessibilityDescriptionAttribute)

//        self.backwardButton.toolTip = _NS("Backward")
//        self.backwardButton.cell accessibilitySetOverrideValue:_NS("Seek backward") forAttribute:NSAccessibilityDescriptionAttribute
//        self.backwardButton.cell accessibilitySetOverrideValue:self.backwardButton toolTip] forAttribute:NSAccessibilityTitleAttribute

//        self.forwardButton.toolTip = _NS("Forward")
//        self.forwardButton.cell accessibilitySetOverrideValue:_NS("Seek forward") forAttribute:NSAccessibilityDescriptionAttribute
//        self.forwardButton.cell accessibilitySetOverrideValue:self.forwardButton toolTip] forAttribute:NSAccessibilityTitleAttribute

        self.timeSlider.toolTip = _NS("Position")
        self.timeSlider.cell.accessibilitySetOverrideValue(_NS("Playback position"), forAttribute:NSAccessibilityDescriptionAttribute)
        self.timeSlider.cell.accessibilitySetOverrideValue(self.timeSlider.toolTip, forAttribute:NSAccessibilityTitleAttribute)
//        if (_darkInterface)
//            self.timeSlider setSliderStyleDark

            self.bottomBarView setDark:NO

            self.backwardButton.image = imageFromRes(@"backward-3btns")
            self.backwardButton.alternateImage = imageFromRes(@"backward-3btns-pressed")
            _playImage = imageFromRes(@"play");
            _pressedPlayImage = imageFromRes(@"play-pressed");
            _pauseImage = imageFromRes(@"pause");
            _pressedPauseImage = imageFromRes(@"pause-pressed");
            self.forwardButton.image = imageFromRes(@"forward-3btns")
            self.forwardButton.alternateImage = imageFromRes(@"forward-3btns-pressed")

        self.playButton.image = _playImage
        self.playButton.alternateImage = _pressedPlayImage

        NSColor *timeFieldTextColor;
        if !var_InheritBool(getIntf()?.as_vlc_object_pointer(), "macosx-interfacestyle") {
            timeFieldTextColor = [NSColor colorWithCalibratedRed:0.229 green:0.229 blue:0.229 alpha:100.0
        } else {
            timeFieldTextColor = [NSColor colorWithCalibratedRed:0.64 green:0.64 blue:0.64 alpha:100.0
        }
        self.timeField.textColor: timeFieldTextColor
        self.timeField.font:[NSFont titleBarFontOfSize:10.0]
        self.timeField.alignment: NSCenterTextAlignment
        self.timeField.needsDisplay:YES
        self.timeField.remainingIdentifier:@"DisplayTimeAsTimeRemaining"
        self.timeField.cell.accessibilitySetOverrideValue:_NS("Playback time")
                                                forAttribute:NSAccessibilityDescriptionAttribute

        if config_GetInt("macosx-show-playback-buttons") {
            self.toggleForwardBackwardMode: YES
        }
    }

    let height: CGFloat {
//        return self.bottomBarView frame].size.height;
    }

    func setActive() {

    }

    func setNonActive() {

    }

    func toggleForwardBackwardMode(_ b_alt: Bool) {
        if (b_alt == YES) {
            /* change the accessibility help for the backward/forward buttons accordingly */
            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Backward") forAttribute:NSAccessibilityTitleAttribute
            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Seek backward") forAttribute:NSAccessibilityDescriptionAttribute

            self.forwardButton.cell accessibilitySetOverrideValue:_NS("Forward") forAttribute:NSAccessibilityTitleAttribute
            self.forwardButton.cell accessibilitySetOverrideValue:_NS("Seek forward") forAttribute:NSAccessibilityDescriptionAttribute

            self.forwardButton setAction:@selector(alternateForward:)
            self.backwardButton setAction:@selector(alternateBackward:)

        } else {
            /* change the accessibility help for the backward/forward buttons accordingly */
            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Previous") forAttribute:NSAccessibilityTitleAttribute
            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Go to previous item") forAttribute:NSAccessibilityDescriptionAttribute

            self.backwardButton.cell accessibilitySetOverrideValue:_NS("Next") forAttribute:NSAccessibilityTitleAttribute
            self.forwardButton.cell accessibilitySetOverrideValue:_NS("Go to next item") forAttribute:NSAccessibilityDescriptionAttribute

            self.forwardButton setAction:@selector(fwd:)
            self.backwardButton setAction:@selector(bwd:)
        }
    }

// MARK: - Button Actions

    @IBAction func play(_ sender: Any) {
        VLCCoreInteraction.instance.playOrPause()
    }

    func resetPreviousButton() {
        if (([NSDate timeIntervalSinceReferenceDate] - last_bwd_event) >= 0.35) {
            // seems like no further event occurred, so let's switch the playback item
            VLCCoreInteraction.instance.previous()
            just_triggered_previous = NO;
        }
    }

    func resetBackwardSkip() {
        // the user stopped skipping, so let's allow him to change the item
        if (([NSDate timeIntervalSinceReferenceDate] - last_bwd_event) >= 0.35)
            just_triggered_previous = NO;
    }

    @IBAction func bwd(_ sender: Any) {
        if (!just_triggered_previous) {
            just_triggered_previous = YES;
            self performSelector:@selector(resetPreviousButton)
                       withObject: NULL
                       afterDelay:0.40
        } else {
            if (([NSDate timeIntervalSinceReferenceDate] - last_fwd_event) > 0.16) {
                // we just skipped 4 "continous" events, otherwise we are too fast
                VLCCoreInteraction.instance.backwardExtraShort
                last_bwd_event = [NSDate timeIntervalSinceReferenceDate
                self performSelector:@selector(resetBackwardSkip)
                           withObject: NULL
                           afterDelay:0.40
            }
        }
    }

    func resetNextButton() {
        if (([NSDate timeIntervalSinceReferenceDate] - last_fwd_event) >= 0.35) {
            // seems like no further event occurred, so let's switch the playback item
            VLCCoreInteraction.instance.next
            just_triggered_next = NO;
        }
    }

    func resetForwardSkip() {
        // the user stopped skipping, so let's allow him to change the item
        if (([NSDate timeIntervalSinceReferenceDate] - last_fwd_event) >= 0.35)
            just_triggered_next = NO;
    }

    @IBAction func fwd(_ sender: Any) {
        if (!just_triggered_next) {
            just_triggered_next = YES;
            self performSelector:@selector(resetNextButton)
                       withObject: NULL
                       afterDelay:0.40
        } else {
            if (([NSDate timeIntervalSinceReferenceDate] - last_fwd_event) > 0.16) {
                // we just skipped 4 "continous" events, otherwise we are too fast
                VLCCoreInteraction.instance.forwardExtraShort
                last_fwd_event = [NSDate timeIntervalSinceReferenceDate
                self performSelector:@selector(resetForwardSkip)
                           withObject: NULL
                           afterDelay:0.40
            }
        }
    }

    // alternative actions for forward / backward buttons when next / prev are activated
    @IBAction func alternateForward(_ sender: Any) {
        VLCCoreInteraction.instance.forwardExtraShort
    }

    @IBAction func alternateBackward(_ sender: Any) {
        VLCCoreInteraction.instance.backwardExtraShort
    }

    @IBAction func timeSliderAction(_ sender: Any) {
        float f_updated;
        input_thread_t * p_input;

        switch([[NSApp currentEvent] type]) {
            case NSLeftMouseUp:
                /* Ignore mouse up, as this is a continous slider and
                 * when the user does a single click to a position on the slider,
                 * the action is called twice, once for the mouse down and once
                 * for the mouse up event. This results in two short seeks one
                 * after another to the same position, which results in weird
                 * audio quirks.
                 */
                return;
            case NSLeftMouseDown:
            case NSLeftMouseDragged:
                f_updated = [sender floatValue
                break;

            default:
                return;
        }
        p_input = pl_CurrentInput(getIntf());
        if (p_input != NULL) {
            vlc_value_t pos;
            NSString * o_time;

            pos.f_float = f_updated / 10000.;
            var_Set(p_input, "position", pos);
            self.timeSlider.FloatValue: f_updated

            o_time = [[VLCStringUtility sharedInstance] getCurrentTimeAsString: p_input negative:self.timeField timeRemaining]
            self.timeField setStringValue: o_time
            vlc_object_release(p_input);
        }
    }

    @IBAction func fullscreen(_ sender: Any) {
        VLCCoreInteraction.instance.toggleFullscreen
    }

// MARK: - Updaters

    func updateTimeSlider() {
        let p_input: UnsafeMutablePointer<input_thread_t> = pl_CurrentInput(getIntf());

        self.timeSlider.hidden:NO

        if p_input = nil {
            // Nothing playing
            self.timeSlider.knobHidden:YES
            self.timeSlider.floatValue: 0.0
            self.timeField stringValue: @"00:00"
            self.timeSlider.indefinite:NO
            self.timeSlider.enabled:NO
            return;
        }

        self.timeSlider.KnobHidden:NO

        vlc_value_t pos;
        var_Get(p_input, "position", &pos);
        self.timeSlider.FloatValue:(10000. * pos.f_float)

        mtime_t dur = input_item_GetDuration(input_GetItem(p_input));
        if (dur == -1) {
            // No duration, disable slider
            self.timeSlider.Enabled:NO
        } else {
            input_state_e inputState = input_GetState(p_input);
            bool buffering = (inputState == INIT_S || inputState == OPENING_S);
            self.timeSlider.Indefinite:buffering
        }

        NSString *time = [[VLCStringUtility sharedInstance] getCurrentTimeAsString:p_input
                                                                          negative:self.timeField timeRemaining]
        self.timeField setStringValue:time
        self.timeField setNeedsDisplay:YES

        vlc_object_release(p_input);
    }

    func updateControls() {
        bool b_plmul = false;
        bool b_seekable = false;
        bool b_chapters = false;
        bool b_buffering = false;

        playlist_t * p_playlist = pl_Get(getIntf());

        PL_LOCK;
        b_plmul = playlist_CurrentSize(p_playlist) > 1;
        PL_UNLOCK;

        input_thread_t * p_input = playlist_CurrentInput(p_playlist);

        if (p_input) {
            input_state_e inputState = input_GetState(p_input);
            if (inputState == INIT_S || inputState == OPENING_S)
                b_buffering = YES;

            /* seekable streams */
            b_seekable = var_GetBool(p_input, "can-seek");

            /* chapters & titles */
            //FIXME! b_chapters = p_input->stream.i_area_nb > 1;

            vlc_object_release(p_input);
        }

        self.timeSlider.Enabled: b_seekable

        self.forwardButton setEnabled: (b_seekable || b_plmul || b_chapters)
        self.backwardButton setEnabled: (b_seekable || b_plmul || b_chapters)
    }

    func setPause() {
        self.playButton.image = _pauseImage
        self.playButton.alternateImage = _pressedPauseImage
        self.playButton.toolTip = _NS("Pause")
        self.playButton.cell accessibilitySetOverrideValue:self.playButton toolTip] forAttribute:NSAccessibilityTitleAttribute
    }

    func setPlay() {
        self.playButton.image = _playImage
        self.playButton.alternateImage = _pressedPlayImage
        self.playButton.toolTip = _NS("Play")
        self.playButton.cell accessibilitySetOverrideValue:self.playButton toolTip] forAttribute:NSAccessibilityTitleAttribute
    }
}
