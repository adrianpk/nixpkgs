{stdenv, gcc, fetchurl, perl, ghc, m4, readline, ncurses}:

stdenv.mkDerivation {
  name = "ghc-6.4.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ghc-6.4.1-src.tar.bz2;
    md5 = "fd289bc7c3afa272ff831a71a50b5b00";
  };
  buildInputs = [perl ghc m4];
  propagatedBuildInputs = [readline ncurses];
  builder = ./builder.sh;
  inherit gcc;
}
