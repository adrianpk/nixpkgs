[
  ./config/fonts/corefonts.nix
  ./config/fonts/fontconfig.nix
  ./config/fonts/fontconfig-ultimate.nix
  ./config/fonts/fontdir.nix
  ./config/fonts/fonts.nix
  ./config/fonts/ghostscript.nix
  ./config/gnu.nix
  ./config/gtk-exe-env.nix
  ./config/i18n.nix
  ./config/krb5.nix
  ./config/ldap.nix
  ./config/networking.nix
  ./config/no-x-libs.nix
  ./config/nsswitch.nix
  ./config/power-management.nix
  ./config/pulseaudio.nix
  ./config/qt-plugin-env.nix
  ./config/shells-environment.nix
  ./config/swap.nix
  ./config/sysctl.nix
  ./config/system-environment.nix
  ./config/system-path.nix
  ./config/timezone.nix
  ./config/vpnc.nix
  ./config/unix-odbc-drivers.nix
  ./config/users-groups.nix
  ./config/zram.nix
  ./hardware/all-firmware.nix
  ./hardware/cpu/amd-microcode.nix
  ./hardware/cpu/intel-microcode.nix
  ./hardware/network/b43.nix
  ./hardware/network/intel-2100bg.nix
  ./hardware/network/intel-2200bg.nix
  ./hardware/network/intel-3945abg.nix
  ./hardware/network/ralink.nix
  ./hardware/network/rtl8192c.nix
  ./hardware/opengl.nix
  ./hardware/pcmcia.nix
  ./hardware/video/bumblebee.nix
  ./hardware/video/nvidia.nix
  ./hardware/video/ati.nix
  ./installer/tools/nixos-checkout.nix
  ./installer/tools/tools.nix
  ./misc/assertions.nix
  ./misc/check-config.nix
  ./misc/crashdump.nix
  ./misc/ids.nix
  ./misc/lib.nix
  ./misc/locate.nix
  ./misc/meta.nix
  ./misc/nixpkgs.nix
  ./misc/passthru.nix
  ./misc/version.nix
  ./programs/atop.nix
  ./programs/bash/bash.nix
  ./programs/blcr.nix
  ./programs/command-not-found/command-not-found.nix
  ./programs/dconf.nix
  ./programs/environment.nix
  ./programs/info.nix
  ./programs/light.nix
  ./programs/nano.nix
  ./programs/screen.nix
  ./programs/shadow.nix
  ./programs/shell.nix
  ./programs/ssh.nix
  ./programs/ssmtp.nix
  ./programs/uim.nix
  ./programs/venus.nix
  ./programs/virtualbox-host.nix
  ./programs/wvdial.nix
  ./programs/freetds.nix
  ./programs/zsh/zsh.nix
  ./rename.nix
  ./security/apparmor.nix
  ./security/apparmor-suid.nix
  ./security/ca.nix
  ./security/duosec.nix
  ./security/grsecurity.nix
  ./security/pam.nix
  ./security/pam_usb.nix
  ./security/polkit.nix
  ./security/prey.nix
  ./security/rngd.nix
  ./security/rtkit.nix
  ./security/setuid-wrappers.nix
  ./security/sudo.nix
  ./services/amqp/activemq/default.nix
  ./services/amqp/rabbitmq.nix
  ./services/audio/alsa.nix
  # Disabled as fuppes it does no longer builds.
  # ./services/audio/fuppes.nix
  ./services/audio/liquidsoap.nix
  ./services/audio/mpd.nix
  ./services/audio/mopidy.nix
  ./services/backup/almir.nix
  ./services/backup/bacula.nix
  ./services/backup/crashplan.nix
  ./services/backup/mysql-backup.nix
  ./services/backup/postgresql-backup.nix
  ./services/backup/rsnapshot.nix
  ./services/backup/sitecopy-backup.nix
  ./services/backup/tarsnap.nix
  ./services/cluster/fleet.nix
  ./services/cluster/kubernetes.nix
  ./services/computing/torque/server.nix
  ./services/computing/torque/mom.nix
  ./services/continuous-integration/jenkins/default.nix
  ./services/continuous-integration/jenkins/slave.nix
  ./services/databases/4store-endpoint.nix
  ./services/databases/4store.nix
  ./services/databases/couchdb.nix
  ./services/databases/firebird.nix
  ./services/databases/hbase.nix
  ./services/databases/influxdb.nix
  ./services/databases/memcached.nix
  ./services/databases/monetdb.nix
  ./services/databases/mongodb.nix
  ./services/databases/mysql.nix
  ./services/databases/neo4j.nix
  ./services/databases/openldap.nix
  ./services/databases/opentsdb.nix
  ./services/databases/postgresql.nix
  ./services/databases/redis.nix
  ./services/databases/virtuoso.nix
  ./services/desktops/accountsservice.nix
  ./services/desktops/geoclue2.nix
  ./services/desktops/gnome3/at-spi2-core.nix
  ./services/desktops/gnome3/evolution-data-server.nix
  ./services/desktops/gnome3/gnome-documents.nix
  ./services/desktops/gnome3/gnome-keyring.nix
  ./services/desktops/gnome3/gnome-online-accounts.nix
  ./services/desktops/gnome3/gnome-online-miners.nix
  ./services/desktops/gnome3/gnome-user-share.nix
  ./services/desktops/gnome3/gvfs.nix
  ./services/desktops/gnome3/seahorse.nix
  ./services/desktops/gnome3/sushi.nix
  ./services/desktops/gnome3/tracker.nix
  ./services/desktops/profile-sync-daemon.nix
  ./services/desktops/telepathy.nix
  ./services/games/ghost-one.nix
  ./services/games/minecraft-server.nix
  ./services/hardware/acpid.nix
  ./services/hardware/amd-hybrid-graphics.nix
  ./services/hardware/bluetooth.nix
  ./services/hardware/freefall.nix
  ./services/hardware/nvidia-optimus.nix
  ./services/hardware/pcscd.nix
  ./services/hardware/pommed.nix
  ./services/hardware/sane.nix
  ./services/hardware/tcsd.nix
  ./services/hardware/tlp.nix
  ./services/hardware/thinkfan.nix
  ./services/hardware/udev.nix
  ./services/hardware/udisks2.nix
  ./services/hardware/upower.nix
  ./services/hardware/thermald.nix
  ./services/logging/klogd.nix
  ./services/logging/logcheck.nix
  ./services/logging/logrotate.nix
  ./services/logging/logstash.nix
  ./services/logging/rsyslogd.nix
  ./services/logging/syslogd.nix
  ./services/logging/syslog-ng.nix
  ./services/mail/dovecot.nix
  ./services/mail/freepops.nix
  ./services/mail/mail.nix
  ./services/mail/mlmmj.nix
  ./services/mail/opensmtpd.nix
  ./services/mail/postfix.nix
  ./services/mail/spamassassin.nix
  ./services/misc/apache-kafka.nix
  #./services/misc/autofs.nix
  ./services/misc/cpuminer-cryptonight.nix
  ./services/misc/cgminer.nix
  ./services/misc/dictd.nix
  ./services/misc/disnix.nix
  ./services/misc/docker-registry.nix
  ./services/misc/etcd.nix
  ./services/misc/felix.nix
  ./services/misc/folding-at-home.nix
  ./services/misc/gitlab.nix
  ./services/misc/gitolite.nix
  ./services/misc/gpsd.nix
  ./services/misc/mesos-master.nix
  ./services/misc/mesos-slave.nix
  ./services/misc/nix-daemon.nix
  ./services/misc/nix-gc.nix
  ./services/misc/nixos-manual.nix
  ./services/misc/nix-ssh-serve.nix
  ./services/misc/phd.nix
  ./services/misc/redmine.nix
  ./services/misc/rippled.nix
  ./services/misc/rogue.nix
  ./services/misc/siproxd.nix
  ./services/misc/svnserve.nix
  ./services/misc/synergy.nix
  ./services/misc/uhub.nix
  ./services/misc/zookeeper.nix
  ./services/monitoring/apcupsd.nix
  ./services/monitoring/bosun.nix
  ./services/monitoring/cadvisor.nix
  ./services/monitoring/collectd.nix
  ./services/monitoring/dd-agent.nix
  ./services/monitoring/graphite.nix
  ./services/monitoring/monit.nix
  ./services/monitoring/munin.nix
  ./services/monitoring/nagios.nix
  ./services/monitoring/riemann.nix
  ./services/monitoring/riemann-dash.nix
  ./services/monitoring/scollector.nix
  ./services/monitoring/smartd.nix
  ./services/monitoring/statsd.nix
  ./services/monitoring/systemhealth.nix
  ./services/monitoring/ups.nix
  ./services/monitoring/uptime.nix
  ./services/monitoring/zabbix-agent.nix
  ./services/monitoring/zabbix-server.nix
  ./services/network-filesystems/drbd.nix
  ./services/network-filesystems/nfsd.nix
  ./services/network-filesystems/openafs-client/default.nix
  ./services/network-filesystems/rsyncd.nix
  ./services/network-filesystems/samba.nix
  ./services/network-filesystems/diod.nix
  ./services/network-filesystems/yandex-disk.nix
  ./services/networking/amuled.nix
  ./services/networking/atftpd.nix
  ./services/networking/avahi-daemon.nix
  ./services/networking/bind.nix
  ./services/networking/bitlbee.nix
  ./services/networking/btsync.nix
  ./services/networking/chrony.nix
  ./services/networking/cjdns.nix
  ./services/networking/cntlm.nix
  ./services/networking/connman.nix
  ./services/networking/consul.nix
  ./services/networking/ddclient.nix
  ./services/networking/dhcpcd.nix
  ./services/networking/dhcpd.nix
  ./services/networking/dnscrypt-proxy.nix
  ./services/networking/dnsmasq.nix
  ./services/networking/ejabberd.nix
  ./services/networking/firefox/sync-server.nix
  ./services/networking/firewall.nix
  ./services/networking/flashpolicyd.nix
  ./services/networking/freenet.nix
  ./services/networking/git-daemon.nix
  ./services/networking/gnunet.nix
  ./services/networking/gogoclient.nix
  ./services/networking/gvpe.nix
  ./services/networking/haproxy.nix
  ./services/networking/hostapd.nix
  ./services/networking/i2pd.nix
  ./services/networking/ifplugd.nix
  ./services/networking/iodined.nix
  ./services/networking/ircd-hybrid/default.nix
  ./services/networking/kippo.nix
  ./services/networking/mailpile.nix
  ./services/networking/minidlna.nix
  ./services/networking/mstpd.nix
  ./services/networking/murmur.nix
  ./services/networking/nat.nix
  ./services/networking/networkmanager.nix
  ./services/networking/ngircd.nix
  ./services/networking/notbit.nix
  ./services/networking/nsd.nix
  ./services/networking/ntopng.nix
  ./services/networking/ntpd.nix
  ./services/networking/nylon.nix
  ./services/networking/oidentd.nix
  ./services/networking/openfire.nix
  ./services/networking/openntpd.nix
  ./services/networking/openvpn.nix
  ./services/networking/polipo.nix
  ./services/networking/prayer.nix
  ./services/networking/privoxy.nix
  ./services/networking/prosody.nix
  ./services/networking/quassel.nix
  ./services/networking/radicale.nix
  ./services/networking/radvd.nix
  ./services/networking/rdnssd.nix
  ./services/networking/rpcbind.nix
  ./services/networking/sabnzbd.nix
  ./services/networking/searx.nix
  ./services/networking/seeks.nix
  ./services/networking/spiped.nix
  ./services/networking/ssh/lshd.nix
  ./services/networking/ssh/sshd.nix
  ./services/networking/strongswan.nix
  ./services/networking/supybot.nix
  ./services/networking/syncthing.nix
  ./services/networking/tcpcrypt.nix
  ./services/networking/teamspeak3.nix
  ./services/networking/tftpd.nix
  ./services/networking/tox-bootstrapd.nix
  ./services/networking/unbound.nix
  ./services/networking/unifi.nix
  ./services/networking/vsftpd.nix
  ./services/networking/wakeonlan.nix
  ./services/networking/websockify.nix
  ./services/networking/wicd.nix
  ./services/networking/wpa_supplicant.nix
  ./services/networking/xinetd.nix
  ./services/networking/znc.nix
  ./services/printing/cupsd.nix
  ./services/scheduling/atd.nix
  ./services/scheduling/chronos.nix
  ./services/scheduling/cron.nix
  ./services/scheduling/fcron.nix
  ./services/search/elasticsearch.nix
  ./services/search/solr.nix
  ./services/security/clamav.nix
  ./services/security/fail2ban.nix
  ./services/security/fprintd.nix
  ./services/security/fprot.nix
  ./services/security/frandom.nix
  ./services/security/haveged.nix
  ./services/security/torify.nix
  ./services/security/tor.nix
  ./services/security/torsocks.nix
  ./services/system/cloud-init.nix
  ./services/system/dbus.nix
  ./services/system/kerberos.nix
  ./services/system/nscd.nix
  ./services/system/uptimed.nix
  ./services/torrent/deluge.nix
  ./services/torrent/peerflix.nix
  ./services/torrent/transmission.nix
  ./services/ttys/agetty.nix
  ./services/ttys/gpm.nix
  ./services/ttys/kmscon.nix
  ./services/web-servers/apache-httpd/default.nix
  ./services/web-servers/fcgiwrap.nix
  ./services/web-servers/jboss/default.nix
  ./services/web-servers/lighttpd/cgit.nix
  ./services/web-servers/lighttpd/default.nix
  ./services/web-servers/lighttpd/gitweb.nix
  ./services/web-servers/nginx/default.nix
  ./services/web-servers/phpfpm.nix
  ./services/web-servers/tomcat.nix
  ./services/web-servers/varnish/default.nix
  ./services/web-servers/winstone.nix
  ./services/web-servers/zope2.nix
  ./services/x11/desktop-managers/default.nix
  ./services/x11/display-managers/auto.nix
  ./services/x11/display-managers/default.nix
  ./services/x11/display-managers/gdm.nix
  ./services/x11/display-managers/kdm.nix
  ./services/x11/display-managers/lightdm.nix
  ./services/x11/display-managers/slim.nix
  ./services/x11/hardware/multitouch.nix
  ./services/x11/hardware/synaptics.nix
  ./services/x11/hardware/wacom.nix
  ./services/x11/redshift.nix
  ./services/x11/window-managers/awesome.nix
  #./services/x11/window-managers/compiz.nix
  ./services/x11/window-managers/default.nix
  ./services/x11/window-managers/fluxbox.nix
  ./services/x11/window-managers/icewm.nix
  ./services/x11/window-managers/bspwm.nix
  ./services/x11/window-managers/metacity.nix
  ./services/x11/window-managers/none.nix
  ./services/x11/window-managers/twm.nix
  ./services/x11/window-managers/wmii.nix
  ./services/x11/window-managers/xmonad.nix
  ./services/x11/xfs.nix
  ./services/x11/xserver.nix
  ./system/activation/activation-script.nix
  ./system/activation/top-level.nix
  ./system/boot/emergency-mode.nix
  ./system/boot/kernel.nix
  ./system/boot/kexec.nix
  ./system/boot/loader/efi.nix
  ./system/boot/loader/generations-dir/generations-dir.nix
  ./system/boot/loader/grub/grub.nix
  ./system/boot/loader/grub/ipxe.nix
  ./system/boot/loader/grub/memtest.nix
  ./system/boot/loader/gummiboot/gummiboot.nix
  ./system/boot/loader/init-script/init-script.nix
  ./system/boot/loader/raspberrypi/raspberrypi.nix
  ./system/boot/luksroot.nix
  ./system/boot/modprobe.nix
  ./system/boot/shutdown.nix
  ./system/boot/stage-1.nix
  ./system/boot/stage-2.nix
  ./system/boot/systemd.nix
  ./system/boot/tmp.nix
  ./system/etc/etc.nix
  ./system/upstart/upstart.nix
  ./tasks/bcache.nix
  ./tasks/cpu-freq.nix
  ./tasks/encrypted-devices.nix
  ./tasks/filesystems.nix
  ./tasks/filesystems/btrfs.nix
  ./tasks/filesystems/cifs.nix
  ./tasks/filesystems/ext.nix
  ./tasks/filesystems/f2fs.nix
  ./tasks/filesystems/jfs.nix
  ./tasks/filesystems/nfs.nix
  ./tasks/filesystems/reiserfs.nix
  ./tasks/filesystems/unionfs-fuse.nix
  ./tasks/filesystems/vfat.nix
  ./tasks/filesystems/xfs.nix
  ./tasks/filesystems/zfs.nix
  ./tasks/kbd.nix
  ./tasks/lvm.nix
  ./tasks/network-interfaces.nix
  ./tasks/network-interfaces-systemd.nix
  ./tasks/network-interfaces-scripted.nix
  ./tasks/scsi-link-power-management.nix
  ./tasks/swraid.nix
  ./tasks/trackpoint.nix
  ./testing/service-runner.nix
  ./virtualisation/container-config.nix
  ./virtualisation/containers.nix
  ./virtualisation/docker.nix
  ./virtualisation/libvirtd.nix
  ./virtualisation/lxc.nix
  #./virtualisation/nova.nix
  ./virtualisation/openvswitch.nix
  ./virtualisation/parallels-guest.nix
  ./virtualisation/virtualbox-guest.nix
  #./virtualisation/xen-dom0.nix
]
