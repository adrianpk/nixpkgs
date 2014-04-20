{ stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  name = "xmlindent-${version}";
  version = "0.2.17";

  src = fetchurl {
    url = "mirror://sourceforge/project/xmlindent/xmlindent/${version}/${name}.tar.gz";
    sha256 = "0k15rxh51a5r4bvfm6c4syxls8al96cx60a9mn6pn24nns3nh3rs";
  };

  buildInputs = [ flex ];

  preConfigure = ''
    substituteInPlace Makefile --replace "PREFIX=/usr/local" "PREFIX=$out"
  '';

  meta = {
    description = "XML stream reformatter";
    homepage = http://xmlindent.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
