{ stdenv, fetchurl
, fltk
, openssl
, libjpeg, libpng
, perl
, libXcursor, libXi, libXinerama
}:

stdenv.mkDerivation rec {
  version = "3.0.4";
  name = "dillo-${version}";

  src = fetchurl {
    url = "http://www.dillo.org/download/${name}.tar.bz2";
    sha256 = "0ffz481vgl7f12f575pmbagm8swgxgv9s9c0p8c7plhd04jsnazf";
  };

  buildInputs = with stdenv.lib;
    [ fltk openssl libjpeg libpng libXcursor libXi libXinerama ];

  nativeBuildInputs = [ perl ];

  configureFlags =  "--enable-ssl";

  meta = {
    homepage = http://www.dillo.org/;
    description = "A fast graphical web browser with a small footprint";
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
