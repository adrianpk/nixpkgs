{ stdenv, fetchurl, xz, bzip2, perl, xlibs, libdvdnav, libbluray
, zlib, a52dec, libmad, faad2, ffmpeg, alsaLib
, pkgconfig, dbus, fribidi, qt4, freefont_ttf
, libvorbis, libtheora, speex, lua5, libgcrypt, libupnp
, libcaca, pulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, udev, gnutls, avahi, libcddb, jackaudio, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, liboggz
, libass, libva, libdvbpsi, libdc1394, libraw1394, libopus
}:

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "2.0.7";

  src = fetchurl {
    url = "http://download.videolan.org/pub/videolan/vlc/${version}/${name}.tar.xz";
    sha256 = "052kfkpd0r2fwkyz97qhz2a368xqxa905qacrd1bkl2bkvahfc94";
  };

  postPatch = /* flac 1.3.0 fix */ ''
    sed -i -e 's:stream_decoder.h:FLAC/stream_decoder.h:' modules/codec/flac.c
    sed -i -e 's:stream_encoder.h:FLAC/stream_encoder.h:' modules/codec/flac.c
  '';

  buildInputs =
    [ xz bzip2 perl zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
      libbluray dbus fribidi qt4 libvorbis libtheora speex lua5 libgcrypt
      libupnp libcaca pulseaudio flac schroedinger libxml2 librsvg mpeg2dec
      udev gnutls avahi libcddb jackaudio SDL SDL_image libmtp unzip taglib
      libkate libtiger libv4l samba liboggz libass libdvbpsi libva
      xlibs.xlibs xlibs.libXv xlibs.libXvMC xlibs.libXpm xlibs.xcbutilkeysyms
      libdc1394 libraw1394 libopus
    ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags =
    [ "--enable-alsa"
      "--with-kde-solid=$out/share/apps/solid/actions"
      "--enable-dc1394"
    ];

  preConfigure = ''sed -e "s@/bin/echo@echo@g" -i configure'';

  enableParallelBuilding = true;

  preBuild = ''
    substituteInPlace modules/text_renderer/freetype.c --replace \
      /usr/share/fonts/truetype/freefont/FreeSerifBold.ttf \
      ${freefont_ttf}/share/fonts/truetype/FreeSerifBold.ttf
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
  };
}
