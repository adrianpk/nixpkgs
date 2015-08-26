{ stdenv, fetchurl, intltool, pkgconfig, readline, openldap, cyrus_sasl, libupnp
, zlib, libxml2, gtk2, libnotify, speex, ffmpeg, libX11, polarssl, libsoup, udev
, ortp, mediastreamer, sqlite, belle-sip, libosip, libexosip
}:

stdenv.mkDerivation rec {
  name = "linphone-3.8.5";

  src = fetchurl {
    url = "mirror://savannah/linphone/3.8.x/sources/${name}.tar.gz";
    sha256 = "10brlbwkk61nhd5v2sim1vfv11xm138l1cqqh3imhs2sigmzzlax";
  };

  buildInputs = [
    readline openldap cyrus_sasl libupnp zlib libxml2 gtk2 libnotify speex ffmpeg libX11
    polarssl libsoup udev ortp mediastreamer sqlite belle-sip libosip libexosip
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "--enable-ldap"
    "--with-ffmpeg=${ffmpeg}"
    "--with-polarssl=${polarssl}"
    "--enable-lime"
    "--enable-external-ortp"
    "--enable-external-mediastreamer"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
