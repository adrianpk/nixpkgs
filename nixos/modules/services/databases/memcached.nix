{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.memcached;

  memcached = pkgs.memcached;

in

{

  ###### interface

  options = {

    services.memcached = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable Memcached.
        ";
      };

      user = mkOption {
        default = "memcached";
        description = "The user to run Memcached as";
      };

      listen = mkOption {
        default = "127.0.0.1";
        description = "The IP address to bind to";
      };

      port = mkOption {
        default = 11211;
        description = "The port to bind to";
      };

      enableUnixSocket = mkEnableOption "unix socket at /run/memcached/memcached.sock";

      maxMemory = mkOption {
        default = 64;
        description = "The maximum amount of memory to use for storage, in megabytes.";
      };

      maxConnections = mkOption {
        default = 1024;
        description = "The maximum number of simultaneous connections";
      };

      extraOptions = mkOption {
        default = [];
        description = "A list of extra options that will be added as a suffix when running memcached";
      };
    };

  };

  ###### implementation

  config = mkIf config.services.memcached.enable {

    users.users = optional (cfg.user == "memcached") {
      name = "memcached";
      description = "Memcached server user";
    };

    environment.systemPackages = [ memcached ];

    systemd.services.memcached = {
      description = "Memcached server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        PermissionsStartOnly = true;
        ExecStartPre = optionals cfg.enableUnixSocket [
          "${pkgs.coreutils}/bin/install -d -o ${cfg.user} /run/memcached/"
          "${pkgs.coreutils}/bin/chown -R ${cfg.user} /run/memcached/"
        ];
        ExecStart =
        let
          networking = if cfg.enableUnixSocket
          then "-s /run/memcached/memcached.sock"
          else "-l ${cfg.listen} -p ${toString cfg.port}";
        in "${memcached}/bin/memcached ${networking} -m ${toString cfg.maxMemory} -c ${toString cfg.maxConnections} ${concatStringsSep " " cfg.extraOptions}";

        User = cfg.user;
      };
    };
  };
  imports = [
    (mkRemovedOptionModule ["services" "memcached" "socket"] ''
      This option was replaced by a fixed unix socket path at /run/memcached/memcached.sock enabled using services.memached.enableUnixSocket.
    '')
  ];

}
