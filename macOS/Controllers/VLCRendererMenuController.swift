//
//  VLCRendererMenuController.swift
//  VLC
//
//  Created by Dao Hung Huynh on 10/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

class VLCRendererMenuController {
//    private NSMutableDictionary         *_rendererItems;
//    private NSMutableArray              *_rendererDiscoveries;
//    private BOOL                         _isDiscoveryEnabled;
//    private NSMenuItem                  *_selectedItem;
//
//    private intf_thread_t               *p_intf;
//    private vlc_renderer_discovery_t    *p_rd;

    weak var rendererMenu: NSMenu?
    weak var rendererNoneItem: NSMenuItem?

//    - (void)startRendererDiscoveries;
//    - (void)stopRendererDiscoveries;
//    - (void)selectRenderer:(NSMenuItem *)sender;

// - (instancetype)init
// {
//     self = [super init];
//     if (self) {
//         _rendererItems = [NSMutableDictionary dictionary];
//         _rendererDiscoveries = [NSMutableArray array];
//         _isDiscoveryEnabled = NO;
//         p_intf = getIntf();
//
//         [self loadRendererDiscoveries];
//     }
//     return self;
// }
//
// - (void)awakeFromNib
// {
//     _selectedItem = _rendererNoneItem;
// }
//
// - (void)dealloc
// {
//     [self stopRendererDiscoveries];
// }
//
// - (void)loadRendererDiscoveries
// {
//     playlist_t *playlist = pl_Get(p_intf);
//
//     // Service Discovery subnodes
//     char **ppsz_longnames;
//     char **ppsz_names;
//
//     if (vlc_rd_get_names(playlist, &ppsz_names, &ppsz_longnames) != VLC_SUCCESS) {
//         return;
//     }
//     char **ppsz_name = ppsz_names;
//     char **ppsz_longname = ppsz_longnames;
//
//     for( ; *ppsz_name; ppsz_name++, ppsz_longname++) {
//         VLCRendererDiscovery *dc = [[VLCRendererDiscovery alloc] initWithName:*ppsz_name andLongname:*ppsz_longname];
//         [dc setDelegate:self];
//         [_rendererDiscoveries addObject:dc];
//         free(*ppsz_name);
//         free(*ppsz_longname);
//     }
//     free(ppsz_names);
//     free(ppsz_longnames);
// }
//
// #pragma mark - Renderer item management
//
// - (void)addRendererItem:(VLCRendererItem *)item
// {
//     // Check if the item is already selected
//     if (_selectedItem.representedObject != nil)
//     {
//         VLCRendererItem *selected_rd_item = _selectedItem.representedObject;
//         if ([selected_rd_item.identifier isEqualToString:item.identifier])
//         {
//             [_selectedItem setRepresentedObject:item];
//             return;
//         }
//     }
//
//     // Create a menu item
//     NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:item.name
//                                                       action:#selector(selectRenderer:)
//                                                keyEquivalent:@""];
//     if (item.capabilityFlags & VLC_RENDERER_CAN_VIDEO)
//         [menuItem setImage:[NSImage imageNamed:@"sidebar-movie"]];
//     else
//         [menuItem setImage:[NSImage imageNamed:@"sidebar-music"]];
//     [menuItem setTarget:self];
//     [menuItem setRepresentedObject:item];
//     [_rendererMenu insertItem:menuItem atIndex:[_rendererMenu indexOfItem:_rendererNoneItem] + 1];
// }
//
// - (void)removeRendererItem:(VLCRendererItem *)item
// {
//     NSInteger index = [_rendererMenu indexOfItemWithRepresentedObject:item];
//     if (index != NSNotFound) {
//         NSMenuItem *menuItem = [_rendererMenu itemAtIndex:index];
//         // Don't remove selected item
//         if (menuItem != _selectedItem)
//             [_rendererMenu removeItemAtIndex:index];
//     }
// }
//
// - (void)startRendererDiscoveries
// {
//     _isDiscoveryEnabled = YES;
//     for (VLCRendererDiscovery *dc in _rendererDiscoveries) {
//         [dc startDiscovery];
//     }
// }
//
// - (void)stopRendererDiscoveries
// {
//     _isDiscoveryEnabled = NO;
//     for (VLCRendererDiscovery *dc in _rendererDiscoveries) {
//         [dc stopDiscovery];
//     }
// }
//
// - (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
//     if (menuItem == _rendererNoneItem ||
//         [[menuItem representedObject] isKindOfClass:[VLCRendererItem class]]) {
//         return _isDiscoveryEnabled;
//     }
//     return [menuItem isEnabled];
// }
//
// - (void)selectRenderer:(NSMenuItem *)sender
// {
//     [_rendererNoneItem setState:NSOffState];
//
//     [_selectedItem setState:NSOffState];
//     [sender setState:NSOnState];
//     _selectedItem = sender;
//
//     VLCRendererItem* item = [sender representedObject];
//     playlist_t *playlist = pl_Get(p_intf);
//
//     if (!playlist)
//         return;
//
//     if (item) {
//         [item setRendererForPlaylist:playlist];
//     } else {
//         [self unsetRendererForPlaylist:playlist];
//     }
// }
//
// - (void)unsetRendererForPlaylist:(playlist_t*)playlist
// {
//     playlist_SetRenderer(playlist, NULL);
// }
//
// #pragma mark VLCRendererDiscovery delegate methods
// - (void)addedRendererItem:(VLCRendererItem *)item from:(VLCRendererDiscovery *)sender
// {
//     [self addRendererItem:item];
// }
//
// - (void)removedRendererItem:(VLCRendererItem *)item from:(VLCRendererDiscovery *)sender
// {
//     [self removeRendererItem:item];
// }
//
// #pragma mark Menu actions
// - (IBAction)toggleRendererDiscovery:(id)sender {
//     if (_isDiscoveryEnabled) {
//         [self stopRendererDiscoveries];
//     } else {
//         [self startRendererDiscoveries];
//     }
// }

}
