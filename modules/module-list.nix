[ ./config/fonts.nix
  ./config/i18n.nix
  ./config/krb5.nix
  ./config/ldap.nix
  ./config/networking.nix
  ./config/no-x-libs.nix
  ./config/nsswitch.nix
  ./config/power-management.nix
  ./config/system-path.nix
  ./config/timezone.nix
  ./config/unix-odbc-drivers.nix
  ./config/users-groups.nix
  ./hardware/network/intel-2200bg.nix
  ./hardware/network/intel-3945abg.nix
  ./hardware/network/rt73.nix 
  ./hardware/pcmcia.nix
  ./installer/grub/grub.nix
  ./installer/init-script/init-script.nix
  ./installer/generations-dir/generations-dir.nix
  ./installer/tools/nixos-checkout.nix
  ./installer/tools/tools.nix
  ./misc/assertions.nix
  ./misc/check-config.nix
  ./misc/ids.nix
  ./misc/locate.nix
  ./misc/nixpkgs.nix
  ./misc/passthru.nix
  ./programs/bash/bash.nix
  ./programs/info.nix
  ./programs/pwdutils/pwdutils.nix
  ./programs/ssh.nix
  ./programs/ssmtp.nix
  ./rename.nix
  ./security/consolekit.nix
  ./security/pam.nix
  ./security/pam_usb.nix
  ./security/policykit.nix
  #./security/polkit.nix # Currently disabled; using the old policykit.
  ./security/setuid-wrappers.nix
  ./security/sudo.nix
  ./services/audio/alsa.nix
  ./services/audio/pulseaudio.nix
  ./services/backup/mysql-backup.nix
  ./services/backup/postgresql-backup.nix
  ./services/backup/sitecopy-backup.nix
  ./services/databases/mysql.nix
  ./services/databases/postgresql.nix
  ./services/hardware/acpid.nix
  ./services/hardware/hal.nix
  ./services/hardware/pcscd.nix
  ./services/hardware/udev.nix
  ./services/logging/klogd.nix
  ./services/logging/syslogd.nix
  ./services/mail/dovecot.nix
  ./services/mail/postfix.nix
  ./services/misc/autofs.nix
  ./services/misc/disnix.nix
  ./services/misc/gpsd.nix
  ./services/misc/nix-daemon.nix
  ./services/misc/nix-gc.nix
  ./services/misc/nixos-manual.nix
  ./services/misc/rogue.nix
  ./services/misc/synergy.nix
  ./services/monitoring/monit.nix
  ./services/monitoring/nagios/default.nix
  ./services/monitoring/systemhealth.nix
  ./services/monitoring/zabbix-agent.nix
  ./services/monitoring/zabbix-server.nix
  ./services/network-filesystems/nfs-kernel.nix
  ./services/network-filesystems/openafs-client/default.nix
  ./services/network-filesystems/samba.nix
  ./services/networking/avahi-daemon.nix
  ./services/networking/bind.nix
  ./services/networking/bitlbee.nix
  ./services/networking/dhclient.nix
  ./services/networking/ddclient.nix
  ./services/networking/dhcpd.nix
  ./services/networking/ejabberd.nix
  ./services/networking/firewall.nix
  ./services/networking/gnunet.nix
  ./services/networking/gvpe.nix
  ./services/networking/gw6c.nix
  ./services/networking/ifplugd.nix
  ./services/networking/ircd-hybrid.nix
  ./services/networking/ntpd.nix
  ./services/networking/openfire.nix
  ./services/networking/openvpn.nix
  ./services/networking/portmap.nix
  ./services/networking/privoxy.nix
  ./services/networking/ssh/lshd.nix
  ./services/networking/ssh/sshd.nix
  ./services/networking/tftpd.nix
  ./services/networking/vsftpd.nix
  ./services/networking/wicd.nix
  ./services/networking/wpa_supplicant.nix
  ./services/networking/xinetd.nix
  ./services/printing/cupsd.nix
  ./services/scheduling/atd.nix
  ./services/scheduling/cron.nix
  ./services/scheduling/fcron.nix
  ./services/system/dbus.nix
  ./services/system/nscd.nix
  ./services/system/uptimed.nix
  ./services/ttys/gpm.nix
  ./services/ttys/mingetty.nix
  ./services/web-servers/apache-httpd/default.nix
  ./services/web-servers/jboss.nix
  ./services/web-servers/tomcat.nix
  ./services/x11/desktop-managers/default.nix
  ./services/x11/desktop-managers/gnome.nix
  ./services/x11/desktop-managers/kde-environment.nix
  ./services/x11/desktop-managers/kde.nix
  ./services/x11/desktop-managers/kde4.nix
  ./services/x11/desktop-managers/none.nix
  ./services/x11/desktop-managers/xterm.nix
  ./services/x11/display-managers/default.nix
  ./services/x11/display-managers/auto.nix
  ./services/x11/display-managers/kdm.nix
  ./services/x11/display-managers/slim.nix
  ./services/x11/hardware/synaptics.nix
  ./services/x11/hardware/wacom.nix
  ./services/x11/window-managers/compiz.nix
  ./services/x11/window-managers/default.nix
  ./services/x11/window-managers/icewm.nix
  ./services/x11/window-managers/kwm.nix
  ./services/x11/window-managers/metacity.nix
  ./services/x11/window-managers/none.nix
  ./services/x11/window-managers/twm.nix
  ./services/x11/window-managers/wmii.nix
  ./services/x11/window-managers/xmonad.nix
  ./services/x11/xfs.nix
  ./services/x11/xserver.nix
  ./system/activation/activation-script.nix
  ./system/activation/top-level.nix
  ./system/boot/kernel.nix
  ./system/boot/modprobe.nix
  ./system/boot/stage-1.nix
  ./system/boot/stage-2.nix
  ./system/etc/etc.nix
  ./system/upstart-events/control-alt-delete.nix
  ./system/upstart-events/runlevel.nix
  ./system/upstart-events/shutdown.nix
  ./system/upstart/upstart.nix
  ./tasks/filesystems.nix
  ./tasks/kbd.nix
  ./tasks/lvm.nix
  ./tasks/network-interfaces.nix
  ./tasks/swap.nix
  ./tasks/swraid.nix
  ./tasks/tty-backgrounds.nix
]
