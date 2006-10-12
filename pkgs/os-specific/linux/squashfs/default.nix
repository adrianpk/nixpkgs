{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "squashfs-3.1-r2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/squashfs3.1-r2.tar.gz;
    md5 = "c252e5286b142afa54ca49829c51a33f";
  };
  buildInputs = [zlib];
}
