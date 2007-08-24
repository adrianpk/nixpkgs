{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "flac-1.1.2";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/flac/flac-1.1.2.tar.gz;
    md5 = "2bfc127cdda02834d0491ab531a20960" ;
  };

  buildInputs = [libogg] ;
}
