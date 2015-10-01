{ stdenv, fetchurl, alsaLib, libjack2, pkgconfig, libpulseaudio, xorg }:

stdenv.mkDerivation  rec {
  name = "bristol-${version}";
  version = "0.60.11";

  src = fetchurl {
    url = "mirror://sourceforge/bristol/${name}.tar.gz";
    sha256 = "1fi2m4gmvxdi260821y09lxsimq82yv4k5bbgk3kyc3x1nyhn7vx";
  };

  buildInputs = [
    alsaLib libjack2 pkgconfig libpulseaudio xorg.libX11 xorg.libXext
    xorg.xproto
  ];

  preInstall = ''
    sed -e "s@\`which bristol\`@$out/bin/bristol@g" -i bin/startBristol
    sed -e "s@\`which brighton\`@$out/bin/brighton@g" -i bin/startBristol
  '';

  meta = with stdenv.lib; {
    description = "A range of synthesiser, electric piano and organ emulations";
    homepage = http://bristol.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
