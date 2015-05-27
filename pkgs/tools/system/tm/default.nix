{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "tm-0.4.1";

  installPhase=''make install "PREFIX=$out"'';

  patchPhase = ''sed -i 's@/usr/bin/install@install@g' Makefile'';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/tm/tm-0.4.1.tar.gz;
    sha256 = "3b389bc03b6964ad5ffa57a344b891fdbcf7c9b2604adda723a863f83657c4a0";
  };

  meta = with stdenv.lib; {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/tm";
    description = "terminal mixer - multiplexer for the i/o of terminal applications";
    license = with licenses; gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; all;
  };

}
