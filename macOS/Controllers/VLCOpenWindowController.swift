//
//  VLCOpenWindowController.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 18/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

fileprivate let kFileTabViewId     = "file"
fileprivate let kNetworkTabViewId  = "network"
fileprivate let kCaptureTabViewId  = "capture"


class VLCOpenWindowController : NSWindowController, NSTabViewDelegate {

    @IBOutlet weak var mrlTextField: NSTextField!
    @IBOutlet weak var mrlButton: NSButton!
    @IBOutlet weak var mrlButtonLabel: NSButton!
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var mrlViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var okButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!

    /* bottom-line items */
    @IBOutlet weak var outputCheckbox: NSButton!
    @IBOutlet weak var outputSettingsButton: NSButton!

    /* open file */
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet weak var fileNameStubLabel: NSTextField!
    @IBOutlet weak var fileIconWell: NSImageView!
    @IBOutlet weak var fileBrowseButton: NSButton!
    @IBOutlet weak var fileTreatAsPipeButton: NSButton!
    @IBOutlet weak var fileSlaveCheckbox: NSButton!
    @IBOutlet weak var fileSelectSlaveButton: NSButton!
    @IBOutlet weak var fileSlaveFilenameLabel: NSTextField!
    @IBOutlet weak var fileSlaveIconWell: NSImageView!
    @IBOutlet weak var fileSubtitlesFilenameLabel: NSTextField!
    @IBOutlet weak var fileSubtitlesIconWell: NSImageView!
    @IBOutlet weak var fileCustomTimingCheckbox: NSButton!
    @IBOutlet weak var fileStartTimeTextField: NSTextField!
    @IBOutlet weak var fileStartTimeLabel: NSTextField!
    @IBOutlet weak var fileStopTimeTextField: NSTextField!
    @IBOutlet weak var fileStopTimeLabel: NSTextField!

    /* open network */
    @IBOutlet weak var netHTTPURLLabel: NSTextField!
    @IBOutlet weak var netHTTPURLTextField: NSTextField!
    @IBOutlet weak var netHelpLabel: NSTextField!

    /* open UDP stuff panel */
    @IBOutlet weak var netHelpUDPLabel: NSTextField!
    @IBOutlet weak var netUDPProtocolMatrix: NSMatrix!
    @IBOutlet weak var netUDPProtocolLabel: NSTextField!
    @IBOutlet weak var netUDPAddressLabel: NSTextField!
    @IBOutlet weak var netUDPModeLabel: NSTextField!
    @IBOutlet weak var netModeMatrix: NSMatrix!
    @IBOutlet weak var netOpenUDPButton: NSButton!
    @IBOutlet weak var netUDPCancelButton: NSButton!
    @IBOutlet weak var netUDPOKButton: NSButton!
    @property (readwrite)       IBOutlet NSWindow *netUDPPanel
    @IBOutlet weak var netUDPPortTextField: NSTextField!
    @IBOutlet weak var netUDPPortLabel: NSTextField!
    @IBOutlet weak var netUDPPortStepper: NSStepper!
    @IBOutlet weak var netUDPMAddressTextField: NSTextField!
    @IBOutlet weak var netUDPMAddressLabel: NSTextField!
    @IBOutlet weak var netUDPMPortTextField: NSTextField!
    @IBOutlet weak var netUDPMPortLabel: NSTextField!
    @IBOutlet weak var netUDPMPortStepper: NSStepper!

    /* open subtitle file */
    @IBOutlet weak var fileSubCheckbox: NSButton!
    @IBOutlet weak var fileSubSettingsButton: NSButton!
    @property (readwrite) IBOutlet NSPanel *fileSubSheet
    @IBOutlet weak var fileSubPathLabel: NSTextField!
    @IBOutlet weak var fileSubPathTextField: NSTextField!
    @IBOutlet weak var fileSubIconView: NSImageView!
    @IBOutlet weak var fileSubBrowseButton: NSButton!
    @IBOutlet weak var fileSubOverrideCheckbox: NSButton!
    @IBOutlet weak var fileSubDelayTextField: NSTextField!
    @IBOutlet weak var fileSubDelayLabel: NSTextField!
    @IBOutlet weak var fileSubDelayStepper: NSStepper!
    @IBOutlet weak var fileSubFPSTextField: NSTextField!
    @IBOutlet weak var fileSubFPSLabel: NSTextField!
    @IBOutlet weak var fileSubFPSStepper: NSStepper!
    @IBOutlet weak var fileSubEncodingPopup: NSPopUpButton!
    @IBOutlet weak var fileSubEncodingLabel: NSTextField!
    @IBOutlet weak var fileSubSizePopup: NSPopUpButton!
    @IBOutlet weak var fileSubSizeLabel: NSTextField!
    @IBOutlet weak var fileSubAlignPopup: NSPopUpButton!
    @IBOutlet weak var fileSubAlignLabel: NSTextField!
    @IBOutlet weak var fileSubOKButton: NSButton!
    @IBOutlet weak var fileSubFontBox: NSBox!
    @IBOutlet weak var fileSubFileBox: NSBox!

    /* generic capturing stuff */
    @IBOutlet weak var captureModePopup: NSPopUpButton!
    @IBOutlet weak var captureTabView: NSTabView!

    /* screen support */
    @IBOutlet weak var screenFPSTextField: NSTextField!
    @IBOutlet weak var screenFPSLabel: NSTextField!
    @IBOutlet weak var screenFPSStepper: NSStepper!
    @IBOutlet weak var screenLabel: NSTextField!
    @IBOutlet weak var screenPopup: NSPopUpButton!
    @IBOutlet weak var screenLeftTextField: NSTextField!
    @IBOutlet weak var screenLeftLabel: NSTextField!
    @IBOutlet weak var screenLeftStepper: NSStepper!
    @IBOutlet weak var screenTopTextField: NSTextField!
    @IBOutlet weak var screenTopLabel: NSTextField!
    @IBOutlet weak var screenTopStepper: NSStepper!
    @IBOutlet weak var screenWidthTextField: NSTextField!
    @IBOutlet weak var screenWidthLabel: NSTextField!
    @IBOutlet weak var screenWidthStepper: NSStepper!
    @IBOutlet weak var screenHeightTextField: NSTextField!
    @IBOutlet weak var screenHeightLabel: NSTextField!
    @IBOutlet weak var screenHeightStepper: NSStepper!
    @IBOutlet weak var screenFollowMouseCheckbox: NSButton!
    @IBOutlet weak var screenqtkAudioPopup: NSPopUpButton!
    @IBOutlet weak var screenqtkAudioCheckbox: NSButton!

    /* QTK support */
    @IBOutlet weak var qtkVideoDevicePopup: NSPopUpButton!
    @IBOutlet weak var qtkVideoCheckbox: NSButton!
    @IBOutlet weak var qtkAudioDevicePopup: NSPopUpButton!
    @IBOutlet weak var qtkAudioCheckbox: NSButton!

    /* text field / stepper binding values - subs panel */
    var fileSubDelay: Float = 0.0
    var fileSubFps: Float = 0.0

//@IBAction func outputSettings:(id)sender
//func setSubPanel -> void
//func tabView:(NSTabView *)o_tv didSelectTabViewItem:(NSTabViewItem *)o_tvi -> void
//func textFieldWasClicked:(NSNotification *)o_notification -> void
//@IBAction func expandMRLfieldAction:(id)sender
//@IBAction func inputSlaveAction:(id)sender
//@IBAction func fileTimeCustomization:(id)sender

//@IBAction func openFileBrowse:(id)sender
//@IBAction func openFileStreamChanged:(id)sender

//func openDisc -> void
//@IBAction func discSelectorChanged:(id)sender
//@IBAction func openSpecialMediaFolder:(id)sender
//@IBAction func dvdreadOptionChanged:(id)sender
//@IBAction func vcdOptionChanged:(id)sender

//func openNet -> void
//@IBAction func openNetModeChanged:(id)sender
//@IBAction func openNetStepperChanged:(id)sender
//func openNetInfoChanged:(NSNotification *)o_notification -> void
//@IBAction func openNetUDPButtonAction:(id)sender

//func openCapture -> void
//@IBAction func openCaptureModeChanged:(id)sender

// Screen actions
//@IBAction func screenChanged:(id)sender
//@IBAction func screenAudioChanged:(id)sender

// QTKit actions
//@IBAction func qtkChanged:(id)sender
//@IBAction func qtkAudioChanged:(id)sender
//@IBAction func qtkToggleUIElements:(id)sender
//
//@IBAction func subsChanged:(id)sender
//@IBAction func subSettings:(id)sender
//@IBAction func subFileBrowse:(id)sender
//@IBAction func subOverride:(id)sender
//
//@IBAction func subCloseSheet:(id)sender
//
//@IBAction func panelCancel:(id)sender
//@IBAction func panelOk:(id)sender
//
//func openFileWithAction:(void (^)(NSArray *files))action -> void

    private var _output: VLCOutput!
    private var b_outputNibLoaded: Bool
    private var _avvideoDevices: NSArray
    private var _avaudioDevices: NSArray
    private var _avCurrentDeviceUID: String
    private var _avCurrentAudioDeviceUID: String

    private var b_autoplay: Bool
    private var b_nodvdmenus: Bool
    private var _currentOpticalMediaView: NSView
    private var _currentOpticalMediaIconView: NSImageView
    private var _allMediaDevices: NSMutableArray
    private var _opticalDevices: NSArray
    private var _specialMediaFolders: NSMutableArray
    private var filePath: String = ""
    private var _fileSlavePath: String
    private var subPath: String = ""
    private var MRL: String = ""
    private var _displayInfos: [UnsafeMutablePointer<display_info_t>] = []


    // MARK: - Init

    init() {
        self.init(windowNibName: NSNib.Name("Open"))
    }

    deinit {
        for p_displayInfo in _displayInfos {
            free([p_displayInfo])
        }
    }

    override func windowDidLoad() {
        _output = VLCOutput()

        self.window.collectionBehavior = NSWindow.CollectionBehavior.fullScreenAuxiliary

        self.window.title = "Open Source"
        self.mrlButtonLabel.title = "Media Resource Locator (MRL)"

        self.okButton.title = "Open"
        self.cancelButton.title = "Cancel"

        self.outputCheckbox.title = "Stream output:"
        self.outputSettingsButton.title = "Settings..."

//        self.tabView.accessibilitySetOverrideValue = "Choose media input type" forAttribute:NSAccessibilityDescriptionAttribute]
        self.tabView.tabViewItem(at: 0).label = "File"
        self.tabView.tabViewItem(at: 1).label = "Disc"
        self.tabView.tabViewItem(at: 2).label = "Network"
        self.tabView.tabViewItem(at: 3).label = "Capture"
        self.fileNameLabel.stringValue = ""
        self.fileNameStubLabel.stringValue =  "Choose a file"
        self.fileIconWell.image = NSImage(named: "generic")
        self.fileBrowseButton.title = "Browse..."
//        self.fileBrowseButton.cell accessibilitySetOverrideValue:_NS("Select a file for playback") forAttribute:NSAccessibilityDescriptionAttribute]
        self.fileTreatAsPipeButton.title = "Treat as a pipe rather than as a file"
        self.fileTreatAsPipeButton.isHidden = false
        self.fileSlaveCheckbox.title = "Play another media synchronously"
        self.fileSelectSlaveButton.title = "Choose..."
//        [self.fileBrowseButton cell accessibilitySetOverrideValue:_NS("Select another file to play in sync with the previously selected file") forAttribute:NSAccessibilityDescriptionAttribute]
        self.fileSlaveFilenameLabel.stringValue =  ""
        self.fileSlaveIconWell.image = nil
        self.fileSubtitlesFilenameLabel.stringValue =  ""
        self.fileSubtitlesIconWell.image = nil
        self.fileCustomTimingCheckbox.title = "Custom playback"
        self.fileStartTimeLabel.stringValue = "Start time"
        self.fileStartTimeTextField.stringValue =  ""
        self.fileStopTimeLabel.stringValue =  "Stop time"
        self.fileStopTimeTextField.stringValue =  ""

        self.netUDPPortLabel.stringValue = "Port"
        self.netUDPMAddressLabel.stringValue =  "IP Address"
        self.netUDPMPortLabel.stringValue = "Port"
        self.netHTTPURLLabel.stringValue = "URL"
        self.netHelpLabel.stringValue = "To Open a usual network stream (HTTP, RTSP, RTMP, MMS, FTP, etc.), just enter the URL in the field above. If you want to open a RTP or UDP stream, press the button below."
        self.netHelpUDPLabel.stringValue = "If you want to open a multicast stream, enter the respective IP address given by the stream provider. In unicast mode, VLC will use your machine's IP automatically.\n\nTo open a stream using a different protocol, just press Cancel to close this sheet."
//        self.netHTTPURLTextField accessibilitySetOverrideValue:"Enter a stream URL here. To open RTP or UDP streams, use the respective button below.") forAttribute:NSAccessibilityDescriptionAttribute
        self.netUDPCancelButton.title = "Cancel"
        self.netUDPOKButton.title = "Open"
        self.netOpenUDPButton.title = "Open RTP/UDP Stream"
        self.netUDPModeLabel.stringValue = "Mode"
        self.netUDPProtocolLabel.stringValue = "Protocol"
        self.netUDPAddressLabel.stringValue = "Address"

        self.netModeMatrix.cell(atRow:0, column:0)?.title = "Unicast"
        self.netModeMatrix.cell(atRow:1, column:0)?.title = "Multicast"

        self.netUDPPortTextField.intValue = config_GetInt("server-port")
        self.netUDPPortStepper.intValue = config_GetInt("server-port")

        self.captureModePopup.removeAllItems()
        self.captureModePopup.addItem(withTitle: "Input Devices")
        self.captureModePopup.addItem(withTitle: "Screen")
        self.screenFPSLabel.stringValue = "Frames per Second:"
        self.screenLabel.stringValue = "Screen"
        self.screenLeftLabel.stringValue = "Subscreen left:"
        self.screenTopLabel.stringValue = "Subscreen top:"
        self.screenWidthLabel.stringValue = "Subscreen Width:"
        self.screenHeightLabel.stringValue = "Subscreen Height:"
        self.screenFollowMouseCheckbox.title = "Follow the mouse"
        self.screenqtkAudioCheckbox.title = "Capture Audio"

        #warning QTKit stuff is deprecated and broken!
        /* The QTKit audio capture does not work anymore since 3.x, it has to be
         * replaced with AVFoundation audio capture stuff and things have to be
         * changed here to not try to use the qtkit module anymore.
         */

        // setup start / stop time fields
        self.fileStartTimeTextField.formatter = PositionFormatter()
        self.fileStopTimeTextField.formatter = PositionFormatter()

        // Auto collapse MRL field
        self.mrlViewHeightConstraint.constant = 0

        [self updateQTKVideoDevices]
        self.qtkVideoDevicePopup removeAllItems]
        msg_Dbg(getIntf(), "Found %lu video capture devices", _avvideoDevices.count)

        if (self.avvideoDevices.count >= 1) {
        if (!self.avCurrentDeviceUID)
        _avCurrentDeviceUID = [[[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] uniqueID]
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

        NSUInteger deviceCount = _avvideoDevices.count
        for (int ivideo = 0; ivideo < deviceCount; ivideo++) {
        AVCaptureDevice *avDevice = self.avvideoDevices objectAtIndex:ivideo]
        // allow same name for multiple times
        [self.qtkVideoDevicePopup menu] addItemWithTitle:[avDevice localizedName] action:nil keyEquivalent:""]

        if ([[[avDevice uniqueID] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:_avCurrentDeviceUID])
        self.qtkVideoDevicePopup selectItemAtIndex:ivideo]
        }
        } else {
        self.qtkVideoDevicePopup addItemWithTitle: _NS("None")]
        }

        self.qtkAudioDevicePopup removeAllItems]
        self.screenqtkAudioPopup removeAllItems]

        [self updateQTKAudioDevices]
        msg_Dbg(getIntf(), "Found %lu audio capture devices", _avaudioDevices.count)

        if (self.avaudioDevices.count >= 1) {
        if (!self.avCurrentAudioDeviceUID)
        _avCurrentAudioDeviceUID = [[[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] uniqueID]
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

        NSUInteger deviceCount = _avaudioDevices.count
        for (int iaudio = 0; iaudio < deviceCount; iaudio++) {
        AVCaptureDevice *avAudioDevice = self.avaudioDevices objectAtIndex:iaudio]

        // allow same name for multiple times
        String *localizedName = [avAudioDevice localizedName]
        [self.qtkAudioDevicePopup menu] addItemWithTitle:localizedName action:nil keyEquivalent:""]
        [self.screenqtkAudioPopup menu] addItemWithTitle:localizedName action:nil keyEquivalent:""]

        if ([[[avAudioDevice uniqueID] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:_avCurrentAudioDeviceUID]) {
        self.qtkAudioDevicePopup selectItemAtIndex:iaudio]
        self.screenqtkAudioPopup selectItemAtIndex:iaudio]
        }
        }
        } else {
        self.qtkAudioDevicePopup addItemWithTitle: _NS("None")]
        self.screenqtkAudioPopup addItemWithTitle: _NS("None")]
        }

        [self setSubPanel]

        [[NSNotificationCenter defaultCenter] addObserver: self
        selector: #selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: _netUDPPortTextField]
        [[NSNotificationCenter defaultCenter] addObserver: self
        selector: #selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: _netUDPMAddressTextField]
        [[NSNotificationCenter defaultCenter] addObserver: self
        selector: #selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: _netUDPMPortTextField]
        [[NSNotificationCenter defaultCenter] addObserver: self
        selector: #selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: _netHTTPURLTextField]

        [[NSNotificationCenter defaultCenter] addObserver: self
        selector: #selector(screenFPSfieldChanged:)
        name: NSControlTextDidChangeNotification
        object: _screenFPSTextField]

        /* register clicks on text fields */
        [[NSNotificationCenter defaultCenter] addObserver: self
        selector: #selector(textFieldWasClicked:)
        name: VLCOpenTextFieldWasClicked
        object: nil]

        /* we want to be notified about removed or added media */
        _allMediaDevices = [[NSMutableArray alloc] init]
        _specialMediaFolders = [[NSMutableArray alloc] init]
        _displayInfos = [[NSMutableArray alloc] init]
        NSWorkspace *sharedWorkspace = NSWorkspace.shared]
        [[sharedWorkspace notificationCenter] addObserver:self selector:#selector(scanOpticalMedia:) name:NSWorkspaceDidMountNotification object:nil]
        [[sharedWorkspace notificationCenter] addObserver:self selector:#selector(scanOpticalMedia:) name:NSWorkspaceDidUnmountNotification object:nil]

        [self qtkToggleUIElements:nil]
        [self scanOpticalMedia:nil]

        [self.MRL = ""]
    }

//    func.MRL =(String *)newMRL -> void
//    {
//    if (!newMRL)
//    newMRL = ""
//
//    _MRL = newMRL
//    [self.mrlTextField performSelectorOnMainThread:#selector(setStringValue:) withObject:_MRL waitUntilDone:false]
//    if (self.MRL length] > 0)
//    self.okButton.isEnabled = true]
//    else
//    self.okButton.isEnabled = false]
//    }
//
//    func setSubPanel -> void
//    {
//    int i_index
//    module_config_t * p_item
//
//    self.fileSubCheckbox setTitle: _NS("Add Subtitle File:")]
//    self.fileSubPathLabel.stringValue =  _NS("Choose a file")]
//    self.fileSubPathLabel.isHidden = false]
//    self.fileSubPathTextField.stringValue =  ""]
//    self.fileSubSettingsButton setTitle: _NS("Choose...")]
//    [self.fileSubSettingsButton cell] accessibilitySetOverrideValue:_NS("Setup subtitle playback details") forAttribute:NSAccessibilityDescriptionAttribute]
//    [self.fileBrowseButton cell] accessibilitySetOverrideValue:_NS("Select a file for playback") forAttribute:NSAccessibilityDescriptionAttribute]
//    self.fileSubBrowseButton setTitle: _NS("Browse...")]
//    [self.fileSubBrowseButton cell] accessibilitySetOverrideValue:_NS("Select a subtitle file") forAttribute:NSAccessibilityDescriptionAttribute]
//    self.fileSubOverrideCheckbox setTitle: _NS("Override parameters")]
//    self.fileSubDelayLabel.stringValue =  _NS("Delay")]
//    self.fileSubDelayStepper.isEnabled = false]
//    self.fileSubFPSLabel.stringValue =  _NS("FPS")]
//    self.fileSubFPSStepper.isEnabled = false]
//    self.fileSubEncodingLabel.stringValue =  _NS("Subtitle encoding")]
//    self.fileSubEncodingPopup removeAllItems]
//    self.fileSubSizeLabel.stringValue =  _NS("Font size")]
//    self.fileSubSizePopup removeAllItems]
//    self.fileSubAlignLabel.stringValue =  _NS("Subtitle alignment")]
//    self.fileSubAlignPopup removeAllItems]
//    self.fileSubOKButton.stringValue =  _NS("OK")]
//    [self.fileSubOKButton cell] accessibilitySetOverrideValue:_NS("Dismiss the subtitle setup dialog") forAttribute:NSAccessibilityDescriptionAttribute]
//    self.fileSubFontBox setTitle: _NS("Font Properties")]
//    self.fileSubFileBox setTitle: _NS("Subtitle File")]
//
//    p_item = config_FindConfig("subsdec-encoding")
//
//    if (p_item) {
//    for (int i = 0; i < p_item->list_count; i++) {
//    self.fileSubEncodingPopup addItemWithTitle: _NS(p_item->list_text[i])]
//    [self.fileSubEncodingPopup lastItem] setRepresentedObject:[String stringWithFormat:"%s", p_item->list.psz[i]]]
//    if (p_item->value.psz && !strcmp(p_item->value.psz, p_item->list.psz[i]))
//    self.fileSubEncodingPopup selectItem: self.fileSubEncodingPopup lastItem]]
//    }
//
//    if (self.fileSubEncodingPopup indexOfSelectedItem] < 0)
//    self.fileSubEncodingPopup selectItemAtIndex:0]
//    }
//
//    p_item = config_FindConfig("subsdec-align")
//
//    if (p_item) {
//    for (i_index = 0; i_index < p_item->list_count; i_index++)
//    self.fileSubAlignPopup addItemWithTitle: _NS(p_item->list_text[i_index])]
//
//    self.fileSubAlignPopup selectItemAtIndex: p_item->value.i]
//    }
//
//    p_item = config_FindConfig("freetype-rel-fontsize")
//
//    if (p_item) {
//    for (i_index = 0; i_index < p_item->list_count; i_index++) {
//    self.fileSubSizePopup addItemWithTitle: _NS(p_item->list_text[i_index])]
//
//    if (p_item->value.i == p_item->list.i[i_index])
//    self.fileSubSizePopup selectItemAtIndex: i_index]
//    }
//    }
//    }

    private func openTarget(identifier: String) {
        /* check whether we already run a modal dialog */
        guard NSApp.modalWindow == nil else {
            return
        }

        // load window
//        self.window
        self.tabView.selectTabViewItem(withIdentifier: identifier)
        self.fileSubCheckbox.state = .off

        let i_result = NSApp.runModal(for: self.window!)
        self.window!.close()
        // Check if dialog was canceled or stopped (NSModalResponseStop)
        if i_result != .continue {
            return
        }

//        NSMutableDictionary *itemOptionsDictionary
        var options = [String]()
        let itemOptionsDictionary = ["ITEM_URL" : self.MRL]

        if self.fileSubCheckbox.state == .on {

            options.append("sub-file=\(self.subPath)")
            if self.fileSubOverrideCheckbox.state == .on {
                options.append("sub-delay=\(self.fileSubDelay * 10)")
                options.append("sub-fps=\(self.fileSubFps)")
            }
            options.append("subsdec-encoding=\(self.fileSubEncodingPopup!.selectedItem?.representedObject)")
            options.append("subsdec-align=\(self.fileSubAlignPopup.indexOfSelectedItem)")
            if let p_item = config_FindConfig("freetype-rel-fontsize") {
                options.append("freetype-rel-fontsize=\(p_item.pointee.list.i[self.fileSubSizePopup.indexOfSelectedItem])")
            }
        }

//        if (self.fileCustomTimingCheckbox.state == .on) {
//            NSArray *components = [self.fileStartTimeTextField stringValue] componentsSeparatedByString:":"]
//            NSUInteger componentCount = [components count]
//            NSInteger tempValue = 0
//            if (componentCount == 1)
//            tempValue = [[components firstObject] intValue]
//            else if (componentCount == 2)
//            tempValue = [[components firstObject] intValue] * 60 + [[components objectAtIndex:1] intValue]
//            else if (componentCount == 3)
//            tempValue = [[components firstObject] intValue] * 3600 + [[components objectAtIndex:1] intValue] * 60 + [[components objectAtIndex:2] intValue]
//            if (tempValue > 0)
//            options.append([String stringWithFormat:"start-time=%li", tempValue]]
//            components = [self.fileStopTimeTextField stringValue] componentsSeparatedByString:":"]
//            componentCount = [components count]
//            if (componentCount == 1)
//            tempValue = [[components firstObject] intValue]
//            else if (componentCount == 2)
//            tempValue = [[components firstObject] intValue] * 60 + [[components objectAtIndex:1] intValue]
//            else if (componentCount == 3)
//            tempValue = [[components firstObject] intValue] * 3600 + [[components objectAtIndex:1] intValue] * 60 + [[components objectAtIndex:2] intValue]
//            if (tempValue != 0)
//            options.append([String stringWithFormat:"stop-time=%li", tempValue]]
//        }
//        if (self.outputCheckbox.state == .on) {
//            NSArray *soutMRL = self.output soutMRL]
//            NSUInteger count = [soutMRL count]
//            for (NSUInteger i = 0 ; i < count ; i++)
//            options.append([String stringWithString: [soutMRL objectAtIndex:i]]]
//        }
//        if (self.fileSlaveCheckbox.state && _fileSlavePath)
//            options.append([String stringWithFormat: "input-slave=%", _fileSlavePath]]
//        if ([[self.tabView selectedTabViewItem] identifier] isEqualToString: kCaptureTabViewId]) {
//            if ([[self.captureModePopup selectedItem] title] isEqualToString: _NS("Screen")]) {
//                int selected_index = self.screenPopup indexOfSelectedItem]
//                NSValue *v = self.displayInfos objectAtIndex:selected_index]
//                struct display_info_t *item = (struct display_info_t *)[v pointerValue]
//
//                options.append([String stringWithFormat: "screen-fps=%f", self.screenFPSTextField floatValue]]]
//                options.append([String stringWithFormat: "screen-display-id=%i", item->id]]
//                options.append([String stringWithFormat: "screen-left=%i", self.screenLeftTextField intValue]]]
//                options.append([String stringWithFormat: "screen-top=%i", self.screenTopTextField intValue]]]
//                options.append([String stringWithFormat: "screen-width=%i", self.screenWidthTextField intValue]]]
//                options.append([String stringWithFormat: "screen-height=%i", self.screenHeightTextField intValue]]]
//                if (self.screenFollowMouseCheckbox intValue] == true)
//                options.append("screen-follow-mouse"]
//                else
//                options.append("no-screen-follow-mouse"]
//                if (self.screenqtkAudioCheckbox.state && _avCurrentAudioDeviceUID)
//                options.append([String stringWithFormat: "input-slave=qtsound://%", _avCurrentAudioDeviceUID]]
//            }
//            else if ([[self.captureModePopup selectedItem] title] isEqualToString: _NS("Input Devices")]) {
//                if (self.qtkVideoCheckbox.state) {
//                    if (self.qtkAudioCheckbox.state && _avCurrentAudioDeviceUID)
//                        options.append([String stringWithFormat: "input-slave=qtsound://%", _avCurrentAudioDeviceUID]]
//                }
//            }
//        }

        /* apply the options to our item(s) */
//        [itemOptionsDictionary setObject: (NSArray *)[options copy] forKey: "ITEM_OPTIONS"]

//        [[[VLCMain sharedInstance] playlist] addPlaylistItems:[NSArray arrayWithObject:itemOptionsDictionary]]
    }

//#pragma mark Main Actions
//
//
//    func tabView:(NSTabView *)o_tv didSelectTabViewItem:(NSTabViewItem *)tabViewItem -> void
//    {
//    String *identifier = [tabViewItem identifier]
//
//    if ([identifier isEqualToString: kFileTabViewId])
//    [self openFilePathChanged: nil]
//    else if ([identifier isEqualToString: kDiscTabViewId])
//    [self scanOpticalMedia: nil]
//    else if ([identifier isEqualToString: kNetworkTabViewId])
//    [self openNetInfoChanged: nil]
//    else if ([identifier isEqualToString: kCaptureTabViewId])
//    [self openCaptureModeChanged: nil]
//    }
//
//    @IBAction func expandMRLfieldAction:(id)sender
//    {
//    if (self.mrlButton.state == NSOffState) {
//    self.mrlViewHeightConstraint.animator.constant = 0
//    } else {
//    self.mrlViewHeightConstraint.animator.constant = 39
//    }
//    }

    func openFileGeneric() {
        openFilePathChanged(notification: nil)
        openTarget(identifier: kFileTabViewId)
    }

//    func openDisc -> void
//    {
//    @synchronized (self) {
//    self.specialMediaFolders removeAllObjects]
//    }
//
//    [self scanOpticalMedia: nil]
//    [self openTarget: kDiscTabViewId]
//    }
//
//    func openNet -> void
//    {
//    [self openNetInfoChanged: nil]
//    [self openTarget: kNetworkTabViewId]
//    }
//
//    func openCapture -> void
//    {
//    [self openCaptureModeChanged: nil]
//    [self openTarget: kCaptureTabViewId]
//    }
//
//    func openFileWithAction:(void (^)(NSArray *files))action -> void
//    {
//    NSOpenPanel *openPanel = [NSOpenPanel openPanel]
//    [openPanel setAllowsMultipleSelection: true]
//    [openPanel setCanChooseDirectories: true]
//    [openPanel setTitle: _NS("Open File")]
//    [openPanel setPrompt: _NS("Open")]
//
//    if ([openPanel runModal] == NSModalResponseOK) {
//    NSArray *URLs = [openPanel URLs]
//    NSUInteger count = [URLs count]
//    NSMutableArray *values = [NSMutableArray arrayWithCapacity:count]
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count]
//    for (NSUInteger i = 0; i < count; i++)
//    [values.append([[URLs objectAtIndex:i] path]]
//    [values sortUsingSelector:#selector(caseInsensitiveCompare:)]
//
//    for (NSUInteger i = 0; i < count; i++) {
//    NSDictionary *dictionary
//    char *psz_uri = vlc_path2uri([[values objectAtIndex:i] UTF8String], "file")
//    if (!psz_uri)
//    continue
//    dictionary = [NSDictionary dictionaryWithObject:toNSStr(psz_uri) forKey:"ITEM_URL"]
//    free(psz_uri)
//    [array.append(dictionary]
//    }
//
//    action(array)
//    }
//    }
//
//    @IBAction func outputSettings:(id)sender
//    {
//    if (sender == self.outputCheckbox) {
//    self.outputSettingsButton.isEnabled = self.outputCheckbox.state
//    return
//    }
//
//    if (!b_outputNibLoaded)
//    b_outputNibLoaded = [NSBundle loadNibNamed:"StreamOutput" owner:_output]
//
//    [NSApp beginSheet:_output.outputSheet
//    modalForWindow:self.window
//    modalDelegate:self
//    didEndSelector:NULL
//    contextInfo:nil]
//    }

//#pragma mark File Panel

    private func openFilePathChanged(notification: NSNotification?) {

        if self.filePath.count > 0 {

            let b_stream = self.fileTreatAsPipeButton.state == .on
            let b_dir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)

            FileManager.default.fileExists(atPath: self.filePath, isDirectory: b_dir)

            let psz_uri = vlc_path2uri(self.filePath.withCString { return $0 }, "file")
            if psz_uri == nil { return }

            var mrlString = String(utf8String: psz_uri!)!
            free(psz_uri)

            if b_dir.pointee.boolValue {
                mrlString = mrlString.replacingOccurrences(of: "file", with: "directory")
            } else if b_stream {
                mrlString = mrlString.replacingOccurrences(of: "file", with: "stream")
            }

            self.fileNameLabel.stringValue = FileManager.default.displayName(atPath: self.filePath)
            self.fileNameStubLabel.isHidden = true
            self.fileTreatAsPipeButton.isHidden = false
            self.fileIconWell.image = NSWorkspace.shared.icon(forFile: self.filePath)
            self.fileIconWell.isHidden = false
            self.MRL = mrlString

        } else {
            self.fileNameLabel.stringValue = ""
            self.fileNameStubLabel.isHidden = false
            self.fileTreatAsPipeButton.isHidden = true
            self.fileIconWell.image = NSImage(named: NSImage.Name("generic"))
            self.MRL = ""
        }
    }

//    @IBAction func openFileBrowse:(id)sender
//    {
//    NSOpenPanel *openPanel = [NSOpenPanel openPanel]
//    [openPanel setAllowsMultipleSelection: false]
//    [openPanel setCanChooseDirectories: true]
//    [openPanel setTitle: _NS("Open File")]
//    [openPanel setPrompt: _NS("Open")]
//    openPanel.beginSheetModalForWindow:[sender window.completionHandler:^(NSInteger returnCode) {
//    if (returnCode == NSFileHandlingPanelOKButton) {
//    self.filePath = [[[openPanel URLs] firstObject] path]
//    [self openFilePathChanged: nil]
//    }
//    }]
//    }
//
//    @IBAction func openFileStreamChanged:(id)sender
//    {
//    [self openFilePathChanged: nil]
//    }
//
//    @IBAction func inputSlaveAction:(id)sender
//    {
//    if (sender == _fileSlaveCheckbox)
//    self.fileSelectSlaveButton.isEnabled = self.fileSlaveCheckbox.state]
//    else {
//    NSOpenPanel *openPanel
//    openPanel = [NSOpenPanel openPanel]
//    [openPanel setCanChooseFiles: true]
//    [openPanel setCanChooseDirectories: false]
//    if ([openPanel runModal] == NSModalResponseOK) {
//    _fileSlavePath = [[openPanel.URLs.firstObject] path]
//    }
//    }
//    if (self.fileSlavePath && self.fileSlaveCheckbox.state == .on) {
//    _fileSlaveFilenameLabel.stringValue = [[NSFileManager defaultManager.displayNameAtPath:_fileSlavePath]]
//    _fileSlaveIconWell.image = [NSWorkspace.shared.iconForFile: _fileSlavePath]]
//    } else {
//    self.fileSlaveFilenameLabel.stringValue =  ""]
//    self.fileSlaveIconWell.image = NULL]
//    }
//    }
//
//    @IBAction func fileTimeCustomization:(id)sender
//    {
//    Bool b_value = self.fileCustomTimingCheckbox.state
//    self.fileStartTimeTextField.isEnabled = b_value]
//    self.fileStartTimeLabel.isEnabled = b_value]
//    self.fileStopTimeTextField.isEnabled = b_value]
//    self.fileStopTimeLabel.isEnabled = b_value]
//    }
//
//#pragma mark Optical Media Panel
//
//    func showOpticalMediaView:(NSView *)theView withIcon:(NSImage *)icon -> void
//    {
//    NSRect viewRect = [theView frame]
//    [theView setFrame: NSMakeRect(233, 0, viewRect.size.width, viewRect.size.height)]
//    [theView setAutoresizesSubviews: true]
//
//    NSView *opticalTabView = [self.tabView tabViewItemAtIndex: self.tabView indexOfTabViewItemWithIdentifier:kDiscTabViewId]] view]
//    if (self.currentOpticalMediaView) {
//    [opticalTabView.animator.replaceSubview: _currentOpticalMediaView with: theView]
//    }
//    else
//    [opticalTabView.animator.addSubview: theView]
//    _currentOpticalMediaView = theView
//
//    NSImageView *imageView = [NSImageView.alloc.init]
//    [imageView setFrame: NSMakeRect(53, 61, 128, 128)]
//    [icon setSize: NSMakeSize(128,128)]
//    [imageView.image = icon]
//    if (self.currentOpticalMediaIconView) {
//    [opticalTabView.animator.replaceSubview: _currentOpticalMediaIconView with: imageView]
//    }
//    else
//    [opticalTabView.animator.addSubview: imageView]
//    _currentOpticalMediaIconView = imageView
//    self.currentOpticalMediaView.setNeedsDisplay: true]
//    self.currentOpticalMediaIconView.setNeedsDisplay: true]
//    [opticalTabView.setNeedsDisplay: true]
//    [opticalTabView displayIfNeeded]
//    }
//
//    func showOpticalAtPath: (NSDictionary *)valueDictionary -> void
//    {
//    String *diskType = [valueDictionary objectForKey:"mediaType"]
//    String *opticalDevicePath = [valueDictionary objectForKey:"path"]
//    String *devicePath = [valueDictionary objectForKey:"devicePath"]
//    NSImage *image = [valueDictionary objectForKey:"image"]
//
//    if ([diskType isEqualToString: kVLCMediaDVD] || [diskType isEqualToString: kVLCMediaVideoTSFolder]) {
//    _discDVDLabel.stringValue = [[NSFileManager defaultManager.displayNameAtPath:opticalDevicePath]]
//    self.discDVDwomenusLabel.stringValue =  self.discDVDLabel stringValue]]
//
//    if (!b_nodvdmenus) {
//    [self.MRL = [String stringWithFormat: "dvdnav://%", devicePath]]
//    [self showOpticalMediaView: _discDVDView withIcon:image]
//    } else {
//    [self.MRL = [String stringWithFormat: "dvdread://%@#%i:%i-", devicePath, self.discDVDwomenusTitleTextField intValue], self.discDVDwomenusChapterTextField intValue]]]
//    [self showOpticalMediaView: _discDVDwomenusView withIcon:image]
//    }
//    } else if ([diskType isEqualToString: kVLCMediaAudioCD]) {
//    _discAudioCDLabel.stringValue = [[NSFileManager defaultManager.displayNameAtPath: opticalDevicePath]]
//    _discAudioCDTrackCountLabel.stringValue = [String stringWithFormat:_NS("%i tracks"), [[[NSFileManager defaultManager.subpathsOfDirectoryAtPath: opticalDevicePath error:NULL] count] - 1]]; // minus .TOC.plist
//    [self showOpticalMediaView: _discAudioCDView withIcon: image]
//    [self.MRL = [String stringWithFormat: "cdda://%", devicePath]]
//    } else if ([diskType isEqualToString: kVLCMediaVCD]) {
//    _discVCDLabel.stringValue = [[NSFileManager defaultManager.displayNameAtPath: opticalDevicePath]]
//    [self showOpticalMediaView: _discVCDView withIcon: image]
//    [self.MRL = [String stringWithFormat: "vcd://%@#%i:%i", devicePath, self.discVCDTitleTextField intValue], self.discVCDChapterTextField intValue]]]
//    } else if ([diskType isEqualToString: kVLCMediaSVCD]) {
//    _discVCDLabel.stringValue = [[NSFileManager defaultManager.displayNameAtPath: opticalDevicePath]]
//    [self showOpticalMediaView: _discVCDView withIcon: image]
//    [self.MRL = [String stringWithFormat: "vcd://%@@%i:%i", devicePath, self.discVCDTitleTextField intValue], self.discVCDChapterTextField intValue]]]
//    } else if ([diskType isEqualToString: kVLCMediaBD] || [diskType isEqualToString: kVLCMediaBDMVFolder]) {
//    _discBDLabel.stringValue = [[NSFileManager defaultManager.displayNameAtPath: opticalDevicePath]]
//    [self showOpticalMediaView: _discBDView withIcon: image]
//    [self.MRL = [String stringWithFormat: "bluray://%", opticalDevicePath]]
//    } else {
//    if (getIntf())
//    msg_Warn(getIntf(), "unknown disk type, no idea what to display")
//
//    [self showOpticalMediaView: _discNoDiscView withIcon: [NSImage imageNamed:"NSApplicationIcon"]]
//    }
//    }
//
//    func scanPath:(String *)path -> NSDictionary *
//    {
//    String *type = [VLCStringUtility.sharedInstance.getVolumeTypeFromMountPath:path]
//    NSImage *image = [NSWorkspace.shared] iconForFile: path]
//    String *devicePath
//
//    // BDMV path must not end with BDMV directory
//    if([type isEqualToString: kVLCMediaBDMVFolder]) {
//    if([path.lastPathComponent.isEqualToString: "BDMV"]) {
//    path = [path stringByDeletingLastPathComponent]
//    }
//    }
//
//    if ([type isEqualToString: kVLCMediaVideoTSFolder] ||
//    [type isEqualToString: kVLCMediaBD] ||
//    [type isEqualToString: kVLCMediaBDMVFolder] ||
//    [type isEqualToString: kVLCMediaUnknown])
//    devicePath = path
//    else
//    devicePath = [VLCStringUtility.sharedInstance.getBSDNodeFromMountPath:path]
//
//    return [NSDictionary dictionaryWithObjectsAndKeys: path, "path",
//    devicePath, "devicePath",
//    type, "mediaType",
//    image, "image", nil]
//    }
//
//    func scanDevicesWithPaths:(NSArray *)paths -> void
//    {
//    @autoreleasepool {
//    NSUInteger count = [paths count]
//    NSMutableArray *o_result = [NSMutableArray array]
//    for (NSUInteger i = 0; i < count; i++)
//    [o_result.append([self scanPath:[paths objectAtIndex:i]]]
//
//    @synchronized (self) {
//    _opticalDevices = [NSArray.alloc.initWithArray: o_result]
//    }
//
//    [self performSelectorOnMainThread:#selector(updateMediaSelector:) withObject:nil waitUntilDone:false]
//    }
//    }
//
//    func scanSpecialPath:(String *)oPath -> void
//    {
//    @autoreleasepool {
//    NSDictionary *o_dict = [self scanPath:oPath]
//
//    @synchronized (self) {
//    self.specialMediaFolders addObject:o_dict]
//    }
//
//    self.performSelectorOnMainThread:#selector(updateMediaSelector:) withObject:[NSNumber numberWithBool:true.waitUntilDone:false]
//    }
//    }
//
//    func scanOpticalMedia:(NSNotification *)o_notification -> void
//    {
//    [NSThread detachNewThreadSelector:#selector(scanDevicesWithPaths:) toTarget:self withObject:[NSArray arrayWithArray:[NSWorkspace.shared] mountedRemovableMedia]]]
//    }
//
//    func updateMediaSelector:(NSNumber *)selection -> void
//    {
//    self.allMediaDevices removeAllObjects]
//
//    @synchronized (self) {
//    self.allMediaDevices addObjectsFromArray:_opticalDevices]
//    self.allMediaDevices addObjectsFromArray:_specialMediaFolders]
//    }
//
//    NSUInteger count = self.allMediaDevices count]
//    if (count > 0) {
//    for (NSUInteger i = 0; i < count ; i++) {
//    NSDictionary *o_dict = self.allMediaDevices objectAtIndex:i]
//    }
//
//
//
//    // only trigger MRL update if the tab view is active
//    if ([[self.tabView selectedTabViewItem] identifier] isEqualToString:kDiscTabViewId])
//    [self discSelectorChanged:nil]
//    } else {
//    msg_Dbg(getIntf(), "no optical media found")
//    self.discSelectorPopup.isHidden = true]
//    [self.MRL =""]
//    [self showOpticalMediaView: _discNoDiscView withIcon: [NSImage imageNamed: "NSApplicationIcon"]]
//    }
//
//    }
//
//    @IBAction func discSelectorChanged:(id)sender
//    {
//    [self showOpticalAtPath:self.allMediaDevices objectAtIndex:self.discSelectorPopup indexOfSelectedItem]]]
//    }
//
//    @IBAction func openSpecialMediaFolder:(id)sender
//    {
//    /* this is currently for VIDEO_TS and BDMV folders */
//    NSOpenPanel *openPanel = [NSOpenPanel openPanel]
//    [openPanel setAllowsMultipleSelection: false]
//    [openPanel setCanChooseDirectories: true]
//    [openPanel setTitle: [sender title]]
//    [openPanel setPrompt: _NS("Open")]
//
//    /* work-around for Mountain Lion, which treats folders called "BDMV" including an item named "INDEX.BDM"
//     * as a _FILE_. Don't ask, move on. There is nothing to see here */
//    [openPanel setCanChooseFiles: true]
//    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:"public.directory"]]
//
//    if ([openPanel runModal] == NSModalResponseOK) {
//    String *oPath = [[[openPanel URLs] firstObject] path]
//    if ([oPath length] > 0) {
//    [NSThread detachNewThreadSelector:#selector(scanSpecialPath:) toTarget:self withObject:oPath]
//    }
//    }
//    }
//
//    @IBAction func dvdreadOptionChanged:(id)sender
//    {
//    String *devicePath = [self.allMediaDevices objectAtIndex:self.discSelectorPopup indexOfSelectedItem]] objectForKey:"devicePath"]
//
//    if (sender == _discDVDwomenusEnableMenusButton) {
//    b_nodvdmenus = false
//    [self.MRL = [String stringWithFormat: "dvdnav://%", devicePath]]
//    [self showOpticalMediaView:_discDVDView withIcon:self.currentOpticalMediaIconView image]]
//    return
//    }
//    if (sender == _discDVDDisableMenusButton) {
//    b_nodvdmenus = true
//    [self showOpticalMediaView:_discDVDwomenusView withIcon:self.currentOpticalMediaIconView image]]
//    }
//
//    if (sender == _discDVDwomenusTitleTextField)
//    self.discDVDwomenusTitleStepper setIntValue: self.discDVDwomenusTitleTextField intValue]]
//    if (sender == _discDVDwomenusTitleStepper)
//    self.discDVDwomenusTitleTextField setIntValue: self.discDVDwomenusTitleStepper intValue]]
//    if (sender == _discDVDwomenusChapterTextField)
//    self.discDVDwomenusChapterStepper setIntValue: self.discDVDwomenusChapterTextField intValue]]
//    if (sender == _discDVDwomenusChapterStepper)
//    self.discDVDwomenusChapterTextField setIntValue: self.discDVDwomenusChapterStepper intValue]]
//
//    [self.MRL = [String stringWithFormat: "dvdread://%@#%i:%i-", devicePath, self.discDVDwomenusTitleTextField intValue], self.discDVDwomenusChapterTextField intValue]]]
//    }
//
//    @IBAction func vcdOptionChanged:(id)sender
//    {
//    if (sender == _discVCDTitleTextField)
//    self.discVCDTitleStepper setIntValue: self.discVCDTitleTextField intValue]]
//    if (sender == _discVCDTitleStepper)
//    self.discVCDTitleTextField setIntValue: self.discVCDTitleStepper intValue]]
//    if (sender == _discVCDChapterTextField)
//    self.discVCDChapterStepper setIntValue: self.discVCDChapterTextField intValue]]
//    if (sender == _discVCDChapterStepper)
//    self.discVCDChapterTextField setIntValue: self.discVCDChapterStepper intValue]]
//
//    String *devicePath = [self.allMediaDevices objectAtIndex:self.discSelectorPopup indexOfSelectedItem]] objectForKey:"devicePath"]
//    [self.MRL = [String stringWithFormat: "vcd://%@@%i:%i", devicePath, self.discVCDTitleTextField intValue], self.discVCDChapterTextField intValue]]]
//    }
//
//#pragma mark Network Panel
//
//    func textFieldWasClicked:(NSNotification *)notification -> void
//    {
//    if ([notification object] == _netUDPPortTextField)
//    self.netModeMatrix selectCellAtRow: 0 column: 0]
//    else if ([notification object] == _netUDPMAddressTextField ||
//    [notification object] == _netUDPMPortTextField)
//    self.netModeMatrix selectCellAtRow: 1 column: 0]
//    else
//    self.netModeMatrix selectCellAtRow: 2 column: 0]
//
//    [self openNetInfoChanged: nil]
//    }
//
//    @IBAction func openNetModeChanged:(id)sender
//    {
//    if (sender == _netModeMatrix) {
//    if ([[sender selectedCell] tag] == 0)
//    [self.window makeFirstResponder: _netUDPPortTextField]
//    else if ([[sender selectedCell] tag] == 1)
//    [self.window makeFirstResponder: _netUDPMAddressTextField]
//    else
//    msg_Warn(getIntf(), "Unknown sender tried to change UDP/RTP mode")
//    }
//
//    [self openNetInfoChanged: nil]
//    }
//
//    @IBAction func openNetStepperChanged:(id)sender
//    {
//    int i_tag = [sender tag]
//
//    if (i_tag == 0) {
//    self.netUDPPortTextField setIntValue: self.netUDPPortStepper intValue]]
//    [[NSNotificationCenter defaultCenter] postNotificationName: VLCOpenTextFieldWasClicked
//    object: _netUDPPortTextField]
//    [self.window makeFirstResponder: _netUDPPortTextField]
//    }
//    else if (i_tag == 1) {
//    self.netUDPMPortTextField setIntValue: self.netUDPMPortStepper intValue]]
//    [[NSNotificationCenter defaultCenter] postNotificationName: VLCOpenTextFieldWasClicked
//    object: _netUDPMPortTextField]
//    [self.window makeFirstResponder: _netUDPMPortTextField]
//    }
//
//    [self openNetInfoChanged: nil]
//    }
//
//    func openNetInfoChanged:(NSNotification *)o_notification -> void
//    {
//    String *mrlString
//
//    if (self.netUDPPanel isVisible]) {
//    String *mode
//    mode = [self.netModeMatrix selectedCell] title]
//
//    if ([mode isEqualToString: _NS("Unicast")]) {
//    int port = self.netUDPPortTextField intValue]
//
//    if ([self.netUDPProtocolMatrix selectedCell] tag] == 0)
//    mrlString = "udp://"
//    else
//    mrlString = "rtp://"
//
//    if (port != config_GetInt("server-port")) {
//    mrlString =
//    [mrlString stringByAppendingFormat: "@:%i", port]
//    }
//    }
//    else if ([mode isEqualToString: _NS("Multicast")]) {
//    String *oAddress = self.netUDPMAddressTextField stringValue]
//    int iPort = self.netUDPMPortTextField intValue]
//
//    if ([self.netUDPProtocolMatrix selectedCell] tag] == 0)
//    mrlString = [String stringWithFormat: "udp://@%", oAddress]
//    else
//    mrlString = [String stringWithFormat: "rtp://@%", oAddress]
//
//    if (iPort != config_GetInt("server-port")) {
//    mrlString =
//    [mrlString stringByAppendingFormat: ":%i", iPort]
//    }
//    }
//    } else
//    mrlString = self.netHTTPURLTextField stringValue]
//
//    [self.MRL = mrlString]
//    }
//
//    @IBAction func openNetUDPButtonAction:(id)sender
//    {
//    if (sender == _netOpenUDPButton) {
//    [NSApp beginSheet: self.netUDPPanel
//    modalForWindow: self.window
//    modalDelegate: self
//    didEndSelector: NULL
//    contextInfo: nil]
//    [self openNetInfoChanged:nil]
//    }
//    else if (sender == _netUDPCancelButton) {
//    self.netUDPPanel orderOut: sender]
//    [NSApp endSheet: _netUDPPanel]
//    }
//    else if (sender == _netUDPOKButton) {
//    String *mrlString
//    if ([[self.netModeMatrix selectedCell] title] isEqualToString: _NS("Unicast")]) {
//    int port = self.netUDPPortTextField intValue]
//
//    if ([self.netUDPProtocolMatrix selectedCell] tag] == 0)
//    mrlString = "udp://"
//    else
//    mrlString = "rtp://"
//
//    if (port != config_GetInt("server-port")) {
//    mrlString =
//    [mrlString stringByAppendingFormat: "@:%i", port]
//    }
//    }
//    else if ([[self.netModeMatrix selectedCell] title] isEqualToString: _NS("Multicast")]) {
//    String *oAddress = self.netUDPMAddressTextField stringValue]
//    int iPort = self.netUDPMPortTextField intValue]
//
//    if ([self.netUDPProtocolMatrix selectedCell] tag] == 0)
//    mrlString = [String stringWithFormat: "udp://@%", oAddress]
//    else
//    mrlString = [String stringWithFormat: "rtp://@%", oAddress]
//
//    if (iPort != config_GetInt("server-port")) {
//    mrlString =
//    [mrlString stringByAppendingFormat: ":%i", iPort]
//    }
//    }
//    [self.MRL = mrlString]
//    self.netHTTPURLTextField.stringValue =  mrlString]
//    self.netUDPPanel orderOut: sender]
//    [NSApp endSheet: _netUDPPanel]
//    }
//    }
//
//#pragma mark Capture Panel
//
//    @IBAction func openCaptureModeChanged:(id)sender
//    {
//    intf_thread_t * p_intf = getIntf()
//
//    if ([[self.captureModePopup selectedItem] title] isEqualToString: _NS("Screen")]) {
//    self.captureTabView selectTabViewItemAtIndex:1]
//
//    [self.MRL = "screen://"]
//    self.screenHeightTextField setIntValue: config_GetInt("screen-height")]
//    self.screenWidthTextField setIntValue: config_GetInt("screen-width")]
//    self.screenFPSTextField.floatValue: config_GetFloat("screen-fps")]
//    self.screenLeftTextField setIntValue: config_GetInt("screen-left")]
//    self.screenTopTextField setIntValue: config_GetInt("screen-top")]
//    self.screenFollowMouseCheckbox setIntValue: config_GetInt("screen-follow-mouse")]
//
//    int screenIindex = config_GetInt("screen-index")
//    int displayID = config_GetInt("screen-display-id")
//    unsigned int displayCount = 0
//    CGError returnedError
//    struct display_info_t *item
//    NSValue *v
//
//    returnedError = CGGetOnlineDisplayList(0, NULL, &displayCount)
//    if (!returnedError) {
//    CGDirectDisplayID *ids
//    ids = (CGDirectDisplayID *)vlc_alloc(displayCount, sizeof(CGDirectDisplayID))
//    returnedError = CGGetOnlineDisplayList(displayCount, ids, &displayCount)
//    if (!returnedError) {
//    NSUInteger displayInfoCount = self.displayInfos count]
//    for (NSUInteger i = 0; i < displayInfoCount; i ++) {
//    v = self.displayInfos objectAtIndex:i]
//    free([v pointerValue])
//    }
//    self.displayInfos removeAllObjects]
//    self.screenPopup removeAllItems]
//    for (unsigned int i = 0; i < displayCount; i ++) {
//    item = (struct display_info_t *)malloc(sizeof(struct display_info_t))
//    item->id = ids[i]
//    item->rect = CGDisplayBounds(item->id)
//    self.screenPopup addItemWithTitle: [String stringWithFormat:"Screen %d (%dx%d)", i + 1, (int)item->rect.size.width, (int)item->rect.size.height]]
//    v = [NSValue valueWithPointer:item]
//    self.displayInfos addObject:v]
//    if (i == 0 || displayID == item->id || screenIindex - 1 == i) {
//    self.screenPopup selectItemAtIndex: i]
//    self.screenLeftStepper setMaxValue: item->rect.size.width]
//    self.screenTopStepper setMaxValue: item->rect.size.height]
//    self.screenWidthStepper setMaxValue: item->rect.size.width]
//    self.screenHeightStepper setMaxValue: item->rect.size.height]
//    }
//    }
//    }
//    free(ids)
//    }
//    }
//    else if ([[self.captureModePopup selectedItem] title] isEqualToString: _NS("Input Devices")]) {
//    self.captureTabView selectTabViewItemAtIndex:0]
//
//    [self qtkChanged:nil]
//    [self qtkAudioChanged:nil]
//
//    [self.MRL = ""]
//
//    if (self.qtkVideoCheckbox.state && _avCurrentDeviceUID)
//    [self.MRL =[String stringWithFormat:"avcapture://%", _avCurrentDeviceUID]]
//    else if (self.qtkAudioCheckbox.state && _avCurrentAudioDeviceUID)
//    [self.MRL =[String stringWithFormat:"qtsound://%", _avCurrentAudioDeviceUID]]
//    }
//    }
//
//    // Screen actions
//    func screenFPSfieldChanged:(NSNotification *)o_notification -> void
//    {
//    self.screenFPSStepper.floatValue: self.screenFPSTextField floatValue]]
//    if ([self.screenFPSTextField stringValue] isEqualToString: ""])
//    self.screenFPSTextField.floatValue: 1.0]
//    [self.MRL = "screen://"]
//    }
//
//    @IBAction func screenChanged:(id)sender
//    {
//    int selected_index = self.screenPopup indexOfSelectedItem]
//    if (selected_index >= self.displayInfos count]) return
//
//    NSValue *v = self.displayInfos objectAtIndex:selected_index]
//    struct display_info_t *item = (struct display_info_t *)[v pointerValue]
//
//    self.screenLeftStepper setMaxValue: item->rect.size.width]
//    self.screenTopStepper setMaxValue: item->rect.size.height]
//    self.screenWidthStepper setMaxValue: item->rect.size.width]
//    self.screenHeightStepper setMaxValue: item->rect.size.height]
//
//    self.screenqtkAudioPopup.isEnabled = self.screenqtkAudioCheckbox.state]
//    }
//
//    @IBAction func screenAudioChanged:(id)sender
//    {
//    self.screenqtkAudioPopup.isEnabled =_screenqtkAudioCheckbox.state]
//    }
//
//    // QTKit Recording actions
//    @IBAction func qtkChanged:(id)sender
//    {
//    NSInteger selectedDevice = self.qtkVideoDevicePopup indexOfSelectedItem]
//    if (self.avvideoDevices.count >= 1) {
//    _avCurrentDeviceUID = [[(AVCaptureDevice *)self.avvideoDevices objectAtIndex:selectedDevice] uniqueID] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
//    }
//    }
//
//    @IBAction func qtkAudioChanged:(id)sender
//    {
//    NSInteger selectedDevice = self.qtkAudioDevicePopup indexOfSelectedItem]
//    if (self.avaudioDevices.count >= 1) {
//    _avCurrentAudioDeviceUID = [[(AVCaptureDevice *)self.avaudioDevices objectAtIndex:selectedDevice] uniqueID] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
//    }
//    self.screenqtkAudioPopup selectItemAtIndex: selectedDevice]
//    self.qtkAudioDevicePopup selectItemAtIndex: selectedDevice]
//    }
//
//    @IBAction func qtkToggleUIElements:(id)sender
//    {
//    self.qtkAudioDevicePopup.isEnabled =self.qtkAudioCheckbox.state]
//    Bool b_state = self.qtkVideoCheckbox.state
//    self.qtkVideoDevicePopup.isEnabled =b_state]
//    [self qtkAudioChanged:sender]
//    [self qtkChanged:sender]
//    [self openCaptureModeChanged:sender]
//    }
//
//#pragma mark Subtitle Settings
//
//    @IBAction func subsChanged:(id)sender
//    {
//    if (self.fileSubCheckbox.state == .on) {
//    self.fileSubSettingsButton.isEnabled =true]
//    if (self.subPath) {
//    self.fileSubtitlesFilenameLabel.stringValue =  [FileManager.default. displayNameAtPath:self.subPath]]
//    self.fileSubtitlesIconWell.image = [NSWorkspace.shared] iconForFile:self.subPath]]
//    }
//    } else {
//    self.fileSubSettingsButton.isEnabled =false]
//    self.fileSubtitlesFilenameLabel.stringValue =  ""]
//    self.fileSubtitlesIconWell.image = NULL]
//    }
//    }
//
//    @IBAction func subSettings:(id)sender
//    {
//    [NSApp beginSheet: self.fileSubSheet
//    modalForWindow: [sender window]
//    modalDelegate: self
//    didEndSelector: NULL
//    contextInfo: nil]
//    }
//
//    @IBAction func subCloseSheet:(id)sender
//    {
//    [self subsChanged: nil]
//    self.fileSubSheet orderOut:sender]
//    [NSApp endSheet: _fileSubSheet]
//    }
//
//    @IBAction func subFileBrowse:(id)sender
//    {
//    NSOpenPanel *openPanel = [NSOpenPanel openPanel]
//    [openPanel setAllowsMultipleSelection: false]
//    [openPanel setTitle: _NS("Open File")]
//    [openPanel setPrompt: _NS("Open")]
//
//    if ([openPanel runModal] == NSModalResponseOK) {
//    self.subPath = [[[openPanel URLs] firstObject] path]
//    self.fileSubtitlesFilenameLabel.stringValue =  [FileManager.default. displayNameAtPath:self.subPath]]
//    self.fileSubPathTextField.stringValue =  self.fileSubtitlesFilenameLabel stringValue]]
//    self.fileSubPathLabel.isHidden = true]
//    self.fileSubtitlesIconWell.image = [NSWorkspace.shared] iconForFile:self.subPath]]
//    self.fileSubIconView.image = self.fileSubtitlesIconWell image]]
//    } else {
//    self.fileSubPathLabel.isHidden = false]
//    self.fileSubPathTextField.stringValue = ""]
//    self.fileSubtitlesFilenameLabel.stringValue = ""]
//    self.fileSubtitlesIconWell.image = nil]
//    self.fileSubIconView.image = nil]
//    }
//    }
//
//    @IBAction func subOverride:(id)sender
//    {
//    Bool b_state = self.fileSubOverrideCheckbox.state
//    self.fileSubDelayTextField.isEnabled = b_state]
//    self.fileSubDelayStepper.isEnabled = b_state]
//    self.fileSubFPSTextField.isEnabled = b_state]
//    self.fileSubFPSStepper.isEnabled = b_state]
//    }
//
//#pragma mark Miscellaneous
//
//    @IBAction func panelCancel:(id)sender
//    {
//    [NSApp stopModalWithCode: 0]
//    }
//
//    @IBAction func panelOk:(id)sender
//    {
//    if ([[self MRL] length])
//    [NSApp stopModalWithCode: 1]
//    else
//    NSBeep()
//    }
//
//    func updateQTKVideoDevices -> void
//    {
//    _avvideoDevices = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]
//    arrayByAddingObjectsFromArray:[AVCaptureDevice devicesWithMediaType:AVMediaTypeMuxed]]
//    }
//
//    func updateQTKAudioDevices -> void
//    {
//    _avaudioDevices = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]
//    arrayByAddingObjectsFromArray:[AVCaptureDevice devicesWithMediaType:AVMediaTypeMuxed]]
//    }

}


fileprivate let VLCOpenTextFieldWasClicked = Notification.Name("VLCOpenTextFieldWasClicked")

class VLCOpenTextField : NSTextField {
    override func mouseDown(with event: NSEvent) {
        NotificationCenter.default.post(name: VLCOpenTextFieldWasClicked, object: self)
        super.mouseDown(with: event)
    }
}

struct display_info_t {
    var rect: CGRect
    var id: CGDirectDisplayID
}

