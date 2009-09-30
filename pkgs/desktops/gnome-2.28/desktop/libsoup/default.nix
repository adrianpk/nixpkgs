{stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, glib, GConf}:

stdenv.mkDerivation {
  name = "libsoup-2.28.0";
  src = fetchurl {
    url = nirror://gnome/sources/libsoup/2.28/libsoup-2.28.0.tar.bz2;
    sha256 = "1dkgih5im81lqc0y2qv3xcjd8hvmd4fjjvh5a5akfq6mjp9ifwk4";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl glib GConf ];
}
