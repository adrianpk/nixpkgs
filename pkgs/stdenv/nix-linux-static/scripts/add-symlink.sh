$extra2/bin/chmod u+w $out/include
(cd $out/include && $extra2/bin/ln -s $extra/include/* .) || exit 1

cd $out
$extra3/bin/find . -not -type l -exec $extra2/bin/chmod u+w {} \;
$extra3/bin/find . -exec $patchelf --interpreter $out/lib/ld-linux.so.2 --shrink-rpath {} \; || true

$extra2/bin/cat ./bin/catchsegv | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./bin/catchsegv
$extra2/bin/cat ./bin/tzselect | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./bin/tzselect
$extra2/bin/cat ./bin/xtrace | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./bin/xtrace
$extra2/bin/cat ./bin/ldd | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./bin/ldd

$extra2/bin/cat ./lib/libc.so | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./lib/libc.so
$extra2/bin/cat ./lib/libpthread.so | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./lib/libpthread.so

$extra3/bin/find . -not -type l -exec $extra2/bin/chmod u-w {} \;
