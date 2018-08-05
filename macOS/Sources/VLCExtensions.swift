//
//  VLCExtensions.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 21/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import AppKit
import Foundation

extension UnsafeMutablePointer where Pointee == intf_thread_t {
    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
    }
}

extension UnsafeMutablePointer where Pointee == playlist_t {
    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
    }
}

extension UnsafeMutablePointer where Pointee == input_thread_t {
    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
    }
}

extension UnsafeMutablePointer where Pointee == audio_output_t {
    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
    }
}

extension UnsafeMutablePointer where Pointee == vout_thread_t {
    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
    }
}

extension UnsafeMutablePointer where Pointee == libvlc_int_t {
    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
    }
}

extension UnsafeMutablePointer where Pointee == vlc_object_t {
    func as_vout_thread_pointer() -> UnsafeMutablePointer<vout_thread_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: vout_thread_t.self, capacity: 1)
    }

    func as_intf_thread_pointer() -> UnsafeMutablePointer<intf_thread_t> {
        return UnsafeMutableRawPointer(self).bindMemory(to: intf_thread_t.self, capacity: 1)
    }
}

//extension UnsafeMutableRawPointer {
//    func as_vlc_object_pointer() -> UnsafeMutablePointer<vlc_object_t> {
//        return UnsafeMutableRawPointer(self).bindMemory(to: vlc_object_t.self, capacity: 1)
//    }
//}

extension NSScreen {
    var displayID: Int {
        return (self.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! NSNumber).intValue
    }

    class func screen(withDisplayID displayID: CGDirectDisplayID) -> NSScreen? {
        let count = NSScreen.screens.count

        for i in 0..<count {
            let screen = NSScreen.screens[i]
            if screen.displayID == displayID {
                return screen
            }
        }
        return nil
    }

    // TODO
    func blackoutOtherScreens() {
        /* Free our previous blackout window (follow blackoutWindow alloc strategy) */
//        [blackoutWindows makeObjectsPerformSelector:#selector(close)];
//        [blackoutWindows removeAllObjects];

//        NSUInteger screenCount = [[NSScreen screens] count];
//        for (NSUInteger i = 0; i < screenCount; i++) {
//            NSScreen *screen = [[NSScreen screens] objectAtIndex:i];
//            VLCWindow *blackoutWindow;
//            NSRect screen_rect;
//
//            if ([self isScreen: screen])
//            continue;
//
//            screen_rect = [screen frame];
//            screen_rect.origin.x = screen_rect.origin.y = 0;

            /* blackoutWindow alloc strategy
             - The NSMutableArray blackoutWindows has the blackoutWindow references
             - blackoutOtherDisplays is responsible for alloc/releasing its Windows
             */
//            blackoutWindow = [[VLCWindow alloc] initWithContentRect: screen_rect styleMask: NSBorderlessWindowMask
//                backing: NSBackingStoreBuffered defer: NO screen: screen];
//            [blackoutWindow setBackgroundColor:[NSColor blackColor]];
//            [blackoutWindow setLevel: NSFloatingWindowLevel]; /* Disappear when Expose is triggered */
//            [blackoutWindow setReleasedWhenClosed:NO]; // window is released when deleted from array above
//
//            [blackoutWindow displayIfNeeded];
//            [blackoutWindow orderFront: self animate: YES];
//
//            [blackoutWindows addObject: blackoutWindow];
//
//            [screen setFullscreenPresentationOptions];
//        }
    }

    func setFullscreenPresentationOptions() {
//        NSApplicationPresentationOptions presentationOpts = [NSApp presentationOptions];
//        if ([self hasMenuBar])
//        presentationOpts |= NSApplicationPresentationAutoHideMenuBar;
//        if ([self hasMenuBar] || [self hasDock])
//        presentationOpts |= NSApplicationPresentationAutoHideDock;
//        [NSApp setPresentationOptions:presentationOpts];
    }

    func setNonFullscreenPresentationOptions() {
//        let presentationOpts: NSApplicationPresentationOptions = NSApp.presentationOptions
//        if self.hasMenuBar() {
//            presentationOpts &= (~NSApplicationPresentationAutoHideMenuBar)
//        }
//        if self.hasMenuBar || self.hasDock {
//            presentationOpts &= (~NSApplicationPresentationAutoHideDock)
//        }
//        NSApp.setPresentationOptions(presentationOpts)
    }
    
    static func unblackoutScreens() {
//        let blackoutWindowCount = blackoutWindows.count
//
//        for i in 0..<blackoutWindowCount {
//            let blackoutWindow: VLCWindow = blackoutWindows[i]
//            blackoutWindow.screen.setNonFullscreenPresentationOptions()
//            blackoutWindow.closeAndAnimate = true
//        }
    }
}

func bridge<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
    // return unsafeAddressOf(obj) // ***
}

func bridge<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    // return unsafeBitCast(ptr, T.self) // ***
}
