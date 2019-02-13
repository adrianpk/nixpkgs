{ stdenv, autoconf, automake, bash, fetchFromGitHub, libgcc, libjpeg_turbo,
  libpng, libtool, libxml2, pkgconfig, which, xorg }:
stdenv.mkDerivation rec {
  name = "nx-libs-${version}";
  version = "3.5.99.18";
  src = fetchFromGitHub {
    owner = "ArcticaProject";
    repo = "nx-libs";
    rev = version;
    sha256 = "07559zk9flzfnyr2ngcdr3nzccga4bl30wghalhrvpgpyljivdyv";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig which
    xorg.gccmakedep xorg.imake ];
  buildInputs = [ libgcc libjpeg_turbo libpng libxml2 xorg.fontutil
    xorg.libXcomposite xorg.libXdamage xorg.libXdmcp xorg.libXext xorg.libXfont2
    xorg.libXinerama xorg.libXpm xorg.libXrandr xorg.libXtst xorg.pixman
    xorg.xkbcomp xorg.xkeyboardconfig ];

  enableParallelBuilding = true;

  postPatch = ''
    find . -type f -executable -exec sed -i 's|^#!/bin/bash$|#!${bash}/bin/bash|g' {} \;
    find . -type f -name Makefile -exec sed -i 's|^\(SHELL:=\)/bin/bash$|\1${bash}/bin/bash|g' {} \;
    ln -s libNX_X11.so.6.3.0
  '';

  PREFIX=""; # Don't install to $out/usr/local
  installPhase = ''
    make DESTDIR="$out" install
    # See:
    # - https://salsa.debian.org/debian-remote-team/nx-libs/blob/bcc152100617dc59156015a36603a15db530a64f/debian/rules#L66-72
    # - https://github.com/ArcticaProject/nx-libs/issues/652
    patchelf --remove-needed "libX11.so.6" $out/bin/nxagent
  '';

  meta = {
    description = "NX X server based on Xnest";
    homepage = https://github.com/ArcticaProject/nx-libs;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jD91mZM2 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
