{ stdenv, fetchFromGitHub, pkgconfig, qmake, mtdev, gsettings-qt ,
  lxqt, qtx11extras, qtmultimedia, qtsvg, fontconfig, freetype ,
  qt5dxcb-plugin, qtstyleplugins, dtkcore, dtkwidget, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qt5integration";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1v9whlqn07c5c8xnaiicdshj9n88a667gfbn8y8bk5bfylilfzcy";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    qt5dxcb-plugin
    mtdev
    lxqt.libqtxdg
    qtstyleplugins
    qtx11extras
    qtmultimedia
    qtsvg
  ];

  postPatch = ''
    sed -i dstyleplugin/dstyleplugin.pro \
           platformthemeplugin/qt5deepintheme-plugin.pro \
           iconengineplugins/svgiconengine/svgiconengine.pro \
           imageformatplugins/svg/svg.pro \
      -e "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix,"
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugins for DDE";
    homepage = https://github.com/linuxdeepin/qt5integration;
    license = with licenses; [ gpl3 lgpl2Plus bsd2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
