{ stdenv, fetchurl, autoreconfHook, pkgconfig, vala, glib, gjs, mutter
, pango, gtk3, gnome3, dbus, clutter, appstream-glib, wrapGAppsHook, systemd, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "3.28.0";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "15zigqmhd2x58ml0rl6srgvpx8ms7a3dapphcr75563pacv46mir";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig vala wrapGAppsHook ];
  buildInputs = [ glib gjs mutter gnome3.adwaita-icon-theme
                  gtk3 gnome3.gnome-control-center dbus
                  clutter pango appstream-glib systemd gobjectIntrospection ];

  configureFlags = [ "--with-controlcenterdir=$(out)/share/gnome-control-center/keybindings"
                     "--with-dbusservicesdir=$(out)/share/dbus-1/services"
                     "--with-systemduserunitdir=$(out)/etc/systemd/user" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/Keruspe/GPaste;
    description = "Clipboard management system with GNOME3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
