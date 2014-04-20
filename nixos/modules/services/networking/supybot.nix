{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.services.supybot;

in

{

  options = {

    services.supybot = {

      enable = mkOption {
        default = false;
        description = "Enable Supybot, an IRC bot";
      };

      stateDir = mkOption {
        # Setting this to /var/lib/supybot caused useradd to fail
        default = "/home/supybot";
        description = "The root directory, logs and plugins are stored here";
      };

      configFile = mkOption {
        type = types.path;
        description = ''
          Path to a supybot config file. This can be generated by
          running supybot-wizard.

          Note: all paths should include the full path to the stateDir
          directory (backup conf data logs logs/plugins plugins tmp web).
        '';
      };

    };

  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.pythonPackages.limnoria ];

    users.extraUsers = singleton {
      name = "supybot";
      uid = config.ids.uids.supybot;
      group = "supybot";
      description = "Supybot IRC bot user";
      home = cfg.stateDir;
      createHome = true;
    };

    users.extraGroups.supybot = {
      name = "supybot";
      gid = config.ids.gids.supybot;
    };

    systemd.services.supybot = {
      description = "Supybot, an IRC bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pythonPackages.limnoria ];
      preStart = ''
        cd ${cfg.stateDir}
        mkdir -p backup conf data plugins logs/plugins tmp web
        ln -sf ${cfg.configFile} supybot.cfg
        # This needs to be created afresh every time
        rm -f supybot.cfg.bak
      '';

      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.limnoria}/bin/supybot ${cfg.stateDir}/supybot.cfg";
        PIDFile = "/run/supybot.pid";
        User = "supybot";
        Group = "supybot";
        UMask = "0007";
        Restart = "on-abort";
        StartLimitInterval = "5m";
        StartLimitBurst = "1";
      };
    };

  };
}
