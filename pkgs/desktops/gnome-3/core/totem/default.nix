{ stdenv, fetchurl, meson, ninja, intltool, gst_all_1, clutter
, clutter-gtk, clutter-gst, python3Packages, shared-mime-info
, pkgconfig, gtk3, glib, gobjectIntrospection
, bash, wrapGAppsHook, itstool, libxml2, vala, gnome3, librsvg
, gdk_pixbuf, tracker, nautilus }:

stdenv.mkDerivation rec {
  name = "totem-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "10n302fdp3lhkzbij5sbzmsnln738029xil6cnng2d4dxv4n1099";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ meson ninja vala pkgconfig intltool python3Packages.python itstool gobjectIntrospection wrapGAppsHook ];
  buildInputs = [
    gtk3 glib gnome3.grilo clutter-gtk clutter-gst gnome3.totem-pl-parser gnome3.grilo-plugins
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly gst_all_1.gst-libav gnome3.libpeas shared-mime-info
    gdk_pixbuf libxml2 gnome3.defaultIconTheme gnome3.gnome-desktop
    gnome3.gsettings-desktop-schemas tracker nautilus
    python3Packages.pygobject3 python3Packages.dbus-python # for plug-ins
  ];

  postPatch = ''
    chmod +x meson_compile_python.py meson_post_install.py # patchShebangs requires executable file
    patchShebangs .
  '';

  mesonFlags = [
    "-Dwith-nautilusdir=lib/nautilus/extensions-3.0"
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "totem";
      attrPath = "gnome3.totem";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
