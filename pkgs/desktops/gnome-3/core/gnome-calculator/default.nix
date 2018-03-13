{ stdenv, intltool, fetchurl, pkgconfig, libxml2
, bash, gtk3, glib, wrapGAppsHook
, itstool, gnome3, librsvg, gdk_pixbuf, mpfr, gmp, libsoup, libmpc }:

stdenv.mkDerivation rec {
  name = "gnome-calculator-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1qnfvmf615v52c8h1f6zxbvpywi3512hnzyf9azvxb8a6q0rx1vn";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-calculator"; attrPath = "gnome3.gnome-calculator"; };
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ bash gtk3 glib intltool itstool
                  libxml2 gnome3.gtksourceview mpfr gmp
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings-desktop-schemas gnome3.dconf libsoup libmpc ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
