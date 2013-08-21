{ stdenv, fetchurl, pkgconfig, fuse, perl }:

stdenv.mkDerivation rec {
  name = "cromfs-1.5.10.1";
  
  src = fetchurl {
    url = "http://bisqwit.iki.fi/src/arch/${name}.tar.bz2";
    sha256 = "0fg6vnbxr5jk4gqj31yqc9fj1gp3bj955qhxav28nvc6sbql7ac2";
  };

  patchPhase = ''sed -i 's@/bin/bash@/bin/sh@g' configure'';

  # Removing the static linking, as it doesn't compile in x86_64.
  makeFlags = "cromfs-driver util/mkcromfs util/unmkcromfs util/cvcromfs";
  
  installPhase = ''
    install -d $out/bin
    install cromfs-driver $out/bin
    install util/cvcromfs $out/bin
    install util/mkcromfs $out/bin
    install util/unmkcromfs $out/bin
  '';

  buildInputs = [ pkgconfig fuse perl ];

  meta = {
    description = "FUSE Compressed ROM filesystem with lzma";
    homepage = http://bisqwit.iki.fi/source/cromfs.html;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
