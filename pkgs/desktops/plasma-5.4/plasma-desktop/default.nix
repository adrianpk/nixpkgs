{ plasmaPackage, substituteAll, extra-cmake-modules, kdoctools
, attica, baloo, boost, fontconfig, kactivities, kauth, kcmutils
, kdbusaddons, kdeclarative, kded, kdelibs4support, kemoticons
, kglobalaccel, ki18n, kitemmodels, knewstuff, knotifications
, knotifyconfig, kpeople, krunner, kwallet, kwin, phonon
, plasma-framework, plasma-workspace, qtdeclarative, qtx11extras
, qtsvg, libXcursor, libXft, libxkbfile, xf86inputevdev
, xf86inputsynaptics, xinput, xkeyboard_config, xorgserver
, libcanberra_kde, libpulseaudio, makeQtWrapper, utillinux
, qtquick1, qtquickcontrols
}:

plasmaPackage rec {
  name = "plasma-desktop";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    attica boost fontconfig kcmutils kdbusaddons kded kitemmodels
    knewstuff knotifications knotifyconfig kwallet libcanberra_kde
    libXcursor libpulseaudio libXft libxkbfile phonon
    qtsvg xf86inputevdev xf86inputsynaptics
    xkeyboard_config xinput
  ];
  propagatedBuildInputs = [
    baloo kactivities kauth kdeclarative kdelibs4support kemoticons
    kglobalaccel ki18n kpeople krunner kwin plasma-framework
    plasma-workspace qtdeclarative qtquick1 qtquickcontrols
    qtx11extras
  ];
  # All propagatedBuildInputs should be present in the profile because
  # wrappers cannot be used here.
  propagatedUserEnvPkgs = propagatedBuildInputs;
  patches = [
    (substituteAll {
      src = ./0001-hwclock.patch;
      hwclock = "${utillinux}/sbin/hwclock";
    })
    ./0002-zoneinfo.patch
    ./0003-qt-5.5-QML-import-paths.patch
  ];
  NIX_CFLAGS_COMPILE = [ "-I${xorgserver}/include/xorg" ];
  cmakeFlags = [
    "-DEvdev_INCLUDE_DIRS=${xf86inputevdev}/include/xorg"
    "-DSynaptics_INCLUDE_DIRS=${xf86inputsynaptics}/include/xorg"
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kaccess"
    wrapQtProgram "$out/bin/solid-action-desktop-gen"
    wrapQtProgram "$out/bin/knetattach"
    wrapQtProgram "$out/bin/krdb"
    wrapQtProgram "$out/bin/kapplymousetheme"
    wrapQtProgram "$out/bin/kfontinst"
    wrapQtProgram "$out/bin/kcm-touchpad-list-devices"
    wrapQtProgram "$out/bin/kfontview"
  '';
}
