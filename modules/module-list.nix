[ # This file have been generated by gen-module-list.sh
  ./config/fonts.nix
  ./config/i18n.nix
  ./config/nsswitch.nix
  ./config/system-path.nix
  ./config/timezone.nix
  ./config/unix-odbc-drivers.nix
  ./config/users-groups.nix
  ./installer/grub/grub.nix
  ./legacy.nix
  ./security/setuid-wrappers.nix
  ./security/sudo.nix
  ./services/audio/alsa.nix
  ./services/audio/pulseaudio.nix
  ./services/databases/mysql.nix
  ./services/databases/postgresql.nix
  ./services/hardware/acpid.nix
  ./services/hardware/hal.nix
  ./services/hardware/udev.nix
  ./services/logging/klogd.nix
  ./services/logging/syslogd.nix
  ./services/mail/dovecot.nix
  ./services/mail/postfix.nix
  ./services/misc/autofs.nix
  ./services/misc/disnix.nix
  ./services/misc/nix-daemon.nix
  ./services/misc/nixos-manual.nix
  ./services/misc/rogue.nix
  ./services/misc/synergy.nix
  ./services/monitoring/nagios/default.nix
  ./services/monitoring/zabbix-agent.nix
  ./services/monitoring/zabbix-server.nix
  ./services/network-filesystems/nfs-kernel.nix
  ./services/network-filesystems/samba.nix
  ./services/networking/avahi-daemon.nix
  ./services/networking/bind.nix
  ./services/networking/bitlbee.nix
  ./services/networking/dhclient.nix
  ./services/networking/dhcpd.nix
  ./services/networking/ejabberd.nix
  ./services/networking/gnunet.nix
  ./services/networking/gw6c.nix
  ./services/networking/ifplugd.nix
  ./services/networking/ircd-hybrid.nix
  ./services/networking/ntpd.nix
  ./services/networking/openfire.nix
  ./services/networking/openvpn.nix
  ./services/networking/portmap.nix
  ./services/networking/ssh/lshd.nix
  ./services/networking/ssh/sshd.nix
  ./services/networking/vsftpd.nix
  ./services/printing/cupsd.nix
  ./services/scheduling/atd.nix
  ./services/scheduling/cron.nix
  ./services/scheduling/fcron.nix
  ./services/system/consolekit.nix
  ./services/system/dbus.nix
  ./services/system/nscd.nix
  ./services/ttys/gpm.nix
  ./services/ttys/mingetty.nix
  ./services/web-servers/apache-httpd/default.nix
##### ./services/web-servers/apache-httpd/per-server-options.nix
# error: while evaluating the attribute `<let-body>' at `(string):2:8':
# while evaluating the function at `(string):3:22':
# while evaluating the function at `/home/eelco/Dev/modular-nixos/modules/services/web-servers/apache-httpd/per-server-options.nix:6:2':
# the argument named `forMainServer' required by the function is missing
##### ./services/web-servers/apache-httpd/subversion.nix
# error: while evaluating the attribute `<let-body>' at `(string):2:8':
# while evaluating the function at `(string):3:22':
# while evaluating the function at `/home/eelco/Dev/modular-nixos/modules/services/web-servers/apache-httpd/subversion.nix:1:2':
# the argument named `serverInfo' required by the function is missing
##### ./services/web-servers/apache-httpd/tomcat-connector.nix
# error: while evaluating the attribute `<let-body>' at `(string):2:8':
# while evaluating the function at `(string):3:22':
# while evaluating the function at `/home/eelco/Dev/modular-nixos/modules/services/web-servers/apache-httpd/tomcat-connector.nix:1:2':
# the argument named `serverInfo' required by the function is missing
##### ./services/web-servers/apache-httpd/twiki.nix
# error: while evaluating the attribute `<let-body>' at `(string):2:8':
# while evaluating the function at `(string):3:22':
# while evaluating the function at `/home/eelco/Dev/modular-nixos/modules/services/web-servers/apache-httpd/twiki.nix:1:2':
# the argument named `serverInfo' required by the function is missing
##### ./services/web-servers/apache-httpd/zabbix.nix
# error: while evaluating the attribute `<let-body>' at `(string):2:8':
# while evaluating the function at `(string):3:22':
# while evaluating the function at `/home/eelco/Dev/modular-nixos/modules/services/web-servers/apache-httpd/zabbix.nix:1:2':
# the argument named `serverInfo' required by the function is missing
  ./services/web-servers/jboss.nix
  ./services/web-servers/tomcat.nix
  ./services/x11/xfs.nix
  ./services/x11/xserver/default.nix
  ./services/x11/xserver/desktop-managers/default.nix
  ./services/x11/xserver/desktop-managers/gnome.nix
  ./services/x11/xserver/desktop-managers/kde4.nix
  ./services/x11/xserver/desktop-managers/kde-environment.nix
  ./services/x11/xserver/desktop-managers/kde.nix
  ./services/x11/xserver/desktop-managers/none.nix
  ./services/x11/xserver/desktop-managers/xterm.nix
  ./services/x11/xserver/display-managers/default.nix
  ./services/x11/xserver/display-managers/kdm.nix
  ./services/x11/xserver/display-managers/slim.nix
  ./services/x11/xserver/window-managers/compiz.nix
  ./services/x11/xserver/window-managers/default.nix
  ./services/x11/xserver/window-managers/kwm.nix
  ./services/x11/xserver/window-managers/metacity.nix
  ./services/x11/xserver/window-managers/none.nix
  ./services/x11/xserver/window-managers/twm.nix
  ./services/x11/xserver/window-managers/wmii.nix
  ./services/x11/xserver/window-managers/xmonad.nix
  ./system/activation/activation-script.nix
  ./system/activation/top-level.nix
  ./system/boot/kernel.nix
  ./system/boot/stage-1.nix
  ./system/boot/stage-2.nix
  ./system/upstart-events/ctrl-alt-delete.nix
  ./system/upstart-events/halt.nix
  ./system/upstart-events/maintenance-shell.nix
##### ./system/upstart/make-job.nix
# error: while evaluating the attribute `<let-body>' at `(string):2:8':
# while evaluating the function at `(string):3:22':
# while evaluating the function at `/home/eelco/Dev/modular-nixos/modules/system/upstart/make-job.nix:1:2':
# the argument named `runCommand' required by the function is missing
  ./system/upstart/tools.nix
  ./system/upstart/upstart.nix
]
