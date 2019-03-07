{ stdenv, fetchurl, atk, glibmm, pkgconfig, gnome3 }:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.29.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0igm7a2hfzknyb02zbydidbkwpk53af965wba468w7lrqyivlh21";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkgconfig ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = https://gtkmm.org;
    platforms = stdenv.lib.platforms.unix;
  };
}
