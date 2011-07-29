{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "KDE Timer";
    kde = {
      name = "ktimer";
      module = "kdeutils";
      version = "0.6";
      versionFile = "main.cpp";
    };
  };
}
