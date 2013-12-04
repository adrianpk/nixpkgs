{ stdenv, fetchurl, cmake, qt4 }:
stdenv.mkDerivation rec {

  name = "vidalia-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "https://www.torproject.org/dist/vidalia/${name}.tar.gz";
    sha256 = "1mw3wnlh18rj20qjv7jxjk3a8mf75p5wzv358qfs3sm3lqgd68qm";
  };

  buildInputs = [ cmake qt4 ];

  meta = with stdenv.lib; {
    homepage = https://www.torproject.org/projects/vidalia.html.en;
    description = "a cross-platform graphical controller for the Tor software, built using the Qt framework";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}
