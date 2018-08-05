//
//  VLCMainWindowTitleView.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 31/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

class VLCMainWindowTitleView: VLCThreePartImageView {

//    @property (readwrite, strong) IBOutlet VLCCustomWindowCloseButton *redButton
//    @property (readwrite, strong) IBOutlet VLCCustomWindowMinimizeButton *yellowButton
//    @property (readwrite, strong) IBOutlet VLCCustomWindowZoomButton *greenButton
//    @property (readwrite, strong) IBOutlet VLCCustomWindowFullscreenButton *fullscreenButton
//    @property (readwrite, strong) IBOutlet VLCWindowTitleTextField *titleLabel
//
//    @property (readonly) NSButton * closeButton
//    @property (readonly) NSButton * minimizeButton
//    @property (readonly) NSButton * zoomButton

//    func loadButtonIcons -> (void)
//    func buttonAction:(id)sender -> (IBAction)
//    func setWindowButtonOver:(Bool)b_value -> (void)
//    func setWindowFullscreenButtonOver:(Bool)b_value -> (void)

//    NSImage *_redImage
//    NSImage *_redHoverImage
//    NSImage *_redOnClickImage
//    NSImage * _yellowImage
//    NSImage * _yellowHoverImage
//    NSImage * _yellowOnClickImage
//    NSImage * _greenImage
//    NSImage * _greenHoverImage
//    NSImage * _greenOnClickImage
    // yosemite fullscreen images
//    NSImage * _fullscreenImage
//    NSImage * _fullscreenHoverImage
//    NSImage * _fullscreenOnClickImage
    // old native fullscreen images
//    NSImage * _oldFullscreenImage
//    NSImage * _oldFullscreenHoverImage
//    NSImage * _oldFullscreenOnClickImage

//    NSShadow * _windowTitleShadow
//    NSDictionary * _windowTitleAttributesDictionary

//    Bool b_nativeFullscreenMode

    // state to determine correct image for green bubble
    private var alt_pressed: Bool = false
//    Bool b_mouse_over

//    func init -> (id)
//    {
//        self = [super init]
//
//        if (self) {
//            _windowTitleAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor whiteColor], NSForegroundColorAttributeName, [NSFont titleBarFontOfSize:12.0], NSFontAttributeName, nil]
//        }
//
//        return self
//    }

//    func dealloc -> (void)
//    {
//        [[NSNotificationCenter defaultCenter] removeObserver: self]
//    }

//    func awakeFromNib -> (void)
//    {
//        b_nativeFullscreenMode = var_InheritBool(getIntf(), "macosx-nativefullscreenmode")
//
//        if (!b_nativeFullscreenMode || OSX_YOSEMITE_AND_HIGHER) {
//            [_fullscreenButton setHidden: true]
//        }
//
//        [self setAutoresizesSubviews: true]
//        [self setImagesLeft:imageFromRes(@"topbar-dark-left") middle: imageFromRes(@"topbar-dark-center-fill") right:imageFromRes(@"topbar-dark-right")]
//
//        [self loadButtonIcons]
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: #selector(controlTintChanged:) name: NSControlTintDidChangeNotification object: nil]
//    }

//    func controlTintChanged:(NSNotification *)notification -> (void)
//    {
//        [self loadButtonIcons]
//
//        [_redButton.setNeedsDisplay]
//        [_yellowButton.setNeedsDisplay]
//        [_greenButton.setNeedsDisplay]
//    }

    func informModifierPressed(isOptionKey: Bool) {
        let b_state_changed = self.alt_pressed != isOptionKey
        self.alt_pressed = isOptionKey
        if b_state_changed {
            self.updateGreenButton()
        }
    }

//    func getButtonImage:(NSString *)o_id -> (NSImage *)
//    {
//        NSString *o_name = @""
//        if (OSX_YOSEMITE_AND_HIGHER) {
//            o_name = @"yosemite-"
//        } else { // OSX_LION_AND_HIGHER, OSX_MOUNTAIN_LION_AND_HIGHER, OSX_MAVERICKS_AND_HIGHER
//            o_name = @"lion-"
//        }
//
//        o_name = [o_name stringByAppendingString:o_id]
//
//        if ([NSColor currentControlTint] != NSBlueControlTint) {
//            o_name = [o_name stringByAppendingString:@"-graphite"]
//        }
//
//        return [NSImage imageNamed:o_name]
//    }

//    func loadButtonIcons -> (void)
//    {
//        _redImage = [self getButtonImage:@"window-close"]
//        _redHoverImage = [self getButtonImage:@"window-close-over"]
//        _redOnClickImage = [self getButtonImage:@"window-close-on"]
//        _yellowImage = [self getButtonImage:@"window-minimize"]
//        _yellowHoverImage = [self getButtonImage:@"window-minimize-over"]
//        _yellowOnClickImage = [self getButtonImage:@"window-minimize-on"]
//        _greenImage = [self getButtonImage:@"window-zoom"]
//        _greenHoverImage = [self getButtonImage:@"window-zoom-over"]
//        _greenOnClickImage = [self getButtonImage:@"window-zoom-on"]
//
//        // these files are only available in the yosemite variant
//        if (OSX_YOSEMITE_AND_HIGHER) {
//            _fullscreenImage = [self getButtonImage:@"window-fullscreen"]
//            _fullscreenHoverImage = [self getButtonImage:@"window-fullscreen-over"]
//            _fullscreenOnClickImage = [self getButtonImage:@"window-fullscreen-on"]
//        }
//
//        // old native fullscreen images are not available in graphite style
//        // thus they are loaded directly here
//        _oldFullscreenImage = [NSImage imageNamed:@"lion-window-fullscreen"]
//        _oldFullscreenOnClickImage = [NSImage imageNamed:@"lion-window-fullscreen-on"]
//        _oldFullscreenHoverImage = [NSImage imageNamed:@"lion-window-fullscreen-over"]
//
//        [_redButton setImage: _redImage]
//        [_redButton setAlternateImage: _redHoverImage]
//        [[_redButton cell] setShowsBorderOnlyWhileMouseInside: true]
//        [[_redButton cell] setTag: 0]
//        [_yellowButton setImage: _yellowImage]
//        [_yellowButton setAlternateImage: _yellowHoverImage]
//        [[_yellowButton cell] setShowsBorderOnlyWhileMouseInside: true]
//        [[_yellowButton cell] setTag: 1]
//
//        self.updateGreenButton()
//        [[_greenButton cell] setShowsBorderOnlyWhileMouseInside: true]
//        [[_greenButton cell] setTag: 2]
//
//        [_fullscreenButton setImage: _oldFullscreenImage]
//        [_fullscreenButton setAlternateImage: _oldFullscreenHoverImage]
//        [[_fullscreenButton cell] setShowsBorderOnlyWhileMouseInside: true]
//        [[_fullscreenButton cell] setTag: 3]
//    }

    private func updateGreenButton() {
//        // default image for old version, or if native fullscreen is
//        // disabled on yosemite, or if alt key is pressed
//        if (!OSX_YOSEMITE_AND_HIGHER || !b_nativeFullscreenMode || alt_pressed) {
//
//            if (b_mouse_over) {
//                [_greenButton setImage: _greenHoverImage]
//                [_greenButton setAlternateImage: _greenOnClickImage]
//            } else {
//                [_greenButton setImage: _greenImage]
//                [_greenButton setAlternateImage: _greenOnClickImage]
//            }
//        } else {
//
//            if (b_mouse_over) {
//                [_greenButton setImage: _fullscreenHoverImage]
//                [_greenButton setAlternateImage: _fullscreenOnClickImage]
//            } else {
//                [_greenButton setImage: _fullscreenImage]
//                [_greenButton setAlternateImage: _fullscreenOnClickImage]
//            }
//        }
    }

//    func mouseDownCanMoveWindow -> (Bool)
//    {
//        return true
//    }

//    func buttonAction:(id)sender -> (IBAction)
//    {
//        if (sender == _redButton)
//            [[self window] performClose: sender]
//        else if (sender == _yellowButton)
//            [[self window] miniaturize: sender]
//        else if (sender == _greenButton) {
//            if (OSX_YOSEMITE_AND_HIGHER && b_nativeFullscreenMode && !alt_pressed) {
//                [[self window] toggleFullScreen:self]
//            } else {
//                [[self window] performZoom: sender]
//            }
//        } else if (sender == _fullscreenButton) {
//            // same action as native fs button
//            [[self window] toggleFullScreen:self]
//
//        } else
//            msg_Err(getIntf(), "unknown button action sender")
//
//        [self setWindowButtonOver: NO]
//        [self setWindowFullscreenButtonOver: NO]
//    }

    func setWindowTitle(_ title: String) {
// TODO
//        if (!_windowTitleShadow) {
//            _windowTitleShadow = [[NSShadow alloc] init]
//            [_windowTitleShadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.5]]
//            [_windowTitleShadow setShadowOffset:NSMakeSize(0.0, -1.5)]
//            [_windowTitleShadow setShadowBlurRadius:0.5]
//        }
//
//        NSMutableAttributedString *attributedTitleString = [[NSMutableAttributedString alloc] initWithString:title attributes: _windowTitleAttributesDictionary]
//        NSUInteger i_titleLength = [title length]
//
//        [attributedTitleString addAttribute:NSShadowAttributeName value:_windowTitleShadow range:NSMakeRange(0, i_titleLength)]
//        [attributedTitleString setAlignment: NSCenterTextAlignment range:NSMakeRange(0, i_titleLength)]
//        [_titleLabel setAttributedStringValue:attributedTitleString]
    }

//    func setWindowButtonOver:(Bool)b_value -> (void)
//    {
//        b_mouse_over = b_value
//        if (b_value) {
//            [_redButton setImage: _redHoverImage]
//            [_yellowButton setImage: _yellowHoverImage]
//        } else {
//            [_redButton setImage: _redImage]
//            [_yellowButton setImage: _yellowImage]
//        }
//
//        self.updateGreenButton()
//    }

//    func setWindowFullscreenButtonOver:(Bool)b_value -> (void)
//    {
//        if (b_value)
//            [_fullscreenButton setImage: _oldFullscreenHoverImage]
//        else
//            [_fullscreenButton setImage: _oldFullscreenImage]
//    }

//    func mouseDown:(NSEvent *)event -> (void)
//    {
//        NSPoint ml = [self convertPoint: [event locationInWindow] fromView: self]
//        if (([[self window] frame].size.height - ml.y) <= 22. && [event clickCount] == 2) {
//            //Get settings from "System Preferences" >  "Appearance" > "Double-click on windows title bar to minimize"
//            NSString *const MDAppleMiniaturizeOnDoubleClickKey = @"AppleMiniaturizeOnDoubleClick"
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]
//            [userDefaults addSuiteNamed:NSGlobalDomain]
//
//            if ([[userDefaults objectForKey:MDAppleMiniaturizeOnDoubleClickKey] boolValue])
//                [[self window] miniaturize:self]
//        }
//
//        [super mouseDown: event]
//    }

//    func closeButton -> (NSButton*)
//    {
//        return _redButton
//    }
//
//    func minimizeButton -> (NSButton*)
//    {
//        return _yellowButton
//    }
//
//    func zoomButton -> (NSButton*)
//    {
//        return _greenButton
//    }
}

/*****************************************************************************
 * VLCThreePartImageView interface
 *****************************************************************************/
class VLCThreePartImageView: NSView {

    private var left_img: NSImage?
    private var middle_img: NSImage?
    private var right_img: NSImage?

    func setImagesLeft(left: NSImage, middle: NSImage, right: NSImage) {
       self.left_img = left
       self.middle_img = middle
       self.right_img = right
    }

    override func draw(_ dirtyRect: NSRect) {
       NSDrawThreePartImage(self.bounds, self.left_img, self.middle_img, self.right_img, false, .sourceOver, 1, false)
    }
}

fileprivate class VLCWindowButtonCell: NSButtonCell {

//func mouseEntered:(NSEvent *)theEvent -> (void)
//{
//    if ([self tag] == 3)
//        [(VLCMainWindowTitleView *)[[self controlView] superview] setWindowFullscreenButtonOver: true]
//    else
//        [(VLCMainWindowTitleView *)[[self controlView] superview] setWindowButtonOver: true]
//}
//
//func mouseExited:(NSEvent *)theEvent -> (void)
//{
//    if ([self tag] == 3)
//        [(VLCMainWindowTitleView *)[[self controlView] superview] setWindowFullscreenButtonOver: NO]
//    else
//        [(VLCMainWindowTitleView *)[[self controlView] superview] setWindowButtonOver: NO]
//}
//
///* accessibility stuff */
//func accessibilityAttributeNames { -> (NSArray*)
//    NSArray *theAttributeNames = [super accessibilityAttributeNames]
//    id theControlView = [self controlView]
//    return ([theControlView respondsToSelector: #selector(extendedAccessibilityAttributeNames:)] ? [theControlView extendedAccessibilityAttributeNames: theAttributeNames] : theAttributeNames); // ask the cell's control view (i.e., the button) for additional attribute values
//}
//
//func accessibilityAttributeValue: (NSString*)theAttributeName { -> (id)
//    id theControlView = [self controlView]
//    if ([theControlView respondsToSelector: #selector(extendedAccessibilityAttributeValue:)]) {
//        id theValue = [theControlView extendedAccessibilityAttributeValue: theAttributeName]
//        if (theValue) {
//            return theValue; // if this is an extended attribute value we added, return that -- otherwise, fall back to super's implementation
//        }
//    }
//    return [super accessibilityAttributeValue: theAttributeName]
//}
//
//func accessibilityIsAttributeSettable: (NSString*)theAttributeName { -> (Bool)
//    id theControlView = [self controlView]
//    if ([theControlView respondsToSelector: #selector(extendedAccessibilityIsAttributeSettable:)]) {
//        NSNumber *theValue = [theControlView extendedAccessibilityIsAttributeSettable: theAttributeName]
//        if (theValue)
//            return [theValue boolValue]; // same basic strategy we use in -accessibilityAttributeValue:
//    }
//    return [super accessibilityIsAttributeSettable: theAttributeName]
//}
}

/*****************************************************************************
 * custom window buttons to support the accessibility stuff
 *****************************************************************************/

fileprivate class VLCCustomWindowButtonPrototype: NSButton {

//+ (Class)cellClass {
//    return [VLCWindowButtonCell class]
//}

    func extendedAccessibilityAttributeNames(theAttributeNames: [NSAccessibilityAttributeName]  -> [NSAccessibilityAttributeName] {
        return theAttributeNames.contains(NSAccessibilitySubroleAttribute) ? theAttributeNames : theAttributeNames + [NSAccessibilitySubroleAttribute] // run-of-the-mill button cells don't usually have a Subrole attribute, so we add that attribute
    }

    func extendedAccessibilityAttributeValue(theAttributeName: String) -> Any {
        return nil
    }

    func extendedAccessibilityIsAttributeSettable(theAttributeName: String) -> Int? {
        return theAttributeName == NSAccessibilitySubroleAttribute ? Int(false) : nil // make the Subrole attribute we added non-settable
    }

    func accessibilityPerformAction(theActionName: String) {
        if theActionName == NSAccessibilityPressAction {
            if self.isEnabled {
                self.performClick(nil)
            }
        } else {
            super.accessibilityPerformAction(theActionName)
        }
    }

fileprivate class VLCCustomWindowCloseButton: VLCCustomWindowButtonPrototype {
    func extendedAccessibilityAttributeValue(theAttributeName: String) -> NSAccessibilityAttributeName? {
        return theAttributeName == NSAccessibilitySubroleAttribute ? NSAccessibilityCloseButtonAttribute : nil
    }
}

fileprivate class VLCCustomWindowMinimizeButton: VLCCustomWindowButtonPrototype {
    func extendedAccessibilityAttributeValue(theAttributeName: String) -> NSAccessibilityAttributeName? {
        return theAttributeName == NSAccessibilitySubroleAttribute ? NSAccessibilityMinimizeButtonAttribute : nil
    }
}

fileprivate class VLCCustomWindowZoomButton: VLCCustomWindowButtonPrototype {
    func extendedAccessibilityAttributeValue(theAttributeName: String) -> NSAccessibilityAttributeName? {
        return theAttributeName == NSAccessibilitySubroleAttribute ? NSAccessibilityZoomButtonAttribute : nil
    }
}

fileprivate class VLCCustomWindowFullscreenButton: VLCCustomWindowButtonPrototype {
    func extendedAccessibilityAttributeValue(theAttributeName: String) -> NSAccessibilityAttributeName? {
        return theAttributeName == NSAccessibilitySubroleAttribute ? NSAccessibilityFullScreenButtonAttribute : nil
    }
}

fileprivate class VLCWindowTitleTextField: NSTextField {
    var _contextMenu: NSMenu?

    func showRightClickMenu(withEvent o_event: NSEvent) {
        guard let representedURL = window.representedURL else {
            return
        }
        guard let pathComponents = representedURL.pathComponents else {
            return
        }

        _contextMenu = NSMenu(title: FileManager.defaultManager.displayName(atPath: representedURL.path))

        var icon: NSImage
        var currentItem: NSMenuItem
        var iconSize: NSSize = NSMakeSize(16, 16)

        for i in stride(from: pathComponents.count-1, to: 0, by: -1) {
            let currentPath: [String] = []
            for y in 0..<i {
                currentPath += "\(pathComponents[y+1])"
            }

            _contextMenu.addItem(withTitle: FileManager.defaultManager.displayName(atPath: currentPath), action: #selector(revealInFinder), key: "")
            currentItem = _contextMenu.item(at: _contextMenu.numberOfItems-1)!
            currentItem.target = self

            icon = NSWorkspace.shared.icon(forFile: currentPath)
            icon.size = iconSize
            currentItem.image = icon
        }

//    if ([[pathComponents objectAtIndex:1] isEqualToString:@"Volumes"]) {
//        /* we don't want to show the Volumes item, since the Cocoa does it neither */
//        currentItem = [_contextMenu itemWithTitle:[[NSFileManager defaultManager] displayNameAtPath: @"/Volumes"]]
//        if (currentItem)
//            [_contextMenu removeItem: currentItem]
//    } else {
//        /* we're on the boot drive, so add it since it isn't part of the components */
//        [_contextMenu addItemWithTitle: [[NSFileManager defaultManager] displayNameAtPath:@"/"] action:#selector(revealInFinder:) keyEquivalent:@""]
//        currentItem = [_contextMenu itemAtIndex: [_contextMenu numberOfItems] - 1]
//        icon = [[NSWorkspace sharedWorkspace] iconForFile:@"/"]
//        [icon setSize: iconSize]
//        [currentItem setImage: icon]
//        [currentItem setTarget: self]
//    }
//
//    /* add the computer item */
//    [_contextMenu addItemWithTitle:(NSString*)CFBridgingRelease(SCDynamicStoreCopyComputerName(NULL, NULL)) action:#selector(revealInFinder:) keyEquivalent:@""]
//    currentItem = [_contextMenu itemAtIndex: [_contextMenu numberOfItems] - 1]
//    icon = [NSImage imageNamed: NSImageNameComputer]
//    [icon setSize: iconSize]
//    [currentItem setImage: icon]
//    [currentItem setTarget: self]
//
//    // center the context menu similar to the white interface
//    CGFloat menuWidth = [_contextMenu size].width
//    NSRect windowFrame = [[self window] frame]
//    NSPoint point
//
//    CGFloat fullButtonWidth = 0.
//    if([[VLCMain sharedInstance] nativeFullscreenMode])
//        fullButtonWidth = 20.
//
//    // assumes 60 px for the window buttons
//    point.x = (windowFrame.size.width - 60. - fullButtonWidth) / 2. - menuWidth / 2. + 60. - 20.
//    point.y = windowFrame.size.height + 1.
//    if (point.x < 0)
//        point.x = 10
//
//    NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:NSRightMouseDown
//                                                 location:point
//                                            modifierFlags:0
//                                                timestamp:0
//                                             windowNumber:[[self window] windowNumber]
//                                                  context:nil
//                                              eventNumber:0
//                                               clickCount:0
//                                                 pressure:0]
//    [NSMenu popUpContextMenu: _contextMenu withEvent: fakeMouseEvent forView: [self superview]]
    }

//func revealInFinder:(id)sender -> (IBAction)
//{
//    NSUInteger count = [_contextMenu numberOfItems]
//    NSUInteger selectedItem = [_contextMenu indexOfItem: sender]
//
//    if (selectedItem == count - 1) { // the fake computer item
//        [[NSWorkspace sharedWorkspace] selectFile: @"/" inFileViewerRootedAtPath: @""]
//        return
//    }
//
//    NSURL * representedURL = [[self window] representedURL]
//    if (! representedURL)
//        return
//
//    if (selectedItem == 0) { // the actual file, let's save time
//        [[NSWorkspace sharedWorkspace] selectFile: [representedURL path] inFileViewerRootedAtPath: [representedURL path]]
//        return
//    }
//
//    NSArray * pathComponents
//    pathComponents = [representedURL pathComponents]
//    if (!pathComponents)
//        return
//
//    NSMutableString * currentPath
//    currentPath = [NSMutableString stringWithCapacity:1024]
//    selectedItem = count - selectedItem
//
//    /* fix for non-startup volumes */
//    if ([[pathComponents objectAtIndex:1] isEqualToString:@"Volumes"])
//        selectedItem += 1
//
//    for (NSUInteger y = 1; y < selectedItem; y++)
//        [currentPath appendFormat: @"/%@", [pathComponents objectAtIndex:y]]
//
//    [[NSWorkspace sharedWorkspace] selectFile: currentPath inFileViewerRootedAtPath: currentPath]
//}

    func rightMouseDown(o_event: NSEvent) {
        if o_event.class == NSRightMouseDown {
            showRightClickMenuWithEvent(o_event]
        }
        super.mouseDown(o_event)
    }
}
