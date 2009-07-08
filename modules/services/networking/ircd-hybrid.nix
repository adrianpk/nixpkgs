{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      ircdHybrid = {

        enable = mkOption {
          default = false;
          description = "
            Enable IRCD.
          ";
        };

        serverName = mkOption {
          default = "hades.arpa";
          description = "
            IRCD server name.
          ";
        };

        sid = mkOption {
          default = "0NL";
          description = "
            IRCD server unique ID in a net of servers.
          ";
        };

        description = mkOption {
          default = "Hybrid-7 IRC server.";
          description = "
            IRCD server description.
          ";
        };

        rsaKey = mkOption {
          default = null;
          example = /root/certificates/irc.key;
          description = "
            IRCD server RSA key. 
          ";
        };

        certificate = mkOption {
          default = null;
          example = /root/certificates/irc.pem;
          description = "
            IRCD server SSL certificate. There are some limitations - read manual.
          ";
        };

        adminEmail = mkOption {
          default = "<bit-bucket@example.com>";
          example = "<name@domain.tld>";
          description = "
            IRCD server administrator e-mail. 
          ";
        };

        extraIPs = mkOption {
          default = [];
          example = ["127.0.0.1"];
          description = "
            Extra IP's to bind.
          ";
        };

        extraPort = mkOption {
          default = "7117";
          description = "
            Extra port to avoid filtering.
          ";
        };

      };
    };
  };
in

###### implementation

let
  cfg = config.services.ircdHybrid;
  ircdService = import ../../../../services/ircd-hybrid {
    stdenv = pkgs.stdenv;
    inherit (pkgs) ircdHybrid coreutils 
            su iproute gnugrep procps;
    serverName = cfg.serverName;
    sid = cfg.sid;
    description = cfg.description;
    rsaKey = cfg.rsaKey;
    certificate = cfg.certificate;
    adminEmail = cfg.adminEmail;
    extraIPs = cfg.extraIPs;
    extraPort = cfg.extraPort;
    gw6cEnabled = (config.services.gw6c.enable) &&
            (config.services.gw6c.autorun);
  };

  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";

in

mkIf config.services.ircdHybrid.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [{
      name = "ircd-hybrid";
      users = [ {
                      name = "ircd"; 
                      description = "IRCD owner.";
              } ];
      groups = [{name = "ircd";}];
      job = ''
        description = "IRCD Hybrid server."

        start on ${startingDependency}/started
        stop on ${startingDependency}/stop

        respawn ${ircdService}/bin/control start
      '';
    }];
  };
}
