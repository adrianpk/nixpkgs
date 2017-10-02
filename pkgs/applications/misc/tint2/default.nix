{ stdenv, fetchFromGitLab, pkgconfig, cmake, gettext, cairo, pango, pcre
, glib, imlib2, gtk2, libXinerama, libXrender, libXcomposite, libXdamage
, libX11, libXrandr, librsvg, libpthreadstubs, libXdmcp
, libstartup_notification, hicolor_icon_theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "15.2";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "1lfk3zcgmmlby353gs70gpi0m28nx2c20wxqgaw7268a69r5cz7a";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake gettext wrapGAppsHook ];

  buildInputs = [ cairo pango pcre glib imlib2 gtk2 libXinerama libXrender
    libXcomposite libXdamage libX11 libXrandr librsvg libpthreadstubs
    libXdmcp libstartup_notification hicolor_icon_theme ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace /etc $out/etc
    for f in ./src/launcher/apps-common.c \
             ./src/launcher/icon-theme-common.c \
             ./themes/*tint2rc
    do
      substituteInPlace $f --replace /usr/share/ /run/current-system/sw/share/
    done
  '';

  meta = {
    homepage = https://gitlab.com/o9000/tint2;
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
