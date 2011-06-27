{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.7.7";

  src = fetchurl {
    url = http://www.sqlite.org/sqlite-autoconf-3070700.tar.gz;
    sha256 = "115isg9j4hqzq11ky25fj8pxwi4s9h7xzysi1klz584vkzc2mwzx";
  };

  buildInputs = [ readline ncurses ];
  
  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1";
  NIX_CFLAGS_LINK = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
