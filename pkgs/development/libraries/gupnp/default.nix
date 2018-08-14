{ stdenv, fetchurl, pkgconfig, gobjectIntrospection, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_44, glib, gssdp, libsoup, libxml2, libuuid }:

stdenv.mkDerivation rec {
  name = "gupnp-${version}";
  version = "1.0.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${stdenv.lib.versions.majorMinor version}/gupnp-${version}.tar.xz";
    sha256 = "043nqxlj030a3wvd6x4c9z8fjarjjjsl2pjarl0nn70ig6kzswsi";
  };

  patches = [
    # Nix’s pkg-config ignores Requires.private
    # https://github.com/NixOS/nixpkgs/commit/1e6622f4d5d500d6e701bd81dd4a22977d10637d
    # We are essentialy reverting the following patch for now
    # https://bugzilla.gnome.org/show_bug.cgi?id=685477
    # at least until Requires.internal or something is implemented
    # https://gitlab.freedesktop.org/pkg-config/pkg-config/issues/7
    ./fix-requires.patch
  ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection vala gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_44 ];
  propagatedBuildInputs = [ glib gssdp libsoup libxml2 libuuid ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.gupnp.org/;
    description = "An implementation of the UPnP specification";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
