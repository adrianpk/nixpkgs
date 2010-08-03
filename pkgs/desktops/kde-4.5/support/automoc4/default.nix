{stdenv, fetchurl, cmake, qt4}:

stdenv.mkDerivation rec {
  name = "automoc4-0.9.88";
  src = fetchurl {
    url = "mirror://kde/stable/automoc4/0.9.88/${name}.tar.bz2";
    sha256 = "0jackvg0bdjg797qlbbyf9syylm0qjs55mllhn11vqjsq3s1ch93";
  };
  buildInputs = [ cmake qt4 ];
  meta = {
    description = "KDE Meta Object Compiler";
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
