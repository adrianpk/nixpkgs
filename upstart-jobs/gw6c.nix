{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      gw6c = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable Gateway6 client (IPv6 tunnel).
          ";
        };

        autorun = mkOption {
          default = true;
          description = "
            Switch to false to create upstart-job and configuration, 
            but not run it automatically
          ";
        };

        username = mkOption {
          default = "";
          description = "
            Your Gateway6 login name, if any.
          ";
        };

        password = mkOption {
          default = "";
          description = "
            Your Gateway6 password, if any.
          ";
        };

        server = mkOption {
          default = "anon.freenet6.net";
          example = "broker.freenet6.net";
          description = "
            Used Gateway6 server.
          ";
        };

        keepAlive = mkOption {
          default = "30";
          example = "2";
          description = "
            Gateway6 keep-alive period.
          ";
        };

        everPing = mkOption {
          default = "1000000";
          example = "2";
          description = "
            Gateway6 manual ping period.
          ";
        };

        waitPingableBroker = mkOption {
          default = true;
          example = false;
          description = "
            Whether to wait until tunnel broker returns ICMP echo.
          ";
        };
      };
    };
    security = {
      seccureKeys = {
        public = mkOption {
          default = /var/elliptic-keys/public;
          description = "
            Public key. Make it path argument, so it is copied into store and
            hashed. 

            The key is used to encrypt Gateway 6 configuration in store, as it
            contains a password for external service. Unfortunately, 
            derivation file should be protected by other means. For example, 
            nix-http-export.cgi will happily export any non-derivation path,
            but not a derivation.
          ";
        };
        private = mkOption {
          default = "/var/elliptic-keys/private";
          description = "
            Private key. Make it string argument, so it is not copied into store.
          ";
        };
      };
    };
  };
in

###### implementation

let
        cfg = config.services.gw6c;
        procps = pkgs.procps;
        gw6cService = import ../../services/gw6c {
                inherit (pkgs) stdenv gw6c coreutils 
                procps upstart iputils gnused 
                gnugrep seccure writeScript;
                username = cfg.username;
                password = cfg.password;
                server = cfg.server;
                keepAlive = cfg.keepAlive;
                everPing = cfg.everPing;

                seccureKeys = config.security.seccureKeys;

                waitPingableBroker = cfg.waitPingableBroker;
        };
in


mkIf config.services.gw6c.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [{
        name = "gw6c";
        users = [];
        groups = [];
        job = ''
          description \"Gateway6 client\"

          start on ${ if cfg.autorun then "network-interfaces/started" else "never" }
          stop on network-interfaces/stop

          respawn ${gw6cService}/bin/control start
        '';
    }];
  };
}
