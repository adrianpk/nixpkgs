{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.bind;

  bindUser = "named";

  confFile = pkgs.writeText "named.conf"
    ''
      acl cachenetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on {any;};
        listen-on-v6 {any;};
        allow-query { cachenetworks; };
        blackhole { badnetworks; };
        forward first;
        forwarders { ${concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "/var/run/named";
        pid-file "/var/run/named/named.pid";
      };

      ${ concatMapStrings
          ({ name, file, master ? true, slaves ? [], masters ? [] }:
            ''
              zone "${name}" {
                type ${if master then "master" else "slave"};
                file "${file}";
                ${ if master then
                   ''
                     allow-transfer {
                       ${concatMapStrings (ip: "${ip};\n") slaves}
                     };
                   ''
                   else
                   ''
                     masters {
                       ${concatMapStrings (ip: "${ip};\n") masters}
                     };
                   ''
                }
                allow-query { any; };
              };
            '')
          cfg.zones }
    '';

in

{

  ###### interface

  options = {

    services.bind = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable BIND domain name server.
        ";
      };

      cacheNetworks = mkOption {
        default = ["127.0.0.0/24"];
        description = "
          What networks are allowed to use us as a resolver.
        ";
      };

      blockedNetworks = mkOption {
        default = [];
        description = "
          What networks are just blocked.
        ";
      };

      ipv4Only = mkOption {
        default = false;
        description = "
          Only use ipv4, even if the host supports ipv6.
        ";
      };

      forwarders = mkOption {
        default = config.networking.nameservers;
        description = "
          List of servers we should forward requests to.
        ";
      };

      zones = mkOption {
        default = [];
        description = "
          List of zones we claim authority over.
            master=false means slave server; slaves means addresses
           who may request zone transfer.
        ";
        example = [{
          name = "example.com";
          master = false;
          file = "/var/dns/example.com";
          masters = ["192.168.0.1"];
          slaves = [];
        }];
      };

      configFile = mkOption {
        default = confFile;
        description = "
          Overridable config file to use for named. By default, that
          generated by nixos.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.bind.enable {

    users.extraUsers = singleton
      { name = bindUser;
        uid = config.ids.uids.bind;
        description = "BIND daemon user";
      };

    jobs.bind =
      { description = "BIND name server job";

        startOn = "started network-interfaces";

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -p /var/run/named
            chown ${bindUser} /var/run/named
          '';

        exec = "${pkgs.bind}/sbin/named -u ${bindUser} ${optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile} -f";
      };

  };

}
