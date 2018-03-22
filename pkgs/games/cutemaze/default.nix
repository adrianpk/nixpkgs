{ stdenv, fetchurl, qmake, qttools, qtsvg }:

stdenv.mkDerivation rec {
  name = "cutemaze-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${name}-src.tar.bz2";
    sha256 = "1a2jmkm7fjzdrvzgvbqfq20k0vvpwfcycagsm0haxb3fpv86950y";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtsvg ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv CuteMaze.app $out/Applications
  '';

  meta = with stdenv.lib; {
    homepage = https://gottcode.org/cutemaze/;
    description = "Simple, top-down game in which mazes are randomly generated";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
