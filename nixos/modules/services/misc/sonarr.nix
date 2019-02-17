{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.sonarr;
in
{
  options = {
    services.sonarr = {
      enable = mkEnableOption "Sonarr";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/sonarr/.config/NzbDrone";
        description = "The directory where Sonarr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr web interface
        '';
      };

      user = mkOption {
        type = types.str;
        default = "sonarr";
        description = "User account under which Sonaar runs.";
      };

      group = mkOption {
        type = types.str;
        default = "sonarr";
        description = "Group under which Sonaar runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d ${cfg.dataDir} || {
          echo "Creating sonarr data directory in ${cfg.dataDir}"
          mkdir -p ${cfg.dataDir}
        }
        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
        chmod 0700 ${cfg.dataDir}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.sonarr}/bin/NzbDrone -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8989 ];
    };

    users.users = mkIf (cfg.user == "sonarr") {
      sonarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.sonarr;
      };
    };

    users.groups = mkIf (cfg.group == "sonarr") {
      sonarr.gid = config.ids.gids.sonarr;
    };
  };
}
