{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
kdegraphics, lcms, jasper, libgphoto2, kdepimlibs, gettext}:

stdenv.mkDerivation rec {
  name = "digikam-1.2.0";

  src = fetchurl { 
    url = "mirror://sourceforge/digikam/${name}.tar.bz2";
    sha256 = "01hjcdm3l5rxz8wb7rvsplysy8hw2b3hcggg9dgk9bskpfskj1ck";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 eigen
    lcms jasper libgphoto2 kdepimlibs gettext ];
  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.digikam.org;
    maintainers = [ lib.maintainers.viric ];
    platforms = with lib.platforms; linux;
  };
}
