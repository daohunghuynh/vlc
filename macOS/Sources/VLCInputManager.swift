//
//  VLCInputManager.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 02/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import Foundation
import IOKit
import IOKit.pwr_mgt

fileprivate func InputThreadChanged(p_this: UnsafeMutablePointer<vlc_object_t>?, psz_var: UnsafePointer<Int8>?,
                               oldval: vlc_value_t, new_val: vlc_value_t, param: UnsafeMutableRawPointer?) -> Int32 {
    autoreleasepool {
        let inputManager: VLCInputManager = param!.assumingMemoryBound(to: VLCInputManager.self).pointee
        DispatchQueue.main.async { inputManager.inputThreadChanged() }
    }
    return VLC_SUCCESS
}

// static NSDate *lastPositionUpdate = nil

fileprivate func InputEvent(p_this: UnsafeMutablePointer<vlc_object_t>?, psz_var: UnsafePointer<Int8>?, oldval: vlc_value_t, new_val: vlc_value_t, param: UnsafeMutableRawPointer?) -> Int32 {
    autoreleasepool {
        let inputManager: VLCInputManager = bridge(ptr: param!)

        switch UInt32(new_val.i_int) {
        case INPUT_EVENT_STATE.rawValue:
            DispatchQueue.main.async { inputManager.playbackStatusUpdated() }
        case INPUT_EVENT_RATE.rawValue:
            DispatchQueue.main.async { VLCMain.instance.mainMenu.updatePlaybackRate() }
        case INPUT_EVENT_POSITION.rawValue:
            // Rate limit to 100 ms
            if (lastPositionUpdate && fabs([lastPositionUpdate timeIntervalSinceNow]) < 0.1)
                break

            lastPositionUpdate = [NSDate date]

            DispatchQueue.main.async { inputManager.playbackPositionUpdated() }
        case INPUT_EVENT_TITLE.rawValue, INPUT_EVENT_CHAPTER.rawValue:
            DispatchQueue.main.async { inputManager.updateMainMenu() }
        case INPUT_EVENT_CACHE.rawValue:
            DispatchQueue.main.async { inputManager.updateMainWindow() }
//        case INPUT_EVENT_STATISTICS.rawValue:
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [VLCMain.instance.currentMediaInfoPanel] updateStatistics]
//            })
        case INPUT_EVENT_ITEM_META.rawValue, INPUT_EVENT_ITEM_INFO.rawValue:
            DispatchQueue.main.async { inputManager.updateMainMenu() }
            DispatchQueue.main.async { inputManager.updateName() }
            DispatchQueue.main.async { inputManager.updateMetaAndInfo() }
        case INPUT_EVENT_RECORD.rawValue:
            DispatchQueue.main.async { VLCMain.instance.mainMenu.updateRecordState(var_InheritBool(p_this, "record")) }
        case INPUT_EVENT_PROGRAM.rawValue:
            DispatchQueue.main.async { inputManager.updateMainMenu() }
        case INPUT_EVENT_AUDIO_DELAY.rawValue, INPUT_EVENT_SUBTITLE_DELAY.rawValue:
            DispatchQueue.main.async { inputManager.updateDelays() }
        case INPUT_EVENT_DEAD.rawValue:
            DispatchQueue.main.async {
                inputManager.updateName()
                VLCMain.instance.mainWindow.updateTimeSlider()
            }
        case INPUT_EVENT_ES.rawValue, INPUT_EVENT_TELETEXT.rawValue, INPUT_EVENT_AOUT.rawValue, INPUT_EVENT_VOUT.rawValue,
             INPUT_EVENT_BOOKMARK.rawValue, INPUT_EVENT_ITEM_EPG.rawValue, INPUT_EVENT_SIGNAL.rawValue:
            break
        default:
            break
        }
    }
    return VLC_SUCCESS
}


// MARK: - InputManager implementation

class VLCInputManager {

    private unowned let _main: VLCMain
    private let _informInputChangedQueue: DispatchQueue
    private var _currentInput:  UnsafeMutablePointer<input_thread_t>?

    /* sleep management */
    private var _systemSleepAssertionID: IOPMAssertionID
    private var _monitorSleepAssertionID: IOPMAssertionID
    private var _userActivityAssertionID: IOPMAssertionID

    private var _hasEndedTimer: Timer?


    static var _defaults: UserDefaults = {
            let appDefaults: [String: Any] = [
                "recentlyPlayedMediaList": NSMutableArray(),
                "recentlyPlayedMedia": [String: Int64]()
            ]
            UserDefaults.standard.register(defaults: appDefaults)
        }()


    init(withMain: VLCMain) {
//        msg_Dbg(getIntf(), "Initializing input manager")
        _main = withMain
        _informInputChangedQueue = DispatchQueue(__label: "org.videolan.vlc.inputChangedQueue", attr: nil)

        var_AddCallback(pl_Get(getIntf()).as_vlc_object_pointer(), "input-current", InputThreadChanged, bridge(obj: self))
    }

    deinit {
//     msg_Dbg(getIntf(), "Deinitializing input manager")
        if _currentInput != nil {
            /* continue playback where you left off */
            storePlaybackPositionForItem()
         
            var_DelCallback(_currentInput!.as_vlc_object_pointer(), "intf-event", InputEvent, bridge(obj: self))
            vlc_object_release(_currentInput!.as_vlc_object_pointer())
            _currentInput = nil
        }

        var_DelCallback(pl_Get(getIntf()).as_vlc_object_pointer(), "input-current", InputThreadChanged, bridge(obj: self))

// #if !OS_OBJECT_USE_OBJC
        dispatch_release(_informInputChangedQueue)
// #endif
    }


    @objc func inputThreadChanged() {
        if _currentInput != nil {
            var_DelCallback(_currentInput!.as_vlc_object_pointer(), "intf-event", InputEvent, bridge(obj: self))
            vlc_object_release(_currentInput!.as_vlc_object_pointer())
            _currentInput = nil

            _main.mainMenu.setRateControlsEnabled(false)

            NotificationCenter.default.post(name: VLCInputChangedNotification, object:nil)
        }

        // Cancel pending resume dialogs
        VLCMain.instance.resumeDialog.cancel()

        var inputChanged: UnsafeMutableRawPointer?//<input_thread_t>?

         // object is hold here and released then it is dead
        _currentInput = playlist_CurrentInput(pl_Get(getIntf()))
        if _currentInput != nil {

            var_AddCallback(_currentInput!.as_vlc_object_pointer(), "intf-event", InputEvent, bridge(obj: self))
            playbackStatusUpdated()
            _main.mainMenu.setRateControlsEnabled(true)

             if _main.activeVideoPlayback && _main.mainWindow.videoView.isHidden {
                 _main.mainWindow.changePlaylistState(psPlaylistItemChangedEvent)
             }

            inputChanged = vlc_object_hold(_currentInput!.as_vlc_object_pointer())

            _main.playlist.currentlyPlayingItemChanged()

            continuePlaybackWhereYouLeftOff()

            NotificationCenter.default.post(name: VLCInputChangedNotification, object:nil)
        }

        updateMetaAndInfo()
        updateMainWindow()
        updateDelays()
        updateMainMenu()

         /*
          * Due to constraints within NSAttributedString's main loop runtime handling
          * and other issues, we need to inform the extension manager on a separate thread.
          * The serial queue ensures that changed inputs are propagated in the same order as they arrive.
          */
        _informInputChangedQueue.async {
            _main.extensionsManager.inputChanged(inputChanged)
            if inputChanged != nil {
                vlc_object_release(inputChanged!.as_vlc_object_pointer())
            }
         }
     }

    func playbackPositionUpdated() {
//        VLCMain.instance.mainWindow] updateTimeSlider]
//        VLCMain.instance.statusBarIcon] updateProgress]
    }

    func playbackStatusUpdated() {
        // On shutdown, input might not be dead yet. Cleanup actions like inhibit, itunes playback
        // and playback positon are done in different code paths (dealloc and appWillTerminate:).
        if VLCMain.instance.isTerminating {
            return
        }

        var state: Int64 = -1
        if _currentInput != nil {
            state = var_GetInteger(_currentInput!.as_vlc_object_pointer(), "state")
        }

        // cancel itunes timer if next item starts playing
        if state > -1 && state != END_S.rawValue {
            if _hasEndedTimer != nil {
                _hasEndedTimer!.invalidate()
                _hasEndedTimer = nil
            }
        }
         
        if state == PLAYING_S.rawValue {
//            stopItunesPlayback]

            inhibitSleep()
         
            _main.mainMenu.setPause()
            _main.mainWindow.setPause()
        } else {
            _main.mainMenu.setSubmenusEnabled(false)
            _main.mainMenu.setPlay()
            _main.mainWindow.setPlay()
         
            if state == PAUSE_S.rawValue {
                releaseSleepBlockers()
            }
         
            if state == END_S.rawValue || state == -1 {
                /* continue playback where you left off */
                storePlaybackPositionForItem()

                if _hasEndedTimer != nil {
                    _hasEndedTimer!.invalidate()
                }
                _hasEndedTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(onPlaybackHasEnded), userInfo: nil, repeats: false)
            }
        }

//     updateMainWindow]
        sendDistributedNotificationWithUpdatedPlaybackStatus()
    }

     // Called when playback has ended and likely no subsequent media will start playing
    @objc func onPlaybackHasEnded(_ sender: Any?) {
    //     msg_Dbg(getIntf(), "Playback has been ended")
    //
         releaseSleepBlockers()
    //     resumeItunesPlayback]
         _hasEndedTimer = nil
    }

// func stopItunesPlayback -> void
// {
//     intf_thread_t *p_intf = getIntf()
//     int controlItunes = var_InheritInteger(p_intf, "macosx-control-itunes")
//     if (controlItunes <= 0)
//         return
//
//     // pause iTunes
//     if (!b_has_itunes_paused) {
//         iTunesApplication *iTunesApp = (iTunesApplication *) [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"]
//         if (iTunesApp && [iTunesApp isRunning]) {
//             if ([iTunesApp playerState] == iTunesEPlSPlaying) {
//                 msg_Dbg(p_intf, "pausing iTunes")
//                 [iTunesApp pause]
//                 b_has_itunes_paused = true
//             }
//         }
//     }
//
//     // pause Spotify
//     if (!b_has_spotify_paused) {
//         SpotifyApplication *spotifyApp = (SpotifyApplication *) [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"]
//
//         if (spotifyApp) {
//             if ([spotifyApp respondsToSelector:#selector(isRunning)] && [spotifyApp respondsToSelector:#selector(playerState)]) {
//                 if ([spotifyApp isRunning] && [spotifyApp playerState] == kSpotifyPlayerStatePlaying) {
//                     msg_Dbg(p_intf, "pausing Spotify")
//                     [spotifyApp pause]
//                     b_has_spotify_paused = true
//                 }
//             }
//         }
//     }
// }
//
// func resumeItunesPlayback -> void
// {
//     intf_thread_t *p_intf = getIntf()
//     if (var_InheritInteger(p_intf, "macosx-control-itunes") > 1) {
//         if (b_has_itunes_paused) {
//             iTunesApplication *iTunesApp = (iTunesApplication *) [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"]
//             if (iTunesApp && [iTunesApp isRunning]) {
//                 if ([iTunesApp playerState] == iTunesEPlSPaused) {
//                     msg_Dbg(p_intf, "unpausing iTunes")
//                     [iTunesApp playpause]
//                 }
//             }
//         }
//
//         if (b_has_spotify_paused) {
//             SpotifyApplication *spotifyApp = (SpotifyApplication *) [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"]
//             if (spotifyApp) {
//                 if ([spotifyApp respondsToSelector:#selector(isRunning)] && [spotifyApp respondsToSelector:#selector(playerState)]) {
//                     if ([spotifyApp isRunning] && [spotifyApp playerState] == kSpotifyPlayerStatePaused) {
//                         msg_Dbg(p_intf, "unpausing Spotify")
//                         [spotifyApp play]
//                     }
//                 }
//             }
//         }
//     }
//
//     b_has_itunes_paused = false
//     b_has_spotify_paused = false
// }

    private func inhibitSleep() {
        let shouldDisableScreensaver = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "disable-screensaver")

        /* Declare user activity.
         This wakes the display if it is off, and postpones display sleep according to the users system preferences
         Available from 10.7.3 */
        if _main.activeVideoPlayback && shouldDisableScreensaver {
            let success: IOReturn = IOPMAssertionDeclareUserActivity(
                                            "VLC media playback" as CFString,
                                            kIOPMUserActiveLocal,
                                            &_userActivityAssertionID)
            if success != kIOReturnSuccess {
//                msg_Warn(getIntf(), "failed to declare user activity")
            }
        }

        // Only set assertion if no previous / active assertion exist. This is necessary to keep
        // audio only playback awake. If playback switched from video to audio or vice vesa, deactivate
        // the other assertion and activate the needed assertion instead.
        let activateAssertion =  { (assertionType: CFString, assertionIdRef: inout IOPMAssertionID, otherAssertionIdRef: inout IOPMAssertionID) in

            if otherAssertionIdRef > 0 {
//                msg_Dbg(getIntf(), "Releasing old IOKit other assertion (%i)" , *otherAssertionIdRef)
                IOPMAssertionRelease(otherAssertionIdRef)
                otherAssertionIdRef = 0
            }
            if assertionIdRef > 0 {
//                msg_Dbg(getIntf(), "Continue to use IOKit assertion %s (%i)", [(__bridge NSString *)(assertionType) UTF8String], *assertionIdRef)
                return
            }
         
            let success: IOReturn = IOPMAssertionCreateWithName(
                                                assertionType,
                                                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                "VLC media playback" as CFString,
                                                &assertionIdRef)
            if success == kIOReturnSuccess {
//                msg_Dbg(getIntf(), "Activated assertion %s through IOKit (%i)", [(__bridge NSString *)(assertionType) UTF8String], assertionIdRef)
            } else {
//                msg_Warn(getIntf(), "Failed to prevent system sleep through IOKit")
            }
        }
         
        if _main.activeVideoPlayback && shouldDisableScreensaver {
            activateAssertion(kIOPMAssertionTypeNoDisplaySleep as CFString, &_monitorSleepAssertionID, &_systemSleepAssertionID)
        } else {
            activateAssertion(kIOPMAssertionTypeNoIdleSleep as CFString, &_systemSleepAssertionID, &_monitorSleepAssertionID)
        }
    }

    private func releaseSleepBlockers() {
        /* allow the system to sleep again */
        if _systemSleepAssertionID > 0 {
//            msg_Dbg(getIntf(), "Releasing IOKit system sleep blocker (%i)" , systemSleepAssertionID)
            IOPMAssertionRelease(_systemSleepAssertionID)
            _systemSleepAssertionID = 0
        }
        if _monitorSleepAssertionID > 0 {
//            msg_Dbg(getIntf(), "Releasing IOKit monitor sleep blocker (%i)" , monitorSleepAssertionID)
            IOPMAssertionRelease(_monitorSleepAssertionID)
            _monitorSleepAssertionID = 0
        }
    }

    func updateMetaAndInfo() {
        if _currentInput == nil {
            VLCMain.instance.currentMediaInfoPanel.updatePanelWithItem(nil)
            return
        }

        let p_input_item = input_GetItem(_currentInput)
        _main.playlist.model.updateItem(p_input_item)
        VLCMain.instance.currentMediaInfoPanel.updatePanelWithItem(p_input_item)
    }

// func updateMainWindow -> void
// {
//     [_main.mainWindow.updateWindow]
// }

    func updateName() {
//     [_main.mainWindow.updateName]
    }

    func updateDelays() {
        VLCMain.instance.trackSyncPanel.updateValues()
    }

    func updateMainMenu() {
        _main.mainMenu.setupMenus()
        _main.mainMenu.updatePlaybackRate()
        VLCCoreInteraction.instance.resetAtoB()
    }

    private func sendDistributedNotificationWithUpdatedPlaybackStatus() {
        DistributedNotificationCenter.default().postNotificationName(NSNotification.Name("VLCPlayerStateDidChange"), object: nil, userInfo: nil, deliverImmediately: true)
    }

    var hasInput: Bool {
        return _currentInput != nil
    }

// MARK: - Resume logic

    private func isValidResumeItem(_ p_item: UnsafeMutablePointer<input_item_t>) -> Bool {
        let urlString = getURI(inputItem: p_item)
        if urlString == nil {
            return false
        }

        let url = NSURL(string: urlString!)
        if url?.isFileURL != true {
            return false
        }

        var isDir = ObjCBool(false)
        if !FileManager.default.fileExists(atPath: url!.path!, isDirectory: &isDir) {
            return false
        }
        if isDir.boolValue {
            return false
        }
        return true
    }

    private func continuePlaybackWhereYouLeftOff() {
        if _currentInput == nil {
            return
        }

        let p_item = input_GetItem(_currentInput)
        if p_item == nil {
            return
        }

        /* allow the user to over-write the start/stop/run-time */
        let currentInput = _currentInput!.as_vlc_object_pointer()
        if var_GetFloat(currentInput, "run-time") > 0 ||
            var_GetFloat(currentInput, "start-time") > 0 ||
            var_GetFloat(currentInput, "stop-time") != 0 {
            return
        }

        /* check for file existance before resuming */
        if !isValidResumeItem(p_item!) {
            return
        }

        let url = getURI(inputItem: p_item!)
        if url == nil {
            return
        }

        let recentlyPlayedFiles = VLCInputManager._defaults.object(forKey: "recentlyPlayedMedia") as! [String: Int64]
        let lastPosition = recentlyPlayedFiles[url!]
        if lastPosition == nil || lastPosition! <= 0 {
            return
        }

        let settingValue = config_GetInt("macosx-continue-playback")
        if settingValue == 2 { // never resume
            return
        }

        let completionBlock: CompletionBlock = { (result: ResumeResult) in
            if result == .RESUME_RESTART {
                return
            }
            let lastPos: mtime_t = lastPosition! * 1_000_000
//            msg_Dbg(getIntf(), "continuing playback at %lld", lastPos)
            var_SetInteger(currentInput, "time", lastPos)
        }
         
        if settingValue == 1 { // always
            completionBlock(.RESUME_NOW)
            return
        }
         
        VLCMain.instance.resumeDialog.showWindow(forItem: p_item!, withLastPosition: lastPosition!, completionBlock: completionBlock)
    }

    private func storePlaybackPositionForItem() {
        if _currentInput == nil {
            return
        }

        if !var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-recentitems") {
            return
        }

        let p_item = input_GetItem(_currentInput)
        if p_item == nil {
            return
        }

        if !isValidResumeItem(p_item!) {
            return
        }
        
        let url = getURI(inputItem: p_item!)
        if url == nil {
            return
        }

        var mutDict = VLCInputManager._defaults.object(forKey: "recentlyPlayedMedia") as! [String: Int64]
        let mediaList = VLCInputManager._defaults.object(forKey: "recentlyPlayedMediaList") as! NSMutableArray

        let currentInput = _currentInput!.as_vlc_object_pointer()
        let relativePos = var_GetFloat(currentInput, "position")
        let pos: mtime_t = var_GetInteger(currentInput, "time") / CLOCK_FREQ
        let dur: mtime_t = input_item_GetDuration(p_item) / 1000000

        if relativePos > 0.05 && relativePos < 0.95 && dur > 180 {
//            msg_Dbg(getIntf(), "Store current playback position of %f", relativePos)
            mutDict[url!] = pos
            mediaList.remove(url!)
            mediaList.add(url!)

            let mediaListCount = mediaList.count
            if mediaListCount > 30 {
                for _ in 0..<(mediaListCount - 30) {
                    mutDict[mediaList.firstObject as! String] = nil
                    mediaList.removeObject(at: 0)
                }
            }
        } else {
            mutDict[url!] = nil
            mediaList.remove(url!)
        }

        VLCInputManager._defaults.set(mutDict, forKey: "recentlyPlayedMedia")
        VLCInputManager._defaults.set(mediaList, forKey: "recentlyPlayedMediaList")
        VLCInputManager._defaults.synchronize()
    }
}
