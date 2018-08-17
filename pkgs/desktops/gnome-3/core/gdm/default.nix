{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, autoreconfHook
, gtk, libcanberra-gtk3, pam, libtool, gobjectIntrospection, plymouth
, librsvg, coreutils, fetchpatch }:

stdenv.mkDerivation rec {
  name = "gdm-${version}";
  version = "3.26.2.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "17ddcb00602c2b426de58bb4b0d99af9de27450a8557dcc5ec850c080d55ad57";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gdm"; attrPath = "gnome3.gdm"; };
  };

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
  '';

  postPatch = ''
    substituteInPlace daemon/gdm-manager.c --replace "/bin/plymouth" "${plymouth}/bin/plymouth"
    substituteInPlace data/gdm.service.in  --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  configureFlags = [ "--sysconfdir=/etc"
                     "--localstatedir=/var"
                     "--with-plymouth=yes"
                     "--with-initial-vt=7"
                     "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  nativeBuildInputs = [ pkgconfig libxml2 itstool intltool autoreconfHook libtool gnome3.dconf ];
  buildInputs = [ glib accountsservice systemd
                  gobjectIntrospection libX11 gtk
                  libcanberra-gtk3 pam plymouth librsvg ];

  enableParallelBuilding = true;

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  patches = [ ./sessions_dir.patch
              ./gdm-x-session_extra_args.patch
              ./gdm-session-worker_xserver-path.patch
              (fetchpatch{
                name = "CVE-2018-14424_A.patch";
                url = https://gitlab.gnome.org/GNOME/gdm/commit/6060db704a19b0db68f2e9e6a2d020c0c78b6bba.patch;
                sha256 = "1wp6b61jwdm43m696rgxa5iz8v39vk4il5xr4zgsx8y1pxqwb8n6";
              })
              (fetchpatch{
                name = "CVE-2018-14424_B.patch";
                url = https://gitlab.gnome.org/GNOME/gdm/commit/765b306c364885dd89d47fe9fe8618ce6a467bc1.patch;
                sha256 = "07sani5mbgv8cnwkddj15xg4r7f90d1rp8xxh1hnfwigrm1hm69d";
              })
             ];

  postInstall = ''
    # Prevent “Could not parse desktop file orca-autostart.desktop or it references a not found TryExec binary”
    rm $out/share/gdm/greeter/autostart/orca-autostart.desktop
  '';

  installFlags = [ "sysconfdir=$(out)/etc" "dbusconfdir=$(out)/etc/dbus-1/system.d" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "A program that manages graphical display servers and handles graphical user logins";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
