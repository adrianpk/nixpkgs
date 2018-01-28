{ stdenv
, fetchurl, alsaLib
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.25.8";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "16s9z1xc5kv1p90g42vsr9m4gq3dwjsmrj873x4i8601mvpm3nkr";
  };

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags =
    stdenv.lib.optional (hostPlatform ? mpg123) "--with-cpu=${hostPlatform.mpg123.cpu}";

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = http://mpg123.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
    platforms = stdenv.lib.platforms.unix;
  };
}
