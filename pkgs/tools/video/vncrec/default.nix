{ stdenv, fetchurl, libX11, xproto, imake, gccmakedep, libXt, libXmu
, libXaw, libXext, xextproto, libSM, libICE, libXpm, libXp
}:

stdenv.mkDerivation rec {
  name = "vncrec-0.2"; # version taken from Arch AUR

  src = fetchurl {
    url = "http://ronja.twibright.com/utils/vncrec-twibright.tgz";
    sha256 = "1yp6r55fqpdhc8cgrgh9i0mzxmkls16pgf8vfcpng1axr7cigyhc";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [
    libX11 xproto libXt libXmu libXaw
    libXext xextproto libSM libICE libXpm libXp
  ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man"
  ];
  installTargets = "install install.man";

  meta = {
    description = "VNC recorder";
    homepage = http://ronja.twibright.com/utils/vncrec/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
