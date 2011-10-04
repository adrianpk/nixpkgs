{ stdenv, fetchurl, python, pyqt4, sip, popplerQt4, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qt4, icu
, pil, makeWrapper, unrar, chmlib, pythonPackages
}:

stdenv.mkDerivation rec {
  name = "calibre-0.8.21";

  src = fetchurl {
    url = "mirror://sourceforge/calibre/${name}.tar.gz";
    sha256 = "173is8qlsm1gbsx5a411c2226kakwyv200wcw97yfs613k7cz256";
  };

  inherit python;

  buildInputs =
    [ python pyqt4 sip popplerQt4 pkgconfig libpng imagemagick libjpeg
      fontconfig podofo qt4 pil makeWrapper chmlib icu
      pythonPackages.mechanize pythonPackages.lxml pythonPackages.dateutil
      pythonPackages.cssutils pythonPackages.beautifulsoap pythonPackages.sqlite3
    ];

  installPhase = ''
    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${popplerQt4}/include/poppler
    export POPPLER_LIB_DIR=${popplerQt4}/lib
    export MAGICK_INC=${imagemagick}/include/ImageMagick
    export MAGICK_LIB=${imagemagick}/lib
    export FC_INC_DIR=${fontconfig}/include/fontconfig
    export FC_LIB_DIR=${fontconfig}/lib
    export PODOFO_INC_DIR=${podofo}/include/podofo
    export PODOFO_LIB_DIR=${podofo}/lib
    python setup.py install --prefix=$out

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python/python/" $PYFILES
    for a in $out/bin/*; do
      wrapProgram $a --prefix PYTHONPATH : $PYTHONPATH --prefix LD_LIBRARY_PATH : ${unrar}/lib
    done
  '';

  meta = { 
    description = "Comprehensive e-book software";
    homepage = http://calibre-ebook.com;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
