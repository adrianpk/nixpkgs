{ fetchFromGitHub, perl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "libbson-${version}";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libbson";
    rev = version;
    sha256 = "0dbpmvd2p9bdqdyiijmsc1hd9d6l36migk79smw7fpfvh0y6ldsk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "A C Library for parsing, editing, and creating BSON documents";
    homepage = https://github.com/mongodb/libbson;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
