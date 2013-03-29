{ stdenv, fetchurl, python, pkgconfig, popt, libX11, xextproto, libSM, libICE, libXtst, libXi
, intltool, dbus_glib }:

stdenv.mkDerivation rec {

  versionMajor = "2.8";
  versionMinor = "0";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0n64h6j10sn90ds9y70d9wlvvsbwnrym9fm0cyjxb0zmqw7s6q8q";
  };

  buildInputs = [ python pkgconfig popt libX11 xextproto libSM libICE libXtst libXi intltool dbus_glib ];
}
