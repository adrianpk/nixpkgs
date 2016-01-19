{ stdenv, pkgconfig, zlib, qtbase, qtsvg, qttools, qtmultimedia, fetchurl }:
stdenv.mkDerivation rec {
  name = "chessx-${version}";
  version = "1.3.2";
  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${version}.tgz";
    sha256 = "b136cf56d37d34867cdb9538176e1703b14f61b3384885b6f100580d0af0a3ff";
  };
  preConfigure = ''
    qmake -spec linux-g++ chessx.pro
  '';
  buildInputs = [
   stdenv
   pkgconfig
   qtbase
   qtsvg
   qttools
   qtmultimedia
   zlib
  ];

  enableParallelBuilding = true;
  installPhase = ''
      mkdir -p "$out/bin"
      cp -pr release/chessx "$out/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://chessx.sourceforge.net/;
    description = "ChessX allows you to browse and analyse chess games";
    license = licenses.gpl2;
    maintainers = [maintainers.luispedro];
  };
}
