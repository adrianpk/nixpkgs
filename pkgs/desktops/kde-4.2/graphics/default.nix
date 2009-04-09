{stdenv, fetchurl, cmake, perl, qt4, exiv2, lcms, saneBackends, libgphoto2,
 libspectre, poppler, djvulibre, chmlib, libXxf86vm,
 kdelibs, automoc4, phonon, strigi, qimageblitz, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdegraphics-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdegraphics-4.2.2.tar.bz2;
    sha1 = "cb7bda631b6e5b1866b07c622c7dc54771a87760";
  };
  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre poppler chmlib
                  stdenv.gcc.libc libXxf86vm
                  kdelibs automoc4 phonon strigi qimageblitz soprano qca2 ];
}
