{ stdenv, fetchFromGitHub, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.12.1";
  name = "cgal-" + version;

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "releases";
    rev = "CGAL-${version}";
    sha256 = "0b8wwfnvbayxi18jahfdplkjqr59ynq6phk0kz62gqp8vmwia9d9";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [ boost gmp mpfr ];
  nativeBuildInputs = [ cmake ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = http://cgal.org;
    license = with licenses; [ gpl3Plus lgpl3Plus];
    platforms = platforms.all;
    maintainers = [ maintainers.raskin ];
  };
}
