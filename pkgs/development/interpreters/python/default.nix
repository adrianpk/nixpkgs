{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.4.2";
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.4.2/Python-2.4.2.tar.bz2;
    md5 = "98db1465629693fc434d4dc52db93838";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
}
