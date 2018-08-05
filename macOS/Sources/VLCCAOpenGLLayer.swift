//
//  VLCCAOpenGLLayer.swift
//  CAOpenGLLayer (Mac OS X) video output
//
//  Created by Dao Hung Huynh on 15/09/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//

import Foundation
import QuartzCore

/*****************************************************************************
 * Preamble
 *****************************************************************************/

// #ifdef HAVE_CONFIG_H
// # include "config.h"
// #endif

// #include <vlc_common.h>
// #include <vlc_plugin.h>
// #include <vlc_vout_display.h>
// #include <vlc_opengl.h>

// #import <QuartzCore/QuartzCore.h>
// #import <Cocoa/Cocoa.h>
// #import <OpenGL/OpenGL.h>
// #import <dlfcn.h>               /* dlsym */

// #include "opengl/vout_helper.h"

// #define OSX_SIERRA_AND_HIGHER (NSAppKitVersionNumber >= 1485)

/*****************************************************************************
 * Vout interface
 *****************************************************************************/
// static int  Open   (vlc_object_t *);
// static void Close  (vlc_object_t *);

// vlc_module_begin()
//     set_description(N_("Core Animation OpenGL Layer (Mac OS X)"))
//     set_capability("vout display", 0)
//     set_category(CAT_VIDEO)
//     set_subcategory(SUBCAT_VIDEO_VOUT)
//     set_callbacks(Open, Close)
// vlc_module_end()

//static picture_pool_t *Pool (vout_display_t *vd, unsigned requested_count);
//static void PictureRender   (vout_display_t *vd, picture_t *pic, subpicture_t *subpicture);
//static void PictureDisplay  (vout_display_t *vd, picture_t *pic, subpicture_t *subpicture);
//static int Control          (vout_display_t *vd, int query, va_list ap);

//static void *OurGetProcAddress (vlc_gl_t *gl, const char *name);
//static int OpenglLock         (vlc_gl_t *gl);
//static void OpenglUnlock       (vlc_gl_t *gl);
//static void OpenglSwap         (vlc_gl_t *gl);

//@protocol VLCCoreAnimationVideoLayerEmbedding <NSObject>
//- (void)addVoutLayer:(CALayer *)aLayer;
//- (void)removeVoutLayer:(CALayer *)aLayer;
//- (CGSize)currentOutputSize;
//@end


//struct gl_sys
//{
//    CGLContextObj locked_ctx;
//    VLCCAOpenGLLayer *cgLayer;
//};

/*****************************************************************************
 * Open: This function allocates and initializes the OpenGL vout method.
 *****************************************************************************/
//static int Open (vlc_object_t *p_this)
//{
//    vout_display_t *vd = (vout_display_t *)p_this;
//    vout_display_sys_t *sys;
//
//    /* Allocate structure */
//    vd->sys = sys = calloc(1, sizeof(vout_display_sys_t));
//    if (sys == NULL)
//        return VLC_EGENERIC;
//
//    @autoreleasepool {
//        id container = var_CreateGetAddress(vd, "drawable-nsobject");
//        if (container)
//            vout_display_DeleteWindow(vd, NULL);
//        else {
//            sys->embed = vout_display_NewWindow(vd, VOUT_WINDOW_TYPE_NSOBJECT);
//            if (sys->embed)
//                container = sys->embed->handle.nsobject;
//
//            if (!container) {
//                msg_Err(vd, "No drawable-nsobject found!");
//                goto bailout;
//            }
//        }
//
//        /* store for later, released in Close() */
//        sys->container = [container retain];
//
//        CATransaction.begin()
//        sys->cgLayer = [[VLCCAOpenGLLayer alloc] init];
//        [sys->cgLayer setVoutDisplay:vd];
//
//        [sys->cgLayer performSelectorOnMainThread:@selector(display)
//                                       withObject:nil
//                                    waitUntilDone:YES];
//
//        if ([container respondsToSelector:@selector(addVoutLayer:)]) {
//            msg_Dbg(vd, "container implements implicit protocol");
//            [container addVoutLayer:sys->cgLayer];
//        } else if ([container respondsToSelector:@selector(addSublayer:)] ||
//                   [container isKindOfClass:[CALayer class]]) {
//            msg_Dbg(vd, "container doesn't implement implicit protocol, fallback mode used");
//            [container addSublayer:sys->cgLayer];
//        } else {
//            msg_Err(vd, "Provided NSObject container isn't compatible");
//            [sys->cgLayer release];
//            sys->cgLayer = nil;
//            CATransaction.commit()
//            goto bailout;
//        }
//        CATransaction.commit()
//
//        if (!sys->cgLayer)
//            goto bailout;
//
//        if (![sys->cgLayer glContext])
//            msg_Warn(vd, "we might not have an OpenGL context yet");
//
//        /* Initialize common OpenGL video display */
//        sys->gl = vlc_object_create(vd, sizeof(*sys->gl));
//        if (unlikely(!sys->gl))
//            goto bailout;
//        sys->gl->makeCurrent = OpenglLock;
//        sys->gl->releaseCurrent = OpenglUnlock;
//        sys->gl->swap = OpenglSwap;
//        sys->gl->getProcAddress = OurGetProcAddress;
//
//        struct gl_sys *glsys = sys->gl->sys = malloc(sizeof(*glsys));
//        if (!sys->gl->sys)
//            goto bailout;
//        glsys->locked_ctx = NULL;
//        glsys->cgLayer = sys->cgLayer;
//
//        const vlc_fourcc_t *subpicture_chromas;
//        video_format_t fmt = vd->fmt;
//        if (!OpenglLock(sys->gl)) {
//            sys->vgl = vout_display_opengl_New(&vd->fmt, &subpicture_chromas,
//                                               sys->gl, &vd->cfg->viewpoint);
//            OpenglUnlock(sys->gl);
//        } else
//            sys->vgl = NULL;
//        if (!sys->vgl) {
//            msg_Err(vd, "Error while initializing opengl display.");
//            goto bailout;
//        }
//
//        /* setup vout display */
//        vout_display_info_t info = vd->info;
//        info.subpicture_chromas = subpicture_chromas;
//        vd->info = info;
//
//        vd->pool    = Pool;
//        vd->prepare = PictureRender;
//        vd->display = PictureDisplay;
//        vd->control = Control;
//
//        if (OSX_SIERRA_AND_HIGHER) {
//            /* request our screen's HDR mode (introduced in OS X 10.11, but correctly supported in 10.12 only) */
//            if ([sys->cgLayer respondsToSelector:@selector(setWantsExtendedDynamicRangeContent:)]) {
//                [sys->cgLayer setWantsExtendedDynamicRangeContent:YES];
//            }
//        }
//
//        /* setup initial state */
//        CGSize outputSize;
//        if ([container respondsToSelector:@selector(currentOutputSize)])
//            outputSize = [container currentOutputSize];
//        else
//            outputSize = [sys->container visibleRect].size;
//        vout_display_SendEventDisplaySize(vd, (int)outputSize.width, (int)outputSize.height);
//
//        return VLC_SUCCESS;
//
//    bailout:
//        Close(p_this);
//        return VLC_EGENERIC;
//    }
//}

//static void Close (vlc_object_t *p_this)
//{
//    vout_display_t *vd = (vout_display_t *)p_this;
//    vout_display_sys_t *sys = vd->sys;
//
//    if (sys->cgLayer) {
//        if ([sys->container respondsToSelector:@selector(removeVoutLayer:)])
//            [sys->container removeVoutLayer:sys->cgLayer];
//        else
//            [sys->cgLayer removeFromSuperlayer];
//
//        if ([sys->cgLayer glContext])
//            CGLReleaseContext([sys->cgLayer glContext]);
//
//        [sys->cgLayer release];
//    }
//
//    if (sys->container)
//        [sys->container release];
//
//    if (sys->embed)
//        vout_display_DeleteWindow(vd, sys->embed);
//
//    if (sys->vgl != NULL && !OpenglLock(sys->gl)) {
//        vout_display_opengl_Delete(sys->vgl);
//        OpenglUnlock(sys->gl);
//    }
//
//    if (sys->gl != NULL)
//    {
//        if (sys->gl->sys != NULL)
//        {
//            assert(((struct gl_sys *)sys->gl->sys)->locked_ctx == NULL);
//            free(sys->gl->sys);
//        }
//        vlc_object_release(sys->gl);
//    }
//
//    free(sys);
//}

//static picture_pool_t *Pool (vout_display_t *vd, unsigned count)
//{
//    vout_display_sys_t *sys = vd->sys;
//
//    if (!sys->pool && !OpenglLock(sys->gl)) {
//        sys->pool = vout_display_opengl_GetPool(sys->vgl, count);
//        OpenglUnlock(sys->gl);
//        assert(sys->pool);
//    }
//    return sys->pool;
//}

//static void PictureRender (vout_display_t *vd, picture_t *pic, subpicture_t *subpicture)
//{
//    vout_display_sys_t *sys = vd->sys;
//
//    if (pic == NULL) {
//        msg_Warn(vd, "invalid pic, skipping frame");
//        return;
//    }
//
//    @synchronized (sys->cgLayer) {
//        if (!OpenglLock(sys->gl)) {
//            vout_display_opengl_Prepare(sys->vgl, pic, subpicture);
//            OpenglUnlock(sys->gl);
//        }
//    }
//}

//static void PictureDisplay (vout_display_t *vd, picture_t *pic, subpicture_t *subpicture)
//{
//    vout_display_sys_t *sys = vd->sys;
//
//    @synchronized (sys->cgLayer) {
//        sys->b_frame_available = true
//
//        /* Calling display on the non-main thread is not officially supported, but
//         * its suggested at several places and works fine here. Flush is thread-safe
//         * and makes sure the picture is actually displayed. */
//        [sys->cgLayer display];
//        CATransaction.flush()
//    }
//
//    picture_Release(pic);
//
//    if (subpicture)
//        subpicture_Delete(subpicture);
//}

//static int Control (vout_display_t *vd, int query, va_list ap)
//{
//    vout_display_sys_t *sys = vd->sys;
//
//    if (!vd->sys)
//        return VLC_EGENERIC;
//
//    switch (query)
//    {
//        case VOUT_DISPLAY_CHANGE_DISPLAY_SIZE:
//        case VOUT_DISPLAY_CHANGE_DISPLAY_FILLED:
//        case VOUT_DISPLAY_CHANGE_ZOOM:
//        case VOUT_DISPLAY_CHANGE_SOURCE_ASPECT:
//        case VOUT_DISPLAY_CHANGE_SOURCE_CROP:
//        {
//            const vout_display_cfg_t *cfg;
//
//            if (query == VOUT_DISPLAY_CHANGE_SOURCE_ASPECT || query == VOUT_DISPLAY_CHANGE_SOURCE_CROP) {
//                cfg = vd->cfg;
//            } else {
//                cfg = (const vout_display_cfg_t*)va_arg (ap, const vout_display_cfg_t *);
//            }
//
//            /* we always use our current frame here */
//            vout_display_cfg_t cfg_tmp = *cfg;
//            CATransaction.lock()
//            CGRect bounds = [sys->cgLayer visibleRect];
//            CATransaction.unlock()
//            cfg_tmp.display.width = bounds.size.width;
//            cfg_tmp.display.height = bounds.size.height;
//
//            /* Reverse vertical alignment as the GL tex are Y inverted */
//            if (cfg_tmp.align.vertical == VOUT_DISPLAY_ALIGN_TOP)
//                cfg_tmp.align.vertical = VOUT_DISPLAY_ALIGN_BOTTOM;
//            else if (cfg_tmp.align.vertical == VOUT_DISPLAY_ALIGN_BOTTOM)
//                cfg_tmp.align.vertical = VOUT_DISPLAY_ALIGN_TOP;
//
//            vout_display_place_t place;
//            vout_display_PlacePicture (&place, &vd->source, &cfg_tmp, false);
//            if (OpenglLock(sys->gl))
//                return VLC_EGENERIC;
//
//            vout_display_opengl_SetWindowAspectRatio(sys->vgl, (float)place.width / place.height);
//            OpenglUnlock(sys->gl);
//
//            sys->place = place;
//
//            return VLC_SUCCESS;
//        }
//
//        case VOUT_DISPLAY_CHANGE_VIEWPOINT:
//        {
//            int ret;
//
//            if (OpenglLock(sys->gl))
//                return VLC_EGENERIC;
//
//            ret = vout_display_opengl_SetViewpoint(sys->vgl,
//                &va_arg (ap, const vout_display_cfg_t* )->viewpoint);
//            OpenglUnlock(sys->gl);
//            return ret;
//        }
//
//        case VOUT_DISPLAY_RESET_PICTURES:
//            vlc_assert_unreachable ();
//        default:
//            msg_Err (vd, "Unhandled request %d", query);
//            return VLC_EGENERIC;
//    }
//
//    return VLC_SUCCESS;
//}

// #pragma mark OpenGL callbacks

//static int OpenglLock (vlc_gl_t *gl)
//{
//    struct gl_sys *sys = gl->sys;
//    assert(sys->locked_ctx == NULL);
//
//    CGLContextObj ctx = [sys->cgLayer glContext];
//    if(!ctx) {
//        return 1;
//    }
//
//    CGLError err = CGLLockContext(ctx);
//    if (kCGLNoError == err) {
//        sys->locked_ctx = ctx;
//        CGLSetCurrentContext(ctx);
//        return 0;
//    }
//    return 1;
//}

//static void OpenglUnlock (vlc_gl_t *gl)
//{
//    struct gl_sys *sys = gl->sys;
//    CGLUnlockContext(sys->locked_ctx);
//    sys->locked_ctx = NULL;
//}

//static void OpenglSwap (vlc_gl_t *gl)
//{
//    glFlush();
//}

//static void *OurGetProcAddress (vlc_gl_t *gl, const char *name)
//{
//    VLC_UNUSED(gl);
//
//    return dlsym(RTLD_DEFAULT, name);
//}

// #pragma mark CA layer

/*****************************************************************************
 * @implementation VLCCAOpenGLLayer
 *****************************************************************************/
class VLCCAOpenGLLayer : CAOpenGLLayer {

    override convenience init() {
        self.init()

        CATransaction.lock()
        self.needsDisplayOnBoundsChange = true
        self.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        self.isAsynchronous = false
        CATransaction.unlock()
    }

    var voutDisplay: UnsafeMutablePointer<vout_display_t>?
    var glContext: CGLContextObj?

//    func setVoutDisplay(aVd: vout_display_t) {
//        self.voutDisplay = aVd;
//    }

    override func resize(withOldSuperlayerSize size: CGSize) {
        super.resize(withOldSuperlayerSize: size)

        let boundsSize = self.visibleRect.size
        if self.voutDisplay != nil {
            vout_display_SendEventDisplaySize(self.voutDisplay!, Int32(boundsSize.width), Int32(boundsSize.height))
        }
    }

    func canDrawInCGLContext(glContext: CGLContextObj, pixelFormat: CGLPixelFormatObj, forLayerTime timeInterval: CFTimeInterval, displayTime timeStamp: UnsafeMutablePointer<CVTimeStamp>) -> Bool {
        /* Only draw the frame if we have a frame that was previously rendered */
        if self.voutDisplay == nil {
            return false
        }

        return self.voutDisplay!.pointee.sys.b_frame_available
    }

    func drawInCGLContext(glContext: CGLContextObj, pixelFormat: CGLPixelFormatObj, forLayerTime timeInterval: CFTimeInterval, displayTime timeStamp: UnsafeMutablePointer<CVTimeStamp>) {
        if self.voutDisplay == nil {
            return
        }

        let sys: UnsafeMutablePointer<vout_display_sys_t> = self.voutDisplay.pointee.sys

        if sys.vgl == nil {
            return
        }

        let bounds = self.visibleRect

        // x / y are top left corner, but we need the lower left one
        vout_display_opengl_Viewport(sys.pointee.vgl,
                                     sys.pointee.place.x,
                                     bounds.size.height - (sys.pointee.place.y + sys.pointee.place.height),
                                     sys.pointee.place.width,
                                     sys.pointee.place.height)

        // flush is also done by this method, no need to call super
        vout_display_opengl_Display(sys.pointee.vgl, &self.voutDisplay.pointee.source)
        sys.pointee.b_frame_available = false
    }

    override func copyCGLPixelFormat(forDisplayMask mask: uint32_t) -> CGLPixelFormatObj {
        // The default is fine for this demonstration.
        return super.copyCGLPixelFormat(forDisplayMask: mask)
    }

    override func copyCGLContext(forPixelFormat pixelFormat: CGLPixelFormatObj) -> CGLContextObj {
        // Only one opengl context is allowed for the module lifetime
        if self.glContext != nil {
//            msg_Dbg(self.voutDisplay, "Return existing context: %p", self.glContext)
            return self.glContext!
        }

        let context: CGLContextObj = super.copyCGLContext(forPixelFormat: pixelFormat)

        // Swap buffers only during the vertical retrace of the monitor.
        //http://developer.apple.com/documentation/GraphicsImaging/
        //Conceptual/OpenGL/chap5/chapter_5_section_44.html /

        var params: GLint = 1
        CGLSetParameter(CGLGetCurrentContext(), kCGLCPSwapInterval, &params)
// TODO
//        @synchronized (self) {
            self.glContext = context;
//        }
        return context
    }

    override func releaseCGLContext(_ glContext: CGLContextObj) {
        // do not release anything here, we do that when closing the module
    }

    func mouseButtonDown(buttonNumber: int) {
        // TODO
//        @synchronized (self) {
            if self.voutDisplay != nil {
                if buttonNumber == 0 {
                    vout_display_SendEventMousePressed(self.voutDisplay!, MOUSE_BUTTON_LEFT)
                } else if buttonNumber == 1 {
                    vout_display_SendEventMousePressed(self.voutDisplay!, MOUSE_BUTTON_RIGHT)
                } else {
                    vout_display_SendEventMousePressed(self.voutDisplay!, MOUSE_BUTTON_CENTER)
                }
            }
//        }
    }

    func mouseButtonUp(buttonNumber: int) {
        // TODO
//        @synchronized (self) {
            if self.voutDisplay != nil {
                if buttonNumber == 0 {
                    vout_display_SendEventMouseReleased(self.voutDisplay!, MOUSE_BUTTON_LEFT)
                } else if buttonNumber == 1 {
                    vout_display_SendEventMouseReleased(self.voutDisplay!, MOUSE_BUTTON_RIGHT)
                } else {
                    vout_display_SendEventMouseReleased(self.voutDisplay!, MOUSE_BUTTON_CENTER)
                }
            }
//        }
    }

    func mouseMovedTo(x: double, y: double) {
        // TODO
        //        @synchronized (self) {
            if (self.voutDisplay) {
                vout_display_SendMouseMovedDisplayCoordinates(self.voutDisplay,
                                                              ORIENT_NORMAL,
                                                              x,
                                                              y,
                                                              &self.voutDisplay->sys->place);
            }
//        }
    }
}
