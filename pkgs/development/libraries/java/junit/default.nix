{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "junit-3.8.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/junit3.8.1.zip;
    md5 = "5110326e4b7f7497dfa60ede4b626751";
  };

  inherit unzip;
}
