{ stdenv, fetchpatch, fetchurl, openssl, pkgconfig, libnl
, dbus, readline ? null, pcsclite ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "2.7";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "https://w1.fi/releases/${name}.tar.gz";
    sha256 = "0x1hqyahq44jyla8jl6791nnwrgicrhidadikrnqxsm2nw36pskn";
  };

  # TODO: Patch epoll so that the dbus actually responds
  # TODO: Figure out how to get privsep working, currently getting SIGBUS
  extraConfig = ''
    CONFIG_AP=y
    CONFIG_LIBNL32=y
    CONFIG_EAP_FAST=y
    CONFIG_EAP_PWD=y
    CONFIG_EAP_PAX=y
    CONFIG_EAP_SAKE=y
    CONFIG_EAP_GPSK=y
    CONFIG_EAP_GPSK_SHA256=y
    CONFIG_WPS=y
    CONFIG_WPS_ER=y
    CONFIG_WPS_NFS=y
    CONFIG_EAP_IKEV2=y
    CONFIG_EAP_EKE=y
    CONFIG_HT_OVERRIDES=y
    CONFIG_VHT_OVERRIDES=y
    CONFIG_ELOOP=eloop
    #CONFIG_ELOOP_EPOLL=y
    CONFIG_L2_PACKET=linux
    CONFIG_IEEE80211W=y
    CONFIG_TLS=openssl
    CONFIG_TLSV11=y
    #CONFIG_TLSV12=y see #8332
    CONFIG_IEEE80211R=y
    CONFIG_DEBUG_SYSLOG=y
    #CONFIG_PRIVSEP=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211AC=y
    CONFIG_INTERNETWORKING=y
    CONFIG_HS20=y
    CONFIG_P2P=y
    CONFIG_TDLS=y
    CONFIG_BGSCAN_SIMPLE=y
  '' + optionalString (pcsclite != null) ''
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_PCSC=y
  '' + optionalString (dbus != null) ''
    CONFIG_CTRL_IFACE_DBUS=y
    CONFIG_CTRL_IFACE_DBUS_NEW=y
    CONFIG_CTRL_IFACE_DBUS_INTRO=y
  '' + (if readline != null then ''
    CONFIG_READLINE=y
  '' else ''
    CONFIG_WPA_CLI_EDIT=y
  '');

  preBuild = ''
    for manpage in wpa_supplicant/doc/docbook/wpa_supplicant.conf* ; do
      substituteInPlace "$manpage" --replace /usr/share/doc $out/share/doc
    done
    cd wpa_supplicant
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    cat -n .config
    substituteInPlace Makefile --replace /usr/local $out
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE \
      -I$(echo "${stdenv.lib.getDev libnl}"/include/libnl*/) \
      -I${stdenv.lib.getDev pcsclite}/include/PCSC/"
  '';

  buildInputs = [ openssl libnl dbus readline pcsclite ];

  nativeBuildInputs = [ pkgconfig ];

  patches = [
    (fetchpatch {
      name = "build-fix.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-wireless/wpa_supplicant/files/wpa_supplicant-2.7-fix-undefined-remove-ie.patch?id=e0288112138a70a8acc3ae0196772fd7ccb677ce";
      sha256 = "0ysazfcyn195mvkb1v10mgzzmpmqgv5kwqxwzfbsfhzq5bbaihld";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v "doc/docbook/"*.5 $out/share/man/man5/
    cp -v "doc/docbook/"*.8 $out/share/man/man8/
    mkdir -p $out/etc/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v "dbus/"*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i "$out/share/dbus-1/system-services/"*
    cp -v dbus/dbus-wpa_supplicant.conf $out/etc/dbus-1/system.d
    cp -v "systemd/"*.service $out/etc/systemd/system
    rm $out/share/man/man8/wpa_priv.8
    install -Dm444 wpa_supplicant.conf $out/share/doc/wpa_supplicant/wpa_supplicant.conf.example
  '';

  meta = with stdenv.lib; {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
