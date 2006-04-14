{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi
, libjpeg, libpng, zlib, cairo

, # If you want the resulting program to call itself "Firefox" instead
  # of "Deer Park", enable this option.  However, those binaries may
  # not be distributed without permission from the Mozilla Foundation,
  # see http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

stdenv.mkDerivation {
  name = "firefox-1.5.0.2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.5.0.2/source/firefox-1.5.0.2-source.tar.bz2;
    md5 = "6bd65d899e9bcb16c28225899cc61a1e";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
  ];
  inherit gtk;

  patches = [./writable-copies.patch];

  configureFlags = [
    "--enable-application=browser"
    "--enable-optimize"
    "--disable-debug"
    "--enable-xft"
    "--disable-freetype2"
    "--enable-svg"
    "--enable-strip"
    "--enable-default-toolkit=gtk2"
    "--with-system-jpeg"
    "--with-system-png"
    "--with-system-zlib"
    "--with-system-cairo"
  ]
  ++ (if enableOfficialBranding then ["--enable-official-branding"] else []);

  meta = {
    description = "Mozilla Firefox - the browser, reloaded";
  };
}
