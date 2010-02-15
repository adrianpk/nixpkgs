{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdelibs_experimental, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdepim-runtime-4.3.5.tar.bz2;
    sha256 = "0184ag4f1fpjjywbrqh4fcgbhkmdl5bgffvzpfgxy5g2ridl0966";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdelibs_experimental kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  includeAllQtDirs=true;
  builder = ./builder.sh;
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
