/*****************************************************************************
 * ControlsBar.h: MacOS X interface module
 *****************************************************************************
 * Copyright (C) 2012-2016 VLC authors and VideoLAN
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne -at- videolan -dot- org>
 *          David Fuhrmann <david dot fuhrmann at googlemail dot com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#import <Cocoa/Cocoa.h>
#import "misc.h"
#import "VLCControlsBarCommon.h"
#import "VLCVolumeSlider.h"

/*****************************************************************************
 * VLCMainWindowControlsBar
 *
 *  Holds all specific outlets, actions and code for the main window controls bar.
 *****************************************************************************/

@interface VLCMainWindowControlsBar : VLCControlsBarCommon

@property (readwrite, strong) IBOutlet NSButton *stopButton;

@property (readwrite, strong) IBOutlet NSButton *prevButton;
@property (readwrite, strong) IBOutlet NSLayoutConstraint *prevButtonWidthConstraint;
@property (readwrite, strong) IBOutlet NSButton *nextButton;
@property (readwrite, strong) IBOutlet NSLayoutConstraint *nextButtonWidthConstraint;

@property (readwrite, strong) IBOutlet VLCVolumeSlider *volumeSlider;
@property (readwrite, strong) IBOutlet NSButton *volumeDownButton;
@property (readwrite, strong) IBOutlet NSButton *volumeUpButton;

- (IBAction)stop:(id)sender;

- (IBAction)volumeAction:(id)sender;

- (void)toggleJumpButtons;

- (void)updateVolumeSlider;
- (void)updateControls;

@end

