{ stdenv, fetchurl, alsaLib, libclthreads, libclxclient, libX11, libXft, libXrender, fftwFloat, libjack2, zita-alsa-pcmi }:

stdenv.mkDerivation rec {
  name = "jaaa-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "1czksxx2g8na07k7g57qlz0vvkkgi5bzajcx7vc7jhb94hwmmxbc";
  };

  buildInputs = [
    alsaLib libclthreads libclxclient libX11 libXft libXrender fftwFloat libjack2 zita-alsa-pcmi
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  meta = with stdenv.lib; {
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/index.html;
    description = "JACK and ALSA Audio Analyser";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
