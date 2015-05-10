{ lib, stdenv, fetchurl, interactive ? false, readline ? null, ncurses ? null }:

assert interactive -> readline != null && ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.8.10.1";

  src = fetchurl {
    url = "http://sqlite.org/2015/sqlite-autoconf-3081001.tar.gz";
    sha1 = "86bfed5752783fb24c051f3efac5972ce11023f0";
  };

  buildInputs = lib.optionals interactive [ readline ncurses ];

  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ eelco np ];
  };
}
