{ config, lib, pkgs, pkgs_i686, ... }:

with pkgs;
with lib;

let

  cfg = config.hardware.pulseaudio;

  systemWide = cfg.enable && cfg.systemWide;
  nonSystemWide = cfg.enable && !cfg.systemWide;
  hasZeroconf = let z = cfg.zeroconf; in z.publish.enable || z.discovery.enable;

  overriddenPackage = cfg.package.override
    (optionalAttrs hasZeroconf { zeroconfSupport = true; });
  binary = "${getBin overriddenPackage}/bin/pulseaudio";
  binaryNoDaemon = "${binary} --daemonize=no";

  # Forces 32bit pulseaudio and alsaPlugins to be built/supported for apps
  # using 32bit alsa on 64bit linux.
  enable32BitAlsaPlugins = cfg.support32Bit && stdenv.isx86_64 && (pkgs_i686.alsaLib != null && pkgs_i686.libpulseaudio != null);


  myConfigFile =
    let
      addModuleIf = cond: mod: optionalString cond "load-module ${mod}";
      allAnon = optional cfg.tcp.anonymousClients.allowAll "auth-anonymous=1";
      ipAnon =  let a = cfg.tcp.anonymousClients.allowedIpRanges;
                in optional (a != []) ''auth-ip-acl=${concatStringsSep ";" a}'';
    in writeTextFile {
      name = "default.pa";
        text = ''
        .include ${cfg.configFile}
        ${addModuleIf cfg.zeroconf.publish.enable "module-zeroconf-publish"}
        ${addModuleIf cfg.zeroconf.discovery.enable "module-zeroconf-discover"}
        ${addModuleIf cfg.tcp.enable (concatStringsSep " "
           ([ "module-native-protocol-tcp" ] ++ allAnon ++ ipAnon))}
        ${cfg.extraConfig}
      '';
    };

  ids = config.ids;

  uid = ids.uids.pulseaudio;
  gid = ids.gids.pulseaudio;

  stateDir = "/var/run/pulse";

  # Create pulse/client.conf even if PulseAudio is disabled so
  # that we can disable the autospawn feature in programs that
  # are built with PulseAudio support (like KDE).
  clientConf = writeText "client.conf" ''
    autospawn=${if nonSystemWide then "yes" else "no"}
    ${optionalString nonSystemWide "daemon-binary=${binary}"}
    ${cfg.extraClientConf}
  '';

  # Write an /etc/asound.conf that causes all ALSA applications to
  # be re-routed to the PulseAudio server through ALSA's Pulse
  # plugin.
  alsaConf = writeText "asound.conf" (''
    pcm_type.pulse {
      libs.native = ${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so ;
      ${lib.optionalString enable32BitAlsaPlugins
     "libs.32Bit = ${pkgs_i686.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so ;"}
    }
    pcm.!default {
      type pulse
      hint.description "Default Audio Device (via PulseAudio)"
    }
    ctl_type.pulse {
      libs.native = ${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so ;
      ${lib.optionalString enable32BitAlsaPlugins
     "libs.32Bit = ${pkgs_i686.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so ;"}
    }
    ctl.!default {
      type pulse
    }
  '');

in {

  options = {

    hardware.pulseaudio = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the PulseAudio sound server.
        '';
      };

      systemWide = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If false, a PulseAudio server is launched automatically for
          each user that tries to use the sound system. The server runs
          with user privileges. This is the recommended and most secure
          way to use PulseAudio. If true, one system-wide PulseAudio
          server is launched on boot, running as the user "pulse".
          Please read the PulseAudio documentation for more details.
        '';
      };

      support32Bit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to include the 32-bit pulseaudio libraries in the system or not.
          This is only useful on 64-bit systems and currently limited to x86_64-linux.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        description = ''
          The path to the default configuration options the PulseAudio server
          should use. By default, the "default.pa" configuration
          from the PulseAudio distribution is used.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Literal string to append to <literal>configFile</literal>
          and the config file generated by the pulseaudio module.
        '';
      };

      extraClientConf = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration appended to pulse/client.conf file.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pulseaudioLight;
        defaultText = "pkgs.pulseaudioLight";
        example = literalExample "pkgs.pulseaudioFull";
        description = ''
          The PulseAudio derivation to use.  This can be used to enable
          features (such as JACK support, Bluetooth) via the
          <literal>pulseaudioFull</literal> package.
        '';
      };

      daemon = {
        logLevel = mkOption {
          type = types.str;
          default = "notice";
          description = ''
            The log level that the system-wide pulseaudio daemon should use,
            if activated.
          '';
        };

        config = mkOption {
          type = types.attrsOf types.unspecified;
          default = {};
          description = ''Config of the pulse daemon. See <literal>man pulse-daemon.conf</literal>.'';
          example = literalExample ''{ flat-volumes = "no"; }'';
        };
      };

      zeroconf = {
        discovery.enable =
          mkEnableOption "discovery of pulseaudio sinks in the local network";
        publish.enable =
          mkEnableOption "publishing the pulseaudio sink in the local network";
      };

      # TODO: enable by default?
      tcp = {
        enable = mkEnableOption "tcp streaming support";

        anonymousClients = {
          allowAll = mkEnableOption "all anonymous clients to stream to the server";
          allowedIpRanges = mkOption {
            type = types.listOf types.str;
            default = [];
            example = literalExample ''[ "127.0.0.1" "192.168.1.0/24" ]'';
            description = ''
              A list of IP subnets that are allowed to stream to the server.
            '';
          };
        };
      };

    };

  };


  config = mkMerge [
    {
      environment.etc = singleton {
        target = "pulse/client.conf";
        source = clientConf;
      };

      hardware.pulseaudio.configFile = mkDefault "${getBin overriddenPackage}/etc/pulse/default.pa";
    }

    (mkIf cfg.enable {
      environment.systemPackages = [ overriddenPackage ];

      environment.etc = [
        { target = "asound.conf";
          source = alsaConf; }

        { target = "pulse/daemon.conf";
          source = writeText "daemon.conf" (lib.generators.toKeyValue {} cfg.daemon.config); }
      ];

      # Allow PulseAudio to get realtime priority using rtkit.
      security.rtkit.enable = true;

      systemd.packages = [ cfg.package ];
    })

    (mkIf hasZeroconf {
      services.avahi.enable = true;
    })
    (mkIf cfg.zeroconf.publish.enable {
      services.avahi.publish.enable = true;
      services.avahi.publish.userServices = true;
    })

    (mkIf nonSystemWide {
      environment.etc = singleton {
        target = "pulse/default.pa";
        source = myConfigFile;
      };
      systemd.user = {
        services.pulseaudio = {
          serviceConfig = {
            RestartSec = "500ms";
          };
          environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
          restartIfChanged = true;
        };
      };
    })

    (mkIf systemWide {
      users.extraUsers.pulse = {
        # For some reason, PulseAudio wants UID == GID.
        uid = assert uid == gid; uid;
        group = "pulse";
        extraGroups = [ "audio" ];
        description = "PulseAudio system service user";
        home = stateDir;
        createHome = true;
      };

      users.extraGroups.pulse.gid = gid;

      systemd.services.pulseaudio = {
        description = "PulseAudio System-Wide Server";
        wantedBy = [ "sound.target" ];
        before = [ "sound.target" ];
        environment.PULSE_RUNTIME_PATH = stateDir;
        serviceConfig = {
          Type = "notify";
          ExecStart = "${binaryNoDaemon} --log-level=${cfg.daemon.logLevel} --system -n --file=${myConfigFile}";
          Restart = "on-failure";
          RestartSec = "500ms";
        };
      };
    })
  ];

}
