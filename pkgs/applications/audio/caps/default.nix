{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "caps-${version}";
  version = "0.9.24";
  src = fetchurl {
    url = "http://www.quitte.de/dsp/caps_${version}.tar.bz2";
    sha256 = "081zx0i2ysw5nmy03j60q9j11zdlg1fxws81kwanncdgayxgwipp";
  };
  configurePhase = ''
    echo "PREFIX = $out" > defines.make
  '';

  meta = {
    description = "A selection of LADSPA plugins implementing classic effects";
    longDescription = ''
      The C* Audio Plugin Suite is a selection of classic effects,
      unique filters and signal generators.  The digital guitarist
      finds in CAPS a range of processors recreating key aspects of
      the formation of tone in traditional electronic instrument
      amplification.  Beyond sound quality, central design
      considerations are latency-free realtime operation, modesty of
      resource demands and meaningful control interfaces.
    '';
    homepage = http://www.quitte.de/dsp/caps.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
