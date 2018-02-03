{ stdenv, fetchurl, mecab, kytea, libedit, pkgconfig
, suggestSupport ? false, zeromq, libevent, libmsgpack
, lz4Support  ? false, lz4
, zlibSupport ? false, zlib
}:

stdenv.mkDerivation rec {

  name    = "groonga-${version}";
  version = "7.1.0";

  src = fetchurl {
    url    = "http://packages.groonga.org/source/groonga/${name}.tar.gz";
    sha256 = "1v0dyahlq7801bgcyvawj8waw6z84r0sr90x2b8nnrisrac3b8m7";
  };

  buildInputs = with stdenv.lib;
     [ pkgconfig mecab kytea libedit ]
    ++ optional lz4Support lz4
    ++ optional zlibSupport zlib
    ++ optionals suggestSupport [ zeromq libevent libmsgpack ];

  configureFlags = with stdenv.lib;
       optional zlibSupport "--with-zlib"
    ++ optional lz4Support  "--with-lz4";

  doInstallCheck    = true;
  installCheckPhase = "$out/bin/groonga --version";

  meta = with stdenv.lib; {
    homepage    = http://groonga.org/;
    description = "An open-source fulltext search engine and column store";
    license     = licenses.lgpl21;
    maintainers = [ maintainers.ericsagnes ];
    platforms   = platforms.linux;
    longDescription = ''
      Groonga is an open-source fulltext search engine and column store. 
      It lets you write high-performance applications that requires fulltext search.
    '';
  };

}
