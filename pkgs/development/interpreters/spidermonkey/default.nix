{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "spidermonkey-1.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/js-1.5.tar.gz;
    md5 = "863bb6462f4ce535399a7c6276ae6776";
  };

  builder = ./builder.sh;
}
