{ stdenv, fetchurl, pkgconfig
, libX11, libXext, libXft, libXmu, libXinerama, libXrandr, libXpm
, imagemagick, libpng, libjpeg, libexif, libtiff, libungif, libwebp }:

stdenv.mkDerivation rec {
  name = "windowmaker-${version}";
  version = "0.95.7";
  srcName = "WindowMaker-${version}";

  src = fetchurl {
    url = "http://windowmaker.org/pub/source/release/${srcName}.tar.gz";
    sha256 = "1acph0nq6fsb452sl7j7a7kcc87zqqaw7qms1p8ijar19dn4hbc4";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libX11 libXext libXft libXmu libXinerama libXrandr libXpm
                  imagemagick libpng libjpeg libexif libtiff libungif libwebp ];

  configureFlags = [
    "--with-x"
    "--enable-modelock"
    "--enable-randr"
    "--enable-magick"
  ];

  meta = with stdenv.lib; {
    homepage = http://windowmaker.org/;
    description = "NeXTSTEP-like window manager";
    longDescription = ''
      Window Maker is an X11 window manager originally designed to
      provide integration support for the GNUstep Desktop
      Environment. In every way possible, it reproduces the elegant look
      and feel of the NEXTSTEP user interface. It is fast, feature rich,
      easy to configure, and easy to use. It is also free software, with
      contributions being made by programmers from around the world.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

# TODO: investigate support for WEBP (its autodetection is failing)
