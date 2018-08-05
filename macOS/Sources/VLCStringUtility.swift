//
//  VLCStringUtility.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 18/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

/* Get an alternate version of the string.
 * This string is stored as '1:string' but when displayed it only displays
 * the translated string. the translation should be '1:translatedstring' though */
//#define _ANS(s) [((s) ? toNSStr(vlc_gettext(s)) : "") substringFromIndex:2]

//#define B64DecNSStr(s) VLCStringUtility.b64Decode: s]
//#define B64EncAndFree(s) VLCStringUtility.b64EncodeAndFree: s]


let kVLCMediaAudioCD = "AudioCD"
let kVLCMediaDVD = "DVD"
let kVLCMediaVCD = "VCD"
let kVLCMediaSVCD = "SVCD"
let kVLCMediaBD = "Blu-ray"
let kVLCMediaVideoTSFolder = "VIDEO_TS"
let kVLCMediaBDMVFolder = "BDMV"
let kVLCMediaUnknown = "Unknown"
let CLOCK_FREQ = Int64(1000000)


/* Key Shortcuts */
fileprivate let nskeys_to_vlckeys =
    [
        (NSUpArrowFunctionKey, KEY_UP),
        (NSDownArrowFunctionKey, KEY_DOWN),
        (NSLeftArrowFunctionKey, KEY_LEFT),
        (NSRightArrowFunctionKey, KEY_RIGHT),
        (NSF1FunctionKey, KEY_F1),
        (NSF2FunctionKey, KEY_F2),
        (NSF3FunctionKey, KEY_F3),
        (NSF4FunctionKey, KEY_F4),
        (NSF5FunctionKey, KEY_F5),
        (NSF6FunctionKey, KEY_F6),
        (NSF7FunctionKey, KEY_F7),
        (NSF8FunctionKey, KEY_F8),
        (NSF9FunctionKey, KEY_F9),
        (NSF10FunctionKey, KEY_F10),
        (NSF11FunctionKey, KEY_F11),
        (NSF12FunctionKey, KEY_F12),
        (NSInsertFunctionKey, KEY_INSERT),
        (NSHomeFunctionKey, KEY_HOME),
        (NSEndFunctionKey, KEY_END),
        (NSPageUpFunctionKey, KEY_PAGEUP),
        (NSPageDownFunctionKey, KEY_PAGEDOWN),
        (NSMenuFunctionKey, KEY_MENU),
        (NSTabCharacter, KEY_TAB),
        (NSCarriageReturnCharacter, KEY_ENTER),
        (NSEnterCharacter, KEY_ENTER),
        (NSBackspaceCharacter, KEY_BACKSPACE),
        (NSDeleteCharacter, KEY_DELETE),
        (0, 0)
    ]

/**
 * Gets an image resource
 */
func imageFromRes(_ name: String) -> NSImage {
    return NSImage(named: NSImage.Name(name))!
}

/*
 * Takes the first value of an cocoa key string, and converts it to VLCs int representation.
 */
func CocoaKeyToVLC(_ i_key: Unicode.Scalar) -> UInt32 {
    for i in 0..<nskeys_to_vlckeys.count {
        let (nskey, vlckey) = nskeys_to_vlckeys[i]
        if nskey == i_key.value {
            return UInt32(vlckey)
        }
    }
    return i_key.value
}


class VLCStringUtility {

//- (NSString *)OSXStringKeyToString:(NSString *)theString

//- (NSString *)b64Decode:(NSString *)string
//- (NSString *)b64EncodeAndFree:(char *)psz_string

//- (NSString *)getVolumeTypeFromMountPath:(NSString *)mountPath
//- (NSString *)getBSDNodeFromMountPath:(NSString *)mountPath

// MARK: - String utility

    /* toWidth is in pixels */
    class func wrapString(_ theString: String, toWidth width: Int) -> String {

        let attributes = [NSAttributedStringKey.font: NSFont.labelFont(ofSize: 0)]
        let o_storage = NSTextStorage(string: theString, attributes: attributes)
        let o_layout_manager = NSLayoutManager()
        let o_container = NSTextContainer(size: NSMakeSize(CGFloat(width), 2000))

        o_layout_manager.addTextContainer(o_container)
        o_storage.addLayoutManager(o_layout_manager)

        let o_wrapped = NSMutableString(string: theString)
        let glyphRange = o_layout_manager.glyphRange(for: o_container)

        var breaksInserted = 0
        let maxRange: Int = NSMaxRange(glyphRange)
        var glyphIndex: Int = glyphRange.location

        while glyphIndex < maxRange {
            var effectiveRange = NSRange()
            o_layout_manager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: &effectiveRange)
            let charRange = o_layout_manager.characterRange(forGlyphRange: effectiveRange, actualGlyphRange: &effectiveRange)
            let aRange = NSMakeRange(charRange.location + breaksInserted, charRange.length)

            if o_wrapped.lineRange(for: aRange).length > charRange.length {
                o_wrapped.insert("\n", at: NSMaxRange(charRange) + breaksInserted)
                breaksInserted += 1
            }
            glyphIndex += effectiveRange.length
        }
        return String(o_wrapped)
    }

    class func getCurrentTimeAsString(input: UnsafeMutablePointer<input_thread_t>, negative: Bool) -> String {

        var psz_time = [CChar](repeating: 0, count: Int(MSTRTIME_MAX_SIZE))
        let t = var_GetInteger(input.as_vlc_object_pointer(), "time")
        let dur: mtime_t = input_item_GetDuration(input_GetItem(input))

        if negative && dur > 0 {
            let remaining: mtime_t = dur > t ? dur - t : 0
            return "-\(String(cString: secstotimestr(&psz_time, Int32(remaining/1_000_000))))"
        }
        return String(cString: secstotimestr(&psz_time, Int32(t/Int64(CLOCK_FREQ))))
    }

    class func stringForTime(_ time : Int64) -> String {
        if time > 0 {
            let positiveDuration: Int64 = llabs(time)
            if positiveDuration > 3600 {
                return String(format: "%s%01ld:%02ld:%02ld",
                              time < 0 ? "-" : "",
                              CLong(positiveDuration / 3600),
                              CLong((positiveDuration / 60) % 60),
                              CLong(positiveDuration % 60))
            } else {
                return String(format: "%s%02ld:%02ld",
                              time < 0 ? "-" : "",
                              CLong((positiveDuration / 60) % 60),
                              CLong(positiveDuration % 60))
            }
        } else {
            // Return a string that represents an undefined time.
            return "--:--"
        }
    }

    /*
     * Converts VLC key string to a prettified version, for hotkey settings.
     * The returned string adapts similar how its done within the cocoa framework when setting this
     * key to menu items.
     */
    class func OSXStringKeyToString(_ theString: String) -> String {
//    if (!theString.isEqualToString:""]) {
//        /* remove cruft */
//        if (theString.characterAtIndex:(theString.length - 1)] != 0x2b)
//        theString = theString.replacingOccurrences(of: "+", with: ""]
//        } else {
//            theString = theString.replacingOccurrences(of: "+", with: ""]
//            theString = String(format: "%@+", theString]
//        }
//        if (theString.characterAtIndex:(theString.length - 1)] != 0x2d)
//        theString = theString.replacingOccurrences(of: "-", with: ""]
//        } else {
//            theString = theString.replacingOccurrences(of: "-", with: ""]
//            theString = String(format: "%@-", theString]
//        }
//        /* modifiers */
//        theString = theString.replacingOccurrences(of: "Command", with:  [NSString stringWithUTF8String:"\xE2\x8C\x98"]]
//        theString = theString.replacingOccurrences(of: "Alt", with:  [NSString stringWithUTF8String:"\xE2\x8C\xA5"]]
//        theString = theString.replacingOccurrences(of: "Shift", with:  [NSString stringWithUTF8String:"\xE2\x87\xA7"]]
//        theString = theString.replacingOccurrences(of: "Ctrl", with:  [NSString stringWithUTF8String:"\xE2\x8C\x83"]]
//        /* show non-character keys correctly */
//        theString = theString.replacingOccurrences(of: "Right", with: [NSString stringWithUTF8String:"\xE2\x86\x92"]]
//        theString = theString.replacingOccurrences(of: "Left", with: [NSString stringWithUTF8String:"\xE2\x86\x90"]]
//        theString = theString.replacingOccurrences(of: "Page Up", with: [NSString stringWithUTF8String:"\xE2\x87\x9E"]]
//        theString = theString.replacingOccurrences(of: "Page Down", with: [NSString stringWithUTF8String:"\xE2\x87\x9F"]]
//        theString = theString.replacingOccurrences(of: "Up", with: [NSString stringWithUTF8String:"\xE2\x86\x91"]]
//        theString = theString.replacingOccurrences(of: "Down", with: [NSString stringWithUTF8String:"\xE2\x86\x93"]]
//        theString = theString.replacingOccurrences(of: "Enter", with: [NSString stringWithUTF8String:"\xe2\x86\xb5"]]
//        theString = theString.replacingOccurrences(of: "Tab", with: [NSString stringWithUTF8String:"\xe2\x87\xa5"]]
//        theString = theString.replacingOccurrences(of: "Delete", with: [NSString stringWithUTF8String:"\xe2\x8c\xab"]];        /* capitalize plain characters to suit the menubar's look */
//        theString = theString.capitalizedString]
//    }
//    } else
//    theString = [NSString stringWithString:_NS("Not Set")]
//    return theString
    }

    /*
     * Converts VLC key string to cocoa modifiers which can be used as setKeyEquivalent for menu items
     */
    class func VLCModifiersToCocoa(_ theString: String) -> NSEvent.ModifierFlags {
        var ret = NSEvent.ModifierFlags()
        if theString.range(of: "Command")!.isEmpty {
            ret.insert(.command)
        }
        if !theString.range(of: "Alt")!.isEmpty {
            ret.insert(.option)
        }
        if !theString.range(of: "Shift")!.isEmpty {
            ret.insert(.shift)
        }
        if !theString.range(of: "Ctrl")!.isEmpty {
            ret.insert(.control)
        }
        return ret
    }

    /*
     * Converts VLC key to cocoa string which can be used as setKeyEquivalentModifierMask for menu items
     */
    class func VLCKeyToString(_ theString: String) -> String {
        var theString = theString
        if theString != "" {
            if theString.last != Character(Unicode.Scalar(0x2b)) {
                theString = theString.replacingOccurrences(of: "+", with: "")
            } else {
                theString = theString.replacingOccurrences(of: "+", with: "")
                theString = String(format: "%@+", theString)
            }
            if theString.last != Character(Unicode.Scalar(0x2d)) {
                theString = theString.replacingOccurrences(of: "-", with: "")
            } else {
                theString = theString.replacingOccurrences(of: "-", with: "")
                theString = String(format: "%@-", theString)
            }
            theString = theString.replacingOccurrences(of: "Command", with: "")
            theString = theString.replacingOccurrences(of: "Alt", with: "")
            theString = theString.replacingOccurrences(of: "Shift", with: "")
            theString = theString.replacingOccurrences(of: "Ctrl", with: "")
        }

        if theString.count > 1 {
            if !theString.range(of: "Page Up")!.isEmpty {
                return String(format: "%C", NSPageUpFunctionKey)
            } else if !theString.range(of: "Page Down")!.isEmpty {
                return String(format: "%C", NSPageDownFunctionKey)
            } else if !theString.range(of: "Up")!.isEmpty {
                return String(format: "%C", NSUpArrowFunctionKey)
            } else if !theString.range(of: "Down")!.isEmpty {
                return String(format: "%C", NSDownArrowFunctionKey)
            } else if !theString.range(of: "Right")!.isEmpty {
                return String(format: "%C", NSRightArrowFunctionKey)
            } else if !theString.range(of: "Left")!.isEmpty {
                return String(format: "%C", NSLeftArrowFunctionKey)
            } else if !theString.range(of: "Enter")!.isEmpty {
                return String(format: "%C", NSEnterCharacter); // we treat NSCarriageReturnCharacter as aquivalent
            } else if !theString.range(of: "Insert")!.isEmpty {
                return String(format: "%C", NSInsertFunctionKey)
            } else if !theString.range(of: "Home")!.isEmpty {
                return String(format: "%C", NSHomeFunctionKey)
            } else if !theString.range(of: "End")!.isEmpty {
                return String(format: "%C", NSEndFunctionKey)
            } else if !theString.range(of: "Menu")!.isEmpty {
                return String(format: "%C", NSMenuFunctionKey)
            } else if !theString.range(of: "Tab")!.isEmpty {
                return String(format: "%C", NSTabCharacter)
            } else if !theString.range(of: "Backspace")!.isEmpty {
                return String(format: "%C", NSBackspaceCharacter)
            } else if !theString.range(of: "Delete")!.isEmpty {
                return String(format: "%C", NSDeleteCharacter)
            } else if !theString.range(of: "F12")!.isEmpty {
                return String(format: "%C", NSF12FunctionKey)
            } else if !theString.range(of: "F11")!.isEmpty {
                return String(format: "%C", NSF11FunctionKey)
            } else if !theString.range(of: "F10")!.isEmpty {
                return String(format: "%C", NSF10FunctionKey)
            } else if !theString.range(of: "F9")!.isEmpty {
                return String(format: "%C", NSF9FunctionKey)
            } else if !theString.range(of: "F8")!.isEmpty {
                return String(format: "%C", NSF8FunctionKey)
            } else if !theString.range(of: "F7")!.isEmpty {
                return String(format: "%C", NSF7FunctionKey)
            } else if !theString.range(of: "F6")!.isEmpty {
                return String(format: "%C", NSF6FunctionKey)
            } else if !theString.range(of: "F5")!.isEmpty {
                return String(format: "%C", NSF5FunctionKey)
            } else if !theString.range(of: "F4")!.isEmpty {
                return String(format: "%C", NSF4FunctionKey)
            } else if !theString.range(of: "F3")!.isEmpty {
                return String(format: "%C", NSF3FunctionKey)
            } else if !theString.range(of: "F2")!.isEmpty {
                return String(format: "%C", NSF2FunctionKey)
            } else if !theString.range(of: "F1")!.isEmpty {
                return String(format: "%C", NSF1FunctionKey)
            } else if !theString.range(of: "Space")!.isEmpty {
                return " "
            }
            /* note that we don't support esc here, since it is reserved for leaving fullscreen */
        }
        return theString
    }

// MARK: - base64 helpers

//- (NSString *)b64Decode:(NSString *)string
//{
//    char *psz_decoded_string = vlc_b64_decode([string UTF8String])
//    if(!psz_decoded_string)
//    return ""
//
//    NSString *returnStr = String(format: "%s", psz_decoded_string]
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
//    NSString *returnStr = String(format: "%s", psz_encoded_string]
//    free(psz_encoded_string)
//
//    return returnStr
//    }

    class func getBSDNode(fromMountPath mountPath: String) -> String {
        let stf: statfs
        if statfs(NSURL(fileURLWithPath: mountPath).fileSystemRepresentation, &stf) != 0 {
            return ""
        }
        return String(format: "r%s", stf.f_mntfromname)
    }

    class func getVolumeType(fromMountPath mountPath: String) -> String {
        let mountUrl = NSURL(fileURLWithPath: mountPath)
        var returnValue: String?

        let stf: statfs
        if statfs(mountUrl.fileSystemRepresentation, &stf) != 0 {
            return ""
        }

        let matchingDict: CFMutableDictionary = IOBSDNameMatching(kIOMasterPortDefault, 0, stf.f_mntfromname)
        let service: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, matchingDict)
        if (IO_OBJECT_NULL != service) {
            if IOObjectConformsTo(service, kIOCDMediaClass) {
                returnValue = kVLCMediaAudioCD
            } else if IOObjectConformsTo(service, kIODVDMediaClass) {
                returnValue = kVLCMediaDVD
            } else if IOObjectConformsTo(service, kIOBDMediaClass) {
                returnValue = kVLCMediaBD
            }
            IOObjectRelease(service)

            if returnValue != nil {
                return returnValue!
            }
        }

        if mountPath.range(of: "VIDEO_TS", options:[.caseInsensitive, .backwards])!.isEmpty {
            returnValue = kVLCMediaVideoTSFolder
        } else if mountPath.range(of: "BDMV", options:[.caseInsensitive, .backwards])!.isEmpty {
            returnValue = kVLCMediaBDMVFolder
        } else {
            // NSFileManager is not thread-safe, don't use defaultManager outside of the main thread
            let fm = FileManager()

            let dirContents = fm.contentsOfDirectory(atPath: mountPath)
            for i in 0..<dirContents.count {
                let currentFile = dirContents[i]
                let fullPath = mountPath.appendingPathComponent(currentFile)

                var isDir = ObjCBool(false)
                if fm.fileExists(atPath: fullPath, isDirectory: &isDir) && isDir.boolValue {
                    if currentFile.caseInsensitiveCompare("SVCD") == .orderedSame {
                        returnValue = kVLCMediaSVCD
                        break
                    }
                    if currentFile.caseInsensitiveCompare("VCD") == .orderedSame {
                        returnValue = kVLCMediaVCD
                        break
                    }
                    if currentFile.caseInsensitiveCompare("BDMV") == .orderedSame {
                        returnValue = kVLCMediaBDMVFolder
                        break
                    }
                    if currentFile.caseInsensitiveCompare("VIDEO_TS") == .orderedSame {
                        returnValue = kVLCMediaVideoTSFolder
                        break
                    }
                }
            }

            if returnValue == nil {
                returnValue = kVLCMediaVideoTSFolder
            }
        }
        return returnValue!
    }
}

extension String {
    static fromCString(_ str: UnsafePointer<CChar>?) -> String? {
        if str == nil {
            return nil
        }
        let newStr = String(cString: str)
        free(str)
        return newStr
    }
}
