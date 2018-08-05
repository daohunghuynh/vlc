//
//  VLCPlaylist.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 21/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation

class VLCPlaylist {

    init() {
        /* This uses a private API, but works fine on all current OSX releases.
         * Radar ID 11739459 request a public API for this. However, it is probably
         * easier and faster to recreate similar looking bitmaps ourselves. */
//        _ascendingSortingImage = NSOutlineView class] _defaultTableHeaderSortImage
//        _descendingSortingImage = [[NSOutlineView class] _defaultTableHeaderReverseSortImage

//        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: NSApplicationWillTerminateNotification, object: nil)


//        _translationsForPlaylistTableColumns = [
//                                             TRACKNUM_COLUMN: "Track Number",
//                                             TITLE_COLUMN: "Title",
//                                             ARTIST_COLUMN: "Author",
//                                             DURATION_COLUMN: "Duration",
//                                             GENRE_COLUMN: "Genre",
//                                             ALBUM_COLUMN: "Album",
//                                             DESCRIPTION_COLUMN: "Description",
//                                             DATE_COLUMN: "Date",
//                                             LANGUAGE_COLUMN: "Language",
//                                             URI_COLUMN: "URI",
//                                             FILESIZE_COLUMN: "File Size"
//                                         ]
        // this array also assigns tags (index) to type of menu item
//        _menuOrderOfPlaylistTableColumns = [TRACKNUM_COLUMN, TITLE_COLUMN,
//                                            ARTIST_COLUMN, DURATION_COLUMN, GENRE_COLUMN, ALBUM_COLUMN,
//                                            DESCRIPTION_COLUMN, DATE_COLUMN, LANGUAGE_COLUMN, URI_COLUMN,
//                                            FILESIZE_COLUMN]
    }

  //   + (void)initialize
  //   {
  //       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //       NSMutableArray *columnArray = [[NSMutableArray alloc] init];
  //       [columnArray addObject: [NSArray arrayWithObjects:TITLE_COLUMN, [NSNumber numberWithFloat:190.], nil]];
  //       [columnArray addObject: [NSArray arrayWithObjects:ARTIST_COLUMN, [NSNumber numberWithFloat:95.], nil]];
  //       [columnArray addObject: [NSArray arrayWithObjects:DURATION_COLUMN, [NSNumber numberWithFloat:95.], nil]];
  //
  //       NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
  //                                    [NSArray arrayWithArray:columnArray], @"PlaylistColumnSelection", nil];
  //
  //       [defaults registerDefaults:appDefaults];
  //   }
  
  //   - (VLCPLModel *)model
  //   {
  //       return _model;
  //   }
  //
  //   - (void)reloadStyles
  //   {
  //       NSFont *fontToUse;
  //       CGFloat rowHeight;
  //       if (var_InheritBool(getIntf(), "macosx-large-text")) {
  //           fontToUse = [NSFont systemFontOfSize:13.];
  //           rowHeight = 21.;
  //       } else {
  //           fontToUse = [NSFont systemFontOfSize:11.];
  //           rowHeight = 16.;
  //       }
  //
  //       NSArray *columns = [_outlineView tableColumns];
  //       NSUInteger count = columns.count;
  //       for (NSUInteger x = 0; x < count; x++)
  //           [[[columns objectAtIndex:x] dataCell] setFont:fontToUse];
  //       [_outlineView setRowHeight:rowHeight];
  //   }
  //
  //   - (void)awakeFromNib
  //   {
  //       // This is only called for the playlist popup menu
  //       [self initStrings];
  //   }
  //
  //   - (void)setOutlineView:(VLCPlaylistView * __nullable)outlineView
  //   {
  //       _outlineView = outlineView;
  //       [_outlineView setDelegate:self];
  //
  //       playlist_t * p_playlist = pl_Get(getIntf())
  //
  //       _model = [[VLCPLModel alloc] initWithOutlineView:_outlineView playlist:p_playlist rootItem:p_playlist->p_playing];
  //       [_outlineView setDataSource:_model];
  //       [_outlineView reloadData];
  //
  //       [_outlineView setTarget: self];
  //       [_outlineView setDoubleAction: #selector(playItem:)];
  //
  //       [_outlineView setAllowsEmptySelection: NO];
  //       [_outlineView registerForDraggedTypes: [NSArray arrayWithObjects:NSFilenamesPboardType, @"VLCPlaylistItemPboardType", nil]];
  //       [_outlineView setIntercellSpacing: NSMakeSize (0.0, 1.0)];
  //
  //       [self reloadStyles];
  //   }
  //
  //   - (void)setPlaylistHeaderView:(NSTableHeaderView * __nullable)playlistHeaderView
  //   {
  //       VLCMainMenu *mainMenu = [[VLCMain sharedInstance] mainMenu];
  //       _playlistHeaderView = playlistHeaderView;
  //
  //       // Setup playlist table column selection for both context and main menu
  //       NSMenu *contextMenu = [[NSMenu alloc] init];
  //       [self setupPlaylistTableColumnsForMenu:contextMenu];
  //       [_playlistHeaderView setMenu: contextMenu];
  //       [self setupPlaylistTableColumnsForMenu:[[[VLCMain sharedInstance] mainMenu] playlistTableColumnsMenu]];
  //
  //       NSArray * columnArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"PlaylistColumnSelection"];
  //       NSUInteger columnCount = [columnArray count];
  //       NSString * column;
  //
  //       for (NSUInteger i = 0; i < columnCount; i++) {
  //           column = [[columnArray objectAtIndex:i] firstObject];
  //           if ([column isEqualToString:@"status"])
  //               continue;
  //
  //           if(![self setPlaylistColumnTableState: NSOnState forColumn:column])
  //               continue;
  //
  //           [[_outlineView tableColumnWithIdentifier: column] setWidth: [[[columnArray objectAtIndex:i] objectAtIndex:1] floatValue]];
  //       }
  //   }
  //
  //   - (void)applicationWillTerminate:(NSNotification *)notification
  //   {
  //       /* let's make sure we save the correct widths and positions, since this likely changed since the last time the user played with the column selection */
  //       [self saveTableColumns];
  //   }
  //
  //   - (void)initStrings
  //   {
  //       [_playPlaylistMenuItem setTitle: _NS("Play")];
  //       [_deletePlaylistMenuItem setTitle: _NS("Delete")];
  //       [_recursiveExpandPlaylistMenuItem setTitle: _NS("Expand All")];
  //       [_recursiveCollapsePlaylistMenuItem setTitle: _NS("Collapse All")];
  //       [_selectAllPlaylistMenuItem setTitle: _NS("Select All")];
  //       [_infoPlaylistMenuItem setTitle: _NS("Media Information...")];
  //       [_revealInFinderPlaylistMenuItem setTitle: _NS("Reveal in Finder")];
  //       [_addFilesToPlaylistMenuItem setTitle: _NS("Add File...")];
  //   }
  //
  //   - (void)playlistUpdated
  //   {
  //       [_outlineView reloadData];
  //   }
  //
  //   - (void)playbackModeUpdated
  //   {
  //       [_model playbackModeUpdated];
  //   }
  //
  //
  //   - (Bool)isSelectionEmpty
  //   {
  //       return [_outlineView selectedRow] == -1;
  //   }
  //
  //   - (void)currentlyPlayingItemChanged
  //   {
  //       VLCPLItem *item = [[self model] currentlyPlayingItem];
  //       if (!item)
  //           return;
  //
  //       // Search for item row for selection
  //       NSInteger itemIndex = [_outlineView rowForItem:item];
  //       if (itemIndex < 0) {
  //           // Expand if needed. This must be done from root to child
  //           // item in order to work
  //           NSMutableArray *itemsToExpand = [NSMutableArray array];
  //           VLCPLItem *tmpItem = [item parent];
  //           while (tmpItem != nil) {
  //               [itemsToExpand addObject:tmpItem];
  //               tmpItem = [tmpItem parent];
  //           }
  //
  //           for(int i = itemsToExpand.count - 1; i >= 0; i--) {
  //               VLCPLItem *currentItem = [itemsToExpand objectAtIndex:i];
  //               [_outlineView expandItem: currentItem];
  //           }
  //       }
  //
  //       // Update highlight for currently playing item
  //       [_outlineView reloadData];
  //
  //       // Search for row again
  //       itemIndex = [_outlineView rowForItem:item];
  //       if (itemIndex < 0) {
  //           return;
  //       }
  //
  //       [_outlineView selectRowIndexes: [NSIndexSet indexSetWithIndex: itemIndex] byExtendingSelection: NO];
  //       [_outlineView scrollRowToVisible: itemIndex];
  //   }
  //
  //   #pragma mark Playlist actions
  //
  //   /* When called retrieves the selected outlineview row and plays that node or item */
  //   - (IBAction)playItem:(id)sender
  //   {
  //       playlist_t *p_playlist = pl_Get(getIntf())
  //
  //       // ignore clicks on column header when handling double action
  //       if (sender == _outlineView && [_outlineView clickedRow] == -1)
  //           return;
  //
  //       VLCPLItem *o_item = [_outlineView itemAtRow:[_outlineView selectedRow]];
  //       if (!o_item)
  //           return;
  //
  //       PL_LOCK;
  //       playlist_item_t *p_item = playlist_ItemGetById(p_playlist, [o_item plItemId])
  //       playlist_item_t *p_node = playlist_ItemGetById(p_playlist, [[[self model] rootItem] plItemId])
  //
  //       if (p_item && p_node) {
  //           playlist_ViewPlay(p_playlist, p_node, p_item)
  //       }
  //       PL_UNLOCK;
  //   }
  //
  //   - (IBAction)revealItemInFinder:(id)sender
  //   {
  //       NSIndexSet *selectedRows = [_outlineView selectedRowIndexes];
  //       if (selectedRows.count < 1)
  //           return;
  //
  //       VLCPLItem *o_item = [_outlineView itemAtRow:selectedRows.firstIndex];
  //
  //       char *psz_url = input_item_GetURI([o_item input])
  //       if (!psz_url)
  //           return;
  //       char *psz_path = vlc_uri2path(psz_url)
  //       NSString *path = toNSStr(psz_path)
  //       free(psz_url)
  //       free(psz_path)
  //
  //       msg_Dbg(getIntf(), "Reveal url %s in finder", [path UTF8String])
  //       [[NSWorkspace sharedWorkspace] selectFile: path inFileViewerRootedAtPath: path];
  //   }
  //
  //   - (IBAction)selectAll:(id)sender
  //   {
  //       [_outlineView selectAll: nil];
  //   }
  //
  //   - (IBAction)showInfoPanel:(id)sender
  //   {
  //       [[[VLCMain sharedInstance] currentMediaInfoPanel] toggleWindow:sender];
  //   }
  //
  //   - (IBAction)addFilesToPlaylist:(id)sender
  //   {
  //       NSIndexSet *selectedRows = [_outlineView selectedRowIndexes];
  //
  //       NSInteger position = -1;
  //       VLCPLItem *parentItem = [[self model] rootItem];
  //
  //       if (selectedRows.count >= 1) {
  //           position = selectedRows.firstIndex + 1;
  //           parentItem = [_outlineView itemAtRow:selectedRows.firstIndex];
  //           if ([parentItem parent] != nil)
  //               parentItem = [parentItem parent];
  //       }
  //
  //       [[[VLCMain sharedInstance] open] openFileWithAction:^(NSArray *files) {
  //           [self addPlaylistItems:files
  //                 withParentItemId:[parentItem plItemId]
  //                            atPos:position
  //                    startPlayback:NO];
  //       }];
  //   }
  //
  //   - (IBAction)deleteItem:(id)sender
  //   {
  //       [_model deleteSelectedItem];
  //   }
  //
  //   // Actions for playlist column selections
  //
  //
  //   - (void)togglePlaylistColumnTable:(id)sender
  //   {
  //       NSInteger i_new_state = ![sender state];
  //       NSInteger i_tag = [sender tag];
  //
  //       NSString *column = [_menuOrderOfPlaylistTableColumns objectAtIndex:i_tag];
  //
  //       [self setPlaylistColumnTableState:i_new_state forColumn:column];
  //   }
  //
  //   - (Bool)setPlaylistColumnTableState:(NSInteger)i_state forColumn:(NSString *)columnId
  //   {
  //       NSUInteger i_tag = [_menuOrderOfPlaylistTableColumns indexOfObject: columnId];
  //       // prevent setting unknown columns
  //       if(i_tag == NSNotFound)
  //           return NO;
  //
  //       // update state of menu items
  //       [[[_playlistHeaderView menu] itemWithTag: i_tag] setState: i_state];
  //       [[[[[VLCMain sharedInstance] mainMenu] playlistTableColumnsMenu] itemWithTag: i_tag] setState: i_state];
  //
  //       // Change outline view
  //       if (i_state == NSOnState) {
  //           NSString *title = [_translationsForPlaylistTableColumns objectForKey:columnId];
  //           if (!title)
  //               return NO;
  //
  //           NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:columnId];
  //           [tableColumn setEditable:NO];
  //           [[tableColumn dataCell] setFont:[NSFont controlContentFontOfSize:11.]];
  //
  //           [[tableColumn headerCell].stringValue = [_translationsForPlaylistTableColumns objectForKey:columnId]];
  //
  //           if ([columnId isEqualToString: TRACKNUM_COLUMN]) {
  //               [tableColumn setMinWidth:20.];
  //               [tableColumn setMaxWidth:70.];
  //               [[tableColumn headerCell].stringValue = @"#"];
  //
  //           } else {
  //               [tableColumn setMinWidth:42.];
  //           }
  //
  //           [_outlineView addTableColumn:tableColumn];
  //           [_outlineView reloadData];
  //           [_outlineView.setNeedsDisplay: YES];
  //       }
  //       else
  //           [_outlineView removeTableColumn: [_outlineView tableColumnWithIdentifier:columnId]];
  //
  //       [_outlineView setOutlineTableColumn: [_outlineView tableColumnWithIdentifier:TITLE_COLUMN]];
  //
  //       return YES;
  //   }
  //
  //   - (Bool)validateMenuItem:(NSMenuItem *)item
  //   {
  //       if ([item action] == #selector(revealItemInFinder:)) {
  //           NSIndexSet *selectedRows = [_outlineView selectedRowIndexes];
  //           if (selectedRows.count != 1)
  //               return NO;
  //
  //           VLCPLItem *o_item = [_outlineView itemAtRow:selectedRows.firstIndex];
  //
  //           // Check if item exists in file system
  //           char *psz_url = input_item_GetURI([o_item input])
  //           NSURL *url = [NSURL URLWithString:toNSStr(psz_url)];
  //           free(psz_url)
  //           if (![url isFileURL])
  //               return NO;
  //           if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
  //               return NO;
  //
  //       } else if ([item action] == #selector(deleteItem:)) {
  //           return [_outlineView numberOfSelectedRows] > 0 && _model.editAllowed;
  //       } else if ([item action] == #selector(selectAll:)) {
  //           return [_outlineView numberOfRows] > 0;
  //       } else if ([item action] == #selector(playItem:)) {
  //           return [_outlineView numberOfSelectedRows] > 0;
  //       } else if ([item action] == #selector(recursiveExpandOrCollapseNode:)) {
  //           return [_outlineView numberOfSelectedRows] > 0;
  //       } else if ([item action] == #selector(showInfoPanel:)) {
  //           return [_outlineView numberOfSelectedRows] > 0;
  //       }
  //
  //       return YES;
  //   }
  //
  //   #pragma mark Helper for playlist table columns
  //
  //   - (void)setupPlaylistTableColumnsForMenu:(NSMenu *)menu
  //   {
  //       NSMenuItem *menuItem;
  //       NSUInteger count = [_menuOrderOfPlaylistTableColumns count];
  //       for (NSUInteger i = 0; i < count; i++) {
  //           NSString *columnId = [_menuOrderOfPlaylistTableColumns objectAtIndex:i];
  //           NSString *title = [_translationsForPlaylistTableColumns objectForKey:columnId];
  //           menuItem = [menu addItemWithTitle:title
  //                                      action:#selector(togglePlaylistColumnTable:)
  //                               keyEquivalent:@""];
  //           [menuItem setTarget:self];
  //           [menuItem setTag:i];
  //
  //           /* don't set a valid action for the title column selector, since we want it to be disabled */
  //           if ([columnId isEqualToString: TITLE_COLUMN])
  //               [menuItem setAction:nil];
  //
  //       }
  //   }
  //
  //   - (void)saveTableColumns
  //   {
  //       NSMutableArray *arrayToSave = [[NSMutableArray alloc] init];
  //       NSArray *columns = [[NSArray alloc] initWithArray:[_outlineView tableColumns]];
  //       NSUInteger columnCount = [columns count];
  //       NSTableColumn *currentColumn;
  //       for (NSUInteger i = 0; i < columnCount; i++) {
  //           currentColumn = [columns objectAtIndex:i];
  //           [arrayToSave addObject:[NSArray arrayWithObjects:[currentColumn identifier], [NSNumber numberWithFloat:[currentColumn width]], nil]];
  //       }
  //       [[NSUserDefaults standardUserDefaults] setObject:arrayToSave forKey:@"PlaylistColumnSelection"];
  //       [[NSUserDefaults standardUserDefaults] synchronize];
  //   }

    //   #pragma mark Item helpers

    func createItem(_ itemToCreateDict: [String: Any]) -> UnsafeMutablePointer<input_item_t>? {
        let p_intf = getIntf()!
        let p_playlist = pl_Get(p_intf)

        var p_input: UnsafeMutablePointer<input_item_t>?

        var b_rem = ObjCBool(false)
        var b_writable = ObjCBool(false)
        var isDirectory = ObjCBool(false)

        /* Get the item */
        var uri = itemToCreateDict["ITEM_URL"] as! String
        var url = NSURL(string: uri)
        let path = url!.path!
        let name = itemToCreateDict["ITEM_NAME"]!


        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
            && NSWorkspace.shared.getFileSystemInfo(forPath: path, isRemovable: &b_rem,
                                                    isWritable: &b_writable, isUnmountable: nil,
                                                    description: nil, type: nil)
            && b_rem.boolValue && !b_writable.boolValue && url!.isFileURL {

            let diskType = VLCStringUtility.getVolumeType(fromMountPath: path)
//            msg_Dbg(p_intf, "detected optical media of type %s in the file input", [diskType UTF8String])

            switch diskType {
            case kVLCMediaDVD:
                uri = "dvdnav://\(VLCStringUtility.getBSDNode(fromMountPath: path))"
            case kVLCMediaVideoTSFolder:
                uri = "dvdnav://\(path)"
            case kVLCMediaAudioCD:
                uri = "cdda://" + VLCStringUtility.getBSDNode(fromMountPath: path)
            case kVLCMediaVCD:
                uri = "vcd://%@#0:0" + VLCStringUtility.getBSDNode(fromMountPath: path)
            case kVLCMediaSVCD:
                uri = "vcd://%@@0:0" + VLCStringUtility.getBSDNode(fromMountPath: path)
            case kVLCMediaBD, kVLCMediaBDMVFolder:
                uri = "bluray://%@" + path
//            default:
//                msg_Warn(getIntf(), "unknown disk type, treating %s as regular input", [path UTF8String])
            }
            p_input = input_item_New(uri.UTF8String, FileManager.default.displayNameAtPath(path).UTF8String)
        }
        else {
            p_input = input_item_New(uri.fileSystemRepresentation, name)
        }

        if p_input == nil {
            return nil
        }

        if let optionsArray = itemToCreateDict["ITEM_OPTIONS"] as? [String] {
            let count = optionsArray.count
            for i in 0..<count {
                input_item_AddOption(p_input, optionsArray[i], VLC_INPUT_OPTION_TRUSTED.rawValue)
            }
        }

        /* Recent documents menu */
        if url != nil && var_InheritBool(p_intf.as_vlc_object_pointer(), "macosx-recentitems") {
            NSDocumentController.shared.noteNewRecentDocumentURL(url! as URL)
        }
        return p_input
    }

  //   - (NSArray *)createItemsFromExternalPasteboard:(NSPasteboard *)pasteboard
  //   {
  //       NSArray *o_array = [NSArray array];
  //       if (![[pasteboard types] containsObject: NSFilenamesPboardType])
  //           return o_array;
  //
  //       NSArray *o_values = [[pasteboard propertyListForType: NSFilenamesPboardType] sortedArrayUsingSelector:#selector(caseInsensitiveCompare:)];
  //       NSUInteger count = [o_values count];
  //
  //       for (NSUInteger i = 0; i < count; i++) {
  //           NSDictionary *o_dic;
  //           char *psz_uri = vlc_path2uri([[o_values objectAtIndex:i] UTF8String], NULL)
  //           if (!psz_uri)
  //               continue;
  //
  //           o_dic = [NSDictionary dictionaryWithObject:toNSStr(psz_uri) forKey:@"ITEM_URL"];
  //           free(psz_uri)
  //
  //           o_array = [o_array arrayByAddingObject: o_dic];
  //       }
  //
  //       return o_array;
  //   }

    private func addPlaylistItems(_ uriList: [Dictionary<String, String>]) {
        var i_plItemId: Int32 = -1
         // add items directly to media library if this is the current root
//         if ([[self model] currentRootType] == ROOT_TYPE_MEDIALIBRARY)
//             i_plItemId = [[[self model] rootItem] plItemId];

        let autoplay = var_InheritBool(getIntf()!.as_vlc_object_pointer(), "macosx-autoplay")
        addPlaylistItems(uriList, withParentItemId: i_plItemId, atPosition: -1, startPlayback: autoplay)
    }

    func addPlaylistItems(_ uriList: [Dictionary<String, String>], tryAsSubtitle isSubtitle: Bool) {
        let p_input = playlist_CurrentInput(pl_Get(getIntf()))

        if isSubtitle && uriList.count == 1 && p_input != nil {
           let result: Int32 = input_AddSlave(p_input, SLAVE_TYPE_SPU, uriList[0]["ITEM_URL"], true, true, true)
            if result == VLC_SUCCESS {
                vlc_object_release(p_input!.as_vlc_object_pointer())
                return
            }
        }
        if p_input != nil {
             vlc_object_release(p_input!.as_vlc_object_pointer())
        }
        addPlaylistItems(uriList)
    }

    private func addPlaylistItems(_ uriList: [Dictionary<String, String>],
                                  withParentItemId itemId: Int32,
                                  atPosition position: Int32,
                                  startPlayback start: Bool) {

        let p_playlist = pl_Get(getIntf())!
//         PL_LOCK;

        var p_parent: UnsafeMutablePointer<playlist_item_t>?
        if itemId >= 0 {
            p_parent = playlist_ItemGetById(p_playlist, itemId)
        } else {
            p_parent = p_playlist.pointee.p_playing
        }
        if p_parent == nil {
//             PL_UNLOCK;
            return
        }

        var currentOffset: Int32 = 0

        for i in 0..<uriList.count {
            var currentItem = uriList[i]
            let p_input: UnsafeMutablePointer<input_item_t>? = createItem(currentItem)
            if p_input == nil {
                continue
            }

            let pos = (position == -1) ? PLAYLIST_END : (position + currentOffset)
            currentOffset += 1
            let p_item: UnsafeMutablePointer<playlist_item_t>? = playlist_NodeAddInput(p_playlist, p_input, p_parent, pos)
            if p_item == nil {
                continue
            }

            if i == 0 && start {
                playlist_ViewPlay(p_playlist, p_parent, p_item)
            }
            input_item_Release(p_input)
        }
//         PL_UNLOCK;
    }

  //   - (IBAction)recursiveExpandOrCollapseNode:(id)sender
  //   {
  //       bool expand = (sender == _recursiveExpandPlaylistMenuItem)
  //
  //       NSIndexSet * selectedRows = [_outlineView selectedRowIndexes];
  //       NSUInteger count = [selectedRows count];
  //       NSUInteger indexes[count];
  //       [selectedRows getIndexes:indexes maxCount:count inIndexRange:nil];
  //
  //       id item;
  //       playlist_item_t *p_item;
  //       for (NSUInteger i = 0; i < count; i++) {
  //           item = [_outlineView itemAtRow: indexes[i]];
  //
  //           /* We need to collapse the node first, since OSX refuses to recursively
  //            expand an already expanded node, even if children nodes are collapsed. */
  //           if ([_outlineView isExpandable:item]) {
  //               [_outlineView collapseItem: item collapseChildren: YES];
  //
  //               if (expand)
  //                   [_outlineView expandItem: item expandChildren: YES];
  //           }
  //
  //           selectedRows = [_outlineView selectedRowIndexes];
  //           [selectedRows getIndexes:indexes maxCount:count inIndexRange:nil];
  //       }
  //   }
  //
  //   - (NSMenu *)menuForEvent:(NSEvent *)o_event
  //   {
  //       if (!b_playlistmenu_nib_loaded)
  //           b_playlistmenu_nib_loaded = [NSBundle loadNibNamed:@"PlaylistMenu" owner:self];
  //
  //       NSPoint pt = [_outlineView convertPoint: [o_event locationInWindow] fromView: nil];
  //       int row = [_outlineView rowAtPoint:pt];
  //       if (row != -1 && ![[_outlineView selectedRowIndexes] containsIndex: row])
  //           [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
  //
  //       // TODO Reenable once per-item info panel is supported again
  //       _infoPlaylistMenuItem.isHidden = YES;
  //
  //       return _playlistMenu;
  //   }
  //
  //   - (void)outlineView:(NSOutlineView *)outlineView didClickTableColumn:(NSTableColumn *)aTableColumn
  //   {
  //       int type = 0;
  //       intf_thread_t *p_intf = getIntf()
  //       NSString * identifier = [aTableColumn identifier];
  //
  //       playlist_t *p_playlist = pl_Get(p_intf)
  //
  //       if (_sortTableColumn == aTableColumn)
  //           b_isSortDescending = !b_isSortDescending;
  //       else
  //           b_isSortDescending = false;
  //
  //       if (b_isSortDescending)
  //           type = ORDER_REVERSE;
  //       else
  //           type = ORDER_NORMAL;
  //
  //       [[self model] sortForColumn:identifier withMode:type];
  //
  //       /* Clear indications of any existing column sorting */
  //       NSUInteger count = [[_outlineView tableColumns] count];
  //       for (NSUInteger i = 0 ; i < count ; i++)
  //           [_outlineView setIndicatorImage:nil inTableColumn: [[_outlineView tableColumns] objectAtIndex:i]];
  //
  //       [_outlineView setHighlightedTableColumn:nil];
  //       _sortTableColumn = aTableColumn;
  //       [_outlineView setHighlightedTableColumn:aTableColumn];
  //
  //       if (b_isSortDescending)
  //           [_outlineView setIndicatorImage:_descendingSortingImage inTableColumn:aTableColumn];
  //       else
  //           [_outlineView setIndicatorImage:_ascendingSortingImage inTableColumn:aTableColumn];
  //   }
  //
  //
  //   - (void)outlineView:(NSOutlineView *)outlineView
  //       willDisplayCell:(id)cell
  //        forTableColumn:(NSTableColumn *)tableColumn
  //                  item:(id)item
  //   {
  //       /* this method can be called when VLC is already dead, hence the extra checks */
  //       intf_thread_t * p_intf = getIntf()
  //       if (!p_intf)
  //           return;
  //       playlist_t *p_playlist = pl_Get(p_intf)
  //
  //       NSFont *fontToUse;
  //       if (var_InheritBool(getIntf(), "macosx-large-text"))
  //           fontToUse = [NSFont systemFontOfSize:13.];
  //       else
  //           fontToUse = [NSFont systemFontOfSize:11.];
  //
  //       Bool b_is_playing = NO;
  //       PL_LOCK;
  //       playlist_item_t *p_current_item = playlist_CurrentPlayingItem(p_playlist)
  //       if (p_current_item) {
  //           b_is_playing = p_current_item->i_id == [item plItemId];
  //       }
  //       PL_UNLOCK;
  //
  //       if (b_is_playing)
  //           [cell setFont: [[NSFontManager sharedFontManager] convertFont:fontToUse toHaveTrait:NSBoldFontMask]];
  //       else
  //           [cell setFont: [[NSFontManager sharedFontManager] convertFont:fontToUse toNotHaveTrait:NSBoldFontMask]];
  //   }
  //
  //   // TODO remove method
  //   - (NSArray *)draggedItems
  //   {
  //       return [[self model] draggedItems];
  //   }
    
}


fileprivate class VLCPLModel {
    private let p_playlist: UnsafeMutablePointer<playlist_t>


//    #pragma mark Init and Stuff

    init(playlist: UnsafeMutablePointer<playlist_t>, rootItem root: playlist_item_t) {
        self.p_playlist = playlist

//        msg_Dbg(getIntf(), "Initializing playlist model")
//        var_AddCallback(self.p_playlist, "item-change", VLCPLItemUpdated, &self)
//        var_AddCallback(self.p_playlist, "playlist-item-append", VLCPLItemAppended, &self)
//        var_AddCallback(self.p_playlist, "playlist-item-deleted", VLCPLItemRemoved, &self)
//        var_AddCallback(self.p_playlist, "random", PlaybackModeUpdated, &self)
//        var_AddCallback(self.p_playlist, "repeat", PlaybackModeUpdated, &self)
//        var_AddCallback(self.p_playlist, "loop", PlaybackModeUpdated, &self)
//        var_AddCallback(self.p_playlist, "volume", VolumeUpdated, &self)
//        var_AddCallback(self.p_playlist, "mute", VolumeUpdated, &self)

//        PL_LOCK;
//        _rootItem = [[VLCPLItem alloc] initWithPlaylistItem:root];
//        [self rebuildVLCPLItem:_rootItem];
//        PL_UNLOCK;
    }

    deinit {
//        msg_Dbg(getIntf(), "Deinitializing playlist model")
//        var_DelCallback(self.p_playlist, "item-change", VLCPLItemUpdated, &self)
//        var_DelCallback(self.p_playlist, "playlist-item-append", VLCPLItemAppended, &self)
//        var_DelCallback(self.p_playlist, "playlist-item-deleted", VLCPLItemRemoved, &self)
//        var_DelCallback(self.p_playlist, "random", PlaybackModeUpdated, &self)
//        var_DelCallback(self.p_playlist, "repeat", PlaybackModeUpdated, &self)
//        var_DelCallback(self.p_playlist, "loop", PlaybackModeUpdated, &self)
//        var_DelCallback(self.p_playlist, "volume", VolumeUpdated, &self)
//        var_DelCallback(self.p_playlist, "mute", VolumeUpdated, &self)
    }

//    private func changeRootItem:(playlist_item_t *)p_root;) -> void {
//        PL_ASSERT_LOCKED;
//        _rootItem = [[VLCPLItem alloc] initWithPlaylistItem:p_root];
//        [self rebuildVLCPLItem:_rootItem];
//
//        [_outlineView reloadData];
//        [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
//    }

//    private func hasChildren) -> Bool {
//        return [[_rootItem children] count] > 0;
//    }

//    private func currentRootType) -> PLRootType {
//        int i_root_id = [_rootItem plItemId];
//        if (i_root_id == self.p_playlist->p_playing->i_id)
//            return ROOT_TYPE_PLAYLIST;
//        if (self.p_playlist->p_media_library && i_root_id == self.p_playlist->p_media_library->i_id)
//            return ROOT_TYPE_MEDIALIBRARY;
//
//        return ROOT_TYPE_OTHER;
//    }

//    private func editAllowed) -> Bool {
//        return [self currentRootType] == ROOT_TYPE_MEDIALIBRARY ||
//        [self currentRootType] == ROOT_TYPE_PLAYLIST;
//    }

//    private func deleteSelectedItem) -> void {
//        // check if deletion is allowed
//        if (![self editAllowed])
//            return;
//
//        NSIndexSet *selectedIndexes = [_outlineView selectedRowIndexes];
//        _retainedRowSelection = [selectedIndexes firstIndex];
//        if (_retainedRowSelection == NSNotFound)
//            _retainedRowSelection = 0;
//
//        [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, Bool *stop) {
//            VLCPLItem *item = [_outlineView itemAtRow: idx];
//            if (!item)
//                return;
//
//            // model deletion is done via callback
//            PL_LOCK;
//            playlist_item_t *p_root = playlist_ItemGetById(self.p_playlist, [item plItemId])
//            if( p_root != NULL )
//                playlist_NodeDelete(self.p_playlist, p_root)
//            PL_UNLOCK;
//        }];
//    }

//    private func rebuildVLCPLItem:(VLCPLItem *)item) -> void {
//        [item clear];
//        playlist_item_t *p_item = playlist_ItemGetById(self.p_playlist, [item plItemId])
//        if (p_item) {
//            int currPos = 0;
//            for(int i = 0; i < p_item->i_children; ++i) {
//                playlist_item_t *p_child = p_item->pp_children[i];
//
//                if (p_child->i_flags & PLAYLIST_DBL_FLAG)
//                    continue;
//
//                VLCPLItem *child = [[VLCPLItem alloc] initWithPlaylistItem:p_child];
//                [item addChild:child atPos:currPos++];
//
//                if (p_child->i_children >= 0) {
//                    [self rebuildVLCPLItem:child];
//                }
//
//            }
//        }
//
//    }

//    private func findItemByPlaylistId:(int)i_pl_id) -> VLCPLItem * {
//        return [self findItemInnerByPlaylistId:i_pl_id node:_rootItem];
//    }
//
//    private func findItemInnerByPlaylistId:(int)i_pl_id node:(VLCPLItem *)node) -> VLCPLItem * {
//        if ([node plItemId] == i_pl_id) {
//            return node;
//        }
//
//        for (NSUInteger i = 0; i < [[node children] count]; ++i) {
//            VLCPLItem *o_sub_item = [[node children] objectAtIndex:i];
//            if ([o_sub_item plItemId] == i_pl_id) {
//                return o_sub_item;
//            }
//
//            if (![o_sub_item isLeaf]) {
//                VLCPLItem *o_returned = [self findItemInnerByPlaylistId:i_pl_id node:o_sub_item];
//                if (o_returned)
//                    return o_returned;
//            }
//        }
//
//        return nil;
//    }

//    #pragma mark Core events


//    private func VLCPLItemAppended:(NSArray *)valueArray) -> void {
//        int i_node = [[valueArray firstObject] intValue];
//        int i_item = [[valueArray objectAtIndex:1] intValue];
//
//        [self addItem:i_item withParentNode:i_node];
//
//        // update badge in sidebar
//        [[[VLCMain sharedInstance] mainWindow] updateWindow];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName: VLCMediaKeySupportSettingChangedNotification
//                                                            object: nil
//                                                          userInfo: nil];
//    }

//    private func VLCPLItemRemoved:(NSNumber *)value) -> void {
//        int i_item = [value intValue];
//
//        [self removeItem:i_item];
//        // retain selection before deletion
//        [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:_retainedRowSelection] byExtendingSelection:NO];
//
//        // update badge in sidebar
//        [[[VLCMain sharedInstance] mainWindow] updateWindow];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName: VLCMediaKeySupportSettingChangedNotification
//                                                            object: nil
//                                                          userInfo: nil];
//    }

//    private func VLCPLItemUpdated) -> void {
//        VLCMain *instance = [VLCMain sharedInstance];
//        [[instance mainWindow] updateName];
//
//        [[instance currentMediaInfoPanel] updateMetadata];
//    }

//    private func addItem:(int)i_item withParentNode:(int)i_node) -> void {
//        VLCPLItem *o_parent = [self findItemByPlaylistId:i_node];
//        if (!o_parent) {
//            return;
//        }
//
//        PL_LOCK;
//        playlist_item_t *p_item = playlist_ItemGetById(self.p_playlist, i_item)
//        if (!p_item || p_item->i_flags & PLAYLIST_DBL_FLAG)
//        {
//            PL_UNLOCK;
//            return;
//        }
//
//        int pos;
//        for(pos = p_item->p_parent->i_children - 1; pos >= 0; pos--)
//            if(p_item->p_parent->pp_children[pos] == p_item)
//                break;
//
//        VLCPLItem *o_new_item = [[VLCPLItem alloc] initWithPlaylistItem:p_item];
//        PL_UNLOCK;
//        if (pos < 0)
//            return;
//
//        [o_parent addChild:o_new_item atPos:pos];
//
//        if ([o_parent plItemId] == [_rootItem plItemId])
//            [_outlineView reloadData];
//        else // only reload leafs this way, doing it with nil collapses width of title column
//            [_outlineView reloadItem:o_parent reloadChildren:YES];
//    }

//    private func removeItem:(int)i_item) -> void {
//        VLCPLItem *o_item = [self findItemByPlaylistId:i_item];
//        if (!o_item) {
//            return;
//        }
//
//        VLCPLItem *o_parent = [o_item parent];
//        [o_parent deleteChild:o_item];
//
//        if ([o_parent plItemId] == [_rootItem plItemId])
//            [_outlineView reloadData];
//        else
//            [_outlineView reloadItem:o_parent reloadChildren:YES];
//    }

//    private func updateItem:(input_item_t *)p_input_item) -> void {
//        PL_LOCK;
//        playlist_item_t *pl_item = playlist_ItemGetByInput(self.p_playlist, p_input_item)
//        if (!pl_item) {
//            PL_UNLOCK;
//            return;
//        }
//        VLCPLItem *item = [self findItemByPlaylistId:pl_item->i_id];
//        PL_UNLOCK;
//
//        if (!item)
//            return;
//
//        NSInteger row = [_outlineView rowForItem:item];
//        if (row == -1)
//            return;
//
//        [_outlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row]
//                                columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[_outlineView tableColumns] count])]];
//
//    }

//    private func currentlyPlayingItem) -> VLCPLItem * {
//        VLCPLItem *item = nil;
//
//        PL_LOCK;
//        playlist_item_t *p_current = playlist_CurrentPlayingItem(self.p_playlist)
//        if (p_current)
//            item = [self findItemByPlaylistId:p_current->i_id];
//        PL_UNLOCK;
//        return item;
//    }

//    private func playbackModeUpdated) -> void {
//        bool loop = var_GetBool(self.p_playlist, "loop")
//        bool repeat = var_GetBool(self.p_playlist, "repeat")
//
//        VLCMainWindowControlsBar *controlsBar = (VLCMainWindowControlsBar *)[[[VLCMain sharedInstance] mainWindow] controlsBar];
//        VLCMainMenu *mainMenu = [[VLCMain sharedInstance] mainMenu];
//        if (repeat) {
//            [controlsBar setRepeatOne];
//            [mainMenu setRepeatOne];
//        } else if (loop) {
//            [controlsBar setRepeatAll];
//            [mainMenu setRepeatAll];
//        } else {
//            [controlsBar setRepeatOff];
//            [mainMenu setRepeatOff];
//        }
//
//        [controlsBar setShuffle];
//        [mainMenu setShuffle];
//    }

//    #pragma mark Sorting / Searching

//    private func sortForColumn:(NSString *)o_column withMode:(int)i_mode) -> void {
//        int i_column = 0;
//        if ([o_column isEqualToString:TRACKNUM_COLUMN])
//            i_column = SORT_TRACK_NUMBER;
//        else if ([o_column isEqualToString:TITLE_COLUMN])
//            i_column = SORT_TITLE;
//        else if ([o_column isEqualToString:ARTIST_COLUMN])
//            i_column = SORT_ARTIST;
//        else if ([o_column isEqualToString:GENRE_COLUMN])
//            i_column = SORT_GENRE;
//        else if ([o_column isEqualToString:DURATION_COLUMN])
//            i_column = SORT_DURATION;
//        else if ([o_column isEqualToString:ALBUM_COLUMN])
//            i_column = SORT_ALBUM;
//        else if ([o_column isEqualToString:DESCRIPTION_COLUMN])
//            i_column = SORT_DESCRIPTION;
//        else if ([o_column isEqualToString:URI_COLUMN])
//            i_column = SORT_URI;
//        else
//            return;
//
//        PL_LOCK;
//        playlist_item_t *p_root = playlist_ItemGetById(self.p_playlist, [_rootItem plItemId])
//        if (!p_root) {
//            PL_UNLOCK;
//            return;
//        }
//
//        playlist_RecursiveNodeSort(self.p_playlist, p_root, i_column, i_mode)
//
//        [self rebuildVLCPLItem:_rootItem];
//        [_outlineView reloadData];
//        PL_UNLOCK;
//    }

//    private func searchUpdate:(NSString *)o_search) -> void {
//        PL_LOCK;
//        playlist_item_t *p_root = playlist_ItemGetById(self.p_playlist, [_rootItem plItemId])
//        if (!p_root) {
//            PL_UNLOCK;
//            return;
//        }
//        playlist_LiveSearchUpdate(self.p_playlist, p_root, [o_search UTF8String],
//                                  true)
//        [self rebuildVLCPLItem:_rootItem];
//        [_outlineView reloadData];
//        PL_UNLOCK;
//    }

//    private func outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item) -> NSInteger {
//        return !item ? [[_rootItem children] count] : [[item children] count];
//    }

//    private func outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item) -> Bool {
//        return !item ? YES : [[item children] count] > 0;
//    }

//    private func outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item) -> id {
//        id obj = !item ? _rootItem : item;
//        return [[obj children] objectAtIndex:index];
//    }

//    private func outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item) -> id {
//        id o_value = nil;
//        char *psz_value;
//
//        input_item_t *p_input = [item input];
//
//        NSString * o_identifier = [tableColumn identifier];
//
//        if ([o_identifier isEqualToString:TRACKNUM_COLUMN]) {
//            psz_value = input_item_GetTrackNumber(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:TITLE_COLUMN]) {
//            psz_value = input_item_GetTitleFbName(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:ARTIST_COLUMN]) {
//            psz_value = input_item_GetArtist(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:DURATION_COLUMN]) {
//            char psz_duration[MSTRTIME_MAX_SIZE];
//            mtime_t dur = input_item_GetDuration(p_input)
//            if (dur != -1) {
//                secstotimestr(psz_duration, dur/1000000)
//                o_value = toNSStr(psz_duration)
//            }
//            else
//                o_value = @"--:--";
//
//        } else if ([o_identifier isEqualToString:GENRE_COLUMN]) {
//            psz_value = input_item_GetGenre(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:ALBUM_COLUMN]) {
//            psz_value = input_item_GetAlbum(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:DESCRIPTION_COLUMN]) {
//            psz_value = input_item_GetDescription(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:DATE_COLUMN]) {
//            psz_value = input_item_GetDate(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:LANGUAGE_COLUMN]) {
//            psz_value = input_item_GetLanguage(p_input)
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:URI_COLUMN]) {
//            psz_value = vlc_uri_decode(input_item_GetURI(p_input))
//            o_value = toNSStr(psz_value)
//            free(psz_value)
//
//        } else if ([o_identifier isEqualToString:FILESIZE_COLUMN]) {
//            psz_value = input_item_GetURI(p_input)
//            if (!psz_value)
//                return @"";
//            NSURL *url = [NSURL URLWithString:toNSStr(psz_value)];
//            free(psz_value)
//            if (![url isFileURL])
//                return @"";
//
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            Bool b_isDir;
//            if (![fileManager fileExistsAtPath:[url path] isDirectory:&b_isDir] || b_isDir)
//                return @"";
//
//            NSDictionary *attributes = [fileManager attributesOfItemAtPath:[url path] error:nil];
//            if (!attributes)
//                return @"";
//
//            o_value = [VLCByteCountFormatter stringFromByteCount:[attributes fileSize] countStyle:NSByteCountFormatterCountStyleDecimal];
//
//        } else if ([o_identifier isEqualToString:STATUS_COLUMN]) {
//            if (input_item_HasErrorWhenReading(p_input)) {
//                o_value = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kAlertCautionIcon)];
//                [o_value setSize: NSMakeSize(16,16)];
//            }
//        }
//
//        return o_value;
//    }

//    #pragma mark Drag and Drop support

//    private func isItem: (VLCPLItem *)p_item inNode: (VLCPLItem *)p_node) -> Bool {
//        while(p_item) {
//            if ([p_item plItemId] == [p_node plItemId]) {
//                return YES;
//            }
//
//            p_item = [p_item parent];
//        }
//
//        return NO;
//    }

//    private func outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard) -> Bool {
//        NSUInteger itemCount = [items count];
//        _draggedItems = [[NSMutableArray alloc] initWithArray:items];
//
//        /* Add the data to the pasteboard object. */
//        [pboard declareTypes: [NSArray arrayWithObject:VLCPLItemPasteboadType] owner: self];
//        [pboard setData:[NSData data] forType:VLCPLItemPasteboadType];
//
//        return YES;
//    }

//    private func outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index) -> NSDragOperation {
//        NSPasteboard *o_pasteboard = [info draggingPasteboard];
//
//        /* Dropping ON items is not allowed if item is not a node */
//        if (item) {
//            if (index == NSOutlineViewDropOnItemIndex && [item isLeaf]) {
//                return NSDragOperationNone;
//            }
//        }
//
//        if (![self editAllowed])
//            return NSDragOperationNone;
//
//        /* Drop from the Playlist */
//        if ([[o_pasteboard types] containsObject:VLCPLItemPasteboadType]) {
//            NSUInteger count = [_draggedItems count];
//            for (NSUInteger i = 0 ; i < count ; i++) {
//                /* We refuse to Drop in a child of an item we are moving */
//                if ([self isItem: item inNode: [_draggedItems objectAtIndex:i]]) {
//                    return NSDragOperationNone;
//                }
//            }
//            return NSDragOperationMove;
//        }
//        /* Drop from the Finder */
//        else if ([[o_pasteboard types] containsObject: NSFilenamesPboardType]) {
//            return NSDragOperationGeneric;
//        }
//        return NSDragOperationNone;
//    }

//    private func outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)targetItem childIndex:(NSInteger)index) -> Bool {
//        NSPasteboard *o_pasteboard = [info draggingPasteboard];
//
//        if (targetItem == nil) {
//            targetItem = _rootItem;
//        }
//
//        /* Drag & Drop inside the playlist */
//        if ([[o_pasteboard types] containsObject:VLCPLItemPasteboadType]) {
//
//            NSMutableArray *o_filteredItems = [NSMutableArray arrayWithArray:_draggedItems];
//            const NSUInteger draggedItemsCount = [_draggedItems count];
//            for (NSInteger i = 0; i < [o_filteredItems count]; i++) {
//                for (NSUInteger j = 0; j < draggedItemsCount; j++) {
//                    VLCPLItem *itemToCheck = [o_filteredItems objectAtIndex:i];
//                    VLCPLItem *nodeToTest = [_draggedItems objectAtIndex:j];
//                    if ([itemToCheck plItemId] == [nodeToTest plItemId])
//                        continue;
//
//                    if ([self isItem:itemToCheck inNode:nodeToTest]) {
//                        [o_filteredItems removeObjectAtIndex:i];
//                        --i;
//                        break;
//                    }
//                }
//            }
//
//            NSUInteger count = [o_filteredItems count];
//            if (count == 0)
//                return NO;
//
//            playlist_item_t **pp_items = (playlist_item_t **)calloc(count, sizeof(playlist_item_t*))
//            if (!pp_items)
//                return NO;
//
//            PL_LOCK;
//            playlist_item_t *p_new_parent = playlist_ItemGetById(self.p_playlist, [targetItem plItemId])
//            if (!p_new_parent) {
//                PL_UNLOCK;
//                return NO;
//            }
//
//            NSUInteger j = 0;
//            for (NSUInteger i = 0; i < count; i++) {
//                playlist_item_t *p_item = playlist_ItemGetById(self.p_playlist, [[o_filteredItems objectAtIndex:i] plItemId])
//                if (p_item)
//                    pp_items[j++] = p_item;
//            }
//
//            // drop on a node itself will append entries at the end
//            if (index == NSOutlineViewDropOnItemIndex)
//                index = p_new_parent->i_children;
//
//            if (playlist_TreeMoveMany(self.p_playlist, j, pp_items, p_new_parent, index) != VLC_SUCCESS) {
//                PL_UNLOCK;
//                free(pp_items)
//                return NO;
//            }
//
//            PL_UNLOCK;
//            free(pp_items)
//
//            // rebuild our model
//            NSUInteger filteredItemsCount = [o_filteredItems count];
//            for(NSUInteger i = 0; i < filteredItemsCount; ++i) {
//                VLCPLItem *o_item = [o_filteredItems objectAtIndex:i];
//                NSLog(@"delete child from parent %p", [o_item parent])
//                [[o_item parent] deleteChild:o_item];
//                [targetItem addChild:o_item atPos:index + i];
//            }
//
//            [_outlineView reloadData];
//
//            NSMutableIndexSet *selectedIndexes = [[NSMutableIndexSet alloc] init];
//            for(NSUInteger i = 0; i < draggedItemsCount; ++i) {
//                NSInteger row = [_outlineView rowForItem:[_draggedItems objectAtIndex:i]];
//                if (row < 0)
//                    continue;
//
//                [selectedIndexes addIndex:row];
//            }
//
//            if ([selectedIndexes count] == 0)
//                [selectedIndexes addIndex:[_outlineView rowForItem:targetItem]];
//
//            [_outlineView selectRowIndexes:selectedIndexes byExtendingSelection:NO];
//
//            return YES;
//        }
//
//        // try file drop
//
//        // drop on a node itself will append entries at the end
//        static_assert(NSOutlineViewDropOnItemIndex == -1, "Expect NSOutlineViewDropOnItemIndex to be -1")
//
//        NSArray *items = [[[VLCMain sharedInstance] playlist] createItemsFromExternalPasteboard:o_pasteboard];
//        if (items.count == 0)
//            return NO;
//
//        [[[VLCMain sharedInstance] playlist] addPlaylistItems:items
//                                             withParentItemId:[targetItem plItemId]
//                                                        atPos:index
//                                                startPlayback:NO];
//        return YES;
//    }
}


//fileprivate func VLCPLItemUpdated(vlc_object_t *p_this, const char *psz_var,
//                         vlc_value_t oldval, vlc_value_t new_val, void *param) -> Int32 {
//    return autoreleasepool {
//        VLCPLModel *model = (__bridge VLCPLModel*)param;
//        [model performSelectorOnMainThread:#selector(VLCPLItemUpdated) withObject:nil waitUntilDone:NO];
//
//        return VLC_SUCCESS;
//    }
//}
//
//fileprivate func VLCPLItemAppended(vlc_object_t *p_this, const char *psz_var,
//                          vlc_value_t oldval, vlc_value_t new_val, void *param) -> Int32 {
//    return autoreleasepool {
//        playlist_item_t *p_item = new_val.p_address;
//        int i_node = p_item->p_parent ? p_item->p_parent->i_id : -1;
//        NSArray *o_val = [NSArray arrayWithObjects:[NSNumber numberWithInt:i_node], [NSNumber numberWithInt:p_item->i_id], nil];
//        VLCPLModel *model = (__bridge VLCPLModel*)param;
//        [model performSelectorOnMainThread:#selector(VLCPLItemAppended:) withObject:o_val waitUntilDone:NO];
//
//        return VLC_SUCCESS;
//    }
//}
//
//fileprivate func VLCPLItemRemoved(vlc_object_t *p_this, const char *psz_var,
//                         vlc_value_t oldval, vlc_value_t new_val, void *param) -> Int32 {
//    return autoreleasepool {
//        playlist_item_t *p_item = new_val.p_address;
//        NSNumber *o_val = [NSNumber numberWithInt:p_item->i_id];
//        VLCPLModel *model = (__bridge VLCPLModel*)param;
//        [model performSelectorOnMainThread:#selector(VLCPLItemRemoved:) withObject:o_val waitUntilDone:NO];
//
//        return VLC_SUCCESS;
//    }
//}
//
//fileprivate func PlaybackModeUpdated(vlc_object_t *p_this, const char *psz_var,
//                               vlc_value_t oldval, vlc_value_t new_val, void *param) -> Int32 {
//    return autoreleasepool {
//        VLCPLModel *model = (__bridge VLCPLModel*)param;
//        [model performSelectorOnMainThread:#selector(playbackModeUpdated) withObject:nil waitUntilDone:NO];
//
//        return VLC_SUCCESS;
//    }
//}

fileprivate func VolumeUpdated(_ p_this: vlc_object_t, _ psz_var: String,
                               oldval: vlc_value_t, new_val: vlc_value_t) -> Int32 {
    autoreleasepool {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            VLCMain.instance] mainWindow] updateVolumeSlider];
//        })
        return VLC_SUCCESS;
    }
}
