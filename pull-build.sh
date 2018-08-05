#!/bin/sh

CFLAGS=${CFLAGS}
LDFLAGS=${LDFLAGS}

case "${ARCH}" in
    x86_64*)
        CFLAGS="${CFLAGS} -m64 -march=core2 -mtune=core2"
        LDFLAGS="${LDFLAGS} -m64"
        ;;
    *x86*)
        CFLAGS="${CFLAGS} -m32 -march=prescott -mtune=generic"
        LDFLAGS="${LDFLAGS} -m32"
        ;;
esac

OPTIONS="
        --prefix=`pwd`/vlc_install_dir
        --enable-macosx
        --enable-merge-ffmpeg
        --enable-osx-notifications
        --enable-faad
        --enable-flac
        --enable-theora
        --enable-shout
        --enable-ncurses
        --enable-twolame
        --enable-realrtsp
        --enable-libass
        --enable-macosx-qtkit
        --enable-macosx-avfoundation
        --disable-skins2
        --disable-xcb
        --disable-caca
        --disable-pulse
        --disable-sdl-image
        --disable-vnc
        --with-macosx-version-min=10.10
"

export CFLAGS
export LDFLAGS

# sh "$(dirname $0)"/../../../configure ${OPTIONS} $*
# `dirname $0`/configure --prefix='$HOME/Documents/Developer/Graphics/vlc_swift' --disable-vlc \
#     --disable-neon --disable-arm64 --disable-altivec --enable-optimize-memory --disable-sout --disable-lua \
#     --disable-sftp --disable-v4l2 --disable-decklink --disable-smbclient --disable-dsm --disable-libcddb --disable-screen \
#     --disable-vnc -disable-freerdp --enable-realrtsp --disable-dc1394 --disable-dv1394 --disable-vcd \
#     --enable-dependency-tracking \
#     --disable-a52 --disable-spatialaudio --disable-sparkle --disable-breakpad --disable-secret --disable-kwallet --disable-notify \
#     --disable-qt --disable-skins2 --disable-libtar \
#     --enable-merge-ffmpeg \
#     --enable-faad --enable-flac --enable-theora --enable-shout --enable-realrtsp --enable-libass \
#     --disable-xcb --disable-caca --disable-pulse --disable-sdl-image

# --with-sysroot --enable-cprof --with-default-font=PATH --with-default-monospace-font=PATH --with-default-font-family=NAME --enable-shine --enable-x26410b 
# --enable-macosx --with-macosx-version-min=10.12 --enable-macosx-qtkit --enable-macosx-avfoundation --disable-osx-notifications --enable-twolame --enable-ncurses  \
