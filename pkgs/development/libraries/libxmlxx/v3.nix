{ stdenv, fetchurl, pkgconfig, libxml2, glibmm, perl }:

stdenv.mkDerivation rec {
  name = "libxml++-${maj_ver}.${min_ver}";
  maj_ver = "3.0";
  min_ver = "0";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${maj_ver}/${name}.tar.xz";
    sha256 = "0lkrajbdys5f6w6qwfijih3hnbk4c6809qx2mmxkb7bj2w269wrg";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    homepage = http://libxmlplusplus.sourceforge.net/;
    description = "C++ wrapper for the libxml2 XML parser library, version 3";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ loskutov ];
  };
}
