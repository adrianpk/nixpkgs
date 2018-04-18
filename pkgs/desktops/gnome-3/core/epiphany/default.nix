{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig, gtk, glib, icu
, wrapGAppsHook, gnome3, libxml2, libxslt, itstool
, webkitgtk, libsoup, glib-networking, libsecret, gnome-desktop, libnotify, p11-kit
, sqlite, gcr, isocodes, desktop-file-utils
, gdk_pixbuf, gst_all_1, json-glib }:

stdenv.mkDerivation rec {
  name = "epiphany-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0zvxrwlswxadq4zbr4f73ms141d08j0lhi6rzmj83j1s3gan88md";
  };

  # Tests need an X display
  mesonFlags = [ "-Dunit_tests=false" ];

  nativeBuildInputs = [
    meson ninja libxslt pkgconfig itstool gettext wrapGAppsHook desktop-file-utils
  ];

  buildInputs = [
    gtk glib webkitgtk libsoup libxml2 libsecret gnome-desktop libnotify
    sqlite isocodes p11-kit icu
    gdk_pixbuf gnome3.defaultIconTheme gcr
    glib-networking gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav json-glib
  ];

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "epiphany";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
