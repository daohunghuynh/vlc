//
//  VLCVoutWindowController.m
//  Pixie
//
//  Created by Dao Hung Huynh on 21/04/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

#include <stdarg.h>
#include <vlc_vout_display.h>

#import <Foundation/Foundation.h>
#import "VLCVoutWindowController.h"
#import "Pixie-Swift.h"

int WindowControlObjc(vout_window_t *p_wnd, int i_query, va_list args)
{
    switch(i_query) {
        case VOUT_WINDOW_SET_STATE:
        {
            unsigned i_state = va_arg(args, unsigned);
            return [VLCVoutWindowController WindowControl:p_wnd i_query:i_query args:NULL];//@[[NSNumber numberWithUnsignedInt: i_state]]);
        }
        case VOUT_WINDOW_SET_SIZE:
        {
            unsigned int i_width  = va_arg(args, unsigned int);
            unsigned int i_height = va_arg(args, unsigned int);
            return WindowControl(p_wnd, i_query, NULL);//@[i_width, i_height]);

        }
        case VOUT_WINDOW_SET_FULLSCREEN:
        {
            int i_full = va_arg(args, int);
            return WindowControl(p_wnd, i_query, NULL);//@[i_full]);
        }
        default:
        {
            return WindowControl(p_wnd, i_query, @[]);
        }
    }
}
