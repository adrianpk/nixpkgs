{ gestures ? false
, stdenv, fetchurl, pkgconfig
, cairo, fontconfig, freetype, libXft, libXcursor, libXinerama
, libXpm, libXt, librsvg, libpng, fribidi, perl
, libstroke ? null
}:

assert gestures -> libstroke != null;

stdenv.mkDerivation rec {
  name = "fvwm-2.6.5";

  src = fetchurl {
    url = "ftp://ftp.fvwm.org/pub/fvwm/version-2/${name}.tar.bz2";
    sha256 = "1ks8igvmzm0m0sra05k8xzc8vkqy3gv1qskl6davw1irqnarjm11";
  };

  buildInputs = [
    pkgconfig cairo fontconfig freetype
    libXft libXcursor libXinerama libXpm libXt
    librsvg libpng fribidi perl
  ] ++ stdenv.lib.optional gestures libstroke;

  meta = {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
