{ stdenv, fetchurl, gtk3
, pkgconfig, gnome3, dbus, xvfb_run }:
let
  version = "5.0.0";
  pname = "amtk";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zriix7bdwcg0868mfc7jy6zbwjwdmjwbh0ah6dbddrhiabrda8j";
  };

  nativeBuildInputs = [
    pkgconfig
    dbus
  ];

  buildInputs = [
    gtk3
  ];

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    ${xvfb_run}/bin/xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Amtk;
    description = "Actions, Menus and Toolbars Kit for GTK+ applications";
    maintainers = [ maintainers.manveru ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
