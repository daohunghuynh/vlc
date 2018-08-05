//
//  VLCMainMenu.swift
//  VLC
//
//  Created by Dao Hung Huynh on 10/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation


class VLCMainMenu : NSMenu, NSMenuDelegate {

    /* main menu */
    @IBOutlet weak var about: NSMenuItem!
//    @IBOutlet weak var prefs: NSMenuItem!
    @IBOutlet weak var extensions: NSMenuItem!
    @IBOutlet weak var extensionsMenu: NSMenu!
    @IBOutlet weak var addonManager: NSMenuItem!
    @IBOutlet weak var add_intf: NSMenuItem!
    @IBOutlet weak var add_intfMenu: NSMenu!
    @IBOutlet weak var services: NSMenuItem!
    @IBOutlet weak var hide: NSMenuItem!
    @IBOutlet weak var hide_others: NSMenuItem!
    @IBOutlet weak var show_all: NSMenuItem!
    @IBOutlet weak var quit: NSMenuItem!

    @IBOutlet weak var fileMenu: NSMenu!
    @IBOutlet weak var open_file: NSMenuItem!
    @IBOutlet weak var open_generic: NSMenuItem!
    @IBOutlet weak var open_disc: NSMenuItem!
    @IBOutlet weak var open_net: NSMenuItem!
    @IBOutlet weak var open_capture: NSMenuItem!
    @IBOutlet weak var open_recent: NSMenuItem!
    @IBOutlet weak var close_window: NSMenuItem!
    @IBOutlet weak var convertandsave: NSMenuItem!
    @IBOutlet weak var save_playlist: NSMenuItem!
    @IBOutlet weak var revealInFinder: NSMenuItem!

    @IBOutlet weak var editMenu: NSMenu!
    @IBOutlet weak var cutItem: NSMenuItem!
    @IBOutlet weak var mcopyItem: NSMenuItem!
    @IBOutlet weak var pasteItem: NSMenuItem!
    @IBOutlet weak var clearItem: NSMenuItem!
    @IBOutlet weak var select_all: NSMenuItem!
    @IBOutlet weak var findItem: NSMenuItem!

    @IBOutlet weak var viewMenu: NSMenu!
    @IBOutlet weak var toggleJumpButtons: NSMenuItem!
    @IBOutlet weak var togglePlaymodeButtons: NSMenuItem!
    @IBOutlet weak var toggleEffectsButton: NSMenuItem!
    @IBOutlet weak var toggleSidebar: NSMenuItem!
    @IBOutlet weak var playlistTableColumnsMenu: NSMenu!
    @IBOutlet weak var playlistTableColumns: NSMenuItem!

    @IBOutlet weak var controlsMenu: NSMenu!
    @IBOutlet weak var play: NSMenuItem!
    @IBOutlet weak var stop: NSMenuItem!
    @IBOutlet weak var record: NSMenuItem!
    @IBOutlet weak var rate: NSMenuItem!
    @IBOutlet weak var rate_view: NSView!
    @IBOutlet weak var rateLabel: NSTextField!
    @IBOutlet weak var rate_slowerLabel: NSTextField!
    @IBOutlet weak var rate_normalLabel: NSTextField!
    @IBOutlet weak var rate_fasterLabel: NSTextField!
    @IBOutlet weak var rate_sld: NSSlider!
    @IBOutlet weak var rateTextField: NSTextField!
    @IBOutlet weak var trackSynchronization: NSMenuItem!
    @IBOutlet weak var previous: NSMenuItem!
    @IBOutlet weak var next: NSMenuItem!
    @IBOutlet weak var random: NSMenuItem!
//    @IBOutlet weak var repeat: NSMenuItem!
    @IBOutlet weak var loop: NSMenuItem!
    @IBOutlet weak var AtoBloop: NSMenuItem!
    @IBOutlet weak var quitAfterPB: NSMenuItem!
    @IBOutlet weak var fwd: NSMenuItem!
    @IBOutlet weak var bwd: NSMenuItem!
    @IBOutlet weak var jumpToTime: NSMenuItem!
    @IBOutlet weak var rendererMenu: NSMenu!
    @IBOutlet weak var rendererMenuItem: NSMenuItem!
    @IBOutlet weak var rendererNoneItem: NSMenuItem!
    @IBOutlet weak var program: NSMenuItem!
    @IBOutlet weak var programMenu: NSMenu!
    @IBOutlet weak var titleMenuItem: NSMenuItem!
    @IBOutlet weak var titleMenu: NSMenu!
    @IBOutlet weak var chapter: NSMenuItem!
    @IBOutlet weak var chapterMenu: NSMenu!

    @IBOutlet weak var audioMenu: NSMenu!
    @IBOutlet weak var vol_up: NSMenuItem!
    @IBOutlet weak var vol_down: NSMenuItem!
    @IBOutlet weak var mute: NSMenuItem!
    @IBOutlet weak var audiotrack: NSMenuItem!
    @IBOutlet weak var audiotrackMenu: NSMenu!
    @IBOutlet weak var channels: NSMenuItem!
    @IBOutlet weak var channelsMenu: NSMenu!
    @IBOutlet weak var audioDevice: NSMenuItem!
    @IBOutlet weak var audioDeviceMenu: NSMenu!
    @IBOutlet weak var visual: NSMenuItem!
    @IBOutlet weak var visualMenu: NSMenu!

    @IBOutlet weak var videoMenu: NSMenu!
    @IBOutlet weak var half_window: NSMenuItem!
    @IBOutlet weak var normal_window: NSMenuItem!
    @IBOutlet weak var double_window: NSMenuItem!
    @IBOutlet weak var fittoscreen: NSMenuItem!
    @IBOutlet weak var fullscreenItem: NSMenuItem!
    @IBOutlet weak var floatontop: NSMenuItem!
    @IBOutlet weak var snapshot: NSMenuItem!
    @IBOutlet weak var videotrack: NSMenuItem!
    @IBOutlet weak var videotrackMenu: NSMenu!
    @IBOutlet weak var screen: NSMenuItem!
    @IBOutlet weak var screenMenu: NSMenu!
    @IBOutlet weak var aspect_ratio: NSMenuItem!
    @IBOutlet weak var aspect_ratioMenu: NSMenu!
    @IBOutlet weak var crop: NSMenuItem!
    @IBOutlet weak var cropMenu: NSMenu!
    @IBOutlet weak var deinterlace: NSMenuItem!
    @IBOutlet weak var deinterlaceMenu: NSMenu!
    @IBOutlet weak var deinterlace_mode: NSMenuItem!
    @IBOutlet weak var deinterlace_modeMenu: NSMenu!
    @IBOutlet weak var postprocessing: NSMenuItem!
    @IBOutlet weak var postprocessingMenu: NSMenu!

    @IBOutlet weak var subtitlesMenu: NSMenu!
    @IBOutlet weak var subtitle_track: NSMenuItem!
    @IBOutlet weak var subtitle_tracksMenu: NSMenu!
    @IBOutlet weak var openSubtitleFile: NSMenuItem!
    @IBOutlet weak var subtitle_sizeMenu: NSMenu!
    @IBOutlet weak var subtitle_size: NSMenuItem!
    @IBOutlet weak var subtitle_textcolorMenu: NSMenu!
    @IBOutlet weak var subtitle_textcolor: NSMenuItem!
    @IBOutlet weak var subtitle_bgcolorMenu: NSMenu!
    @IBOutlet weak var subtitle_bgcolor: NSMenuItem!
    @IBOutlet weak var subtitle_bgopacity: NSMenuItem!
    @IBOutlet weak var subtitle_bgopacity_view: NSView!
    @IBOutlet weak var subtitle_bgopacityLabel: NSTextField!
    @IBOutlet weak var subtitle_bgopacityLabel_gray: NSTextField!
    @IBOutlet weak var subtitle_bgopacity_sld: NSSlider!
    @IBOutlet weak var subtitle_outlinethicknessMenu: NSMenu!
    @IBOutlet weak var subtitle_outlinethickness: NSMenuItem!
    @IBOutlet weak var teletext: NSMenuItem!
    @IBOutlet weak var teletext_transparent: NSMenuItem!
    @IBOutlet weak var teletext_index: NSMenuItem!
    @IBOutlet weak var teletext_red: NSMenuItem!
    @IBOutlet weak var teletext_green: NSMenuItem!
    @IBOutlet weak var teletext_yellow: NSMenuItem!
    @IBOutlet weak var teletext_blue: NSMenuItem!

    @IBOutlet weak var windowMenu: NSMenu!
    @IBOutlet weak var minimize: NSMenuItem!
    @IBOutlet weak var zoom_window: NSMenuItem!
    @IBOutlet weak var player: NSMenuItem!
    @IBOutlet weak var controller: NSMenuItem!
    @IBOutlet weak var audioeffects: NSMenuItem!
    @IBOutlet weak var videoeffects: NSMenuItem!
    @IBOutlet weak var bookmarks: NSMenuItem!
    @IBOutlet weak var playlist: NSMenuItem!
    @IBOutlet weak var info: NSMenuItem!
    @IBOutlet weak var errorsAndWarnings: NSMenuItem!
    @IBOutlet weak var messages: NSMenuItem!
    @IBOutlet weak var bring_atf: NSMenuItem!

    @IBOutlet weak var helpMenu: NSMenu!
    @IBOutlet weak var help: NSMenuItem!
    @IBOutlet weak var documentation: NSMenuItem!
    @IBOutlet weak var license: NSMenuItem!
    @IBOutlet weak var website: NSMenuItem!
    @IBOutlet weak var donation: NSMenuItem!
    @IBOutlet weak var forum: NSMenuItem!

    /* dock menu */
    @IBOutlet weak var dockMenuplay: NSMenuItem!
    @IBOutlet weak var dockMenustop: NSMenuItem!
    @IBOutlet weak var dockMenunext: NSMenuItem!
    @IBOutlet weak var dockMenuprevious: NSMenuItem!
    @IBOutlet weak var dockMenumute: NSMenuItem!

    /* vout menu */
    @IBOutlet weak var voutMenu: NSMenu!
    @IBOutlet weak var voutMenuplay: NSMenuItem!
    @IBOutlet weak var voutMenustop: NSMenuItem!
    @IBOutlet weak var voutMenuprev: NSMenuItem!
    @IBOutlet weak var voutMenunext: NSMenuItem!
    @IBOutlet weak var voutMenuvolup: NSMenuItem!
    @IBOutlet weak var voutMenuvoldown: NSMenuItem!
    @IBOutlet weak var voutMenumute: NSMenuItem!
    @IBOutlet weak var voutMenufullscreen: NSMenuItem!
    @IBOutlet weak var voutMenusnapshot: NSMenuItem!
    //    @IBOutlet weak var let playlistSaveAccessoryView: NSView
    //    @IBOutlet weak var let playlistSaveAccessoryPopup: NSPopUpButton
    //    @IBOutlet weak var let playlistSaveAccessoryText: NSTextField

    //    let _aboutWindowController: VLCAboutWindowController
//    var aboutWindowController: Any?
    //    VLCHelpWindowController  *_helpWindowController
//    var helpWindowController: Any?
    //    let _addonsController: VLCAddonsWindowController
//    var addonsController: Any?
    var rendererMenuController: VLCRendererMenuController!
    //    let _cancelRendererDiscoveryTimer: NSTimer
    //    let _playlistTableColumnsContextMenu: NSMenu
    //    __strong let _timeSelectionPanel: VLCTimeSelectionPanelController

    deinit {
//        msg_Dbg(getIntf(), "Deinitializing main menu")
        NotificationCenter.default.removeObserver(self)

        releaseRepresentedObjects(NSApp.mainMenu!)
    }

    override func awakeFromNib() {
        // TODO
//            self.timeSelectionPanel = VLCTimeSelectionPanelController.alloc.init

        /* check whether the user runs OSX with a RTL language */
        let languages = NSLocale.preferredLanguages
        let preferredLanguage: String = languages.first!

        if NSLocale.characterDirection(forLanguage: preferredLanguage) == .rightToLeft {
//            msg_Dbg(getIntf(), "adapting interface since '%s' is a RTL language", preferredLanguage.UTF8String)
            rateTextField.alignment = .left
        }

        setRateControlsEnabled(false)

        /* Get ExtensionsManager */
        let p_intf: UnsafeMutablePointer<intf_thread_t> = getIntf()!

        initStrings()

        setupMenuItem(self.quit, withConfigKey: "key-quit")

        setupMenuItem(self.stop, withConfigKey: "key-stop")

        setupMenuItem(self.previous, withConfigKey: "key-prev")

        setupMenuItem(self.next, withConfigKey: "key-next")

        setupMenuItem(self.fwd, withConfigKey: "key-jump+short")

        setupMenuItem(self.bwd, withConfigKey: "key-jump-short")

        setupMenuItem(self.vol_up, withConfigKey: "key-vol-up")

        setupMenuItem(self.vol_down, withConfigKey: "key-vol-down")

        setupMenuItem(self.mute, withConfigKey: "key-vol-mute")

        setupMenuItem(self.fullscreenItem, withConfigKey: "key-toggle-fullscreen")

        setupMenuItem(self.snapshot, withConfigKey: "key-snapshot")

        setupMenuItem(self.random, withConfigKey: "key-random")

        setupMenuItem(self.half_window, withConfigKey: "key-zoom-half")

        setupMenuItem(self.normal_window, withConfigKey: "key-zoom-original")

        setupMenuItem(self.double_window, withConfigKey: "key-zoom-double")

        setSubmenusEnabled(false)

        /* configure playback / controls menu */
        self.controlsMenu.delegate = self
        self.rendererNoneItem.state = NSControl.StateValue.on
        self.rendererMenuController = VLCRendererMenuController()
        self.rendererMenuController.rendererNoneItem = self.rendererNoneItem
        self.rendererMenuController.rendererMenu = self.rendererMenu

        NotificationCenter.default.addObserver(self, selector: #selector(refreshVoutDeviceMenu(notification:)), name: NSApplication.didChangeScreenParametersNotification, object: nil)

        setupVarMenuItem(self.add_intf,
                         target: p_intf.as_vlc_object_pointer(),
                         the_var: "intf-add",
                         selector: #selector(toggleVar(_:)))

        /* setup extensions menu */
        /* Let the ExtensionsManager itself build the menu */
        let extMgr: VLCExtensionsManager = VLCMain.instance.extensionsManager
        extMgr.buildMenu(self.extensionsMenu!)
        self.extensions.isEnabled = self.extensionsMenu!.numberOfItems > 0

        // FIXME: Implement preference for autoloading extensions on mac
//        if (!extMgr.isLoaded && !extMgr.cannotLoad)
//        extMgr.loadExtensions

        /* setup post-proc menu */
        if self.postprocessingMenu.numberOfItems > 0 {
            self.postprocessingMenu.removeAllItems()
        }

        var mitem: NSMenuItem!
        self.postprocessingMenu.autoenablesItems = true
        self.postprocessingMenu.addItem(withTitle: "Disable", action:#selector(togglePostProcessing(_:)), keyEquivalent: "")
        mitem = self.postprocessingMenu.item(at: 0)
        mitem.tag = -1
        mitem.isEnabled = true
        mitem.target = self
        for x in 1..<7 {
            self.postprocessingMenu.addItem(withTitle: "Level \(x)",
                                            action: #selector(togglePostProcessing(_:)),
                                            keyEquivalent: "")
            mitem = self.postprocessingMenu.item(at: x)
            mitem.isEnabled = true
            mitem.tag = x
            mitem.target = self
        }
        let psz_config: UnsafeMutablePointer<Int8>! = config_GetPsz("video-filter")
        if psz_config != nil {
            if strstr(psz_config, "postproc") == nil {
                self.postprocessingMenu.item(at: 0)?.state = .on
            } else {
                self.postprocessingMenu.item(withTag: Int(config_GetInt("postproc-q")))?.state = .on
            }
            free(psz_config)
        } else {
            self.postprocessingMenu.item(at: 0)?.state = .on
        }
        self.postprocessing.isEnabled = false

        self.refreshAudioDeviceList()

        /* setup subtitles menu */
        // Persist those variables on the playlist
        let p_playlist: UnsafeMutablePointer<playlist_t> = pl_Get(getIntf())
        var_Create(p_playlist.as_vlc_object_pointer(), "freetype-color", VLC_VAR_INTEGER | VLC_VAR_DOINHERIT)
        var_Create(p_playlist.as_vlc_object_pointer(), "freetype-background-opacity", VLC_VAR_INTEGER | VLC_VAR_DOINHERIT)
        var_Create(p_playlist.as_vlc_object_pointer(), "freetype-background-color", VLC_VAR_INTEGER | VLC_VAR_DOINHERIT)
        var_Create(p_playlist.as_vlc_object_pointer(), "freetype-outline-thickness", VLC_VAR_INTEGER | VLC_VAR_DOINHERIT)

        setupMenu(self.subtitle_textcolorMenu, withIntList: "freetype-color", andSelector: #selector(switchSubtitleOption(_:)))
//        self.subtitle_bgopacity_sld.intValue = config_GetInt("freetype-background-opacity")
        setupMenu(self.subtitle_bgcolorMenu, withIntList: "freetype-background-color", andSelector: #selector(switchSubtitleOption(_:)))
        setupMenu(self.subtitle_outlinethicknessMenu, withIntList: "freetype-outline-thickness", andSelector: #selector(switchSubtitleOption(_:)))

        /* Build size menu based on different scale factors */
        let scaleValues: [(name: String, scaleValue: Int)] = [
            ("Smaller", 50),
            ("Small", 75),
            ("Normal", 100),
            ("Large", 125),
            ("Larger", 150)]

        for i in 0..<scaleValues.count {
            let menuItem: NSMenuItem = self.subtitle_sizeMenu.addItem(withTitle: scaleValues[i].name, action: #selector(switchSubtitleSize(_:)), keyEquivalent: "")
            menuItem.tag = scaleValues[i].scaleValue
            menuItem.target = self
        }
    }

// MARK: - Initialization

    private func setupMenuItem(_ menuItem: NSMenuItem, withConfigKey configKey: String) {
        var keyString: String!
        var key: UnsafeMutablePointer<Int8>!

        key = config_GetPsz(configKey)
        keyString = String(cString: key)
        menuItem.keyEquivalent = VLCStringUtility.VLCKeyToString(keyString)
        menuItem.keyEquivalentModifierMask = VLCStringUtility.VLCModifiersToCocoa(keyString)
        free(key)
    }

    private func setupMenu(_ menu: NSMenu, withIntList psz_name: String, andSelector selector: Selector) {

        menu.removeAllItems()

        let p_item: UnsafeMutablePointer<module_config_t> = config_FindConfig(psz_name)
//        if p_item == nil {
//            msg_Err(getIntf(), "couldn't create menu int list for item '%s' as it does not exist", psz_name)
//            return
//        }

        for i in 0..<p_item.pointee.list_count {
            var mi: NSMenuItem!

            if p_item.pointee.list_text != nil {
                mi = NSMenuItem(title: String(cString: p_item.pointee.list_text[Int(i)]!), action: nil, keyEquivalent: "")
            } else if p_item.pointee.list.i[Int(i)] != 0 {
                mi = NSMenuItem(title: "\(p_item.pointee.list.i[Int(i)])", action: nil, keyEquivalent: "")
            } else {
//                msg_Err(getIntf(), "item %d of pref %s failed to be created", i, psz_name)
                continue
            }

            mi.target = self
            mi.action = selector
            mi.tag = Int(p_item.pointee.list.i[Int(i)])
            mi.representedObject = psz_name
            menu.addItem(mi)
            if p_item.pointee.value.i == p_item.pointee.list.i[Int(i)] {
                mi.state = .on
            }
        }
    }

    private func initStrings() {
        /* main menu */
        self.about.title = "About VLC media player..."
//        self.prefs.title = "Preferences..."
        self.extensions.title = "Extensions"
        self.extensionsMenu.title = "Extensions"
        self.addonManager.title = "Addons Manager"
        self.add_intf.title = "Add Interface"
        self.add_intfMenu.title = "Add Interface"
        self.services.title = "Services"
        self.hide.title = "Hide VLC"
        self.hide_others.title = "Hide Others"
        self.show_all.title = "Show All"
        self.quit.title = "Quit VLC"

        self.fileMenu.title = "1:File"
        self.open_generic.title = "Advanced Open File..."
        self.open_file.title = "Open File..."
        self.open_disc.title = "Open Disc..."
        self.open_net.title = "Open Network..."
        self.open_capture.title = "Open Capture Device..."
        self.open_recent.title = "Open Recent"
        self.close_window.title = "Close Window"
        self.convertandsave.title = "Convert / Stream..."
        self.save_playlist.title = "Save Playlist..."
        self.revealInFinder.title = "Reveal in Finder"

        self.editMenu.title = "Edit"
        self.cutItem.title = "Cut"
        self.mcopyItem.title = "Copy"
        self.pasteItem.title = "Paste"
        self.clearItem.title = "Delete"
        self.select_all.title = "Select All"
        self.findItem.title = "Find"

        self.viewMenu.title = "View"
        self.toggleJumpButtons.title = "Show Previous & Next Buttons"
        self.toggleJumpButtons.state = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-show-playback-buttons") ? .on : .off
        self.togglePlaymodeButtons.title = "Show Shuffle & Repeat Buttons"
        self.togglePlaymodeButtons.state = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-show-playmode-buttons") ? .on : .off
        self.toggleEffectsButton.title = "Show Audio Effects Button"
        self.toggleEffectsButton.state = var_InheritBool(getIntf()?.as_vlc_object_pointer(), "macosx-show-effects-button") ? .on : .off
        self.toggleSidebar.title = "Show Sidebar"
        self.playlistTableColumns.title = "Playlist Table Columns"

        self.controlsMenu.title = "Playback"
        self.play.title = "Play"
        self.stop.title = "Stop"
        self.record.title = "Record"
        self.rate_view.autoresizingMask = .width
        self.rate.view = self.rate_view
        self.rateLabel.stringValue = "Playback Speed"
        self.rate_slowerLabel.stringValue = "Slower"
        self.rate_normalLabel.stringValue = "Normal"
        self.rate_fasterLabel.stringValue = "Faster"
        self.trackSynchronization.title = "Track Synchronization"
        self.previous.title = "Previous"
        self.next.title = "Next"
        self.random.title = "Random"
//        self.repeat.title = "Repeat One"
        self.loop.title = "Repeat All"
        self.AtoBloop.title = "A→B Loop"
        self.quitAfterPB.title = "Quit after Playback"
        self.fwd.title = "Step Forward"
        self.bwd.title = "Step Backward"
        self.jumpToTime.title = "Jump to Time"
        self.rendererMenuItem.title = "Renderer"
        self.rendererNoneItem.title = "No renderer"
        self.program.title = "Program"
        self.programMenu.title = "Program"
        self.titleMenuItem.title = "Title"
        self.titleMenu.title = "Title"
        self.chapter.title = "Chapter"
        self.chapterMenu.title = "Chapter"

        self.audioMenu.title = "Audio"
        self.vol_up.title = "Increase Volume"
        self.vol_down.title = "Decrease Volume"
        self.mute.title = "Mute"
        self.audiotrack.title = "Audio Track"
        self.audiotrackMenu.title = "Audio Track"
        self.channels.title = "Stereo audio mode"
        self.channelsMenu.title = "Stereo audio mode"
        self.audioDevice.title = "Audio Device"
        self.audioDeviceMenu.title = "Audio Device"
        self.visual.title = "Visualizations"
        self.visualMenu.title = "Visualizations"

        self.videoMenu.title = "Video"
        self.half_window.title = "Half Size"
        self.normal_window.title = "Normal Size"
        self.double_window.title = "Double Size"
        self.fittoscreen.title = "Fit to Screen"
        self.fullscreenItem.title = "Fullscreen"
        self.floatontop.title = "Float on Top"
        self.snapshot.title = "Snapshot"
        self.videotrack.title = "Video Track"
        self.videotrackMenu.title = "Video Track"
        self.aspect_ratio.title = "Aspect ratio"
        self.aspect_ratioMenu.title = "Aspect ratio"
        self.crop.title = "Crop"
        self.cropMenu.title = "Crop"
        self.screen.title = "Fullscreen Video Device"
        self.screenMenu.title = "Fullscreen Video Device"
        self.deinterlace.title = "Deinterlace"
        self.deinterlaceMenu.title = "Deinterlace"
        self.deinterlace_mode.title = "Deinterlace mode"
        self.deinterlace_modeMenu.title = "Deinterlace mode"
        self.postprocessing.title = "Post processing"
        self.postprocessingMenu.title = "Post processing"

        self.subtitlesMenu.title = "Subtitles"
        self.openSubtitleFile.title = "Add Subtitle File..."
        self.subtitle_track.title = "Subtitles Track"
        self.subtitle_tracksMenu.title = "Subtitles Track"
        self.subtitle_size.title = "Text Size"
        self.subtitle_textcolor.title = "Text Color"
        self.subtitle_outlinethickness.title = "Outline Thickness"

        // Autoresizing with constraints does not work on 10.7,
        // translate autoresizing mask to constriaints for now
        self.subtitle_bgopacity_view.autoresizingMask = .width
        self.subtitle_bgopacity.view = self.subtitle_bgopacity_view
        self.subtitle_bgopacityLabel.stringValue = "Background Opacity"
        self.subtitle_bgopacityLabel_gray.stringValue = "Background Opacity"
        self.subtitle_bgcolor.title = "Background Color"
        self.teletext.title = "Teletext"
        self.teletext_transparent.title = "Transparent"
        self.teletext_index.title = "Index"
        self.teletext_red.title = "Red"
        self.teletext_green.title = "Green"
        self.teletext_yellow.title = "Yellow"
        self.teletext_blue.title = "Blue"

        self.windowMenu.title = "Window"
        self.minimize.title = "Minimize"
        self.zoom_window.title = "Zoom"
        self.player.title = "Player..."
        self.controller.title = "Main Window..."
        self.audioeffects.title = "Audio Effects..."
        self.videoeffects.title = "Video Effects..."
        self.bookmarks.title = "Bookmarks..."
        self.playlist.title = "Playlist..."
        self.info.title = "Media Information..."
        self.messages.title = "Messages..."
        self.errorsAndWarnings.title = "Errors and Warnings..."

        self.bring_atf.title = "Bring All to Front"

        self.helpMenu.title = "Help"
        self.help.title = "VLC media player Help..."
        self.license.title = "License"
        self.documentation.title = "Online Documentation..."
        self.website.title = "VideoLAN Website..."
        self.donation.title = "Make a donation..."
        self.forum.title = "Online Forum..."

        /* dock menu */
        self.dockMenuplay.title = "Play"
        self.dockMenustop.title = "Stop"
        self.dockMenunext.title = "Next"
        self.dockMenuprevious.title = "Previous"
        self.dockMenumute.title = "Mute"

        /* vout menu */
        self.voutMenuplay.title = "Play"
        self.voutMenustop.title = "Stop"
        self.voutMenuprev.title = "Previous"
        self.voutMenunext.title = "Next"
        self.voutMenuvolup.title = "Volume Up"
        self.voutMenuvoldown.title = "Volume Down"
        self.voutMenumute.title = "Mute"
        self.voutMenufullscreen.title = "Fullscreen"
        self.voutMenusnapshot.title = "Snapshot"
    }

// MARK: - Termination

    private func releaseRepresentedObjects(_ the_menu: NSMenu) {
        for one_item in the_menu.items {
            if let submenu = one_item.submenu {
                releaseRepresentedObjects(submenu)
            }
            one_item.representedObject = nil
        }
    }

// MARK: - Interface update

    func setupMenus() {

        let p_playlist: UnsafeMutablePointer<playlist_t> = pl_Get(getIntf())
        let p_input: UnsafeMutablePointer<input_thread_t>! = playlist_CurrentInput(p_playlist)

        if p_input != nil {
            setupVarMenuItem(self.program, target: p_input.as_vlc_object_pointer(), the_var: "program", selector: #selector(toggleVar(_:)))

            setupVarMenuItem(self.titleMenuItem, target: p_input.as_vlc_object_pointer(), the_var: "title", selector: #selector(toggleVar(_:)))

            setupVarMenuItem(self.chapter, target: p_input.as_vlc_object_pointer(), the_var: "chapter", selector: #selector(toggleVar(_:)))

            setupVarMenuItem(self.audiotrack, target: p_input.as_vlc_object_pointer(), the_var: "audio-es", selector: #selector(toggleVar(_:)))

            setupVarMenuItem(self.videotrack, target: p_input.as_vlc_object_pointer(), the_var: "video-es", selector: #selector(toggleVar(_:)))

            setupVarMenuItem(self.subtitle_track, target: p_input.as_vlc_object_pointer(), the_var: "spu-es", selector: #selector(toggleVar(_:)))

            let p_aout: UnsafeMutablePointer<audio_output_t>! = playlist_GetAout(p_playlist)

            if p_aout != nil {
                setupVarMenuItem(self.channels, target: p_aout.as_vlc_object_pointer(), the_var: "stereo-mode", selector: #selector(toggleVar(_:)))

                setupVarMenuItem(self.visual, target: p_aout.as_vlc_object_pointer(), the_var: "visual", selector: #selector(toggleVar(_:)))

                vlc_object_release(p_aout.as_vlc_object_pointer())
            }

            let p_vout: UnsafeMutablePointer<vout_thread_t>! = getVoutForActiveWindow()

            if p_vout != nil {
                setupVarMenuItem(self.aspect_ratio, target: p_vout.as_vlc_object_pointer(), the_var: "aspect-ratio", selector: #selector(toggleVar(_:)))

                setupVarMenuItem(self.crop, target:  p_vout.as_vlc_object_pointer(), the_var: "crop", selector: #selector(toggleVar(_:)))

                setupVarMenuItem(self.deinterlace, target: p_vout.as_vlc_object_pointer(), the_var: "deinterlace", selector: #selector(toggleVar(_:)))

                setupVarMenuItem(self.deinterlace_mode, target: p_vout.as_vlc_object_pointer(), the_var: "deinterlace-mode", selector: #selector(toggleVar(_:)))

                vlc_object_release(p_vout.as_vlc_object_pointer())

                refreshVoutDeviceMenu(notification: nil)
            }

            self.postprocessing.isEnabled = true
            vlc_object_release(p_input.as_vlc_object_pointer())
        } else {
            self.postprocessing.isEnabled = false
        }
    }

    @objc private func refreshVoutDeviceMenu(notification: Notification?) {
        let submenu: NSMenu = self.screenMenu
        if submenu.numberOfItems > 0 {
            submenu.removeAllItems()
        }

        let screens: [NSScreen] = NSScreen.screens
        self.screen.isEnabled = true

        submenu.addItem(withTitle: "Default", action: #selector(toggleFullscreenDevice(_:)), keyEquivalent: "")
        var mitem: NSMenuItem! = submenu.item(at: 0)!
        mitem.tag = 0
        mitem.isEnabled = true
        mitem.target = self

        for i in 0..<screens.count {
            let s_rect: NSRect = screens[i].frame
            submenu.addItem(withTitle: "Screen \(i+1) (\(s_rect.size.width)x\(s_rect.size.height))",
                            action: #selector(toggleFullscreenDevice(_:)),
                            keyEquivalent: "")

            mitem = submenu.item(at: i+1)!
            mitem.tag = screens[i].displayID
            mitem.isEnabled = true
            mitem.target = self
        }

        let obj = getIntf()!.as_vlc_object_pointer()
        let name = "macosx-vdev".withCString() { cString in return UnsafePointer<Int8>(cString) }
        submenu.item(withTag: Int(var_InheritInteger(obj, name)))?.state = .on
    }

    func setSubmenusEnabled(_ enabled: Bool) {

        self.program.isEnabled = enabled
        self.titleMenuItem.isEnabled = enabled
        self.chapter.isEnabled = enabled
        self.audiotrack.isEnabled = enabled
        self.visual.isEnabled = enabled
        self.videotrack.isEnabled = enabled
        self.subtitle_track.isEnabled = enabled
        self.channels.isEnabled = enabled
        self.deinterlace.isEnabled = enabled
        self.deinterlace_mode.isEnabled = enabled
        self.screen.isEnabled = enabled
        self.aspect_ratio.isEnabled = enabled
        self.crop.isEnabled = enabled
    }

    private func setSubtitleMenuEnabled(_ enabled: Bool) {

        self.openSubtitleFile.isEnabled = enabled
        if enabled {
            self.subtitle_bgopacityLabel_gray.isHidden = true
            self.subtitle_bgopacityLabel.isHidden = false
        } else {
            self.subtitle_bgopacityLabel_gray.isHidden = false
            self.subtitle_bgopacityLabel.isHidden = true
        }
        self.subtitle_bgopacity_sld.isEnabled = enabled
        self.teletext.isEnabled = enabled
    }

    func setRateControlsEnabled(_ b_enabled: Bool) {

        let playbackRate = Int32(VLCCoreInteraction.instance.playbackRate)
        self.rate_sld.isEnabled = b_enabled
        self.rate_sld.intValue = playbackRate
        let speed =  pow(Double(playbackRate) / 17, 2)
        self.rateTextField.stringValue = String(format: "%.2fx", speed)

        let color: NSColor = b_enabled ? NSColor.controlTextColor : NSColor.disabledControlTextColor

        self.rateLabel.textColor = color
        self.rate_slowerLabel.textColor = color
        self.rate_normalLabel.textColor = color
        self.rate_fasterLabel.textColor = color
        self.rateTextField.textColor = color

        setSubtitleMenuEnabled(b_enabled)
    }

// MARK: - View

    @IBAction func toggleEffectsButton(_ sender: Any) {
//        BOOL b_value = !var_InheritBool(getIntf(), "macosx-show-effects-button")
//        config_PutInt("macosx-show-effects-button", b_value)
//        (VLCMainWindowControlsBar.*)VLCMain.instance.mainWindow.controlsBar toggleEffectsButton
//        self.toggleEffectsButton.state = b_value
    }

    @IBAction func toggleJumpButtons(_ sender: Any) {
//        BOOL b_value = !var_InheritBool(getIntf(), "macosx-show-playback-buttons")
//        config_PutInt("macosx-show-playback-buttons", b_value)
//
//        (VLCMainWindowControlsBar.*)VLCMain.instance.mainWindow.controlsBar toggleJumpButtons
//        [VLCMain.instance.voutController updateWindowsUsingBlock:^(let window: VLCVideoWindowCommon) {
//        window.controlsBar.toggleForwardBackwardMode: b_value
//        })
//
//        self.toggleJumpButtons.state = b_value
    }

    @IBAction func togglePlaymodeButtons(_ sender: Any) {
//        BOOL b_value = !var_InheritBool(getIntf(), "macosx-show-playmode-buttons")
//        config_PutInt("macosx-show-playmode-buttons", b_value)
//        (VLCMainWindowControlsBar.*)VLCMain.instance.mainWindow.controlsBar togglePlaymodeButtons
//        self.togglePlaymodeButtons.state = b_value
    }

    @IBAction func toggleSidebar(_ sender: Any) {
//        VLCMain.instance.mainWindow.toggleLeftSubSplitView
    }

    private func updateSidebarMenuItem(show: Bool) {
//        self.toggleSidebar.state =show
    }

// MARK: - Playback

    @IBAction func play(_ sender: Any) {
        VLCCoreInteraction.instance.playOrPause()
    }

    @IBAction func stop(_ sender: Any) {
//        VLCCoreInteraction.instance.stop
    }

    @IBAction func prev(_ sender: Any) {
//        VLCCoreInteraction.instance.previous
    }

    @IBAction func next(_ sender: Any) {
//        VLCCoreInteraction.instance.next
    }

    @IBAction func random(_ sender: Any) {
//        VLCCoreInteraction.instance.shuffle
    }

    @IBAction func repeatPlay(_ sender: Any) {
//        vlc_value_t val
//        let p_intf: intf_thread_t = getIntf()
//        let p_playlist: playlist_t = pl_Get(p_intf)
//
//        var_Get(p_playlist, "repeat", &val)
//        if (! val.b_bool)
//        VLCCoreInteraction.instance.repeatOne
//        else
//        VLCCoreInteraction.instance.repeatOff
    }

    @IBAction func loopPlayList(_ sender: Any) {
//        vlc_value_t val
//        let p_intf: intf_thread_t = getIntf()
//        let p_playlist: playlist_t = pl_Get(p_intf)
//
//        var_Get(p_playlist, "loop", &val)
//        if (! val.b_bool)
//        VLCCoreInteraction.instance.repeatAll
//        else
//        VLCCoreInteraction.instance.repeatOff
    }

    @IBAction func forward(_ sender: Any) {
//        VLCCoreInteraction.instance.forward
    }

    @IBAction func backward(_ sender: Any) {
//        VLCCoreInteraction.instance.backward
    }

    @IBAction func volumeUp(_ sender: Any) {
//        VLCCoreInteraction.instance.volumeUp
    }

    @IBAction func volumeDown(_ sender: Any) {
//        VLCCoreInteraction.instance.volumeDown
    }

    @IBAction func mute(_ sender: Any) {
//        VLCCoreInteraction.instance.toggleMute
    }

    private func lockVideosAspectRatio(_ sender: Any) {
//        VLCCoreInteraction.instance.setAspectRatioIsLocked: !sender.state
//        sender.state = VLCCoreInteraction.instance.aspectRatioIsLocked
    }

    @IBAction func quitAfterPlayback(_ sender: Any) {
//        let p_playlist: playlist_t = pl_Get(getIntf())
//        bool b_value = !var_CreateGetBool(p_playlist, "play-and-exit")
//        var_SetBool(p_playlist, "play-and-exit", b_value)
//        config_PutInt("play-and-exit", b_value)
    }

    @IBAction func toggleRecord(_ sender: Any) {
//        VLCCoreInteraction.instance.toggleRecord
    }

    func updateRecordState(_ b_value: Bool) {
//        self.record.state =b_value
    }

    @IBAction func setPlaybackRate(_ sender: Any) {
//        VLCCoreInteraction.instance.setPlaybackRate: self.rate_sld.intValue
//        int i = VLCCoreInteraction.instance.playbackRate
//        double speed =  pow(2, (double)i / 17)
//        self.rateTextField.stringValue = NSString.stringWithFormat:@"%.2fx", speed
    }

    public func updatePlaybackRate() {
//        int i = VLCCoreInteraction.instance.playbackRate
//        double speed =  pow(2, (double)i / 17)
//        self.rateTextField.stringValue = NSString.stringWithFormat:@"%.2fx", speed
//        self.rate_sld.intValue = i
    }

    @IBAction func toggleAtoBloop(_ sender: Any) {
//        VLCCoreInteraction.instance.setAtoB
    }

    @IBAction func goToSpecificTime(_ sender: Any) {
//        let p_input: input_thread_t = pl_CurrentInput(getIntf())
//        if (p_input) {
        /* we can obviously only do that if an input is available */
//        int64self.t length = var_GetInteger(p_input, "length")
//        self.timeSelectionPanel.setMaxValue:(length / CLOCK_FREQ)
//        int64self.t pos = var_GetInteger(p_input, "time")
//        self.timeSelectionPanel.setJumpTimeValue: (pos / CLOCK_FREQ)
//        [self.timeSelectionPanel runModalForWindow:NSApp.mainWindow
//        completionHandler:^(NSInteger returnCode, int64self.t returnTime) {
//
//        if (returnCode != NSModalResponseOK)
//        return
//
//        let p_input: input_thread_t = pl_CurrentInput(getIntf())
//        if (p_input) {
//        input_Control(p_input, INPUT_SET_TIME, (int64self.t)(returnTime *1000000))
//        vlc_object_release(p_input)
//        }
//        })
//
//        vlc_object_release(p_input)
//        }
    }

    @IBAction func selectRenderer(_ sender: Any) {
//        self.rendererMenuController.selectRenderer:sender
    }

// MARK: - audio menu

    private func refreshAudioDeviceList() {
//        char **ids, **names
//        char *currentDevice
//
//        self.audioDeviceMenu.removeAllItems
//
//        let p_aout: audio_output_t = getAout()
//        if (!p_aout)
//        return
//
//        int n = aout_DevicesList(p_aout, &ids, &names)
//        if (n == -1) {
//        vlc_object_release(p_aout)
//        return
//        }
//
//        currentDevice = aout_DeviceGet(p_aout)
//        let _tmp: NSMenuItem
//
//        for (NSUInteger x = 0; x < n; x++) {
//        self.tmp = [self.audioDeviceMenu addItemWithTitle:toNSStr(names[x]) action: #selector(toggleAudioDevice:) keyEquivalent:@"")
//        self.tmp.target =self
//        [self.tmp setTag:[[NSString stringWithFormat:@"%s", ids[x]] intValue])
//        }
//        vlc_object_release(p_aout)
//
//        self.audioDeviceMenu.item(withTag:.NSString.stringWithFormat:@"%s",.currentDevice intValue state =NSOnState
//
//        free(currentDevice)
//
//        for (NSUInteger x = 0; x < n; x++) {
//        free(ids[x])
//        free(names[x])
//        }
//        free(ids)
//        free(names)
//
//        self.audioDeviceMenu.setAutoenablesItems:true
//        self.audioDevice.isEnabled = true
    }

    private func toggleAudioDevice(_ sender: Any) {
//        let p_aout: audio_output_t = getAout()
//        if (!p_aout)
//        return
//
//        int returnValue = 0
//
//        if (sender.tag > 0)
//        returnValue = aout_DeviceSet(p_aout, NSString.stringWithFormat:@"%li",.sender.tag UTF8String)
//        else
//        returnValue = aout_DeviceSet(p_aout, nil
//
//        if (returnValue != 0)
//        msg_Warn(getIntf(), "failed to set audio device %li", sender.tag)
//
//        vlc_object_release(p_aout)
//        self.refreshAudioDeviceList)
    }

// MARK: - video menu

    @IBAction func toggleFullscreen(_ sender: Any) {
//        VLCCoreInteraction.instance.toggleFullscreen
    }

    @IBAction func resizeVideoWindow(_ sender: Any) {
//        let p_input: input_thread_t = pl_CurrentInput(getIntf())
//        if (p_input) {
//        let p_vout: vout_thread_t = getVoutForActiveWindow()
//        if (p_vout) {
//        if (sender == self.half_window)
//        var_SetFloat(p_vout, "zoom", 0.5)
//        else if (sender == self.normal_window)
//        var_SetFloat(p_vout, "zoom", 1.0)
//        else if (sender == self.double_window)
//        var_SetFloat(p_vout, "zoom", 2.0)
//        else
//        {
//        NSApp.keyWindow.performZoom:sender
//        }
//        vlc_object_release(p_vout)
//        }
//        vlc_object_release(p_input)
//        }
    }

    @IBAction func floatOnTop(_ sender: Any) {
//        let p_input: input_thread_t = pl_CurrentInput(getIntf())
//        if (p_input) {
//        let p_vout: vout_thread_t = getVoutForActiveWindow()
//        if (p_vout) {
//        BOOL b_fs = var_ToggleBool(p_vout, "video-on-top")
//        var_SetBool(pl_Get(getIntf()), "video-on-top", b_fs)
//
//        vlc_object_release(p_vout)
//        }
//        vlc_object_release(p_input)
//        }
    }

    @IBAction func createVideoSnapshot(_ sender: Any) {
//        let p_input: input_thread_t = pl_CurrentInput(getIntf())
//        if (p_input) {
//        let p_vout: vout_thread_t = getVoutForActiveWindow()
//        if (p_vout) {
//        var_TriggerCallback(p_vout, "video-snapshot")
//        vlc_object_release(p_vout)
//        }
//        vlc_object_release(p_input)
//        }
    }

    private func disablePostProcessing() {
//        VLCCoreInteraction.instance.setVideoFilter:"postproc" on:false
    }

    private func enablePostProcessing() {
//        VLCCoreInteraction.instance.setVideoFilter:"postproc" on:true
    }

    @objc private func togglePostProcessing(_ sender: Any) {
//        char *psz_name = "postproc"
//        NSInteger count = self.postprocessingMenu.numberOfItems
//        for (NSUInteger x = 0; x < count; x++)
//        self.postprocessingMenu.item(at:.x state =NSOffState
//
//        if (sender.tag == -1) {
//        self.self.disablePostProcessing)
//        sender.state =NSOnState
//        } else {
//        self.self.enablePostProcessing)
//        sender.state =NSOnState
//
//        VLCCoreInteraction.instance.setVideoFilterProperty:"postproc-q" forFilter:"postproc" withValue:(vlc_value_t){ .i_int = sender.tag }
//        }
    }

    @objc private func toggleFullscreenDevice(_ sender: Any) {
//        config_PutInt("macosx-vdev", sender.tag)
//        self.refreshVoutDeviceMenu: nil)
    }

// MARK: - Subtitles Menu

    @IBAction func addSubtitleFile(_ sender: Any) {
//        NSInteger i_returnValue = 0
//        let p_input: input_thread_t = pl_CurrentInput(getIntf())
//        if (!p_input)
//        return
//
//        let p_item: input_item_t = input_GetItem(p_input)
//        if (!p_item) {
//        vlc_object_release(p_input)
//        return
//        }
//
//        char *path = input_item_GetURI(p_item)
//
//        if (!path)
//        path = strdup("")
//
//        let openPanel: NSOpenPanel = NSOpenPanel.openPanel
//        openPanel.setCanChooseFiles = true
//        openPanel.setCanChooseDirectories = false
//        openPanel.setAllowsMultipleSelection = true
//
//        openPanel.setAllowedFileTypes: NSArray.arrayWithObjects:@"cdg",@"idx",@"srt",@"sub",@"utf",@"ass",@"ssa",@"aqt",@"jss",@"psb",@"rt",@"smi",@"txt",@"smil",@"stl",@"usf",@"dks",@"pjs",@"mpl2",@"mks",@"vtt",@"ttml",@"dfxp",nil
//
//        let url: NSURL = NSURL.URLWithString:toNSStr(path).stringByExpandingTildeInPath
//        url = url.URLByDeletingLastPathComponent
//        openPanel.setDirectoryURL: url
//        free(path)
//        vlc_object_release(p_input)
//
//        i_returnValue = openPanel.runModal
//
//        if (i_returnValue == NSModalResponseOK)
//        VLCCoreInteraction.instance.addSubtitlesToCurrentInput:openPanel.URLs
    }

    @objc private func switchSubtitleSize(_ sender: Any) {
//        int intValue = sender.tag
//        var_SetInteger(pl_Get(getIntf()), "sub-text-scale", intValue)
    }


    @objc private func switchSubtitleOption(_ sender: Any) {
//        int intValue = sender.tag
//        let representedObject: NSString = sender.representedObject
//
//        var_SetInteger(pl_Get(getIntf()), representedObject.UTF8String, intValue)
//
//        let menu: NSMenu = sender.menu
//        NSUInteger count = (NSUInteger) menu.numberOfItems
//        for (NSUInteger x = 0; x < count; x++)
//        menu.item(at:.x state =NSOffState
//        menu.item(withTag:.intValue state =NSOnState
    }

    @IBAction func switchSubtitleBackgroundOpacity(_ sender: Any) {
//        var_SetInteger(pl_Get(getIntf()), "freetype-background-opacity", sender.intValue)
    }

    @IBAction func telxTransparent(_ sender: Any) {
//        let p_vbi: vlc_object_t
//        p_vbi = (vlc_object_t *) vlc_object_find_name(pl_Get(getIntf()), "zvbi")
//        if (p_vbi) {
//        var_SetBool(p_vbi, "vbi-opaque", sender.state)
//        sender.state = !sender.state
//        vlc_object_release(p_vbi)
//        }
    }

    @IBAction func telxNavLink(_ sender: Any) {
//        let p_vbi: vlc_object_t
//        int i_page = 0
//
//        if (sender.title.isEqualToString: "Index")
//        i_page = 'i' << 16
//        else if (sender.title.isEqualToString: "Red")
//        i_page = 'r' << 16
//        else if (sender.title.isEqualToString: "Green")
//        i_page = 'g' << 16
//        else if (sender.title.isEqualToString: "Yellow")
//        i_page = 'y' << 16
//        else if (sender.title.isEqualToString: "Blue")
//        i_page = 'b' << 16
//        if (i_page == 0) return
//
//        p_vbi = (vlc_object_t *) vlc_object_find_name(pl_Get(getIntf()), "zvbi")
//        if (p_vbi) {
//        var_SetInteger(p_vbi, "vbi-page", i_page)
//        vlc_object_release(p_vbi)
//        }
    }

// MARK: - Panels

    @IBAction func intfOpenFile(_ sender: Any) {
//        VLCMain.instance.open openFileWithAction:^(let files: NSArray) {
//        VLCMain.instance.playlist.addPlaylistItems:files
//        })
    }

    @IBAction func intfOpenFileGeneric(_ sender: Any) {
//        VLCMain.instance.open.openFileGeneric
    }

    @IBAction func intfOpenDisc(_ sender: Any) {
//        VLCMain.instance.open.openDisc
    }

    @IBAction func intfOpenNet(_ sender: Any) {
//        VLCMain.instance.open.openNet
    }

    @IBAction func intfOpenCapture(_ sender: Any) {
//        VLCMain.instance.open.openCapture
    }

    @IBAction func savePlaylist(_ sender: Any) {
//        let p_playlist: playlist_t = pl_Get(getIntf())
//
//        let savePanel: NSSavePanel = NSSavePanel.savePanel
//        NSString * name = NSString.stringWithFormat: @"%@", "Untitled"
//
//        NSBundle.loadNibNamed:@"PlaylistAccessoryView" owner:self
//
//        self.playlistSaveAccessoryText.stringValue = "File Format:"
//        self.playlistSaveAccessoryPopup.item(at:.0 title = "Extended M3U"
//        self.playlistSaveAccessoryPopup.item(at:.1 title = "XML Shareable Playlist Format (XSPF)"
//        self.playlistSaveAccessoryPopup.item(at:.2 title = "HTML playlist"
//
//        savePanel.title = "Save Playlist"
//        savePanel.setPrompt: "Save"
//        savePanel.setAccessoryView: self.playlistSaveAccessoryView
//        savePanel.setNameFieldStringValue: name
//
//        if (savePanel.runModal == NSFileHandlingPanelOKButton) {
//        let filename: NSString = savePanel.URL.path
//
//        if (self.playlistSaveAccessoryPopup.indexOfSelectedItem == 0) {
//        let actualFilename: NSString
//        NSRange range
//        range.location = filename.length - @".m3u".length
//        range.length = @".m3u".length
//
//        if (filename.compare:@".m3u" options: NSCaseInsensitiveSearch range: range != NSOrderedSame)
//        actualFilename = NSString.stringWithFormat: @"%@.m3u", filename
//        else
//        actualFilename = filename
//
//        playlist_Export(p_playlist,
//        actualFilename.fileSystemRepresentation,
//        true, "export-m3u")
//        } else if (self.playlistSaveAccessoryPopup.indexOfSelectedItem == 1) {
//        let actualFilename: NSString
//        NSRange range
//        range.location = filename.length - @".xspf".length
//        range.length = @".xspf".length
//
//        if (filename.compare:@".xspf" options: NSCaseInsensitiveSearch range: range != NSOrderedSame)
//        actualFilename = NSString.stringWithFormat: @"%@.xspf", filename
//        else
//        actualFilename = filename
//
//        playlist_Export(p_playlist,
//        actualFilename.fileSystemRepresentation,
//        true, "export-xspf")
//        } else {
//        let actualFilename: NSString
//        NSRange range
//        range.location = filename.length - @".html".length
//        range.length = @".html".length
//
//        if (filename.compare:@".html" options: NSCaseInsensitiveSearch range: range != NSOrderedSame)
//        actualFilename = NSString.stringWithFormat: @"%@.html", filename
//        else
//        actualFilename = filename
//
//        playlist_Export(p_playlist,
//        actualFilename.fileSystemRepresentation,
//        true, "export-html")
//        }
//        }
    }

    @IBAction func showConvertAndSave(_ sender: Any) {
//        VLCMain.instance.convertAndSaveWindow.showWindow:self
    }

    @IBAction func showVideoEffects(_ sender: Any) {
//        VLCMain.instance.videoEffectsPanel.toggleWindow:sender
    }

    @IBAction func showTrackSynchronization(_ sender: Any) {
//        VLCMain.instance.trackSyncPanel.toggleWindow:sender
    }

    @IBAction func showAudioEffects(_ sender: Any) {
//        VLCMain.instance.audioEffectsPanel.toggleWindow:sender
    }

    @IBAction func showBookmarks(_ sender: Any) {
//        VLCMain.instance.bookmarks.toggleWindow:sender
    }

    @IBAction func showPreferences(_ sender: Any) {
//        NSInteger i_level = VLCMain.instance.voutController.currentStatusWindowLevel
//        VLCMain.instance.simplePreferences.showSimplePrefsWithLevel:i_level
    }

    @IBAction func openAddonManager(_ sender: Any) {
//        if (!self.addonsController)
//        self.addonsController = VLCAddonsWindowController.alloc.init
//
//        self.addonsController.showWindow:self
    }

    @IBAction func showErrorsAndWarnings(_ sender: Any) {
//        VLCMain.instance.coreDialogProvider.errorPanel.showWindow:self
    }

    @IBAction func showMessagesPanel(showMessagesPanel: Any) {
//        VLCMain.instance.debugMsgPanel.showWindow:self
    }

    @IBAction public func showMainWindow(_ sender: Any) {
//        VLCMain.instance.mainWindow.makeKeyAndOrderFront:sender
    }

    @IBAction func showPlaylist(_ sender: Any) {
//    VLCMain.instance.mainWindow.changePlaylistState: psUserMenuEvent
    }

// MARK: - Help and Docs

    @IBAction func showAbout(_ sender: Any) {
//        if (!self.aboutWindowController)
//        self.aboutWindowController = VLCAboutWindowController.alloc.init
//
//        self.aboutWindowController.showAbout
    }

    @IBAction func showLicense(_ sender: Any) {
//        if (!self.aboutWindowController)
//        self.aboutWindowController = VLCAboutWindowController.alloc.init
//
//        self.aboutWindowController.showGPL
    }

    @IBAction func showHelp(_ sender: Any) {
//        if (!self.helpWindowController)
//        self.helpWindowController = VLCHelpWindowController.alloc.init
//
//        self.helpWindowController.showHelp
    }

    @IBAction func openDocumentation(_ sender: Any) {
//        let url: NSURL = NSURL.URLWithString: @"http://www.videolan.org/doc/"
//
//        NSWorkspace.sharedWorkspace.openURL: url
    }

    @IBAction func openWebsite(_ sender: Any) {
//        let url: NSURL = NSURL.URLWithString: @"http://www.videolan.org/"
//
//        NSWorkspace.sharedWorkspace.openURL: url
    }

    @IBAction func openForum(_ sender: Any) {
//        let url: NSURL = NSURL.URLWithString: @"http://forum.videolan.org/"
//
//        NSWorkspace.sharedWorkspace.openURL: url
    }

    @IBAction func openDonate(_ sender: Any) {
//        let url: NSURL = NSURL.URLWithString: @"http://www.videolan.org/contribute.html#paypal"
//
//        NSWorkspace.sharedWorkspace.openURL: url
    }

    @IBAction func showInformationPanel(_ sender: Any) {
//        VLCMain.instance.currentMediaInfoPanel.toggleWindow:sender
    }

// MARK: - convinience stuff for other objects

    func setPlay() {
//        self.play.title = "Play"
//        self.dockMenuplay.title = "Play"
//        self.voutMenuplay.title = "Play"
    }

    func setPause() {
//        self.play.title = "Pause"
//        self.dockMenuplay.title = "Pause"
//        self.voutMenuplay.title = "Pause"
    }

    private func setRepeatOne() {
//    self.repeat.state = NSOnState
//    self.loop.state = NSOffState
    }

    private func setRepeatAll() {
//        self.repeat.state = NSOffState
//        self.loop.state = NSOnState
    }

    private func setRepeatOff() {
//        self.repeat.state = NSOffState
//        self.loop.state = NSOffState
    }

    private func setShuffle() {
//        bool b_value
//        let p_playlist: playlist_t = pl_Get(getIntf())
//        b_value = var_GetBool(p_playlist, "random")
//
//        self.random.state = b_value
    }

// MARK: - Dynamic menu creation and validation

    func setupVarMenuItem(_ mi: NSMenuItem, target p_object: UnsafeMutablePointer<vlc_object_t>, the_var psz_variable: String, selector pf_callback: Selector) {

        //        vlc_value_t val, text
//        int i_type = var_Type(p_object, psz_variable)

//        switch(i_type & VLC_VAR_TYPE) {
//            case VLC_VAR_VOID:
//            case VLC_VAR_BOOL:
//            case VLC_VAR_STRING:
//            case VLC_VAR_INTEGER:
//            break
//            default:
            /* Variable doesn't exist or isn't handled */
//            msg_Warn(p_object, "variable %s doesn't exist or isn't handled", psz_variable)
//            return
//        }

        /* Get the descriptive name of the variable */
//        var_Change(p_object, psz_variable, VLC_VAR_GETTEXT, &text, nil
//        mi.title = _NS(text.psz_string ? text.psz_string : psz_variable)
//
//        if (i_type & VLC_VAR_HASCHOICE) {
//        let menu: NSMenu = mi.submenu
//
//        self.setupVarMenu:menu forMenuItem:mi, target:p_object
//        the_var: psz_variable selector:pf_callback)
//
//        free(text.psz_string)
//        return
//        }
//
//        if (var_Get(p_object, psz_variable, &val) < 0)
//        return
//
//        let data: VLCAutoGeneratedMenuContent
//        switch(i_type & VLC_VAR_TYPE) {
//        case VLC_VAR_VOID:
//        data = [VLCAutoGeneratedMenuContent.alloc initWithVariableName: psz_variable ofObject: p_object
//        andValue: val ofType: i_type)
//        mi.setRepresentedObject:data
//        break
//
//        case VLC_VAR_BOOL:
//        data = [VLCAutoGeneratedMenuContent.alloc initWithVariableName: psz_variable ofObject: p_object
//        andValue: val ofType: i_type)
//        mi.setRepresentedObject:data
//        if (!(i_type & VLC_VAR_ISCOMMAND))
//        mi.state = val.b_bool ? TRUE : FALSE
//        break
//
//        default:
//        break
//        }
//
//        if ((i_type & VLC_VAR_TYPE) == VLC_VAR_STRING) free(val.psz_string)
//        free(text.psz_string)
    }


    private func setupVarMenu(menu: NSMenu) {
//        forMenuItem: (NSMenuItem *)parent
//       , target:(vlc_object_t *)p_object
//        the_var: (const char *)psz_variable
//        selector:(SEL)pf_callback
//        {
//        vlc_value_t val, val_list, text_list
//        int i_type, i

        /* remove previous items */
//        menu.removeAllItems

        /* we disable everything here, and enable it again when needed, below */
//        parent.isEnabled = false

        /* Aspect Ratio */
//        if (parent.title.isEqualToString: "Aspect ratio" == true) {
//        let lmi_tmp2: NSMenuItem
//        lmi_tmp2 = menu.addItem(withTitle: "Lock Aspect Ratio" action: #selector(lockVideosAspectRatio:) keyEquivalent: @""
//        lmi_tmp2.target = self
//        lmi_tmp2.isEnabled = true
//        lmi_tmp2.state = VLCCoreInteraction.instance.aspectRatioIsLocked
//        parent.isEnabled = true
//        menu.addItem: NSMenuItem.separatorItem
//        }

        /* Check the type of the object variable */
//        i_type = var_Type(p_object, psz_variable)

        /* Make sure we want to display the variable */
//        if (i_type & VLC_VAR_HASCHOICE) {
//        var_Change(p_object, psz_variable, VLC_VAR_CHOICESCOUNT, &val, nil
//        if (val.i_int == 0 || val.i_int == 1)
//        return
//        }
//        else
//        return

//        switch(i_type & VLC_VAR_TYPE) {
//        case VLC_VAR_VOID:
//        case VLC_VAR_BOOL:
//        case VLC_VAR_STRING:
//        case VLC_VAR_INTEGER:
//        break
//        default:
        /* Variable doesn't exist or isn't handled */
//        return
//        }

//        if (var_Get(p_object, psz_variable, &val) < 0) {
//        return
//        }

//        if (var_Change(p_object, psz_variable, VLC_VAR_GETCHOICES,
//        &val_list, &text_list) < 0) {
//        if ((i_type & VLC_VAR_TYPE) == VLC_VAR_STRING) free(val.psz_string)
//        return
//        }

        /* make (un)sensitive */
//        parent.isEnabled = (val_list.p_list->i_count > 1)

//        for (i = 0; i < val_list.p_list->i_count; i++) {
//        let lmi: NSMenuItem
//        let title: NSString = @""
//        let data: VLCAutoGeneratedMenuContent

//        switch(i_type & VLC_VAR_TYPE) {
//        case VLC_VAR_STRING:

//        title = _NS(text_list.p_list->p_values[i].psz_string ? text_list.p_list->p_values[i].psz_string : val_list.p_list->p_values[i].psz_string)
//
//        lmi = menu.addItem(withTitle: title action: pf_callback keyEquivalent: @""
//        data = [VLCAutoGeneratedMenuContent.alloc initWithVariableName: psz_variable ofObject: p_object
//        andValue: val_list.p_list->p_values[i] ofType: i_type)
//        lmi.setRepresentedObject:data
//        lmi.target = self
//
//        if (!strcmp(val.psz_string, val_list.p_list->p_values[i].psz_string) && !(i_type & VLC_VAR_ISCOMMAND))
//        lmi.state = TRUE
//
//        break
//
//        case VLC_VAR_INTEGER:
//
//        title = text_list.p_list->p_values[i].psz_string ?
//        _NS(text_list.p_list->p_values[i].psz_string) : [NSString stringWithFormat: @"%"PRId64, val_list.p_list->p_values[i].i_int)
//
//        lmi = menu.addItem(withTitle: title action: pf_callback keyEquivalent: @""
//        data = [VLCAutoGeneratedMenuContent.alloc initWithVariableName: psz_variable ofObject: p_object
//        andValue: val_list.p_list->p_values[i] ofType: i_type)
//        lmi.setRepresentedObject:data
//        lmi.target = self
//
//        if (val_list.p_list->p_values[i].i_int == val.i_int && !(i_type & VLC_VAR_ISCOMMAND))
//        lmi.state = TRUE
//        break
//
//        default:
//        break
//        }
//        }

        /* clean up everything */
//        if ((i_type & VLC_VAR_TYPE) == VLC_VAR_STRING) free(val.psz_string)
//        var_FreeList(&val_list, &text_list)
    }

    @objc private func toggleVar(_ sender: Any) {
//        let mi: NSMenuItem = (NSMenuItem *)sender
//        let data: VLCAutoGeneratedMenuContent = mi.representedObject
//        [NSThread detachNewThreadSelector: #selector(toggleVarThread:)
//        toTarget: self withObject: data)
//
//        return
    }

    private func toggleVarThread(data: Any) -> Int {
//        @autoreleasepool {
//        let p_object: vlc_object_t
//
//        assert(data.isKindOfClass:VLCAutoGeneratedMenuContent.class)
//        let menuContent: VLCAutoGeneratedMenuContent = (VLCAutoGeneratedMenuContent *)data
//
//        p_object = menuContent.vlcObject
//
//        if (p_object != nil {
//        var_Set(p_object, menuContent.name, menuContent.value)
//        vlc_object_release(p_object)
//        return true
//        }
//        return VLC_EGENERIC
//        }
        return 0
    }

// MARK: - menu delegation

    private func menuWillOpen(menu: NSMenu) {
//        self.cancelRendererDiscoveryTimer.invalidate
//        self.rendererMenuController.startRendererDiscoveries
    }

    private func menuDidClose(menu: NSMenu) {
//        self.cancelRendererDiscoveryTimer = [NSTimer scheduledTimerWithTimeInterval:20.
//       , target:self
//        selector: #selector(cancelRendererDiscovery)
//        userInfo:nil
//        repeats:false)
    }

    private func cancelRendererDiscovery() {
//        self.rendererMenuController.stopRendererDiscoveries
    }

//    @implementation VLCMainMenu (NSMenuValidation)

    private func validateMenuItem(mi: NSMenuItem) -> Bool {
//        let title: NSString = mi.title
        var enabled = true
//        vlc_value_t val
//        let p_playlist: playlist_t = pl_Get(getIntf())
//        let p_input: input_thread_t = playlist_CurrentInput(p_playlist)
//
//        if (mi == self.stop || mi == self.voutMenustop || mi == self.dockMenustop) {
//        if (!p_input)
//        enabled = false
//        self.setupMenus]; /* Make sure input menu is up to date */
//        } else if (mi == self.previous          ||
//        mi == self.voutMenuprev      ||
//        mi == self.dockMenuprevious  ||
//        mi == self.next              ||
//        mi == self.voutMenunext      ||
//        mi == self.dockMenunext
//        ) {
//        PL_LOCK
//        enabled = playlist_CurrentSize(p_playlist) > 1
//        PL_UNLOCK
//        } else if (mi == self.record) {
//        enabled = false
//        if (p_input)
//        enabled = var_GetBool(p_input, "can-record")
//        } else if (mi == self.random) {
//        int i_state
//        var_Get(p_playlist, "random", &val)
//        i_state = val.b_bool ? NSOnState : NSOffState
//        mi.state = i_state
//        } else if (mi == self.repeat) {
//        int i_state
//        var_Get(p_playlist, "repeat", &val)
//        i_state = val.b_bool ? NSOnState : NSOffState
//        mi.state = i_state
//        } else if (mi == self.loop) {
//        int i_state
//        var_Get(p_playlist, "loop", &val)
//        i_state = val.b_bool ? NSOnState : NSOffState
//        mi.state = i_state
//        } else if (mi == self.quitAfterPB) {
//        int i_state
//        bool b_value = var_InheritBool(p_playlist, "play-and-exit")
//        i_state = b_value ? NSOnState : NSOffState
//        mi.state = i_state
//        } else if (mi == self.fwd || mi == self.bwd || mi == self.jumpToTime) {
//        if (p_input != nil {
//        var_Get(p_input, "can-seek", &val)
//        enabled = val.b_bool
//        } else {
//        enabled = false
//        }
//        } else if (mi == self.mute || mi == self.dockMenumute || mi == self.voutMenumute) {
//        mi.state = VLCCoreInteraction.instance.mute ? NSOnState : NSOffState
//        self.setupMenus]; /* Make sure audio menu is up to date */
//        self.refreshAudioDeviceList)
//        } else if (mi == self.half_window           ||
//        mi == self.normal_window         ||
//        mi == self.double_window         ||
//        mi == self.fittoscreen           ||
//        mi == self.snapshot              ||
//        mi == self.voutMenusnapshot      ||
//        mi == self.fullscreenItem        ||
//        mi == self.voutMenufullscreen    ||
//        mi == self.floatontop
//        ) {
//        enabled = false
//
//        if (p_input != nil {
//        let p_vout: vout_thread_t = getVoutForActiveWindow()
//        if (p_vout != nil {
//        if (mi == self.floatontop)
//        mi.state = var_GetBool(p_vout, "video-on-top")
//
//        if (mi == self.fullscreenItem || mi == self.voutMenufullscreen)
//        mi.state = var_GetBool(p_vout, "fullscreen")
//
//        enabled = true
//        vlc_object_release(p_vout)
//        }
//        }
//
//        self.setupMenus]; /* Make sure video menu is up to date */
//
//        } else if (mi == self.openSubtitleFile) {
//        enabled = mi.isEnabled
//        self.setupMenus]; /* Make sure subtitles menu is up to date */
//        } else {
//        let _parent: NSMenuItem = mi.parentItem
//        if (self.parent == self.subtitle_size || mi == self.subtitle_size           ||
//        self.parent == self.subtitle_textcolor || mi == self.subtitle_textcolor ||
//        self.parent == self.subtitle_bgcolor || mi == self.subtitle_bgcolor     ||
//        self.parent == self.subtitle_bgopacity || mi == self.subtitle_bgopacity ||
//        self.parent == self.subtitle_outlinethickness || mi == self.subtitle_outlinethickness ||
//        self.parent == self.teletext || mi == self.teletext
//        ) {
//        enabled = self.openSubtitleFile.isEnabled
//        }
//        }
//
//        if (p_input)
//        vlc_object_release(p_input)

        return enabled
    }
}



/*****************************************************************************
 *VLCAutoGeneratedMenuContent implementation
 *****************************************************************************
 *Object connected to a playlistitem which remembers the data belonging to
 *the variable of the autogenerated menu
 *****************************************************************************/

//@interface VLCAutoGeneratedMenuContent ()
//{
//    char *psz_name
//    let vlc_object: vlc_object_t
//    vlc_value_t value
//    int i_type
//}
//@end
//@implementation VLCAutoGeneratedMenuContent
//
//-(id) initWithVariableName:(const char *)name ofObject:(vlc_object_t *)object
//andValue:(vlc_value_t)val ofType:(int)type
//{
//    self = super.init
//
//    if (self != nil) {
//        vlc_object = vlc_object_hold(object)
//        psz_name = strdup(name)
//        i_type = type
//        value = val
//        if ((i_type & VLC_VAR_TYPE) == VLC_VAR_STRING)
//        value.psz_string = strdup(val.psz_string)
//    }
//
//    return(self)
//    }
//
//    - (void)dealloc
//        {
//            if (vlc_object)
//            vlc_object_release(vlc_object)
//            if ((i_type & VLC_VAR_TYPE) == VLC_VAR_STRING)
//            free(value.psz_string)
//            free(psz_name)
//        }
//
//        - (const char *)name
//            {
//                return psz_name
//            }
//
//            - (vlc_value_t)value
//                {
//                    return value
//                }
//
//                - (vlc_object_t *)vlcObject
//                    {
//                        return vlc_object_hold(vlc_object)
//                    }
//
//                    - (int)type
//                        {
//                            return i_type
//}
//
//@end

