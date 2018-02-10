{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.8.4";
  name = "debianutils-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/debianutils/debianutils_${version}.tar.xz";
    sha256 = "1chypq3dbkgvl16lgzdvqvlr7cdm3814nqmp8ch8j7x6mscsnqf0";
  };

  meta = {
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
       This package provides a number of small utilities which are used primarily by the installation scripts of Debian packages, although you may use them directly.

       The specific utilities included are: add-shell installkernel ischroot remove-shell run-parts savelog tempfile which
    '';
    downloadPage = https://packages.debian.org/sid/debianutils;
    license = with stdenv.lib.licenses; [ gpl2Plus publicDomain smail ];
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
