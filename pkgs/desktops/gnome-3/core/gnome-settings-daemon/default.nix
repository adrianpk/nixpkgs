{ fetchurl, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, perl, gettext, gtk3, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, alsaLib, libcanberra-gtk3, upower, colord, libgweather, polkit, gsettings-desktop-schemas
, geoclue2, librsvg, xf86_input_wacom, udev, libgudev, libwacom, libxslt, libxml2, networkmanager
, gnome-desktop, geocode-glib, docbook_xsl, wrapGAppsHook, python3, ibus, xkeyboard_config, tzdata, nss, wrapperDir ? "/run/wrappers/bin" }:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-${version}";
  version = "3.31.92";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "07n6alm3qqj9c9zpzavidvrb6hqm325qlrbvwgm05b0xmwq32x9h";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig perl gettext libxml2 libxslt docbook_xsl wrapGAppsHook python3 ];

  buildInputs = [
    ibus gtk3 glib gsettings-desktop-schemas networkmanager
    libnotify gnome-desktop lcms2 libXtst libxkbfile libpulseaudio alsaLib
    libcanberra-gtk3 upower colord libgweather xkeyboard_config nss
    polkit geocode-glib geoclue2 librsvg xf86_input_wacom udev libgudev libwacom
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--set GSD_BACKLIGHT_HELPER "${wrapperDir}/gsd-backlight-helper")
  '';

  postPatch = ''
    for f in gnome-settings-daemon/codegen.py plugins/power/gsd-power-constants-update.pl meson_post_install.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-settings-daemon";
      attrPath = "gnome3.gnome-settings-daemon";
    };
  };

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
