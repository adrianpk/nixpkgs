#! /bin/sh

export PATH=$pkgconfig/bin:$freetype/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$fontconfig/lib/pkgconfig:$Xft/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$fontconfig/lib:$Xft/lib

top=`pwd` || exit 1
tar xvfj $src || exit 1
cd pango-* || exit 1
./configure --prefix=$top --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf pango-* || exit 1
