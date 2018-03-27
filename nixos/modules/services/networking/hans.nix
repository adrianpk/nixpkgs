# NixOS module for hans, ip over icmp daemon

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hans;

  hansUser = "hans";

in
{

  ### configuration

  options = {

    services.hans = {
      clients = mkOption {
        default = {};
        description = ''
          Each attribute of this option defines a systemd service that
          runs hans. Many or none may be defined.
          The name of each service is
          <literal>hans-<replaceable>name</replaceable></literal>
          where <replaceable>name</replaceable> is the name of the
          corresponding attribute name.
        '';
        example = literalExample ''
        {
          foo = {
            server = "192.0.2.1";
            extraConfig = "-v";
          }
        }
        '';
        type = types.attrsOf (types.submodule (
        {
          options = {
            server = mkOption {
              type = types.str;
              default = "";
              description = "IP address of server running hans";
              example = "192.0.2.1";
            };

            extraConfig = mkOption {
              type = types.str;
              default = "";
              description = "Additional command line parameters";
              example = "-v";
            };

            passwordFile = mkOption {
              type = types.str;
              default = "";
              description = "File that containts password";
            };

          };
        }));
      };

      server = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "enable hans server";
        };

        ip = mkOption {
          type = types.str;
          default = "";
          description = "The assigned ip range";
          example = "198.51.100.0";
        };

        systemPings = mkOption {
          type = types.bool;
          default = false;
          description = "Respond to ordinary pings";
        };

        extraConfig = mkOption {
          type = types.str;
          default = "";
          description = "Additional command line parameters";
          example = "-v";
        };

        passwordFile = mkOption {
          type = types.str;
          default = "";
          description = "File that containts password";
        };
      };

    };
  };

  ### implementation

  config = mkIf (cfg.server.enable || cfg.clients != {}) {
    boot.kernel.sysctl = optionalAttrs cfg.server.systemPings {
      "net.ipv4.icmp_echo_ignore_all" = 1;
    };

    boot.kernelModules = [ "tun" ];

    systemd.services =
    let
      createHansClientService = name: cfg:
      {
        description = "hans client - ${name}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          cat > /run/hans/${name}-script << EOF
            #!/bin/sh
            ${pkgs.hans}/bin/hans -f -u ${hansUser} ${cfg.extraConfig} -c ${cfg.server} ${optionalString (cfg.passwordFile != "") "-p $(cat \"${cfg.passwordFile}\")"} 
          EOF
          chmod 700 /run/hans/${name}-script
        '';
        script = "/run/hans/${name}-script";
        serviceConfig = {
          RestartSec = "30s";
          Restart = "always";
          RuntimeDirectory = [ "hans" ];
        };
      };
    in
    listToAttrs (
      mapAttrsToList
        (name: value: nameValuePair "hans-${name}" (createHansClientService name value))
        cfg.clients
    ) // {
      hans = mkIf (cfg.server.enable) {
        description = "hans, ip over icmp server daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          cat > /run/hans/script << EOF
            #!/bin/sh
            ${pkgs.hans}/bin/hans -f -u ${hansUser} ${cfg.server.extraConfig} -s ${cfg.server.ip} ${optionalString cfg.server.systemPings "-r"} ${optionalString (cfg.passwordFile != "") "-p $(cat \"${cfg.passwordFile}\")"}
          EOF
          chmod 700 /run/hans/script
        '';
        script = "/run/hans/script";
        serviceConfig.RuntimeDirectory = [ "hans" ];
      };
    };

    users.extraUsers = singleton {
      name = hansUser;
      description = "Hans daemon user";
    };
  };

  meta.maintainers = with maintainers; [ gnidorah ];
}
