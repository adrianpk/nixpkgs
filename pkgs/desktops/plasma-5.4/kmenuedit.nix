{ plasmaPackage, extra-cmake-modules, kdoctools, ki18n, kxmlgui
, kdbusaddons, kiconthemes, kio, sonnet, kdelibs4support
}:

plasmaPackage {
  name = "kmenuedit";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kxmlgui kdbusaddons kiconthemes kio sonnet
  ];
  propagatedBuildInputs = [ kdelibs4support ki18n ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kmenuedit"
  '';
}
