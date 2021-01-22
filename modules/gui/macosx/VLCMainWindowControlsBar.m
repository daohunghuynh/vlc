/*****************************************************************************
 * ControlsBar.m: MacOS X interface module
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

#import "VLCControlsBarCommon.h"
#import "VLCMainWindowControlsBar.h"
#import "VLCMain.h"
#import "VLCCoreInteraction.h"
#import "VLCMainMenu.h"
#import "VLCPlaylist.h"
#import "CompatibilityFixes.h"
#import <vlc_aout.h>

/*****************************************************************************
 * VLCMainWindowControlsBar
 *
 *  Holds all specific outlets, actions and code for the main window controls bar.
 *****************************************************************************/
@implementation VLCMainWindowControlsBar

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.stopButton setToolTip: _NS("Stop")];
    self.stopButton.accessibilityLabel = self.stopButton.toolTip;

    NSString *volumeTooltip = [NSString stringWithFormat:_NS("Volume: %i %%"), 100];
    [self.volumeSlider setToolTip: volumeTooltip];
    self.volumeSlider.accessibilityLabel = _NS("Volume");
    
    [self.volumeDownButton setToolTip: _NS("Mute")];
    self.volumeDownButton.accessibilityLabel = self.volumeDownButton.toolTip;
    
    [self.volumeUpButton setToolTip: _NS("Full Volume")];
    self.volumeUpButton.accessibilityLabel = self.volumeUpButton.toolTip;

    [self.stopButton setImage: imageFromRes(@"stop")];
    [self.stopButton setAlternateImage: imageFromRes(@"stop-pressed")];

    [self.volumeDownButton setImage: imageFromRes(@"volume-low")];
    [self.volumeUpButton setImage: imageFromRes(@"volume-high")];
    [self.volumeSlider setUsesBrightArtwork: YES];

    [self.fullscreenButton setImage: imageFromRes(@"fullscreen-double-buttons")];
    [self.fullscreenButton setAlternateImage: imageFromRes(@"fullscreen-double-buttons-pressed")];

    [self.prevButton setImage: imageFromRes(@"previous-6btns")];
    [self.prevButton setAlternateImage: imageFromRes(@"previous-6btns-pressed")];
    [self.nextButton setImage: imageFromRes(@"next-6btns")];
    [self.nextButton setAlternateImage: imageFromRes(@"next-6btns-pressed")];

    BOOL b_mute = ![[VLCCoreInteraction sharedInstance] mute];
    [self.volumeSlider setEnabled: b_mute];
    [self.volumeSlider setMaxValue: [[VLCCoreInteraction sharedInstance] maxVolume]];
    [self.volumeSlider setDefaultValue: AOUT_VOLUME_DEFAULT];
    [self.volumeUpButton setEnabled: b_mute];

    if (!var_InheritBool(getIntf(), "macosx-show-playback-buttons"))
        [self removeJumpButtons:NO];

    [[[VLCMain sharedInstance] playlist] playbackModeUpdated];

}

#pragma mark -
#pragma mark interface customization

- (void)hideButtonWithConstraint:(NSLayoutConstraint *)constraint animation:(BOOL)animation
{
    NSAssert([constraint.firstItem isKindOfClass:[NSButton class]], @"Constraint must be for NSButton object");

    NSLayoutConstraint *animatedConstraint = animation ? constraint.animator : constraint;
    animatedConstraint.constant = 0;
}

- (void)showButtonWithConstraint:(NSLayoutConstraint *)constraint animation:(BOOL)animation
{
    NSAssert([constraint.firstItem isKindOfClass:[NSButton class]], @"Constraint must be for NSButton object");

    NSLayoutConstraint *animatedConstraint = animation ? constraint.animator : constraint;
    animatedConstraint.constant = ((NSButton *)constraint.firstItem).image.size.width;
}

- (void)toggleJumpButtons
{
    if (var_InheritBool(getIntf(), "macosx-show-playback-buttons"))
        [self addJumpButtons:YES];
    else
        [self removeJumpButtons:YES];
}

- (void)addJumpButtons:(BOOL)withAnimation
{
    [NSAnimationContext beginGrouping];
    [self showButtonWithConstraint:self.prevButtonWidthConstraint animation:withAnimation];
    [self showButtonWithConstraint:self.nextButtonWidthConstraint animation:withAnimation];

    id backwardButton = withAnimation ? self.backwardButton.animator : self.backwardButton;
    id forwardButton = withAnimation ? self.forwardButton.animator : self.forwardButton;
    [forwardButton setImage:imageFromRes(@"forward-6btns")];
    [forwardButton setAlternateImage:imageFromRes(@"forward-6btns-pressed")];
    [backwardButton setImage:imageFromRes(@"backward-6btns")];
    [backwardButton setAlternateImage:imageFromRes(@"backward-6btns-pressed")];

    [NSAnimationContext endGrouping];

    [self toggleForwardBackwardMode: YES];
}

- (void)removeJumpButtons:(BOOL)withAnimation
{
    [NSAnimationContext beginGrouping];
    [self hideButtonWithConstraint:self.prevButtonWidthConstraint animation:withAnimation];
    [self hideButtonWithConstraint:self.nextButtonWidthConstraint animation:withAnimation];

    id backwardButton = withAnimation ? self.backwardButton.animator : self.backwardButton;
    id forwardButton = withAnimation ? self.forwardButton.animator : self.forwardButton;
    [forwardButton setImage:imageFromRes(@"forward-3btns")];
    [forwardButton setAlternateImage:imageFromRes(@"forward-3btns-pressed")];
    [backwardButton setImage:imageFromRes(@"backward-3btns")];
    [backwardButton setAlternateImage:imageFromRes(@"backward-3btns-pressed")];
    [NSAnimationContext endGrouping];

    [self toggleForwardBackwardMode: NO];
}

#pragma mark -
#pragma mark Extra button actions

- (IBAction)stop:(id)sender
{
    [[VLCCoreInteraction sharedInstance] stop];
}

// dynamically created next / prev buttons
- (IBAction)prev:(id)sender
{
    [[VLCCoreInteraction sharedInstance] previous];
}

- (IBAction)next:(id)sender
{
    [[VLCCoreInteraction sharedInstance] next];
}

- (IBAction)volumeAction:(id)sender
{
    if (sender == self.volumeSlider)
        [[VLCCoreInteraction sharedInstance] setVolume: [sender intValue]];
    else if (sender == self.volumeDownButton)
        [[VLCCoreInteraction sharedInstance] toggleMute];
    else
        [[VLCCoreInteraction sharedInstance] setVolume: AOUT_VOLUME_MAX];
}

#pragma mark -
#pragma mark Extra updaters

- (void)updateVolumeSlider
{
    int i_volume = [[VLCCoreInteraction sharedInstance] volume];
    BOOL b_muted = [[VLCCoreInteraction sharedInstance] mute];

    if (b_muted)
        i_volume = 0;

    [self.volumeSlider setIntValue: i_volume];

    i_volume = (i_volume * 200) / AOUT_VOLUME_MAX;
    NSString *volumeTooltip = [NSString stringWithFormat:_NS("Volume: %i %%"), i_volume];
    [self.volumeSlider setToolTip:volumeTooltip];

    [self.volumeSlider setEnabled: !b_muted];
    [self.volumeUpButton setEnabled: !b_muted];
}

- (void)updateControls
{
    [super updateControls];

    bool b_input = false;
    bool b_seekable = false;
    bool b_plmul = false;
    bool b_control = false;
    bool b_chapters = false;

    playlist_t * p_playlist = pl_Get(getIntf());

    PL_LOCK;
    b_plmul = playlist_CurrentSize(p_playlist) > 1;
    PL_UNLOCK;

    input_thread_t * p_input = playlist_CurrentInput(p_playlist);
    if ((b_input = (p_input != NULL))) {
        /* seekable streams */
        b_seekable = var_GetBool(p_input, "can-seek");

        /* check whether slow/fast motion is possible */
        b_control = var_GetBool(p_input, "can-rate");

        /* chapters & titles */
        //FIXME! b_chapters = p_input->stream.i_area_nb > 1;

        vlc_object_release(p_input);
    }

    [self.stopButton setEnabled: b_input];
    [self.prevButton setEnabled: (b_seekable || b_plmul || b_chapters)];
    [self.nextButton setEnabled: (b_seekable || b_plmul || b_chapters)];

    [[[VLCMain sharedInstance] mainMenu] setRateControlsEnabled: b_control];
}

@end
