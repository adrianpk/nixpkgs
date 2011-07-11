{ automoc4, cmake, kde, kdelibs, qt4, exiv2 }:

kde.package {

  buildInputs = [ cmake kdelibs qt4 automoc4 exiv2 ];

  meta = {
    description = "Exiv2 support library";
    license = "GPLv2";
    kde.name = "libkexiv2";
  };
}
