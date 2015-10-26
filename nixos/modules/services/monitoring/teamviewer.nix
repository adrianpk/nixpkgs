{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.teamviewer;

in

{

  ###### interface

  options = {

    services.teamviewer.enable = mkEnableOption "teamviewer daemon";
      
  };

  ###### implementation

  config = mkIf (cfg.enable) {

    environment.systemPackages = [ pkgs.teamviewer ];

    systemd.services.teamviewerd = {
      description = "TeamViewer remote control daemon";

      wantedBy = [ "graphical.target" ];
      after = [ "NetworkManager-wait-online.service" "network.target" ];
      preStart = "mkdir -pv /var/tmp/teamviewer10/{logs,config}";

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.teamviewer}/bin/teamviewerd -d";
        PIDFile = "/run/teamviewerd.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-abort";
        StartLimitInterval = "60";
        StartLimitBurst = "10";
      };
    };
  };

}
