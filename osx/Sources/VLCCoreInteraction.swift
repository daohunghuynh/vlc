//
//  VLCCoreInteraction.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 19/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation


fileprivate func BossCallback(_ p_this: UnsafeMutablePointer<vlc_object_t>?,
                              _ psz_var: UnsafePointer<Int8>?,
                              _ oldval: vlc_value_t,
                              _ new_val: vlc_value_t,
                              _ param: UnsafeMutableRawPointer?) -> Int32 {
    return autoreleasepool { () -> Int32 in
        DispatchQueue.main.async() {
            VLCCoreInteraction.instance.pause()
            NSApplication.shared.hide(nil)
        }
        return VLC_SUCCESS
    }
}

typealias CBossCallback = @convention(c) (UnsafeMutablePointer<vlc_object_t>?, UnsafePointer<Int8>?, vlc_value_t, vlc_value_t, UnsafeMutableRawPointer?) -> Int32

let cBossCallback: CBossCallback! = BossCallback


class VLCCoreInteraction {

    private var i_currentPlaybackRate: Int = 0
    private var timeA: mtime_t = 0
    private var timeB: mtime_t = 0

    private var f_maxVolume: Float = 0.0

    /* media key support */
    private var b_mediaKeySupport: Bool = false
    private var b_mediakeyJustJumped: Bool = false
//    private var SPMediaKeyTap *_mediaKeyController
    private var b_mediaKeyTrapEnabled: Bool = false

//    private var AppleRemote *_remote
    private var b_remote_button_hold: Bool = false /* true as long as the user holds the left,right,plus or minus on the remote control */

//    private var NSArray *_usedHotkeys

    static let instance = VLCCoreInteraction()

//    @property (readonly, nonatomic) float maxVolume
//    @property (readwrite) Int playbackRate
//    @property (nonatomic, readwrite) Bool aspectRatioIsLocked
//    @property (readonly) Int durationOfCurrentPlaylistItem
//    @property (readonly) NSURL * URLOfCurrentPlaylistItem
//    @property (readonly) String  * nameOfCurrentPlaylistItem
//    @property (nonatomic, readwrite) Bool mute

//func faster
//func slower
//func normalSpeed
//func toggleRecord
//func next
//func previous
//func forward;        //LEGACY SUPPORT
//func backward;       //LEGACY SUPPORT
//func forwardExtraShort
//func backwardExtraShort
//func forwardShort
//func backwardShort
//func forwardMedium
//func backwardMedium
//func forwardLong
//func backwardLong

//func repeatOne
//func repeatAll
//func repeatOff
//func shuffle
//func setAtoB
//func resetAtoB
//func updateAtoB

//func toggleMute
//func showPosition
//func startListeningWithAppleRemote
//func stopListeningWithAppleRemote

//func menuFocusActivate
//func moveMenuFocusLeft
//func moveMenuFocusRight
//func moveMenuFocusUp
//func moveMenuFocusDown


//func sender -> Bool)performDragOperation:(id <NSDraggingInfo>

//func fixIntfSettings -> Bool

//func o_event -> Bool)keyEvent:(NSEvent *
//func b_force -> Bool)hasDefinedShortcutKey:(NSEvent *)o_event force:(Bool


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
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(coreChangedMediaKeySupportSetting:) name:VLCMediaKeySupportSettingChangedNotification object: nil]

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
        let intf: UnsafeMutablePointer<intf_thread_t>! = getIntf()
        let p_playlist: UnsafeMutablePointer<playlist_t>! = pl_Get(intf)

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
            let p_playlist: UnsafeMutablePointer<playlist_t> = pl_Get(getIntf())

            let speed = pow(2, Double(newValue) / 17)
            let rate: Int = Int(Double(INPUT_RATE_DEFAULT) / speed)
            if self.i_currentPlaybackRate != rate {
                var_SetFloat(p_playlist.as_vlc_object_pointer(), "rate", Float(INPUT_RATE_DEFAULT) / Float(rate))
            }
            self.i_currentPlaybackRate = rate
        }

        get {
            if let p_intf = getIntf() {
                var f_rate: Float

                if let p_input = playlist_CurrentInput(pl_Get(p_intf))?.as_vlc_object_pointer() {
                    f_rate = var_GetFloat(p_input, "rate")
                    vlc_object_release(p_input)
                } else {
                    let p_playlist = pl_Get(getIntf())!.as_vlc_object_pointer()
                    f_rate = var_GetFloat(p_playlist, "rate")
                }

                let value = 17 * log(f_rate) / log(2)
                var returnValue = Int((value > 0) ? value + 0.5 : value - 0.5)
                if (returnValue < -34) {
                    returnValue = -34
                } else if (returnValue > 34) {
                    returnValue = 34
                }

                self.i_currentPlaybackRate = returnValue
                return returnValue
            } else {
                return 0
            }
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

        if let p_intf = getIntf() {
            let i_duration = UnsafeMutablePointer<Int64>.allocate(capacity: 1)
            i_duration.initialize(repeating: -1, count: 1)

            let p_input = playlist_CurrentInput(pl_Get(p_intf))
            if p_input == nil {
                return i_duration.pointee
            }

            getInputControl(p_input!, Int32(INPUT_GET_LENGTH.rawValue), i_duration)
            vlc_object_release(p_input!.as_vlc_object_pointer())

            return (i_duration.pointee / 1000000)
        }
        return 0
    }

//                    func URLOfCurrentPlaylistItem -> NSURL*
//                        {
//                            let p_intf = getIntf()
//                            if (!p_intf)
//                            return nil
//
//                            let p_input = playlist_CurrentInput(pl_Get(p_intf))
//                            if (!p_input)
//                            return nil
//
//                            input_item_t *p_item = input_GetItem(p_input)
//                            if (!p_item) {
//                                vlc_object_release(p_input)
//                                return nil
//                            }
//
//                            char *psz_uri = input_item_GetURI(p_item)
//                            if (!psz_uri) {
//                                vlc_object_release(p_input)
//                                return nil
//                            }
//
//                            NSURL *o_url
//                            o_url = [NSURL URLWithString:toNSStr(psz_uri)]
//                            free(psz_uri)
//                            vlc_object_release(p_input)
//
//                            return o_url
//                        }
//
//                        func nameOfCurrentPlaylistItem -> String *
//                            {
//                                let p_intf = getIntf()
//                                if (!p_intf)
//                                return nil
//
//                                let p_input = playlist_CurrentInput(pl_Get(p_intf))
//                                if (!p_input)
//                                return nil
//
//                                input_item_t *p_item = input_GetItem(p_input)
//                                if (!p_item) {
//                                    vlc_object_release(p_input)
//                                    return nil
//                                }
//
//                                char *psz_uri = input_item_GetURI(p_item)
//                                if (!psz_uri) {
//                                    vlc_object_release(p_input)
//                                    return nil
//                                }
//
//                                String  *o_name = @""
//                                char *format = var_InheritString(getIntf(), "input-title-format")
//                                if (format) {
//                                    char *formated = vlc_strfinput(p_input, format)
//                                    free(format)
//                                    o_name = toNSStr(formated)
//                                    free(formated)
//                                }
//
//                                NSURL * o_url = [NSURL URLWithString:toNSStr(psz_uri)]
//                                free(psz_uri)
//
//                                if ([o_name isEqualToString:@""]) {
//                                    if ([o_url isFileURL])
//                                    o_name = [[NSFileManager defaultManager] displayNameAtPath:[o_url path]]
//                                    else
//                                    o_name = [o_url absoluteString]
//                                }
//                                vlc_object_release(p_input)
//                                return o_name
//                            }
//
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
//
//                                    func jumpWithValue:(char *)p_value forward b_value: Bool)
//{
//    let p_input = playlist_CurrentInput(pl_Get(getIntf()))
//    if (!p_input)
//    return
//
//    Int i_interval = var_InheritInteger( p_input, p_value )
//    if (i_interval > 0) {
//        mtime_t val = CLOCK_FREQ * i_interval
//        if (!b_value)
//        val = val * -1
//        var_SetInteger( p_input, "time-offset", val )
//    }
//    vlc_object_release(p_input)
//    }
//
//    func forwardExtraShort
//        {
//            [self jumpWithValue:"extrashort-jump-size" forward:true]
//        }
//
//        func backwardExtraShort
//            {
//                [self jumpWithValue:"extrashort-jump-size" forward:false]
//            }
//
//            func forwardShort
//                {
//                    [self jumpWithValue:"short-jump-size" forward:true]
//                }
//
//                func backwardShort
//                    {
//                        [self jumpWithValue:"short-jump-size" forward:false]
//                    }
//
//                    func forwardMedium
//                        {
//                            [self jumpWithValue:"medium-jump-size" forward:true]
//                        }
//
//                        func backwardMedium
//                            {
//                                [self jumpWithValue:"medium-jump-size" forward:false]
//                            }
//
//                            func forwardLong
//                                {
//                                    [self jumpWithValue:"long-jump-size" forward:true]
//                                }
//
//                                func backwardLong
//                                    {
//                                        [self jumpWithValue:"long-jump-size" forward:false]
//                                    }
//
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

//                                                                        func toggleMute
//                                                                            {
//                                                                                let p_intf = getIntf()
//                                                                                if (!p_intf)
//                                                                                return
//
//                                                                                playlist_MuteToggle(pl_Get(p_intf))
//                                                                            }
//
//                                                                            func mute -> Bool
//                                                                                {
//                                                                                    let p_intf = getIntf()
//                                                                                    if (!p_intf)
//                                                                                    return false
//
//                                                                                    Bool b_is_muted = false
//                                                                                    b_is_muted = playlist_MuteGet(pl_Get(p_intf)) > 0
//
//                                                                                    return b_is_muted
//                                                                                }

    var volume: Int {
        get {
            let p_intf = getIntf()
            if p_intf == nil {
                return 0
            }

            let volume: Float = playlist_VolumeGet(pl_Get(p_intf))
            return lroundf(volume * Float(AOUT_VOLUME_DEFAULT))
        }
        set {
            let p_intf = getIntf()
            if p_intf == nil {
                return
            }

            let i_value =  Float(newValue) >= self.maxVolume ? Int(self.maxVolume) : newValue
            let f_value = Float(i_value) / Float(AOUT_VOLUME_DEFAULT)
            playlist_VolumeSet(pl_Get(p_intf), f_value)
        }
    }

    var maxVolume: Float {
        if f_maxVolume == 0.0 {
            f_maxVolume = Float(var_InheritInteger(getIntf()!.as_vlc_object_pointer(), "macosx-max-volume")) / 100.0 * Float(AOUT_VOLUME_DEFAULT)
        }
        return f_maxVolume
    }

    func addSubtitlesToCurrentInput(paths: [NSURL]) {
        let p_input = playlist_CurrentInput(pl_Get(getIntf()))
        if p_input == nil {
            return
        }

        for i in 0..<paths.count {
            if let mrl = vlc_path2uri(String(utf8String: paths[i].path!), nil) {
    //            msg_Dbg(getIntf(), "loading subs from %s", mrl)

                if VLC_SUCCESS != input_AddSlave(p_input, SLAVE_TYPE_SPU, mrl, true, true, true) {
//                    msg_Warn(getIntf(), "unable to load subtitles from '%s'", mrl)
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
    //
    //    if (items.count == 0)
    //    return false
    //
    //    VLCMain.instance.playlist.addPlaylistItems(items tryAsSubtitle:true)
        return true
    }

// MARK: - video output stuff

    var aspectRatioIsLocked: Bool {
        set {
            config_PutInt("macosx-lock-aspect-ratio", newValue ? 1 : 0)
        }
        get {
            return config_GetInt("macosx-lock-aspect-ratio") != 0
        }
    }

    func toggleFullscreen() {
        let p_intf = getIntf()

        if let p_vout = getVoutForActiveWindow() {
            let b_fs: Bool = var_ToggleBool(p_vout.as_vlc_object_pointer(), "fullscreen")
            var_SetBool(pl_Get(p_intf).as_vlc_object_pointer(), "fullscreen", b_fs)
            vlc_object_release(p_vout.as_vlc_object_pointer())
        } else { // e.g. lion fullscreen toggle
            let b_fs: Bool = var_ToggleBool(pl_Get(p_intf).as_vlc_object_pointer(), "fullscreen")
            VLCMain.instance.voutController.setFullscreen(b_fs, forWindow: nil, withAnimation: true)
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
//
// MARK: - video filter handling
//
//func psz_name -> const char *)getFilterType:(const char *
//{
//    module_t *p_obj = module_find(psz_name)
//    if (!p_obj) {
//        return NULL
//    }
//
//    if (module_provides(p_obj, "video splitter")) {
//        return "video-splitter"
//    } else if (module_provides(p_obj, "video filter")) {
//        return "video-filter"
//    } else if (module_provides(p_obj, "sub source")) {
//        return "sub-source"
//    } else if (module_provides(p_obj, "sub filter")) {
//        return "sub-filter"
//    } else {
//        msg_Err(getIntf(), "Unknown video filter type.")
//        return NULL
//    }
//    }
//
//    func b_on )setVideoFilter: (const char *)psz_name on:(Bool
//{
//    let p_intf = getIntf()
//    if (!p_intf)
//    return
//    playlist_t *p_playlist = pl_Get(p_intf)
//    char *psz_string, *psz_parser
//
//    const char *psz_filter_type = [self getFilterType:psz_name]
//    if (!psz_filter_type) {
//        msg_Err(p_intf, "Unable to find filter module \"%s\".", psz_name)
//        return
//    }
//
//    msg_Dbg(p_intf, "will turn filter '%s' %s", psz_name, b_on ? "on" : "off")
//
//    psz_string = var_InheritString(p_playlist, psz_filter_type)
//
//    if (b_on) {
//        if (psz_string == NULL) {
//            psz_string = strdup(psz_name)
//        } else if (strstr(psz_string, psz_name) == NULL) {
//            char *psz_tmp = strdup([[String stringWithFormat: @"%s:%s", psz_string, psz_name] UTF8String])
//            free(psz_string)
//            psz_string = psz_tmp
//        }
//    } else {
//        if (!psz_string)
//        return
//
//        psz_parser = strstr(psz_string, psz_name)
//        if (psz_parser) {
//            if (*(psz_parser + strlen(psz_name)) == ':') {
//                memmove(psz_parser, psz_parser + strlen(psz_name) + 1,
//                        strlen(psz_parser + strlen(psz_name) + 1) + 1)
//            } else {
//                *psz_parser = '\0'
//            }
//
//            /* Remove trailing : : */
//            if (strlen(psz_string) > 0 && *(psz_string + strlen(psz_string) -1) == ':')
//            *(psz_string + strlen(psz_string) -1) = '\0'
//        } else {
//            free(psz_string)
//            return
//        }
//    }
//    var_SetString(p_playlist, psz_filter_type, psz_string)
//
//    /* Try to set non splitter filters on the fly */
//    if (strcmp(psz_filter_type, "video-splitter")) {
//        NSArray<NSValue *> *vouts = getVouts()
//        if (vouts)
//        for (NSValue * val in vouts) {
//            vout_thread_t *p_vout = [val pointerValue]
//            var_SetString(p_vout, psz_filter_type, psz_string)
//            vlc_object_release(p_vout)
//        }
//    }
//
//    free(psz_string)
//    }
//
//    func setVideoFilterProperty: (char const *psz_property
//forFilter: (char const *)psz_filter
//withValue: (vlc_value_t)value
//{
//    NSArray<NSValue *> *vouts = getVouts()
//    let p_intf = getIntf()
//    playlist_t *p_playlist = pl_Get(p_intf)
//    if (!p_intf)
//    return
//    Int i_type = 0
//    bool b_is_command = false
//    char const *psz_filter_type = [self getFilterType: psz_filter]
//    if (!psz_filter_type) {
//        msg_Err(p_intf, "Unable to find filter module \"%s\".", psz_filter)
//        return
//    }
//
//    if (vouts && [vouts count])
//    {
//        i_type = var_Type((vout_thread_t *)[[vouts firstObject] pointerValue], psz_property)
//        b_is_command = i_type & VLC_VAR_ISCOMMAND
//    }
//    if (!i_type)
//    i_type = config_GetType(psz_property)
//
//    i_type &= VLC_VAR_CLASS
//    if (i_type == VLC_VAR_Bool)
//    var_SetBool(p_playlist, psz_property, value.b_bool)
//    else if (i_type == VLC_VAR_INTEGER)
//    var_SetInteger(p_playlist, psz_property, value.i_int)
//    else if (i_type == VLC_VAR_FLOAT)
//    var_SetFloat(p_playlist, psz_property, value.f_float)
//    else if (i_type == VLC_VAR_STRING)
//    var_SetString(p_playlist, psz_property, EnsureUTF8(value.psz_string))
//    else
//    {
//        msg_Err(p_intf,
//                "Module %s's %s variable is of an unsupported type ( %d )",
//                psz_filter, psz_property, i_type)
//        b_is_command = false
//    }
//
//    if (b_is_command)
//    if (vouts)
//    for (NSValue *ptr in vouts)
//    {
//        vout_thread_t *p_vout = [ptr pointerValue]
//        var_SetChecked(p_vout, psz_property, i_type, value)
//        #ifndef NDEBUG
//        Int i_cur_type = var_Type(p_vout, psz_property)
//        assert((i_cur_type & VLC_VAR_CLASS) == i_type)
//        assert(i_cur_type & VLC_VAR_ISCOMMAND)
//#endif
//}
//
//if (vouts)
//for (NSValue *ptr in vouts)
//    vlc_object_release((vout_thread_t *)[ptr pointerValue])
//}
//
// MARK: - Media Key support
//
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
//
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
//                [self performSelector:@selector(resetMediaKeyJump)
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
//                [self performSelector:@selector(resetMediaKeyJump)
//                    withObject: NULL
//                    afterDelay:0.25]
//            }
//        }
//    }
//}
//
// MARK: - Apple Remote Control
//
//func startListeningWithAppleRemote
//{
//    [_remote startListening: self]
//    }
//
//    func stopListeningWithAppleRemote
//        {
//            [_remote stopListening:self]
//}
//
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
//            [self performSelector:@selector(executeHoldActionForRemoteButton:)
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
//            [self performSelector:@selector(executeHoldActionForRemoteButton:)
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
//
// MARK: - Key Shortcuts
//
///*****************************************************************************
// * hasDefinedShortcutKey: Check to see if the key press is a defined VLC
// * shortcut key.  If it is, pass it off to VLC for handling and return true,
// * otherwise ignore it and return false (where it will get handled by Cocoa).
// *****************************************************************************/
//
//func o_event -> Bool)keyEvent:(NSEvent *
//{
//    Bool eventHandled = false
//    String  * characters = [o_event charactersIgnoringModifiers]
//    if ([characters length] > 0) {
//        unichar key = [characters characterAtIndex: 0]
//
//        if (key) {
//            input_thread_t * p_input = playlist_CurrentInput(pl_Get(getIntf()))
//            if (p_input != NULL) {
//                vout_thread_t *p_vout = input_GetVout(p_input)
//
//                if (p_vout != NULL) {
//                    /* Escape */
//                    if (key == (unichar) 0x1b) {
//                        if (var_GetBool(p_vout, "fullscreen")) {
//                            [self toggleFullscreen]
//                            eventHandled = true
//                        }
//                    }
//                    vlc_object_release(p_vout)
//                }
//                vlc_object_release(p_input)
//            }
//        }
//    }
//    return eventHandled
//    }
//
//    func b_force -> Bool)hasDefinedShortcutKey:(NSEvent *)o_event force:(Bool
//{
//    let p_intf = getIntf()
//    if (!p_intf)
//    return false
//
//    unichar key = 0
//    vlc_value_t val
//    unsigned Int i_pressed_modifiers = 0
//
//    val.i_int = 0
//    i_pressed_modifiers = [o_event modifierFlags]
//
//    if (i_pressed_modifiers & NSControlKeyMask)
//    val.i_int |= KEY_MODIFIER_CTRL
//
//    if (i_pressed_modifiers & NSAlternateKeyMask)
//    val.i_int |= KEY_MODIFIER_ALT
//
//    if (i_pressed_modifiers & NSShiftKeyMask)
//    val.i_int |= KEY_MODIFIER_SHIFT
//
//    if (i_pressed_modifiers & NSCommandKeyMask)
//    val.i_int |= KEY_MODIFIER_COMMAND
//
//    String  * characters = [o_event charactersIgnoringModifiers]
//    if ([characters length] > 0) {
//        key = [[characters lowercaseString] characterAtIndex: 0]
//
//        /* handle Lion's default key combo for fullscreen-toggle in addition to our own hotkeys */
//        if (key == 'f' && i_pressed_modifiers & NSControlKeyMask && i_pressed_modifiers & NSCommandKeyMask) {
//            [self toggleFullscreen]
//            return true
//        }
//
//        if (!b_force) {
//            switch(key) {
//            case NSDeleteCharacter:
//            case NSDeleteFunctionKey:
//            case NSDeleteCharFunctionKey:
//            case NSBackspaceCharacter:
//            case NSUpArrowFunctionKey:
//            case NSDownArrowFunctionKey:
//            case NSEnterCharacter:
//            case NSCarriageReturnCharacter:
//                return false
//            }
//        }
//
//        val.i_int |= CocoaKeyToVLC(key)
//
//        Bool b_found_key = false
//        for (NSUInteger i = 0; i < [_usedHotkeys count]; i++) {
//            String  *str = [_usedHotkeys objectAtIndex:i]
//            unsigned Int i_keyModifiers = [[VLCStringUtility sharedInstance] VLCModifiersToCocoa: str]
//
//            if ([[characters lowercaseString] isEqualToString: [[VLCStringUtility sharedInstance] VLCKeyToString: str]] &&
//                (i_keyModifiers & NSShiftKeyMask)     == (i_pressed_modifiers & NSShiftKeyMask) &&
//                (i_keyModifiers & NSControlKeyMask)   == (i_pressed_modifiers & NSControlKeyMask) &&
//                (i_keyModifiers & NSAlternateKeyMask) == (i_pressed_modifiers & NSAlternateKeyMask) &&
//                (i_keyModifiers & NSCommandKeyMask)   == (i_pressed_modifiers & NSCommandKeyMask)) {
//                b_found_key = true
//                break
//            }
//        }
//
//        if (b_found_key) {
//            var_SetInteger(p_intf->obj.libvlc, "key-pressed", val.i_int)
//            return true
//        }
//    }
//
//    return false
//    }
//
    func updateCurrentlyUsedHotkeys() {
//            NSMutableArray *mutArray = [[NSMutableArray alloc] init]
//            /* Get the main Module */
//            module_t *p_main = module_get_main()
//            assert(p_main)
//            unsigned confsize
//            module_config_t *p_config
//
//            p_config = module_config_get (p_main, &confsize)
//
//            for (size_t i = 0; i < confsize; i++) {
//                module_config_t *p_item = p_config + i
//
//                if (CONFIG_ITEM(p_item->i_type) && p_item->psz_name != NULL
//                    && !strncmp(p_item->psz_name , "key-", 4)
//                    && !EMPTY_STR(p_item->psz_text)) {
//                    if (p_item->value.psz)
//                    [mutArray addObject:toNSStr(p_item->value.psz)]
//                }
//            }
//            module_config_free (p_config)
//
//            _usedHotkeys = [[NSArray alloc] initWithArray:mutArray copyItems:true]
    }

}
