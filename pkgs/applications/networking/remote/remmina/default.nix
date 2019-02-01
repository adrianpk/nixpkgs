{ stdenv, fetchFromGitLab, cmake, ninja, pkgconfig, wrapGAppsHook
, glib, gtk3, gettext, libxkbfile, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem
, pcre, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, libsoup, spice-protocol, spice-gtk, epoxy, at-spi2-core
, openssl, gsettings-desktop-schemas, json-glib
# The themes here are soft dependencies; only icons are missing without them.
, hicolor-icon-theme, adwaita-icon-theme
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "remmina";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner  = "Remmina";
    repo   = "Remmina";
    rev    = "v${version}";
    sha256 = "15b0fnv7xra4fpmn2y4k2rpzcss30sd1dhnx7yvhs2zq12z2m0wi";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig wrapGAppsHook ];
  buildInputs = [
    gsettings-desktop-schemas
    glib gtk3 gettext libxkbfile libX11
    freerdp libssh libgcrypt gnutls
    pcre libdbusmenu-gtk3 libappindicator-gtk3
    libvncserver libpthreadstubs libXdmcp libxkbcommon
    libsecret libsoup spice-protocol spice-gtk epoxy at-spi2-core
    openssl hicolor-icon-theme adwaita-icon-theme json-glib
  ];

  cmakeFlags = [
    "-DWITH_VTE=OFF"
    "-DWITH_TELEPATHY=OFF"
    "-DWITH_AVAHI=OFF"
    "-DFREERDP_LIBRARY=${freerdp}/lib/libfreerdp2.so"
    "-DFREERDP_CLIENT_LIBRARY=${freerdp}/lib/libfreerdp-client2.so"
    "-DFREERDP_WINPR_LIBRARY=${freerdp}/lib/libwinpr2.so"
    "-DWINPR_INCLUDE_DIR=${freerdp}/include/winpr2"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
    )
  '';

  meta = {
    license = licenses.gpl2;
    homepage = https://gitlab.com/Remmina/Remmina;
    description = "Remote desktop client written in GTK+";
    maintainers = with maintainers; [ melsigl ryantm ];
    platforms = platforms.linux;
  };
}
