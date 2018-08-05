//
//  VLCCoreInteraction.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 19/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation


private func bossCallback(_ p_this: UnsafeMutablePointer<vlc_object_t>?,
                          _ psz_var: UnsafePointer<Int8>?,
                          _ oldval: vlc_value_t,
                          _ new_val: vlc_value_t,
                          _ param: UnsafeMutableRawPointer?) -> Int32 {
return autoreleasepool { () -> Int32 in
        DispatchQueue.main.async {
            VLCCoreInteraction.instance.pause()
            NSApplication.shared.hide(nil)
        }
        return VLC_SUCCESS
    }
}

typealias CBossCallback = @convention(c) (UnsafeMutablePointer<vlc_object_t>?, UnsafePointer<Int8>?, vlc_value_t, vlc_value_t, UnsafeMutableRawPointer?) -> Int32

let cBossCallback: CBossCallback! = bossCallback

class VLCCoreInteraction {
    private var _currentPlaybackRate: Int = 0
    private var timeA: mtime_t = 0
    private var timeB: mtime_t = 0
    private var _maxVolume: Float = 0.0
    private var _usedHotkeys = [String]()

    /* media key support */
//    private var b_mediaKeySupport: Bool = false
//    private var b_mediakeyJustJumped: Bool = false
//    private var SPMediaKeyTap *_mediaKeyController
//    private var b_mediaKeyTrapEnabled: Bool = false

//    private var AppleRemote *_remote
//    private var b_remote_button_hold: Bool = false /* true as long as the user holds the left,right,plus or minus on the remote control */
    static let instance = VLCCoreInteraction()

// MARK: - Initialization

    init() {
        let p_intf = getIntf()!

        /* init media key support */
//        self.b_mediaKeySupport = var_InheritBool(p_intf.as_vlc_object_pointer(), "macosx-mediakeys")
//        if self.b_mediaKeySupport {
//            _mediaKeyController = [[SPMediaKeyTap alloc] initWithDelegate:self]
//            [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
//                [SPMediaKeyTap defaultMediaKeyUserBundleIdentifiers], kMediaKeyUsingBundleIdentifiersDefaultsKey,
//                nil]]
//        }
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: #selector(coreChangedMediaKeySupportSetting:) name:VLCMediaKeySupportSettingChangedNotification object: nil]

        /* init Apple Remote support */
//        _remote = [[AppleRemote alloc] init]
//        [_remote setClickCountEnabledButtons: kRemoteButtonPlay]
//        [_remote setDelegate: self]

        var_AddCallback(p_intf.pointee.obj.libvlc.as_vlc_object_pointer(), "intf-boss", cBossCallback, bridge(obj: self))
    }

    deinit {
        let p_intf = getIntf()!
        var_DelCallback(p_intf.pointee.obj.libvlc.as_vlc_object_pointer(), "intf-boss", cBossCallback, bridge(obj: self))
//        NotificationCenter.default.removeObserver(self)
    }

// MARK: - Playback Controls

    func playOrPause() {
        let p_playlist = pl_Get(getIntf())

        if let p_input = playlist_CurrentInput(p_playlist) {
            vplaylist_Control(p_playlist, Int32(PLAYLIST_TOGGLE_PAUSE), Int32(pl_Unlocked.rawValue))
            vlc_object_release(p_input.as_vlc_object_pointer())

        } else {
//            PLRootType root = VLCMain.instance.playlist.model.currentRootType.
//            if (VLCMain.instance.playlist.isSelectionEmpty. && (root == ROOT_TYPE_PLAYLIST || root == ROOT_TYPE_MEDIALIBRARY))
//            VLCMain.instance.open.openFileGeneric()
//            else
//            VLCMain.instance.playlist.playItem:nil.
        }
    }

    func pause() {
        vplaylist_Control(pl_Get(getIntf()), Int32(PLAYLIST_PAUSE), Int32(pl_Unlocked.rawValue))
    }

    func stop() {
        vplaylist_Control(pl_Get(getIntf()), Int32(PLAYLIST_STOP), Int32(pl_Unlocked.rawValue))
    }

    func faster() {
        var_TriggerCallback(pl_Get(getIntf()).as_vlc_object_pointer(), "rate-faster")
    }

    func slower() {
        var_TriggerCallback(pl_Get(getIntf()).as_vlc_object_pointer(), "rate-slower")
    }

    func normalSpeed() {
        var_SetFloat(pl_Get(getIntf()).as_vlc_object_pointer(), "rate", 1.0)
    }

//                        func toggleRecord
//                            {
//                                let p_intf = getIntf()
//                                if (!p_intf)
//                                return
//
//                                input_thread_t * p_input
//                                p_input = playlist_CurrentInput(pl_Get(p_intf))
//                                if (p_input) {
//                                    var_ToggleBool(p_input, "record")
//                                    vlc_object_release(p_input)
//                                }
//                            }

    var playbackRate: Int {
        set {
            let p_playlist = pl_Get(getIntf())!
            let speed = pow(2, Double(newValue) / 17)
            let rate: Int = Int(Double(INPUT_RATE_DEFAULT) / speed)
            if _currentPlaybackRate != rate {
                var_SetFloat(p_playlist.as_vlc_object_pointer(), "rate", Float(INPUT_RATE_DEFAULT) / Float(rate))
            }
            _currentPlaybackRate = rate
        }
        get {
            let p_intf = getIntf()

            var rate: Float
            if let p_input = playlist_CurrentInput(pl_Get(p_intf))?.as_vlc_object_pointer() {
                rate = var_GetFloat(p_input, "rate")
                vlc_object_release(p_input)
            } else {
                let p_playlist = pl_Get(p_intf)!.as_vlc_object_pointer()
                rate = var_GetFloat(p_playlist, "rate")
            }

            let value = 17 * log(rate) / log(2)
            var returnValue = Int((value > 0) ? value + 0.5 : value - 0.5)
            if returnValue < -34 {
                returnValue = -34
            } else if returnValue > 34 {
                returnValue = 34
            }

            _currentPlaybackRate = returnValue
            return returnValue
        }
    }

//        func previous
//            {
//                playlist_Prev(pl_Get(getIntf()))
//            }
//
//            func next
//                {
//                    playlist_Next(pl_Get(getIntf()))
//                }

    var durationOfCurrentPlaylistItem: Int64 {
        var duration: Int64 = -1
        let p_input = playlist_CurrentInput(pl_Get(getIntf()))
        if p_input == nil {
            return duration
        }
        getInputControl(p_input!, Int32(INPUT_GET_LENGTH.rawValue), duration)
        vlc_object_release(p_input!.as_vlc_object_pointer())
        return (duration / 1_000_000)
        return 0
    }

    var urlOfCurrentPlaylistItem: NSURL? {
        guard let p_input = playlist_CurrentInput(pl_Get(getIntf())) else {
            return nil
        }

        let p_item = input_GetItem(p_input)
        if p_item == nil {
             vlc_object_release(p_input)
             return nil
        }
        let psz_uri = input_item_GetURI(p_item)
        if psz_uri == nil {
             vlc_object_release(p_input)
             return nil
        }
        let o_url = NSURL(withString: psz_uri)
        free(psz_uri)
        vlc_object_release(p_input)
        return o_url
    }

    var nameOfCurrentPlaylistItem: String? {
        guard let p_input = playlist_CurrentInput(pl_Get(getIntf())) else {
            return nil
        }

        let p_item = input_GetItem(p_input)
        if p_item == nil {
            vlc_object_release(p_input)
            return nil
        }
        let psz_uri = String.fromCString(input_item_GetURI(p_item))
        if psz_uri == nil {
            vlc_object_release(p_input)
            return nil
        }

        var name = ""
        let format = var_InheritString(getIntf(), "input-title-format")
        if format != nil {
            let formated = vlc_strfinput(p_input, format)
            free(format)
            name = String.fromCString(formated)
        }
        let url = NSURL(withString:psz_uri)
        if name == "" {
            if url.isFileURL {
                name = NSFileManager.default.displayName(atPath: url.path)
            } else {
                name = url.absoluteString
            }
        }
        vlc_object_release(p_input)
        return name
    }

//                            func forward
//                                {
//                                    //LEGACY SUPPORT
//                                    [self forwardShort]
//                                }
//
//                                func backward
//                                    {
//                                        //LEGACY SUPPORT
//                                        [self backwardShort]
//                                    }

    private func jumpWithValue(_ p_value: String, forward b_value: Bool) {
        guard let p_input = playlist_CurrentInput(pl_Get(getIntf())) else {
            return
        }

        let i_interval: Int64 = var_InheritInteger(p_input!.as_vlc_object_pointer(), p_value)
        if i_interval > 0 {
            var val: mtime_t = CLOCK_FREQ * i_interval
            if b_value == false {
                val *= -1
            }
            var_SetInteger(p_input!.as_vlc_object_pointer(), "time-offset", val)
        }
        vlc_object_release(p_input!.as_vlc_object_pointer())
    }

    func forwardExtraShort() {
        jumpWithValue("extrashort-jump-size", forward: true)
    }

    func backwardExtraShort() {
        jumpWithValue("extrashort-jump-size", forward: false)
    }

    func forwardShort() {
        jumpWithValue("short-jump-size", forward: true)
    }

    func backwardShort() {
        jumpWithValue("short-jump-size", forward: false)
    }

    func forwardMedium() {
        jumpWithValue("medium-jump-size", forward: true)
    }

    func backwardMedium() {
        jumpWithValue("medium-jump-size", forward: false)
    }

    func forwardLong() {
        jumpWithValue("long-jump-size", forward: true)
    }

    func backwardLong() {
        jumpWithValue("long-jump-size", forward: false)
    }

//                                    func shuffle
//                                        {
//                                            let p_intf = getIntf()
//                                            if (!p_intf)
//                                            return
//
//                                            vlc_value_t val
//                                            playlist_t * p_playlist = pl_Get(p_intf)
//                                            vout_thread_t *p_vout = getVout()
//
//                                            var_Get(p_playlist, "random", &val)
//                                            val.b_bool = !val.b_bool
//                                            var_Set(p_playlist, "random", val)
//                                            if (val.b_bool) {
//                                                if (p_vout) {
//                                                    vout_OSDMessage(p_vout, VOUT_SPU_CHANNEL_OSD, "%s", _("Random On"))
//                                                    vlc_object_release(p_vout)
//                                                }
//                                                config_PutInt("random", 1)
//                                            }
//                                            else
//                                            {
//                                                if (p_vout) {
//                                                    vout_OSDMessage(p_vout, VOUT_SPU_CHANNEL_OSD, "%s", _("Random Off"))
//                                                    vlc_object_release(p_vout)
//                                                }
//                                                config_PutInt("random", 0)
//                                            }
//                                        }
//
//                                        func repeatAll
//                                            {
//                                                let p_intf = getIntf()
//                                                if (!p_intf)
//                                                return
//
//                                                playlist_t * p_playlist = pl_Get(p_intf)
//
//                                                var_SetBool(p_playlist, "repeat", false)
//                                                var_SetBool(p_playlist, "loop", true)
//                                                config_PutInt("repeat", false)
//                                                config_PutInt("loop", true)
//
//                                                vout_thread_t *p_vout = getVout()
//                                                if (p_vout) {
//                                                    vout_OSDMessage(p_vout, VOUT_SPU_CHANNEL_OSD, "%s", _("Repeat All"))
//                                                    vlc_object_release(p_vout)
//                                                }
//                                            }
//
//                                            func repeatOne
//                                                {
//                                                    let p_intf = getIntf()
//                                                    if (!p_intf)
//                                                    return
//
//                                                    playlist_t * p_playlist = pl_Get(p_intf)
//
//                                                    var_SetBool(p_playlist, "repeat", true)
//                                                    var_SetBool(p_playlist, "loop", false)
//                                                    config_PutInt("repeat", true)
//                                                    config_PutInt("loop", false)
//
//                                                    vout_thread_t *p_vout = getVout()
//                                                    if (p_vout) {
//                                                        vout_OSDMessage(p_vout, VOUT_SPU_CHANNEL_OSD, "%s", _("Repeat One"))
//                                                        vlc_object_release(p_vout)
//                                                    }
//                                                }
//
//                                                func repeatOff
//                                                    {
//                                                        let p_intf = getIntf()
//                                                        if (!p_intf)
//                                                        return
//
//                                                        playlist_t * p_playlist = pl_Get(p_intf)
//
//                                                        var_SetBool(p_playlist, "repeat", false)
//                                                        var_SetBool(p_playlist, "loop", false)
//                                                        config_PutInt("repeat", false)
//                                                        config_PutInt("loop", false)
//
//                                                        vout_thread_t *p_vout = getVout()
//                                                        if (p_vout) {
//                                                            vout_OSDMessage(p_vout, VOUT_SPU_CHANNEL_OSD, "%s", _("Repeat Off"))
//                                                            vlc_object_release(p_vout)
//                                                        }
//                                                    }
//
//                                                    func setAtoB
//                                                        {
//                                                            if (!timeA) {
//                                                                input_thread_t * p_input = playlist_CurrentInput(pl_Get(getIntf()))
//                                                                if (p_input) {
//                                                                    timeA = var_GetInteger(p_input, "time")
//                                                                    vlc_object_release(p_input)
//                                                                }
//                                                            } else if (!timeB) {
//                                                                input_thread_t * p_input = playlist_CurrentInput(pl_Get(getIntf()))
//                                                                if (p_input) {
//                                                                    timeB = var_GetInteger(p_input, "time")
//                                                                    vlc_object_release(p_input)
//                                                                }
//                                                            } else
//                                                            [self resetAtoB]
//                                                        }
//
//                                                        func resetAtoB
//                                                            {
//                                                                timeA = 0
//                                                                timeB = 0
//                                                            }
//
//                                                            func updateAtoB
//                                                                {
//                                                                    if (timeB) {
//                                                                        input_thread_t * p_input = playlist_CurrentInput(pl_Get(getIntf()))
//                                                                        if (p_input) {
//                                                                            mtime_t currentTime = var_GetInteger(p_input, "time")
//                                                                            if ( currentTime >= timeB || currentTime < timeA)
//                                                                            var_SetInteger(p_input, "time", timeA)
//                                                                            vlc_object_release(p_input)
//                                                                        }
//                                                                    }
//                                                                }

    func volumeUp() {
        if let p_intf = getIntf() {
            playlist_VolumeUp(pl_Get(p_intf), 1, nil)
        }
    }

    func volumeDown() {
        if let p_intf = getIntf() {
            playlist_VolumeUp(pl_Get(p_intf), -1, nil)
        }
    }

    func toggleMute() {
        let p_intf = getIntf()
        playlist_MuteToggle(pl_Get(p_intf))
    }

    var mute: Bool {
        let p_intf = getIntf()
        return playlist_MuteGet(pl_Get(p_intf)) > 0
    }

    var volume: Int {
        get {
            let p_intf = getIntf()
            if p_intf == nil {
                return 0
            }
            let volume = playlist_VolumeGet(pl_Get(p_intf))
            return lroundf(volume * Float(AOUT_VOLUME_DEFAULT))
        }
        set {
            let p_intf = getIntf()
            if p_intf == nil {
                return
            }
            let volume = Float(newValue) >= self.maxVolume ? self.maxVolume : Float(newValue)
            playlist_VolumeSet(pl_Get(p_intf), volume / Float(AOUT_VOLUME_DEFAULT))
        }
    }

    var maxVolume: Float {
        if _maxVolume == 0.0 {
            _maxVolume = Float(var_InheritInteger(getIntf()!.as_vlc_object_pointer(), "macosx-max-volume")) / 100.0 * Float(AOUT_VOLUME_DEFAULT)
        }
        return _maxVolume
    }

    func addSubtitlesToCurrentInput(paths: [NSURL]) {
        guard let p_input = playlist_currentinput(pl_get(getintf())) else {
            return
        }

        for i in 0..<paths.count {
            if let mrl = vlc_path2uri(String(utf8String: paths[i].path!), nil) {
                msg_Dbg(getIntf(), "loading subs from %s", mrl)

                if VLC_SUCCESS != input_AddSlave(p_input, SLAVE_TYPE_SPU, mrl, true, true, true) {
                    msg_Warn(getIntf(), "unable to load subtitles from '%s'", mrl)
                }
                free(mrl)
            }
        }
        vlc_object_release(p_input!.as_vlc_object_pointer())
    }

    func showPosition() {
        if let p_input = playlist_CurrentInput(pl_Get(getIntf())) {
            if let p_vout = input_GetVout(p_input) {
                var_SetInteger(getIntf()!.pointee.obj.libvlc.as_vlc_object_pointer(), "key-action", Int64(ACTIONID_POSITION.rawValue))
                vlc_object_release(p_vout.as_vlc_object_pointer())
            }
            vlc_object_release(p_input.as_vlc_object_pointer())
        }
    }

// MARK: - Drop support for files into the video, controls bar or drop box

    func performDragOperation(sender: NSDraggingInfo) -> Bool {
    //    NSArray *items = VLCMain.instance.playlist.createItemsFromExternalPasteboard([sender draggingPasteboard])
    //    if (items.count == 0)
    //    return false
    //    VLCMain.instance.playlist.addPlaylistItems(items tryAsSubtitle:true)
        return true
    }

// MARK: - video output stuff

    var aspectRatioIsLocked: Bool {
        set { config_PutInt("macosx-lock-aspect-ratio", newValue ? 1 : 0) }
        get { return config_GetInt("macosx-lock-aspect-ratio") != 0 }
    }

    func toggleFullscreen() {
        let p_intf = getIntf()

        if let p_vout = getVoutForActiveWindow() {
            let fullscreen = var_ToggleBool(p_vout.as_vlc_object_pointer(), "fullscreen")
            var_SetBool(pl_Get(p_intf).as_vlc_object_pointer(), "fullscreen", fullscreen)
            vlc_object_release(p_vout.as_vlc_object_pointer())
        } else { // e.g. lion fullscreen toggle
            let fullscreen = var_ToggleBool(pl_Get(p_intf).as_vlc_object_pointer(), "fullscreen")
            VLCMain.instance.voutController.setFullscreen(fullscreen, forWindow: nil, withAnimation: true)
        }
    }

// MARK: - uncommon stuff

//func fixIntfSettings -> Bool
//{
//    NSMutableString * o_workString
//    NSRange returnedRange
//    NSRange fullRange
//    Bool b_needsRestart = false
//
//    #define fixpref(pref) \
//    o_workString = [[NSMutableString alloc] initWithFormat:@"%s", config_GetPsz(pref)]; \
//    if ([o_workString length] > 0) \
//    { \
//        returnedRange = [o_workString rangeOfString:@"macosx" options: NSCaseInsensitiveSearch]; \
//        if (returnedRange.location != NSNotFound) \
//        { \
//            if ([o_workString isEqualToString:@"macosx"]) \
//            [o_workString setString:@""]; \
//            fullRange = NSMakeRange(0, [o_workString length]); \
//            [o_workString replaceOccurrencesOfString:@":macosx" withString:@"" options: NSCaseInsensitiveSearch range: fullRange]; \
//            fullRange = NSMakeRange(0, [o_workString length]); \
//            [o_workString replaceOccurrencesOfString:@"macosx:" withString:@"" options: NSCaseInsensitiveSearch range: fullRange]; \
//            \
//            config_PutPsz(pref, [o_workString UTF8String]); \
//            b_needsRestart = true; \
//        } \
//    }
//
//    fixpref("control")
//    fixpref("extraintf")
//    #undef fixpref
//
//    return b_needsRestart
//}

// MARK: - video filter handling

    func getFilterType(psz_name: String) -> String? {
        guard let p_obj: UnsafePointer<module_t> = module_find(psz_name) else {
            return nil
        }
        if module_provides(p_obj, "video splitter") {
            return "video-splitter"
        } else if module_provides(p_obj, "video filter") {
            return "video-filter"
        } else if module_provides(p_obj, "sub source") {
            return "sub-source"
        } else if module_provides(p_obj, "sub filter") {
            return "sub-filter"
        } else {
            msg_Err(getIntf(), "Unknown video filter type.")
            return nil
        }
    }

    func setVideoFilter(name filterName: String, on b_on: Bool) {
        let p_intf = getIntf()!
        guard let filter_type = getFilterType(filterName) else {
            msg_Err(p_intf, "Unable to find filter module \"%s\".", filterName)
            return
        }

        let p_playlist: UnsafePointer<playlist_t> = pl_Get(p_intf)

        msg_Dbg(p_intf, "will turn filter '%s' %s", filterName, b_on ? "on" : "off")

        var psz_string: String? = String.fromCString(var_InheritString(p_playlist, filter_type))

        if b_on {
            if psz_string == nil {
                psz_string = filterName
            } else if psz_string.range(of: filterName).isEmpty {
                psz_string = "\(psz_string):\(filterName)"
            }
        } else {
            if psz_string == nil {
               return
            }

            if let psz_parser = psz_string.range(of: filterName) {
                let index = psz_string.index(after: psz_parser.upperBound)
                if index != psz_string.endIndex && psz_string[index] == ':') {
                    psz_string.removeSubrange(psz_parser.lowerBound...index)
                    /*memmove(psz_parser, psz_parser + strlen(filterName) + 1, strlen(psz_parser + strlen(filterName) + 1) + 1)*/
                    /* Remove trailing : : */
                    if psz_string.last == ':' {
                    psz_string.removeLast()
                    }
                } else {
                    psz_string = String(psz_string.prefix(upTo: psz_parser.lowerBound))
                }
            } else {
                return
            }
        }
        var_SetString(p_playlist, filter_type, psz_string)

        /* Try to set non splitter filters on the fly */
        if filter_type != "video-splitter" {
            if let vouts: [UnsafePointer<vout_thread_t>]? = getVouts() {
                for val in vouts {
                    let p_vout: UnsafePointer<vout_thread_t> = val.pointee
                    var_SetString(p_vout, filter_type, psz_string)
                    vlc_object_release(p_vout)
                }
            }
        }
    }

    func setVideoFilterProperty(_ property: String, forFilter filter: String, withValue value: vlc_value_t) {
        let p_intf = getIntf()!
        guard let filter_type = getFilterType(filter) else {
            msg_Err(p_intf, "Unable to find filter module \"%s\".", filter)
            return
        }

        var varType = 0
        var isCommand = false
        let p_playlist: playlist_t = pl_Get(p_intf)
        let vouts: [UnsafePointer<vout_thread_t>]? = getVouts()

        if vouts != nil && vouts.count > 0 {
            varType = var_Type((vouts.first as vout_thread_t).pointee, property)
            isCommand = varType & VLC_VAR_ISCOMMAND
        }

        if varType == 0 {
            varType = config_GetType(property)
        }
        varType &= VLC_VAR_CLASS

        if varType == VLC_VAR_Bool {
            var_SetBool(p_playlist, property, value.b_bool)
        } else if varType == VLC_VAR_INTEGER {
            var_SetInteger(p_playlist, property, value.i_int)
        } else if varType == VLC_VAR_FLOAT {
            var_SetFloat(p_playlist, property, value.f_float)
        } else if varType == VLC_VAR_STRING {
            var_SetString(p_playlist, property, EnsureUTF8(value.psz_string))
        } else {
            msg_Err(p_intf, "Module %s's %s variable is of an unsupported type ( %d )", filter, property, varType)
            isCommand = false
        }

        if isCommand {
            if vouts != nil {
                for p_vout in vouts {
                    var_SetChecked(p_vout, property, varType, value)
                    /*#ifndef NDEBUG*/
                    /*Int i_cur_type = var_Type(p_vout, property)*/
                    /*assert((i_cur_type & VLC_VAR_CLASS) == varType)*/
                    /*assert(i_cur_type & VLC_VAR_ISCOMMAND)*/
                /*#endif*/
                }
            }
        }

        if vouts != nil {
            for p_vout in vouts {
                vlc_object_release(p_vout)
            }
        }
    }

// MARK: - Media Key support

//func resetMediaKeyJump
//{
//    b_mediakeyJustJumped = false
//    }
//
    //    func coreChangedMediaKeySupportSetting: (o_notification: NSNotification *
//{
//    let p_intf = getIntf()
//    if (!p_intf)
//    return
//
//    b_mediaKeySupport = var_InheritBool(p_intf, "macosx-mediakeys")
//    if (b_mediaKeySupport && !_mediaKeyController)
//    _mediaKeyController = [[SPMediaKeyTap alloc] initWithDelegate:self]
//
//    VLCMain *main = VLCMain.instance.
//    if (b_mediaKeySupport && ([[[main playlist] model] hasChildren] ||
//        [[main inputManager] hasInput])) {
//        if (!b_mediaKeyTrapEnabled) {
//            b_mediaKeyTrapEnabled = true
//            msg_Dbg(p_intf, "Enable media key support")
//            [_mediaKeyController startWatchingMediaKeys]
//        }
//    } else {
//        if (b_mediaKeyTrapEnabled) {
//            b_mediaKeyTrapEnabled = false
//            msg_Dbg(p_intf, "Disable media key support")
//            [_mediaKeyController stopWatchingMediaKeys]
//        }
//    }
//}

//-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event
//{
//    if (b_mediaKeySupport) {
//        assert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys)
//
//        Int keyCode = (([event data1] & 0xFFFF0000) >> 16)
//        Int keyFlags = ([event data1] & 0x0000FFFF)
//        Int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
//        Int keyRepeat = (keyFlags & 0x1)
//
//        if (keyCode == NX_KEYTYPE_PLAY && keyState == 0)
//        [self playOrPause]
//
//        if ((keyCode == NX_KEYTYPE_FAST || keyCode == NX_KEYTYPE_NEXT) && !b_mediakeyJustJumped) {
//            if (keyState == 0 && keyRepeat == 0)
//            [self next]
//            else if (keyRepeat == 1) {
//                [self forwardShort]
//                b_mediakeyJustJumped = true
//                [self performSelector:#selector(resetMediaKeyJump)
//                    withObject: NULL
//                    afterDelay:0.25]
//            }
//        }
//
//        if ((keyCode == NX_KEYTYPE_REWIND || keyCode == NX_KEYTYPE_PREVIOUS) && !b_mediakeyJustJumped) {
//            if (keyState == 0 && keyRepeat == 0)
//            [self previous]
//            else if (keyRepeat == 1) {
//                [self backwardShort]
//                b_mediakeyJustJumped = true
//                [self performSelector:#selector(resetMediaKeyJump)
//                    withObject: NULL
//                    afterDelay:0.25]
//            }
//        }
//    }
//}

// MARK: - Apple Remote Control

//func startListeningWithAppleRemote
//{
//    [_remote startListening: self]
//    }
//
//    func stopListeningWithAppleRemote
//        {
//            [_remote stopListening:self]
//}

// MARK: - menu navigation

    //func menuFocusActivate
//{
//    let p_input_thread = playlist_CurrentInput(pl_Get(getIntf()))
//    if (p_input_thread == NULL)
//    return
//
//    input_Control(p_input_thread, INPUT_NAV_ACTIVATE, NULL )
//    vlc_object_release(p_input_thread)
//    }
//
//    func moveMenuFocusLeft
//        {
//            let p_input_thread = playlist_CurrentInput(pl_Get(getIntf()))
//            if (p_input_thread == NULL)
//            return
//
//            input_Control(p_input_thread, INPUT_NAV_LEFT, NULL )
//            vlc_object_release(p_input_thread)
//        }
//
//        func moveMenuFocusRight
//            {
//                let p_input_thread = playlist_CurrentInput(pl_Get(getIntf()))
//                if (p_input_thread == NULL)
//                return
//
//                input_Control(p_input_thread, INPUT_NAV_RIGHT, NULL )
//                vlc_object_release(p_input_thread)
//            }
//
//            func moveMenuFocusUp
//                {
//                    let p_input_thread = playlist_CurrentInput(pl_Get(getIntf()))
//                    if (p_input_thread == NULL)
//                    return
//
//                    input_Control(p_input_thread, INPUT_NAV_UP, NULL )
//                    vlc_object_release(p_input_thread)
//                }
//
//                func moveMenuFocusDown
//                    {
//                        let p_input_thread = playlist_CurrentInput(pl_Get(getIntf()))
//                        if (p_input_thread == NULL)
//                        return
//
//                        input_Control(p_input_thread, INPUT_NAV_DOWN, NULL )
//                        vlc_object_release(p_input_thread)
//                    }
//
//                    /* Helper method for the remote control interface in order to trigger forward/backward and volume
//                     increase/decrease as long as the user holds the left/right, plus/minus button */
    //                    func executeHoldActionForRemoteButton: (buttonIdentifierNumber: NSNumber*
//{
//    let p_intf = getIntf()
//    if (!p_intf)
//    return
//
//    if (b_remote_button_hold) {
//        switch([buttonIdentifierNumber intValue]) {
//        case kRemoteButtonRight_Hold:
//            [self forward]
//            break
//        case kRemoteButtonLeft_Hold:
//            [self backward]
//            break
//        case kRemoteButtonVolume_Plus_Hold:
//            if (p_intf)
//            var_SetInteger(p_intf->obj.libvlc, "key-action", ACTIONID_VOL_UP)
//            break
//        case kRemoteButtonVolume_Minus_Hold:
//            if (p_intf)
//            var_SetInteger(p_intf->obj.libvlc, "key-action", ACTIONID_VOL_DOWN)
//            break
//        }
//        if (b_remote_button_hold) {
//            /* trigger event */
//            [self performSelector:#selector(executeHoldActionForRemoteButton:)
//                withObject:buttonIdentifierNumber
//                afterDelay:0.25]
//        }
//    }
//    }
//
//    /* Apple Remote callback */
    //    func appleRemoteButton: (buttonIdentifier: AppleRemoteEventIdentifier
//pressedDown: (Bool) pressedDown
//clickCount: (unsigned Int) count
//{
//    let p_intf = getIntf()
//    if (!p_intf)
//    return
//
//    switch(buttonIdentifier) {
//    case k2009RemoteButtonFullscreen:
//        [self toggleFullscreen]
//        break
//    case k2009RemoteButtonPlay:
//        [self playOrPause]
//        break
//    case kRemoteButtonPlay:
//        if (count >= 2)
//        [self toggleFullscreen]
//        else
//        [self playOrPause]
//        break
//    case kRemoteButtonVolume_Plus:
//        if (config_GetInt("macosx-appleremote-sysvol"))
//        [NSSound increaseSystemVolume]
//        else
//        if (p_intf)
//        var_SetInteger(p_intf->obj.libvlc, "key-action", ACTIONID_VOL_UP)
//        break
//    case kRemoteButtonVolume_Minus:
//        if (config_GetInt("macosx-appleremote-sysvol"))
//        [NSSound decreaseSystemVolume]
//        else
//        if (p_intf)
//        var_SetInteger(p_intf->obj.libvlc, "key-action", ACTIONID_VOL_DOWN)
//        break
//    case kRemoteButtonRight:
//        if (config_GetInt("macosx-appleremote-prevnext"))
//        [self forward]
//        else
//        [self next]
//        break
//    case kRemoteButtonLeft:
//        if (config_GetInt("macosx-appleremote-prevnext"))
//        [self backward]
//        else
//        [self previous]
//        break
//    case kRemoteButtonRight_Hold:
//    case kRemoteButtonLeft_Hold:
//    case kRemoteButtonVolume_Plus_Hold:
//    case kRemoteButtonVolume_Minus_Hold:
//        /* simulate an event as long as the user holds the button */
//        b_remote_button_hold = pressedDown
//        if (pressedDown) {
//            NSNumber* buttonIdentifierNumber = [NSNumber numberWithInt:buttonIdentifier]
//            [self performSelector:#selector(executeHoldActionForRemoteButton:)
//                withObject:buttonIdentifierNumber]
//        }
//        break
//    case kRemoteButtonMenu:
//        [self showPosition]
//        break
//    case kRemoteButtonPlay_Sleep:
//    {
//        NSAppleScript * script = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to sleep"]
//        [script executeAndReturnError:nil]
//        break
//        }
//    default:
//        /* Add here whatever you want other buttons to do */
//        break
//    }
//}

// MARK: - Key Shortcuts

///*****************************************************************************
// * hasDefinedShortcutKey: Check to see if the key press is a defined VLC
// * shortcut key.  If it is, pass it off to VLC for handling and return true,
// * otherwise ignore it and return false (where it will get handled by Cocoa).
// *****************************************************************************/

    func keyEvent(event: NSEvent) {
        var eventHandled = false
        if let key = event.charactersIgnoringModifiers?.first {
            if let p_input = playlist_CurrentInput(pl_Get(getIntf())) {
                if let p_vout: vout_thread_t = input_GetVout(p_input) {
                    /* Escape */
                    if key == (unichar) 0x1b {
                        if var_GetBool(p_vout, "fullscreen") {
                            toggleFullscreen()
                            eventHandled = true
                        }
                    }
                    vlc_object_release(p_vout)
                }
                vlc_object_release(p_input)
            }
        }
        return eventHandled
    }

    func hasDefinedShortcutKey(event: NSEvent, force: Bool) {
        var val = vlc_value_t()
        val.i_int = 0

        var i_pressed_modifiers = event.modifierFlags

        if i_pressed_modifiers.contains(.control) {
            val.i_int |= KEY_MODIFIER_CTRL
        }
        if i_pressed_modifiers.contains(.option) {
            val.i_int |= KEY_MODIFIER_ALT
        }
        if i_pressed_modifiers.contains(.shift) {
            val.i_int |= KEY_MODIFIER_SHIFT
        }
        if i_pressed_modifiers.contains(.command) {
            val.i_int |= KEY_MODIFIER_COMMAND
        }

        if let characters = event.charactersIgnoringModifiers?.lowercased() {
            let key: UInt16? = characters.utf16.first

            /* handle Lion's default key combo for fullscreen-toggle in addition to our own hotkeys */
            if key == UInt16('f') && i_pressed_modifiers.contains(.control) && i_pressed_modifiers.contains(.command) {
                toggleFullscreen()
                return true
            }

            if !force {
                switch key {
                case NSDeleteCharacter, NSDeleteFunctionKey, NSDeleteCharFunctionKey,
                    NSBackspaceCharacter, NSUpArrowFunctionKey, NSDownArrowFunctionKey,
                    NSEnterCharacter, NSCarriageReturnCharacter:
                    return false
                }
            }

            val.i_int |= CocoaKeyToVLC(key)

            var found_key = false
            for str in _usedHotkeys {
                let i_keyModifiers: UInt = VLCStringUtility.VLCModifiersToCocoa(str)
                if characters == VLCStringUtility.VLCKeyToString(str) &&
                    i_keyModifiers.contains(.shift)     == i_pressed_modifiers.contains(.shift) &&
                    i_keyModifiers.contains(.control)   == i_pressed_modifiers.contains(.control) &&
                    i_keyModifiers.contains(.option)    == i_pressed_modifiers.contains(.option) &&
                    i_keyModifiers.contains(.command)   == i_pressed_modifiers.contains(.command) {
                    found_key = true
                    break
                }
            }
            if found_key {
                var_SetInteger(getIntf()->obj.libvlc, "key-pressed", val.i_int)
                return true
            }
        }
        return false
    }

    func updateCurrentlyUsedHotkeys() {
        _usedHotkeys = [String]()
        /* Get the main Module */
        let p_main: UnsafeMutablePointer<module_t> = module_get_main()
        // assert(p_main)

        var confsize: UInt
        let p_config: UnsafeMutablePointer<module_config_t> = module_config_get(p_main, &confsize)
        for i in 0..<confsize {
            let config = p_config[i]
            if (p_item.pointee.i_type & ~0xF) != 0 &&
                p_item.pointee.psz_name != nil &&
                strncmp(p_item.pointee.psz_name, "key-", 4) == 0 &&
                !(p_item.pointee.psz_text == nil || String(cString: p_item.pointee.psz_text).isEmpty) {
                if p_item.pointee.value.psz != nil {
                    _usedHotkeys.append(String(cString: p_item.pointee.value.psz))
                }
            }
        }
        module_config_free(p_config)
    }
}
