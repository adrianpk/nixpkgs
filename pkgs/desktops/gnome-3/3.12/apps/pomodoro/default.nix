{ stdenv, fetchgit, which, automake113x, intltool, pkgconfig, libtool, makeWrapper,
  dbus_glib, libcanberra, gst_all_1, upower, vala, gnome3_12, gtk3, gst_plugins_base,
  glib, gobjectIntrospection, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  name = "gnome-shell-pomodoro-0.10.2-11-gd5f5b69";

  src = fetchgit {
      url = git://github.com/codito/gnome-shell-pomodoro.git;
      rev = "refs/tags/0.10.2";
      sha256 = "e58966abd859e35cbd7fd4b8816b521f4ec9ba5cd8e8c27d2067dd2ec4554b40";
  };

  configureScript = ''./autogen.sh'';

  buildInputs = [
    which automake113x intltool glib gobjectIntrospection pkgconfig libtool
    makeWrapper dbus_glib libcanberra upower vala gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gnome3_12.gsettings_desktop_schemas gnome3_12.gnome_desktop
    gnome3_12.gnome_common gnome3_12.gnome_shell hicolor_icon_theme gtk3
  ];

  preBuild = ''
    sed -i \
        -e 's|/usr\(/share/gir-1.0/UPowerGlib\)|${upower}\1|' \
        -e 's|/usr\(/share/gir-1.0/GnomeDesktop\)|${gnome3_12.gnome_desktop}\1|' \
        vapi/Makefile
  '';

  preFixup = ''
    wrapProgram $out/bin/gnome-pomodoro \
        --prefix XDG_DATA_DIRS : \
        "$out/share:$GSETTINGS_SCHEMAS_PATH:$XDG_DATA_DIRS"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/codito/gnome-shell-pomodoro;
    description =
      "Personal information management application that provides integrated " + 
      "mail, calendaring and address book functionality";
    maintainers = with maintainers; [ DamienCassou ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
