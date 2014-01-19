{ stdenv, fetchurl, alsaLib, boost, cairo, cmake, fftwSinglePrec, fltk
, jackaudio, libsndfile, mesa, minixml, pkgconfig, zlib
}:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "0rb0q0bqsaaj3imdjgfaigj1kbjqkx1gm91nh2mdgy9i09rygsbv";
  };

  buildInputs = [
    alsaLib boost cairo fftwSinglePrec fltk jackaudio libsndfile mesa
    minixml zlib
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = "cd src";

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.glibc}/lib/libm.so" ];

  meta = with stdenv.lib; {
    description = "high quality software synthesizer based on ZynAddSubFX";
    longDescription = ''
      Yoshimi delivers the same synthesizer capabilities as
      ZynAddSubFX along with very good Jack and Alsa midi/audio
      functionality on Linux
    '';
    homepage = http://yoshimi.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
