{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs, polkit_qt4 }:

stdenv.mkDerivation rec {
  name = "polkit-kde-agent-1-0.99.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/${name}.tar.bz2";
    sha256 = "0rxlq6x0vhvha8i6w109zpzzacp4imins55v4p4fq7a3k0kgywg3";
  };

  buildInputs = [ kdelibs polkit_qt4 ];

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  patchPhase = "sed -e s/KDE4_AUTOSTART/AUTOSTART/ -i CMakeLists.txt";

  meta = {
    platforms = stdenv.lib.platforms.linux;
    description = "PolicyKit authentication agent for KDE";
  };
}
