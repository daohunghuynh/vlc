//
//  VLCInputManager.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 02/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import Foundation

// static int InputThreadChanged(vlc_object_t *p_this, const char *psz_var,
//                               vlc_value_t oldval, vlc_value_t new_val, void *param)
// {
//     @autoreleasepool {
//         VLCInputManager *inputManager = (__bridge VLCInputManager *)param
//         [inputManager performSelectorOnMainThread:@selector(inputThreadChanged) withObject:nil waitUntilDone:false]
//     }
//
//     return VLC_SUCCESS
// }
//
// static NSDate *lastPositionUpdate = nil
//
// static int InputEvent(vlc_object_t *p_this, const char *psz_var,
//                       vlc_value_t oldval, vlc_value_t new_val, void *param)
// {
//     @autoreleasepool {
//         VLCInputManager *inputManager = (__bridge VLCInputManager *)param
//
//         switch (new_val.i_int) {
//             case INPUT_EVENT_STATE:
//                 [inputManager performSelectorOnMainThread:@selector(playbackStatusUpdated) withObject: nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_RATE:
//                 [[[VLCMain sharedInstance] mainMenu] performSelectorOnMainThread:@selector(updatePlaybackRate) withObject: nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_POSITION:
//
//                 // Rate limit to 100 ms
//                 if (lastPositionUpdate && fabs([lastPositionUpdate timeIntervalSinceNow]) < 0.1)
//                     break
//
//                 lastPositionUpdate = [NSDate date]
//
//                 [inputManager performSelectorOnMainThread:@selector(playbackPositionUpdated) withObject:nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_TITLE:
//             case INPUT_EVENT_CHAPTER:
//                 [inputManager performSelectorOnMainThread:@selector(updateMainMenu) withObject: nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_CACHE:
//                 [inputManager performSelectorOnMainThread:@selector(updateMainWindow) withObject:nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_STATISTICS:
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [[[VLCMain sharedInstance] currentMediaInfoPanel] updateStatistics]
//                 })
//                 break
//             case INPUT_EVENT_ES:
//                 break
//             case INPUT_EVENT_TELETEXT:
//                 break
//             case INPUT_EVENT_AOUT:
//                 break
//             case INPUT_EVENT_VOUT:
//                 break
//             case INPUT_EVENT_ITEM_META:
//             case INPUT_EVENT_ITEM_INFO:
//                 [inputManager performSelectorOnMainThread:@selector(updateMainMenu) withObject: nil waitUntilDone:false]
//                 [inputManager performSelectorOnMainThread:@selector(updateName) withObject: nil waitUntilDone:false]
//                 [inputManager performSelectorOnMainThread:@selector(updateMetaAndInfo) withObject: nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_BOOKMARK:
//                 break
//             case INPUT_EVENT_RECORD:
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [[[VLCMain sharedInstance] mainMenu] updateRecordState: var_InheritBool(p_this, "record")]
//                 })
//                 break
//             case INPUT_EVENT_PROGRAM:
//                 [inputManager performSelectorOnMainThread:@selector(updateMainMenu) withObject: nil waitUntilDone:false]
//                 break
//             case INPUT_EVENT_ITEM_EPG:
//                 break
//             case INPUT_EVENT_SIGNAL:
//                 break
//
//             case INPUT_EVENT_AUDIO_DELAY:
//             case INPUT_EVENT_SUBTITLE_DELAY:
//                 [inputManager performSelectorOnMainThread:@selector(updateDelays) withObject:nil waitUntilDone:false]
//                 break
//
//             case INPUT_EVENT_DEAD:
//                 [inputManager performSelectorOnMainThread:@selector(updateName) withObject: nil waitUntilDone:false]
//                 [[[VLCMain sharedInstance] mainWindow] performSelectorOnMainThread:@selector(updateTimeSlider) withObject:nil waitUntilDone:false]
//                 break
//
//             default:
//                 break
//         }
//
//         return VLC_SUCCESS
//     }
// }


// MARK: - InputManager implementation

class VLCInputManager {

// func initWithMain:(VLCMain *)o_mainObj; -> id
//
// func inputThreadChanged; -> void
//
// func playbackPositionUpdated; -> void
//
// func hasInput; -> Bool

// private weak VLCMain *o_main
//
// private input_thread_t *p_current_input
// private dispatch_queue_t informInputChangedQueue
//
///* sleep management */
// private IOPMAssertionID systemSleepAssertionID
// private IOPMAssertionID monitorSleepAssertionID
//
// private IOPMAssertionID userActivityAssertionID
//
// private NSTimer *hasEndedTimer


// + (void)initialize
// {
//     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]
//     NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  [NSArray array], @"recentlyPlayedMediaList",
//                                  [NSDictionary dictionary], @"recentlyPlayedMedia", nil]
//
//     [defaults registerDefaults:appDefaults]
// }
//
// func initWithMain:(VLCMain *)o_mainObj -> id
// {
//     self = [super init]
//     if(self) {
//         msg_Dbg(getIntf(), "Initializing input manager")
//
//         o_main = o_mainObj
//         var_AddCallback(pl_Get(getIntf()), "input-current", InputThreadChanged, (__bridge void *)self)
//
//         informInputChangedQueue = dispatch_queue_create("org.videolan.vlc.inputChangedQueue", DISPATCH_QUEUE_SERIAL)
//
//     }
//     return self
// }
//
// func dealloc -> void
// {
//     msg_Dbg(getIntf(), "Deinitializing input manager")
//     if (p_current_input) {
//         /* continue playback where you left off */
//         [self storePlaybackPositionForItem:p_current_input]
//
//         var_DelCallback(p_current_input, "intf-event", InputEvent, (__bridge void *)self)
//         vlc_object_release(p_current_input)
//         p_current_input = NULL
//     }
//
//     var_DelCallback(pl_Get(getIntf()), "input-current", InputThreadChanged, (__bridge void *)self)
//
// #if !OS_OBJECT_USE_OBJC
//     dispatch_release(informInputChangedQueue)
// #endif
// }
//
// func inputThreadChanged -> void
// {
//     if (p_current_input) {
//         var_DelCallback(p_current_input, "intf-event", InputEvent, (__bridge void *)self)
//         vlc_object_release(p_current_input)
//         p_current_input = NULL
//
//         [[o_main mainMenu] setRateControlsEnabled: false]
//
//         [[NSNotificationCenter defaultCenter] postNotificationName:VLCInputChangedNotification
//                                                             object:nil]
//     }
//
//     // Cancel pending resume dialogs
//     [[[VLCMain sharedInstance] resumeDialog] cancel]
//
//     input_thread_t *p_input_changed = NULL
//
//     // object is hold here and released then it is dead
//     p_current_input = playlist_CurrentInput(pl_Get(getIntf()))
//     if (p_current_input) {
//         var_AddCallback(p_current_input, "intf-event", InputEvent, (__bridge void *)self)
//         [self playbackStatusUpdated]
//         [[o_main mainMenu] setRateControlsEnabled: true]
//
//         if ([o_main activeVideoPlayback] && [[[o_main mainWindow] videoView] isHidden]) {
//             [[o_main mainWindow] changePlaylistState: psPlaylistItemChangedEvent]
//         }
//
//         p_input_changed = vlc_object_hold(p_current_input)
//
//         [[o_main playlist] currentlyPlayingItemChanged]
//
//         [self continuePlaybackWhereYouLeftOff:p_current_input]
//
//         [[NSNotificationCenter defaultCenter] postNotificationName:VLCInputChangedNotification
//                                                             object:nil]
//     }
//
//     [self updateMetaAndInfo]
//
//     [self updateMainWindow]
//     [self updateDelays]
//     [self updateMainMenu]
//
//     /*
//      * Due to constraints within NSAttributedString's main loop runtime handling
//      * and other issues, we need to inform the extension manager on a separate thread.
//      * The serial queue ensures that changed inputs are propagated in the same order as they arrive.
//      */
//     dispatch_async(informInputChangedQueue, ^{
//         [[o_main extensionsManager] inputChanged:p_input_changed]
//         if (p_input_changed)
//             vlc_object_release(p_input_changed)
//     })
// }
//
// func playbackPositionUpdated -> void
// {
//     [[[VLCMain sharedInstance] mainWindow] updateTimeSlider]
//     [[[VLCMain sharedInstance] statusBarIcon] updateProgress]
// }

 func playbackStatusUpdated() {
//     // On shutdown, input might not be dead yet. Cleanup actions like inhibit, itunes playback
//     // and playback positon are done in different code paths (dealloc and appWillTerminate:).
//     if ([[VLCMain sharedInstance] isTerminating]) {
//         return
//     }
//
//     intf_thread_t *p_intf = getIntf()
//     int state = -1
//     if (p_current_input) {
//         state = var_GetInteger(p_current_input, "state")
//     }
//
//     // cancel itunes timer if next item starts playing
//     if (state > -1 && state != END_S) {
//         if (hasEndedTimer) {
//             [hasEndedTimer invalidate]
//             hasEndedTimer = nil
//         }
//     }
//
//     if (state == PLAYING_S) {
//         [self stopItunesPlayback]
//
//         [self inhibitSleep]
//
//         [[o_main mainMenu] setPause]
//         [[o_main mainWindow] setPause]
//     } else {
//         [[o_main mainMenu] setSubmenusEnabled: FALSE]
//         [[o_main mainMenu] setPlay]
//         [[o_main mainWindow] setPlay]
//
//         if (state == PAUSE_S)
//             [self releaseSleepBlockers]
//
//         if (state == END_S || state == -1) {
//             /* continue playback where you left off */
//             if (p_current_input)
//                 [self storePlaybackPositionForItem:p_current_input]
//
//             if (hasEndedTimer) {
//                 [hasEndedTimer invalidate]
//             }
//             hasEndedTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
//                                                              target: self
//                                                            selector: @selector(onPlaybackHasEnded:)
//                                                            userInfo: nil
//                                                             repeats: false]
//         }
//     }
//
//     [self updateMainWindow]
//     [self sendDistributedNotificationWithUpdatedPlaybackStatus]
 }

     // Called when playback has ended and likely no subsequent media will start playing
    func onPlaybackHasEnded(_ sender: Any?) {
    //     msg_Dbg(getIntf(), "Playback has been ended")
    //
    //     [self releaseSleepBlockers]
    //     [self resumeItunesPlayback]
    //     hasEndedTimer = nil
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
//             if ([spotifyApp respondsToSelector:@selector(isRunning)] && [spotifyApp respondsToSelector:@selector(playerState)]) {
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
//                 if ([spotifyApp respondsToSelector:@selector(isRunning)] && [spotifyApp respondsToSelector:@selector(playerState)]) {
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
//
// func inhibitSleep -> void
// {
//     Bool shouldDisableScreensaver = var_InheritBool(getIntf(), "disable-screensaver")
//
//     /* Declare user activity.
//      This wakes the display if it is off, and postpones display sleep according to the users system preferences
//      Available from 10.7.3 */
//     if ([o_main activeVideoPlayback] && &IOPMAssertionDeclareUserActivity && shouldDisableScreensaver)
//     {
//         CFStringRef reasonForActivity = CFStringCreateWithCString(kCFAllocatorDefault, _("VLC media playback"), kCFStringEncodingUTF8)
//         IOReturn success = IOPMAssertionDeclareUserActivity(reasonForActivity,
//                                                             kIOPMUserActiveLocal,
//                                                             &userActivityAssertionID)
//         CFRelease(reasonForActivity)
//
//         if (success != kIOReturnSuccess)
//             msg_Warn(getIntf(), "failed to declare user activity")
//
//     }
//
//     // Only set assertion if no previous / active assertion exist. This is necessary to keep
//     // audio only playback awake. If playback switched from video to audio or vice vesa, deactivate
//     // the other assertion and activate the needed assertion instead.
//     void(^activateAssertion)(CFStringRef, IOPMAssertionID*, IOPMAssertionID*) = ^void(CFStringRef assertionType, IOPMAssertionID* assertionIdRef, IOPMAssertionID* otherAssertionIdRef) {
//
//         if (*otherAssertionIdRef > 0) {
//             msg_Dbg(getIntf(), "Releasing old IOKit other assertion (%i)" , *otherAssertionIdRef)
//             IOPMAssertionRelease(*otherAssertionIdRef)
//             *otherAssertionIdRef = 0
//         }
//
//         if (*assertionIdRef) {
//             msg_Dbg(getIntf(), "Continue to use IOKit assertion %s (%i)", [(__bridge NSString *)(assertionType) UTF8String], *assertionIdRef)
//             return
//         }
//
//         CFStringRef reasonForActivity = CFStringCreateWithCString(kCFAllocatorDefault, _("VLC media playback"), kCFStringEncodingUTF8)
//
//         IOReturn success = IOPMAssertionCreateWithName(assertionType, kIOPMAssertionLevelOn, reasonForActivity, assertionIdRef)
//         CFRelease(reasonForActivity)
//
//         if (success == kIOReturnSuccess)
//             msg_Dbg(getIntf(), "Activated assertion %s through IOKit (%i)", [(__bridge NSString *)(assertionType) UTF8String], *assertionIdRef)
//         else
//             msg_Warn(getIntf(), "Failed to prevent system sleep through IOKit")
//     }
//
//     if ([o_main activeVideoPlayback] && shouldDisableScreensaver) {
//         activateAssertion(kIOPMAssertionTypeNoDisplaySleep, &monitorSleepAssertionID, &systemSleepAssertionID)
//     } else {
//         activateAssertion(kIOPMAssertionTypeNoIdleSleep, &systemSleepAssertionID, &monitorSleepAssertionID)
//     }
//
// }
//
// func releaseSleepBlockers -> void
// {
//     /* allow the system to sleep again */
//     if (systemSleepAssertionID > 0) {
//         msg_Dbg(getIntf(), "Releasing IOKit system sleep blocker (%i)" , systemSleepAssertionID)
//         IOPMAssertionRelease(systemSleepAssertionID)
//         systemSleepAssertionID = 0
//     }
//
//     if (monitorSleepAssertionID > 0) {
//         msg_Dbg(getIntf(), "Releasing IOKit monitor sleep blocker (%i)" , monitorSleepAssertionID)
//         IOPMAssertionRelease(monitorSleepAssertionID)
//         monitorSleepAssertionID = 0
//     }
// }
//
// func updateMetaAndInfo -> void
// {
//     if (!p_current_input) {
//         [[[VLCMain sharedInstance] currentMediaInfoPanel] updatePanelWithItem:nil]
//         return
//     }
//
//     input_item_t *p_input_item = input_GetItem(p_current_input)
//
//     [[[o_main playlist] model] updateItem:p_input_item]
//     [[[VLCMain sharedInstance] currentMediaInfoPanel] updatePanelWithItem:p_input_item]
// }
//
// func updateMainWindow -> void
// {
//     [[o_main mainWindow] updateWindow]
// }
//
// func updateName -> void
// {
//     [[o_main mainWindow] updateName]
// }
//
// func updateDelays -> void
// {
//     [[[VLCMain sharedInstance] trackSyncPanel] updateValues]
// }
//
// func updateMainMenu -> void
// {
//     [[o_main mainMenu] setupMenus]
//     [[o_main mainMenu] updatePlaybackRate]
//     [[VLCCoreInteraction sharedInstance] resetAtoB]
// }
//
// func sendDistributedNotificationWithUpdatedPlaybackStatus -> void
// {
//     [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"VLCPlayerStateDidChange"
//                                                                    object:nil
//                                                                  userInfo:nil
//                                                        deliverImmediately:true]
// }
//
// func hasInput -> Bool
// {
//     return p_current_input != NULL
// }

// MARK: - Resume logic

// func isValidResumeItem:(input_item_t *)p_item -> Bool
// {
//     char *psz_url = input_item_GetURI(p_item)
//     NSString *urlString = toNSStr(psz_url)
//     free(psz_url)
//
//     if ([urlString isEqualToString:@""])
//         return false
//
//     NSURL *url = [NSURL URLWithString:urlString]
//
//     if (![url isFileURL])
//         return false
//
//     Bool isDir = false
//     if (![[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir])
//         return false
//
//     if (isDir)
//         return false
//
//     return true
// }
//
// func continuePlaybackWhereYouLeftOff:(input_thread_t *)p_input_thread -> void
// {
//     NSDictionary *recentlyPlayedFiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentlyPlayedMedia"]
//     if (!recentlyPlayedFiles)
//         return
//
//     input_item_t *p_item = input_GetItem(p_input_thread)
//     if (!p_item)
//         return
//
//     /* allow the user to over-write the start/stop/run-time */
//     if (var_GetFloat(p_input_thread, "run-time") > 0 ||
//         var_GetFloat(p_input_thread, "start-time") > 0 ||
//         var_GetFloat(p_input_thread, "stop-time") != 0) {
//         return
//     }
//
//     /* check for file existance before resuming */
//     if (![self isValidResumeItem:p_item])
//         return
//
//     char *psz_url = vlc_uri_decode(input_item_GetURI(p_item))
//     if (!psz_url)
//         return
//     NSString *url = toNSStr(psz_url)
//     free(psz_url)
//
//     NSNumber *lastPosition = [recentlyPlayedFiles objectForKey:url]
//     if (!lastPosition || lastPosition.intValue <= 0)
//         return
//
//     int settingValue = config_GetInt("macosx-continue-playback")
//     if (settingValue == 2) // never resume
//         return
//
//     CompletionBlock completionBlock = ^(enum ResumeResult result) {
//
//         if (result == RESUME_RESTART)
//             return
//
//         mtime_t lastPos = (mtime_t)lastPosition.intValue * 1000000
//         msg_Dbg(getIntf(), "continuing playback at %lld", lastPos)
//         var_SetInteger(p_input_thread, "time", lastPos)
//     }
//
//     if (settingValue == 1) { // always
//         completionBlock(RESUME_NOW)
//         return
//     }
//
//     [[[VLCMain sharedInstance] resumeDialog] showWindowWithItem:p_item
//                                                withLastPosition:lastPosition.intValue
//                                                 completionBlock:completionBlock]
//
// }
//
// func storePlaybackPositionForItem:(input_thread_t *)p_input_thread -> void
// {
//     if (!var_InheritBool(getIntf(), "macosx-recentitems"))
//         return
//
//     input_item_t *p_item = input_GetItem(p_input_thread)
//     if (!p_item)
//         return
//
//     if (![self isValidResumeItem:p_item])
//         return
//
//     char *psz_url = vlc_uri_decode(input_item_GetURI(p_item))
//     if (!psz_url)
//         return
//     NSString *url = toNSStr(psz_url)
//     free(psz_url)
//
//     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]
//     NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"recentlyPlayedMedia"]]
//
//     float relativePos = var_GetFloat(p_input_thread, "position")
//     mtime_t pos = var_GetInteger(p_input_thread, "time") / CLOCK_FREQ
//     mtime_t dur = input_item_GetDuration(p_item) / 1000000
//
//     NSMutableArray *mediaList = [[defaults objectForKey:@"recentlyPlayedMediaList"] mutableCopy]
//
//     if (relativePos > .05 && relativePos < .95 && dur > 180) {
//         msg_Dbg(getIntf(), "Store current playback position of %f", relativePos)
//         [mutDict setObject:[NSNumber numberWithInt:pos] forKey:url]
//
//         [mediaList removeObject:url]
//         [mediaList addObject:url]
//         NSUInteger mediaListCount = mediaList.count
//         if (mediaListCount > 30) {
//             for (NSUInteger x = 0; x < mediaListCount - 30; x++) {
//                 [mutDict removeObjectForKey:[mediaList firstObject]]
//                 [mediaList removeObjectAtIndex:0]
//             }
//         }
//     } else {
//         [mutDict removeObjectForKey:url]
//         [mediaList removeObject:url]
//     }
//     [defaults setObject:mutDict forKey:@"recentlyPlayedMedia"]
//     [defaults setObject:mediaList forKey:@"recentlyPlayedMediaList"]
//     [defaults synchronize]
// }

}
