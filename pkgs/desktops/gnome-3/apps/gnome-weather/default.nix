{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gjs, gobject-introspection
, libgweather, meson, ninja, geoclue2, gnome-desktop, python3 }:

stdenv.mkDerivation rec {
  name = "gnome-weather-${version}";
  version = "3.31.92";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1r0z91k7brf0wbaln0k2cd53zdrzvm0czkd7cifkigjks2cll72m";
  };

  nativeBuildInputs = [ pkgconfig meson ninja wrapGAppsHook python3 ];
  buildInputs = [
    gtk3 gjs gobject-introspection gnome-desktop
    libgweather gnome3.adwaita-icon-theme geoclue2 gnome3.gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-weather";
      attrPath = "gnome3.gnome-weather";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Weather;
    description = "Access current weather conditions and forecasts";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
