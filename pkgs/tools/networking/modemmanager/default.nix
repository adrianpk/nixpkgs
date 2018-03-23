{ stdenv, fetchurl, udev, libgudev, polkit, dbus-glib, ppp, gettext, pkgconfig
, libmbim, libqmi, systemd, fetchpatch }:

stdenv.mkDerivation rec {
  name = "ModemManager-${version}";
  version = "1.7.990";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/ModemManager/${name}.tar.xz";
    sha256 = "1v4hixmghlrw7w4ajq2x4k62js0594h223d0yma365zwqr7hjrfl";
  };

  nativeBuildInputs = [ gettext pkgconfig ];

  buildInputs = [ udev libgudev polkit dbus-glib ppp libmbim libqmi systemd ];

  patches = [
    # Patch dependency on glib headers, this breaks packages using core headers (networkmanager-qt)
    (fetchpatch {
      url = "https://cgit.freedesktop.org/ModemManager/ModemManager/patch/?id=0f377f943eeb81472fd73189f2c3d8fc65b8c609";
      sha256 = "00m7ly1fgspapzkbvjsp25w58wcdax8rrwgvq3axrz4lagwfwnp6";
    })
  ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=$(out)/lib/udev"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-suspend-resume=systemd"
  ];

  installFlags = [ "DESTDIR=\${out}" ];

  preInstall = ''
    mkdir -p $out/etc/systemd/system
  '';

  postInstall = ''
    mv $out/$out/etc/systemd/system/ModemManager.service $out/etc/systemd/system
    rm -rf $out/$out/etc
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done

    # systemd in NixOS doesn't use `systemctl enable`, so we need to establish
    # aliases ourselves.
    ln -s $out/etc/systemd/system/ModemManager.service \
      $out/etc/systemd/system/dbus-org.freedesktop.ModemManager1.service
  '';

  meta = with stdenv.lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = https://www.freedesktop.org/wiki/Software/ModemManager/;
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
