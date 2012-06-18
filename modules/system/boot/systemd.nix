{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.boot.systemd;

  systemd = pkgs.systemd;

  makeUnit = name: unit:
    pkgs.writeTextFile { name = "unit"; inherit (unit) text; destination = "/${name}"; };

  upstreamUnits =
    [ # Targets.
      "basic.target"
      "sysinit.target"
      "sockets.target"
      "graphical.target"
      "multi-user.target"
      "getty.target"
      "rescue.target"
      "network.target"
      "nss-lookup.target"
      "nss-user-lookup.target"
      "syslog.target"
      "time-sync.target"

      # Udev.
      "systemd-udev-control.socket"
      "systemd-udev-kernel.socket"
      "systemd-udev.service"
      "systemd-udev-settle.service"
      "systemd-udev-trigger.service"

      # Login stuff.
      "systemd-logind.service"
      "autovt@.service"
      "systemd-vconsole-setup.service"
      "systemd-user-sessions.service"
      "dbus-org.freedesktop.login1.service"
      "user@.service"

      # Journal.
      "systemd-journald.socket"
      "systemd-journald.service"

      # SysV init compatibility.
      "systemd-initctl.socket"
      "systemd-initctl.service"
      "runlevel0.target"
      "runlevel1.target"
      "runlevel2.target"
      "runlevel3.target"
      "runlevel4.target"
      "runlevel5.target"
      "runlevel6.target"

      # Random seed.
      "systemd-random-seed-load.service"
      "systemd-random-seed-save.service"

      # Utmp maintenance.
      "systemd-update-utmp-runlevel.service"
      "systemd-update-utmp-shutdown.service"
      
      # Filesystems.
      "fsck@.service"
      "fsck-root.service"
      "systemd-remount-fs.service"
      "local-fs.target"
      "local-fs-pre.target"
      "remote-fs.target"
      "remote-fs-pre.target"
      "swap.target"
      "dev-hugepages.mount"
      "dev-mqueue.mount"
      "sys-fs-fuse-connections.mount"
      "sys-kernel-config.mount"
      "sys-kernel-debug.mount"

      # Hibernate / suspend.
      "hibernate.target"
      "hibernate.service"
      "suspend.target"
      "suspend.service"
      "sleep.target"

      # Reboot stuff.
      "reboot.target"
      "reboot.service"
      "poweroff.target"
      "poweroff.service"
      "halt.target"
      "halt.service"
      "ctrl-alt-del.target"
      "shutdown.target"
      "umount.target"
      "final.target"

      # Misc.
      "syslog.socket"
    ];

  upstreamWants =
    [ "basic.target.wants"
      "sysinit.target.wants"
      "sockets.target.wants"
      "local-fs.target.wants"
      "multi-user.target.wants"
      "shutdown.target.wants"
    ];

  nixosUnits = mapAttrsToList makeUnit cfg.units;
    
  units = pkgs.runCommand "units" { preferLocalBuild = true; }
    ''
      mkdir -p $out/system
      for i in ${toString upstreamUnits}; do
        fn=${systemd}/example/systemd/system/$i
        [ -e $fn ]
        if [ -L $fn ]; then
          cp -pd $fn $out/system/
        else
          ln -s $fn $out/system
        fi
      done
      
      for i in ${toString upstreamWants}; do
        fn=${systemd}/example/systemd/system/$i
        [ -e $fn ]
        x=$out/system/$(basename $fn)
        mkdir $x
        for i in $fn/*; do
          y=$x/$(basename $i)
          cp -pd $i $y
          if ! [ -e $y ]; then rm -v $y; fi
        done
      done
      
      for i in ${toString nixosUnits}; do
        cp $i/* $out/system
      done

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/system/${name2}.wants
            ln -sfn ../${name} $out/system/${name2}.wants/
          '') unit.wantedBy) cfg.units)}

      ln -s ${cfg.defaultUnit} $out/system/default.target
    ''; # */
    
in

{

  ###### interface

  options = {

    boot.systemd.units = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = {
        text = mkOption {
          types = types.uniq types.string;
          description = "Text of this systemd unit.";
        };
        wantedBy = mkOption {
          default = [];
          types = types.listOf types.string;
          description = "Units that want (i.e. depend on) this unit.";
        };
      };
      description = "Definition of systemd units.";
    };

    boot.systemd.defaultUnit = mkOption {
      default = "multi-user.target";
      type = types.uniq types.string;
      description = "Default unit started when the system boots.";
    };
    
  };

  
  ###### implementation

  config = {

    system.build.systemd = systemd;

    system.build.units = units;

    environment.systemPackages = [ systemd ];
  
    environment.etc =
      [ { source = units;
          target = "systemd";
        }
      ];

    boot.systemd.units."getty@.service".text =
      ''
        [Unit]
        Description=Getty on %I
        Documentation=man:agetty(8)
        After=systemd-user-sessions.service plymouth-quit-wait.service

        # If additional gettys are spawned during boot then we should make
        # sure that this is synchronized before getty.target, even though
        # getty.target didn't actually pull it in.
        Before=getty.target
        IgnoreOnIsolate=yes

        [Service]
        Environment=TERM=linux
        ExecStart=-${pkgs.utillinux}/sbin/agetty --noclear --login-program ${pkgs.shadow}/bin/login %I 38400
        Type=idle
        Restart=always
        RestartSec=0
        UtmpIdentifier=%I
        TTYPath=/dev/%I
        TTYReset=yes
        TTYVHangup=yes
        TTYVTDisallocate=yes
        KillMode=process
        IgnoreSIGPIPE=no

        # Unset locale for the console getty since the console has problems
        # displaying some internationalized messages.
        Environment=LANG= LANGUAGE= LC_CTYPE= LC_NUMERIC= LC_TIME= LC_COLLATE= LC_MONETARY= LC_MESSAGES= LC_PAPER= LC_NAME= LC_ADDRESS= LC_TELEPHONE= LC_MEASUREMENT= LC_IDENTIFICATION=

        # Some login implementations ignore SIGTERM, so we send SIGHUP
        # instead, to ensure that login terminates cleanly.
        KillSignal=SIGHUP
      '';

    boot.systemd.units."rescue.service".text =
      ''
        [Unit]
        Description=Rescue Shell
        DefaultDependencies=no
        Conflicts=shutdown.target
        After=sysinit.target
        Before=shutdown.target

        [Service]
        Environment=HOME=/root
        WorkingDirectory=/root
        ExecStartPre=-${pkgs.coreutils}/bin/echo 'Welcome to rescue mode. Use "systemctl default" or ^D to enter default mode.'
        #ExecStart=-/sbin/sulogin
        ExecStart=-${pkgs.bashInteractive}/bin/bash --login
        ExecStopPost=-${systemd}/bin/systemctl --fail --no-block default
        Type=idle
        StandardInput=tty-force
        StandardOutput=inherit
        StandardError=inherit
        KillMode=process

        # Bash ignores SIGTERM, so we send SIGHUP instead, to ensure that bash
        # terminates cleanly.
        KillSignal=SIGHUP
      '';

  };

}
