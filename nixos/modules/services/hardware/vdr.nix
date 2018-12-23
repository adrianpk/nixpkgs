{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vdr;
  libDir = "/var/lib/vdr";
in {

  ###### interface

  options = {

    services.vdr = {
      enable = mkEnableOption "enable VDR. Please put config into ${libDir}.";

      package = mkOption {
        type = types.package;
        default = pkgs.vdr;
        defaultText = "pkgs.vdr";
        example = literalExample "pkgs.wrapVdr.override { plugins = with pkgs.vdrPlugins; [ hello ]; }";
        description = "Package to use.";
      };

      videoDir = mkOption {
        type = types.path;
        default = "/srv/vdr/video";
        description = "Recording directory";
      };

      extraArguments = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Additional command line arguments to pass to VDR.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.videoDir} 0755 vdr vdr 0"
      "Z ${cfg.videoDir} - vdr vdr -"
    ];

    systemd.services.vdr = {
      description = "VDR";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/vdr \
            --video="${cfg.videoDir}" \
            --config="${libDir}" \
            ${escapeShellArgs cfg.extraArguments}
        '';
        User = "vdr";
        CacheDirectory = "vdr";
        StateDirectory = "vdr";
        Restart = "on-failure";
      };
    };

    users.users.vdr = {
      group = "vdr";
      home = libDir;
    };

    users.groups.vdr = {};
  };
}
