#! /bin/sh

export PATH=/bin:/usr/bin

tar xvfj $glibcSrc || exit 1
(cd glibc-* && tar xvfj $linuxthreadsSrc) || exit 1

mkdir build || exit 1
cd build || exit 1
LDFLAGS=-Wl,-S ../glibc-*/configure --prefix=$out --enable-add-ons --disable-profile || exit 1

make || exit 1
make install || exit 1
make localedata/install-locales || exit 1
strip -S $out/lib/*.a $out/lib/*.so $out/lib/gconv/*.so
strip -s $out/bin/* $out/sbin/* $out/libexec/*

ln -sf /etc/ld.so.cache $out/etc/ld.so.cache || exit 1

exit 0
