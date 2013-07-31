{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg  = config.services.supybot;
  configFile = pkgs.writeText "supybot.cfg" cfg.config;

in

{

  ###### interface

  options = {

    services.supybot = {

      enable = mkOption {
        default = false;
        description = "Enable the supybot IRC bot";
      };

      homeDir = mkOption {
        default = "/home/supybot";
        description = "
          Directory holding all state for nginx to run.
        ";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Verbatim contents of the supybot config, this can be
          generated by supybot-wizard
        '';
      };

      user = mkOption {
        default = "supybot";
        description = "User account under which supybot runs.";
      };

      group = mkOption {
        default = "supybot";
        description = "Group account under which supybot runs.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
  
    environment.systemPackages = [ pkgs.pythonPackages.limnoria ];

    users.extraUsers = singleton
      { name = cfg.user;
        uid = config.ids.uids.supybot;
        group = "supybot";
        description = "Supybot IRC bot user";
        home = cfg.homeDir;
        createHome = true;
      }; 

    users.extraGroups.supybot = {};

    systemd.services.supybot =
      { description = "Supybot IRC bot";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.pythonPackages.limnoria ];
        preStart = ''
          cd ${cfg.homeDir}
          mkdir -p logs/plugins backup conf data plugins tmp
        '';
        serviceConfig =
          { ExecStart =
              "${pkgs.pythonPackages.limnoria}/bin/supybot ${cfg.homeDir}/supybot.cfg";
            PIDFile = "/run/supybot.pid";
            User = "${cfg.user}"; 
            Group = "${cfg.group}";
            UMask = "0007";
            Restart = "on-abort";
            StartLimitInterval = "5m";
            StartLimitBurst = "1";
          };
      };

  };

}
