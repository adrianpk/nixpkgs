#! /bin/sh

buildinputs="$pkgconfig $perl $glib $gnomevfs $libbonobo $GConf \
  $popt $zlib"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libgnome-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo "$glib $gnomevfs $libbonobo $GConf" > $out/propagated-build-inputs || exit 1
