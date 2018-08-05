//
//  VLCResumeDialogController.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 09/08/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

enum ResumeResult {
    case RESUME_RESTART
    case RESUME_NOW
    case RESUME_FAIL
}

typealias CompletionBlock = (ResumeResult) -> Void


class VLCResumeDialogController : NSWindowController {

    private var _currentResumeTimeout: Int = 0
    private var _countdown_timer: Timer?
    private var _completionBlock: CompletionBlock?

    @IBOutlet var o_title_lbl: VLCWrappableTextField!
    @IBOutlet var o_text_lb: VLCWrappableTextField!

    @IBOutlet var o_restart_btn: NSButton!
    @IBOutlet var o_resume_btn: NSButton!
    @IBOutlet var o_always_resume_chk: NSButton!


    convenience init() {
        self.init(windowNibName: NSNib.Name("ResumeDialog"))
    }

//- (void)windowDidLoad
//{
//    [o_title_lbl setStringValue:_NS("Continue playback?")];
//    [o_resume_btn setTitle:_NS("Continue")];
//
//    [o_always_resume_chk setTitle:_NS("Always continue media playback")];
//}

    func showWindow(forItem p_item: UnsafeMutablePointer<input_item_t>, withLastPosition pos: Int64, completionBlock block: CompletionBlock) {

        _currentResumeTimeout = 10
        _completionBlock = block

        o_restart_btn.title = "Restart playback".appendingFormat(" (%d)", _currentResumeTimeout)

        let titleFbName = getTitleFbName(inputItem: p_item)
        let labelString = NSString(format: "Playback of \"%@\" will continue at %@",
                                   titleFbName,
                                   VLCStringUtility.stringForTime(pos))

        o_text_lbl.stringValue = labelString
        o_always_resume_chk.state = .off

        _countdown_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAlertWindow), userInfo:nil, repeats: true)

        window!.level = VLCMain.instance.voutProvider.currentStatusWindowLevel
        window!.center()
        window!.makeKeyAndOrderFront(nil)
    }

    @objc func updateAlertWindow() {
        _currentResumeTimeout -= 1
        if (_currentResumeTimeout <= 0) {
            self.buttonClicked = o_restart_btn
            _countdown_timer!.invalidate()
            _countdown_timer = nil;
        }

        o_restart_btn.title = "Restart playback".appendingFormat(" (%d)", _currentResumeTimeout)
    }

//- (IBAction)buttonClicked:(id)sender
//{
//    enum ResumeResult resumeResult = RESUME_FAIL;
//
//    if (sender == o_restart_btn)
//        resumeResult = RESUME_RESTART;
//    else if (sender == o_resume_btn)
//        resumeResult = RESUME_NOW;
//
//    [[self window] close];
//
//    if (completionBlock) {
//        completionBlock(resumeResult);
//        completionBlock = nil;
//    }
//}

//- (IBAction)resumeSettingChanged:(id)sender
//{
//    int newState = [sender state] == NSOnState ? 1 : 0;
//    msg_Dbg(getIntf(), "Changing resume setting to %i", newState);
//    config_PutInt("macosx-continue-playback", newState);
//}

//- (void)updateCocoaWindowLevel:(NSInteger)i_level
//{
//    if (self.isWindowLoaded && [self.window isVisible] && [self.window level] != i_level)
//        [self.window setLevel: i_level];
//}

    func cancel() {
        if !isWindowLoaded {
            return
        }
        if _countdown_timer != nil {
            _countdown_timer!.invalidate()
            _countdown_timer = nil;
        }
        self.window!.close()
    }
}
