{stdenv, fetchurl, yacc}:
assert yacc != null;
stdenv.mkDerivation {
  name = "flex-2.5.4a";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/flex/flex-2.5.4a.tar.gz;
    md5 = "bd8753d0b22e1f4ec87a553a73021adf";
  };
  yacc = yacc;
}
