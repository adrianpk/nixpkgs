{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2
, gdbmSupport ? true, gdbm ? null
, sqlite ? null
, db4 ? null
, readline ? null
, openssl ? null
, tk ? null
, tcl ? null
, libX11 ? null
, xproto ? null
, arch ? null
, sw_vers ? null
}:

# This derivation is mostly identical to the one that builds Python 2.x.
# Some of these settings may not apply to the latest version. A general
# cleanup might be worthwile.

assert zlibSupport -> zlib != null;
assert gdbmSupport -> gdbm != null;
assert stdenv.isDarwin -> arch != null;
assert stdenv.isDarwin -> sw_vers != null;

with stdenv.lib;

let

  majorVersion = "3.1";
  version = "${majorVersion}.3";

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [bzip2]
    ++ optional zlibSupport zlib
    ++ optional gdbmSupport gdbm
    ++ optional (sqlite != null) sqlite
    ++ optional (db4 != null) db4
    ++ optional (readline != null) readline
    ++ optional (openssl != null) openssl
    ++ optional (tk != null) tk
    ++ optional (tcl != null) tcl
    ++ optional (libX11 != null) libX11
    ++ optional (xproto != null) xproto
    ++ optional (arch != null) arch
    ++ optional (sw_vers != null) sw_vers
    ;

in

stdenv.mkDerivation ( {
  name = "python3-${version}";
  inherit majorVersion version;

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.bz2";
    sha256 = "1jsqapgwrcqcaskyi2qdn1xj7l8x5340a137hdfshk5ya4dg9xkp";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];

  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  configureFlags = "--enable-shared --with-threads --enable-unicode --with-wctype-functions";

  preConfigure = ''
    # Purity.
    for i in /usr /sw /opt /pkg; do
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  '' + (if readline != null then ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lncurses"
  '' else "");

  setupHook = ./setup-hook.sh;

  postInstall = ''
    rm -rf "$out/lib/python${majorVersion}/test"
  '';

  passthru = {
    inherit zlibSupport;
    sqliteSupport = sqlite != null;
    db4Support = db4 != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null);
    libPrefix = "python${majorVersion}";
  };

  meta = {
    homepage = "http://python.org";
    description = "a high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
} // (if stdenv.isDarwin then { NIX_CFLAGS_COMPILE = "-msse2" ; patches = [./search-path.patch]; } else {} ) )
