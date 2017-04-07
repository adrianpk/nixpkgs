{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs4, kgraphviewer }:

stdenv.mkDerivation rec {
  name = "massif-visualizer-${version}";
  version = "0.3.90";

  src = fetchurl {
    url = "mirror://kde/unstable/massif-visualizer/${version}/src/${name}.tar.xz";
    sha256 = "9940fa90137ca5eef08b9ec220825fadbf03db423a670a2c7fe3edab271d9922";
  };

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];
  buildInputs = [ kdelibs4 kgraphviewer ];

  meta = with stdenv.lib; {
    description = "Tool that visualizes massif data generated by valgrind";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
