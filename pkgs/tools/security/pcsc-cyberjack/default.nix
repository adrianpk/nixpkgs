{ stdenv, fetchurl, pkgconfig, libusb, pcsclite }:

stdenv.mkDerivation rec {
  name = "pcsc-cyberjack-${version}";
  version = "3.99.5_SP12";

  src = with stdenv.lib; let
    splittedVer = splitString "_" version;
    mainVer = if length splittedVer >= 1 then head splittedVer else version;
    spVer = optionalString (length splittedVer >= 1) ("." + last splittedVer);
    tarballVersion = "${mainVer}final${spVer}";
  in fetchurl {
    url = "http://support.reiner-sct.de/downloads/LINUX/V${version}"
        + "/pcsc-cyberjack-${tarballVersion}.tar.bz2";
    sha256 = "04pkmybal56s5xnjld09vl1s1h6qf8mvhm41b758d6hi240kgp1j";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb pcsclite ];

  configureFlags = [ "--with-usbdropdir=\${prefix}/pcsc/drivers" ];

  meta = with stdenv.lib; {
    description = "REINER SCT cyberJack USB chipcard reader user space driver";
    homepage = https://www.reiner-sct.com/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aszlig ];
  };
}
