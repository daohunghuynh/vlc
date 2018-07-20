//
//  VLCStringUtility.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 18/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import Foundation


/* Get an alternate version of the string.
 * This string is stored as '1:string' but when displayed it only displays
 * the translated string. the translation should be '1:translatedstring' though */
//#define _ANS(s) [((s) ? toNSStr(vlc_gettext(s)) : "") substringFromIndex:2]

//#define B64DecNSStr(s) [[VLCStringUtility sharedInstance] b64Decode: s]
//#define B64EncAndFree(s) [[VLCStringUtility sharedInstance] b64EncodeAndFree: s]


//NSString *toNSStr(const char *str)
//unsigned int CocoaKeyToVLC(unichar i_key)

let kVLCMediaAudioCD = "AudioCD"
let kVLCMediaDVD = "DVD"
let kVLCMediaVCD = "VCD"
let kVLCMediaSVCD = "SVCD"
let kVLCMediaBD = "Blu-ray"
let kVLCMediaVideoTSFolder = "VIDEO_TS"
let kVLCMediaBDMVFolder = "BDMV"
let kVLCMediaUnknown = "Unknown"

/**
 * Gets an image resource
 */
//NSImage *imageFromRes(NSString *name)


/*
 * Takes the first value of an cocoa key string, and converts it to VLCs int representation.
 */
func CocoaKeyToVLC(_ i_key: Unicode.Scalar) -> UInt32 {
    //    unsigned int i
    //
    //    for (i = 0; nskeys_to_vlckeys[i].i_nskey != 0; i++) {
    //        if (nskeys_to_vlckeys[i].i_nskey == i_key) {
    //            return nskeys_to_vlckeys[i].i_vlckey
    //        }
    //    }
    return i_key.value
}

class VLCStringUtility {

    static let instance: VLCStringUtility = VLCStringUtility()

    private init() {
    }

//- (NSString *)wrapString: (NSString *)o_in_string toWidth: (int)i_width
//- (NSString *)getCurrentTimeAsString:(input_thread_t *)p_input negative:(BOOL)b_negative
//- (NSString *)stringForTime:(long long int)time

//- (NSString *)OSXStringKeyToString:(NSString *)theString

//- (NSString *)b64Decode:(NSString *)string
//- (NSString *)b64EncodeAndFree:(char *)psz_string

//- (NSString *)getVolumeTypeFromMountPath:(NSString *)mountPath
//- (NSString *)getBSDNodeFromMountPath:(NSString *)mountPath



//#pragma mark String utility

/* i_width is in pixels */
//- (NSString *)wrapString:(NSString *)o_in_string toWidth:(int)i_width
//{
//    NSMutableString *o_wrapped
//    NSString *o_out_string
//    NSRange glyphRange, effectiveRange, charRange
//    NSRect lineFragmentRect
//    unsigned glyphIndex, breaksInserted = 0
//
//    NSTextStorage *o_storage = [[NSTextStorage alloc] initWithString: o_in_string
//    attributes: [NSDictionary dictionaryWithObjectsAndKeys:
//    [NSFont labelFontOfSize: 0.0], NSFontAttributeName, nil]]
//    NSLayoutManager *o_layout_manager = [[NSLayoutManager alloc] init]
//    NSTextContainer *o_container = [[NSTextContainer alloc]
//    initWithContainerSize: NSMakeSize(i_width, 2000)]
//
//    [o_layout_manager addTextContainer: o_container]
//    [o_storage addLayoutManager: o_layout_manager]
//
//    o_wrapped = [o_in_string mutableCopy]
//    glyphRange = [o_layout_manager glyphRangeForTextContainer: o_container]
//
//    for (glyphIndex = glyphRange.location ; glyphIndex < NSMaxRange(glyphRange)
//        glyphIndex += effectiveRange.length) {
//            lineFragmentRect = [o_layout_manager lineFragmentRectForGlyphAtIndex: glyphIndex
//                effectiveRange: &effectiveRange]
//            charRange = [o_layout_manager characterRangeForGlyphRange: effectiveRange
//                actualGlyphRange: &effectiveRange]
//            if ([o_wrapped lineRangeForRange:
//                NSMakeRange(charRange.location + breaksInserted, charRange.length)].length > charRange.length) {
//                [o_wrapped insertString: "\n" atIndex: NSMaxRange(charRange) + breaksInserted]
//                breaksInserted++
//            }
//    }
//    o_out_string = [NSString stringWithString: o_wrapped]
//
//    return o_out_string
//    }

//    - (NSString *)getCurrentTimeAsString:(input_thread_t *)p_input negative:(BOOL)b_negative
//{
//    assert(p_input != nil)
//
//    char psz_time[MSTRTIME_MAX_SIZE]
//    int64_t t = var_GetInteger(p_input, "time")
//
//    mtime_t dur = input_item_GetDuration(input_GetItem(p_input))
//    if (b_negative && dur > 0) {
//        mtime_t remaining = 0
//        if (dur > t)
//        remaining = dur - t
//        return [NSString stringWithFormat: "-%s", secstotimestr(psz_time, (remaining / 1000000))]
//    } else
//    return toNSStr(secstotimestr(psz_time, t / CLOCK_FREQ ))
//    }

//    - (NSString *)stringForTime:(long long int)time
//{
//    if (time > 0) {
//        long long positiveDuration = llabs(time)
//        if (positiveDuration > 3600)
//        return [NSString stringWithFormat:"%s%01ld:%02ld:%02ld",
//            time < 0 ? "-" : "",
//            (long) (positiveDuration / 3600),
//            (long)((positiveDuration / 60) % 60),
//            (long) (positiveDuration % 60)]
//        else
//        return [NSString stringWithFormat:"%s%02ld:%02ld",
//            time < 0 ? "-" : "",
//            (long)((positiveDuration / 60) % 60),
//            (long) (positiveDuration % 60)]
//    } else {
//        // Return a string that represents an undefined time.
//        return "--:--"
//    }
//}

//#pragma mark Key Shortcuts

//static struct
//{
//    unichar i_nskey
//    unsigned int i_vlckey
//} nskeys_to_vlckeys[] =
//    {
//        { NSUpArrowFunctionKey, KEY_UP },
//        { NSDownArrowFunctionKey, KEY_DOWN },
//        { NSLeftArrowFunctionKey, KEY_LEFT },
//        { NSRightArrowFunctionKey, KEY_RIGHT },
//        { NSF1FunctionKey, KEY_F1 },
//        { NSF2FunctionKey, KEY_F2 },
//        { NSF3FunctionKey, KEY_F3 },
//        { NSF4FunctionKey, KEY_F4 },
//        { NSF5FunctionKey, KEY_F5 },
//        { NSF6FunctionKey, KEY_F6 },
//        { NSF7FunctionKey, KEY_F7 },
//        { NSF8FunctionKey, KEY_F8 },
//        { NSF9FunctionKey, KEY_F9 },
//        { NSF10FunctionKey, KEY_F10 },
//        { NSF11FunctionKey, KEY_F11 },
//        { NSF12FunctionKey, KEY_F12 },
//        { NSInsertFunctionKey, KEY_INSERT },
//        { NSHomeFunctionKey, KEY_HOME },
//        { NSEndFunctionKey, KEY_END },
//        { NSPageUpFunctionKey, KEY_PAGEUP },
//        { NSPageDownFunctionKey, KEY_PAGEDOWN },
//        { NSMenuFunctionKey, KEY_MENU },
//        { NSTabCharacter, KEY_TAB },
//        { NSCarriageReturnCharacter, KEY_ENTER },
//        { NSEnterCharacter, KEY_ENTER },
//        { NSBackspaceCharacter, KEY_BACKSPACE },
//        { NSDeleteCharacter, KEY_DELETE },
//        {0,0}
//}

/* takes a good old const c string and converts it to NSString without UTF8 loss */

//NSString *toNSStr(const char *str) {
//    return str != NULL ? [NSString stringWithUTF8String:str] : ""
//    }

    /*
     * Converts VLC key string to a prettified version, for hotkey settings.
     * The returned string adapts similar how its done within the cocoa framework when setting this
     * key to menu items.
     */
//    - (NSString *)OSXStringKeyToString:(NSString *)theString
//{
//    if (![theString isEqualToString:""]) {
//        /* remove cruft */
//        if ([theString characterAtIndex:([theString length] - 1)] != 0x2b)
//        theString = [theString stringByReplacingOccurrencesOfString:"+" withString:""]
//        else {
//            theString = [theString stringByReplacingOccurrencesOfString:"+" withString:""]
//            theString = [NSString stringWithFormat:"%@+", theString]
//        }
//        if ([theString characterAtIndex:([theString length] - 1)] != 0x2d)
//        theString = [theString stringByReplacingOccurrencesOfString:"-" withString:""]
//        else {
//            theString = [theString stringByReplacingOccurrencesOfString:"-" withString:""]
//            theString = [NSString stringWithFormat:"%@-", theString]
//        }
//        /* modifiers */
//        theString = [theString stringByReplacingOccurrencesOfString:"Command" withString: [NSString stringWithUTF8String:"\xE2\x8C\x98"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Alt" withString: [NSString stringWithUTF8String:"\xE2\x8C\xA5"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Shift" withString: [NSString stringWithUTF8String:"\xE2\x87\xA7"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Ctrl" withString: [NSString stringWithUTF8String:"\xE2\x8C\x83"]]
//        /* show non-character keys correctly */
//        theString = [theString stringByReplacingOccurrencesOfString:"Right" withString:[NSString stringWithUTF8String:"\xE2\x86\x92"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Left" withString:[NSString stringWithUTF8String:"\xE2\x86\x90"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Page Up" withString:[NSString stringWithUTF8String:"\xE2\x87\x9E"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Page Down" withString:[NSString stringWithUTF8String:"\xE2\x87\x9F"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Up" withString:[NSString stringWithUTF8String:"\xE2\x86\x91"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Down" withString:[NSString stringWithUTF8String:"\xE2\x86\x93"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Enter" withString:[NSString stringWithUTF8String:"\xe2\x86\xb5"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Tab" withString:[NSString stringWithUTF8String:"\xe2\x87\xa5"]]
//        theString = [theString stringByReplacingOccurrencesOfString:"Delete" withString:[NSString stringWithUTF8String:"\xe2\x8c\xab"]];        /* capitalize plain characters to suit the menubar's look */
//        theString = [theString capitalizedString]
//    }
//    else
//    theString = [NSString stringWithString:_NS("Not Set")]
//    return theString
//    }

    /*
     * Converts VLC key string to cocoa modifiers which can be used as setKeyEquivalent for menu items
     */
    func VLCModifiersToCocoa(_ theString: String) -> UInt {
        var ret: UInt = 0

//    if ([theString rangeOfString:"Command"].location != NSNotFound)
//    new |= NSCommandKeyMask
//    if ([theString rangeOfString:"Alt"].location != NSNotFound)
//    new |= NSAlternateKeyMask
//    if ([theString rangeOfString:"Shift"].location != NSNotFound)
//    new |= NSShiftKeyMask
//    if ([theString rangeOfString:"Ctrl"].location != NSNotFound)
//    new |= NSControlKeyMask
        return ret
    }

    /*
     * Converts VLC key to cocoa string which can be used as setKeyEquivalentModifierMask for menu items
     */
    func VLCKeyToString(_ theString: String) -> String {
//    if (![theString isEqualToString:""]) {
//        if ([theString characterAtIndex:([theString length] - 1)] != 0x2b)
//        theString = [theString stringByReplacingOccurrencesOfString:"+" withString:""]
//        else {
//            theString = [theString stringByReplacingOccurrencesOfString:"+" withString:""]
//            theString = [NSString stringWithFormat:"%@+", theString]
//        }
//        if ([theString characterAtIndex:([theString length] - 1)] != 0x2d)
//        theString = [theString stringByReplacingOccurrencesOfString:"-" withString:""]
//        else {
//            theString = [theString stringByReplacingOccurrencesOfString:"-" withString:""]
//            theString = [NSString stringWithFormat:"%@-", theString]
//        }
//        theString = [theString stringByReplacingOccurrencesOfString:"Command" withString:""]
//        theString = [theString stringByReplacingOccurrencesOfString:"Alt" withString:""]
//        theString = [theString stringByReplacingOccurrencesOfString:"Shift" withString:""]
//        theString = [theString stringByReplacingOccurrencesOfString:"Ctrl" withString:""]
//    }

//    #ifdef __clang__
//    #pragma GCC diagnostic ignored "-Wformat"
//#endif
//if ([theString length] > 1) {
//    if ([theString rangeOfString:"Page Up"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSPageUpFunctionKey]
//    else if ([theString rangeOfString:"Page Down"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSPageDownFunctionKey]
//    else if ([theString rangeOfString:"Up"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSUpArrowFunctionKey]
//    else if ([theString rangeOfString:"Down"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSDownArrowFunctionKey]
//    else if ([theString rangeOfString:"Right"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSRightArrowFunctionKey]
//    else if ([theString rangeOfString:"Left"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSLeftArrowFunctionKey]
//    else if ([theString rangeOfString:"Enter"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSEnterCharacter]; // we treat NSCarriageReturnCharacter as aquivalent
//    else if ([theString rangeOfString:"Insert"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSInsertFunctionKey]
//    else if ([theString rangeOfString:"Home"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSHomeFunctionKey]
//    else if ([theString rangeOfString:"End"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSEndFunctionKey]
//    else if ([theString rangeOfString:"Menu"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSMenuFunctionKey]
//    else if ([theString rangeOfString:"Tab"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSTabCharacter]
//    else if ([theString rangeOfString:"Backspace"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSBackspaceCharacter]
//    else if ([theString rangeOfString:"Delete"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSDeleteCharacter]
//    else if ([theString rangeOfString:"F12"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF12FunctionKey]
//    else if ([theString rangeOfString:"F11"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF11FunctionKey]
//    else if ([theString rangeOfString:"F10"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF10FunctionKey]
//    else if ([theString rangeOfString:"F9"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF9FunctionKey]
//    else if ([theString rangeOfString:"F8"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF8FunctionKey]
//    else if ([theString rangeOfString:"F7"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF7FunctionKey]
//    else if ([theString rangeOfString:"F6"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF6FunctionKey]
//    else if ([theString rangeOfString:"F5"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF5FunctionKey]
//    else if ([theString rangeOfString:"F4"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF4FunctionKey]
//    else if ([theString rangeOfString:"F3"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF3FunctionKey]
//    else if ([theString rangeOfString:"F2"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF2FunctionKey]
//    else if ([theString rangeOfString:"F1"].location != NSNotFound)
//    return [NSString stringWithFormat:"%C", NSF1FunctionKey]
//    else if ([theString rangeOfString:"Space"].location != NSNotFound)
//    return " "
    /* note that we don't support esc here, since it is reserved for leaving fullscreen */
//}
//#ifdef __clang__
//#pragma GCC diagnostic warning "-Wformat"
//#endif

        return theString
    }

//#pragma mark base64 helpers

//- (NSString *)b64Decode:(NSString *)string
//{
//    char *psz_decoded_string = vlc_b64_decode([string UTF8String])
//    if(!psz_decoded_string)
//    return ""
//
//    NSString *returnStr = [NSString stringWithFormat:"%s", psz_decoded_string]
//    free(psz_decoded_string)
//
//    return returnStr
//    }

//    - (NSString *)b64EncodeAndFree:(char *)psz_string
//{
//    char *psz_encoded_string = vlc_b64_encode(psz_string)
//    free(psz_string)
//    if(!psz_encoded_string)
//    return ""
//
//    NSString *returnStr = [NSString stringWithFormat:"%s", psz_encoded_string]
//    free(psz_encoded_string)
//
//    return returnStr
//    }

//    - (NSString *) getBSDNodeFromMountPath:(NSString *)mountPath
//{
//    struct statfs stf
//    int ret = statfs([mountPath fileSystemRepresentation], &stf)
//    if (ret != 0) {
//        return ""
//    }
//
//    return [NSString stringWithFormat:"r%s", stf.f_mntfromname]
//    }

//    - (NSString *)getVolumeTypeFromMountPath:(NSString *)mountPath
//{
//    struct statfs stf
//    int ret = statfs([mountPath fileSystemRepresentation], &stf)
//    if (ret != 0) {
//        return ""
//    }

//    CFMutableDictionaryRef matchingDict = IOBSDNameMatching(kIOMasterPortDefault, 0, stf.f_mntfromname)
//    io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, matchingDict)
//    NSString *returnValue

//    if (IO_OBJECT_NULL != service) {
//        if (IOObjectConformsTo(service, kIOCDMediaClass))
//        returnValue = kVLCMediaAudioCD
//        else if (IOObjectConformsTo(service, kIODVDMediaClass))
//        returnValue = kVLCMediaDVD
//        else if (IOObjectConformsTo(service, kIOBDMediaClass))
//        returnValue = kVLCMediaBD
//        IOObjectRelease(service)
//
//        if (returnValue)
//        return returnValue
//    }
//
//    out:
//        if ([mountPath rangeOfString:"VIDEO_TS" options:NSCaseInsensitiveSearch | NSBackwardsSearch].location != NSNotFound)
//    returnValue = kVLCMediaVideoTSFolder
//    else if ([mountPath rangeOfString:"BDMV" options:NSCaseInsensitiveSearch | NSBackwardsSearch].location != NSNotFound)
//    returnValue = kVLCMediaBDMVFolder
//    else {
//        // NSFileManager is not thread-safe, don't use defaultManager outside of the main thread
//        NSFileManager * fm = [[NSFileManager alloc] init]
//
//        NSArray *dirContents = [fm contentsOfDirectoryAtPath:mountPath error:nil]
//        for (int i = 0; i < [dirContents count]; i++) {
//            NSString *currentFile = [dirContents objectAtIndex:i]
//            NSString *fullPath = [mountPath stringByAppendingPathComponent:currentFile]
//
//            BOOL isDir
//            if ([fm fileExistsAtPath:fullPath isDirectory:&isDir] && isDir)
//            {
//                if ([currentFile caseInsensitiveCompare:"SVCD"] == NSOrderedSame) {
//                    returnValue = kVLCMediaSVCD
//                    break
//                }
//                if ([currentFile caseInsensitiveCompare:"VCD"] == NSOrderedSame) {
//                    returnValue = kVLCMediaVCD
//                    break
//                }
//                if ([currentFile caseInsensitiveCompare:"BDMV"] == NSOrderedSame) {
//                    returnValue = kVLCMediaBDMVFolder
//                    break
//                }
//                if ([currentFile caseInsensitiveCompare:"VIDEO_TS"] == NSOrderedSame) {
//                    returnValue = kVLCMediaVideoTSFolder
//                    break
//                }
//            }
//        }
//
//        if (!returnValue)
//        returnValue = kVLCMediaVideoTSFolder
//    }
//
//    return returnValue
//}
}

