{stdenv, fetchurl, cmake, qt4, perl, gmp, python, libzip, libarchive, sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeutils-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdeutils-4.2.1.tar.bz2;
    sha1 = "2f875d05584b25b928b38e1da2b04c073acefd35";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon qimageblitz ];
}
