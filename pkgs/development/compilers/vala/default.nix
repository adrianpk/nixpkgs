{stdenv, fetchurl, yacc, flex, pkgconfig, glib, xz}:

stdenv.mkDerivation rec {
  name = "vala-0.17.2";

  src = fetchurl {
    url = mirror://gnome/sources/vala/0.17/vala-0.17.2.tar.xz;
    sha256 = "09i2s0dwmrk147ind2dx7nq845g12fp6fsjqrphhrr0dbi0zzgh3";
  };

  buildNativeInputs = [ yacc flex pkgconfig xz ];

  buildInputs = [ glib ];

  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = "free-copyleft";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
