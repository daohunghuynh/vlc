//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>
//#include <sys/mount.h>

#include <vlc_aout.h>
#include <vlc_input.h>
#include <vlc_common.h>
//#include <vlc_interface.h>
#include <vlc_extensions.h>
#include <vlc_playlist.h>
#include <vlc_interface.h>
#include <vlc_http.h>
#include <vlc_actions.h>
#include <vlc_vout_window.h>

//#include <vlc_access.h>
//#include <vlc_addons.h>
//#include <vlc_aout_volume.h>
//#include <vlc_arrays.h>
//#include <vlc_atomic.h>
//#include <vlc_avcodec.h>
//#include <vlc_bits.h>
//#include <vlc_block.h>
//#include <vlc_block_helper.h>
//#include <vlc_boxes.h>
//#include <vlc_charset.h>
//#include <vlc_codec.h>
//#include <vlc_codecs.h>
//#include <vlc_config.h>
//#include <vlc_config_cat.h>
//#include <vlc_configuration.h>
//#include <vlc_cpu.h>
//#include <vlc_demux.h>
//#include <vlc_dialog.h>
//#include <vlc_epg.h>
//#include <vlc_es.h>
//#include <vlc_es_out.h>
//#include <vlc_events.h>
//#include <vlc_filter.h>
//#include <vlc_fingerprinter.h>
//#include <vlc_fixups.h>
//#include <vlc_fourcc.h>
//#include <vlc_fs.h>
//#include <vlc_gcrypt.h>
//#include <vlc_httpd.h>
//#include <vlc_image.h>
//#include <vlc_inhibit.h>
//#include <vlc_input_item.h>
//#include <vlc_interrupt.h>
//#include <vlc_intf_strings.h>
//#include <vlc_iso_lang.h>
//#include <vlc_keystore.h>
//#include <vlc_md5.h>
//#include <vlc_media_library.h>
//#include <vlc_memstream.h>
//#include <vlc_messages.h>
//#include <vlc_meta.h>
//#include <vlc_meta_fetcher.h>
//#include <vlc_mime.h>
#include <vlc_modules.h>
//#include <vlc_mouse.h>
//#include <vlc_mtime.h>
//#include <vlc_network.h>
//#include <vlc_objects.h>
//#include <vlc_opengl.h>
//#include <vlc_pgpkey.h>
//#include <vlc_picture.h>
//#include <vlc_picture_fifo.h>
//#include <vlc_picture_pool.h>
//#include <vlc_plugin.h>
//#include <vlc_probe.h>
//#include <vlc_rand.h>
//#include <vlc_renderer_discovery.h>
//#include <vlc_services_discovery.h>
//#include <vlc_sout.h>
//#include <vlc_spu.h>
//#include <vlc_stream.h>
//#include <vlc_stream_extractor.h>
//#include <vlc_strings.h>
//#include <vlc_subpicture.h>
//#include <vlc_text_style.h>
//#include <vlc_threads.h>
//#include <vlc_timestamp_helper.h>
//#include <vlc_tls.h>
//#include <vlc_update.h>
//#include <vlc_url.h>
//#include <vlc_variables.h>
//#include <vlc_video_splitter.h>
//#include <vlc_viewpoint.h>
//#include <vlc_vlm.h>
//#include <vlc_vod.h>
//#include <vlc_vout.h>
//#include <vlc_vout_osd.h>
//#include <vlc_vout_wrapper.h>
//#include <vlc_xlib.h>
//#include <vlc_xml.h>
#include "VLCVoutWindowController.h"

void vplaylist_Control(playlist_t *p_playlist, int i_query, int b_locked)
{
    playlist_Control(p_playlist, i_query, b_locked);
}

#include <vlc_vout_display.h>
//#import "IOCDMedia.h"
