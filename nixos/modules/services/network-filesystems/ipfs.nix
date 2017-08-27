{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) ipfs runCommand makeWrapper;

  cfg = config.services.ipfs;

  ipfsFlags = toString ([
    (optionalString cfg.autoMount   "--mount")
    (optionalString cfg.autoMigrate "--migrate")
    (optionalString cfg.enableGC    "--enable-gc")
  ] ++ cfg.extraFlags);

  # Before Version 17.09, ipfs would always use "/var/lib/ipfs/.ipfs" as it's dataDir
  defaultDataDir = if versionAtLeast config.system.stateVersion "17.09" then
    "/var/lib/ipfs" else
    "/var/lib/ipfs/.ipfs";

  # Wrapping the ipfs binary with the environment variable IPFS_PATH set to dataDir because we can't set it in the user environment
  wrapped = runCommand "ipfs" { buildInputs = [ makeWrapper ]; } ''
    mkdir -p "$out/bin"
    makeWrapper "${ipfs}/bin/ipfs" "$out/bin/ipfs" \
      --set IPFS_PATH ${cfg.dataDir} \
      --prefix PATH : /run/wrappers/bin
  '';
in

{

  ###### interface

  options = {

    services.ipfs = {

      enable = mkEnableOption "Interplanetary File System";

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = "User under which the IPFS daemon runs";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = "Group under which the IPFS daemon runs";
      };

      dataDir = mkOption {
        type = types.str;
        default = defaultDataDir;
        description = "The data dir for IPFS";
      };

      defaultMode = mkOption {
        description = "systemd service that is enabled by default";
        type = types.enum [ "online" "offline" "norouting" ];
        default = "online";
      };

      autoMigrate = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether IPFS should try to migrate the file system automatically.
        '';
      };

      autoMount = mkOption {
        type = types.bool;
        default = false;
        description = "Whether IPFS should try to mount /ipfs and /ipns at startup.";
      };

      gatewayAddress = mkOption {
        type = types.str;
        default = "/ip4/127.0.0.1/tcp/8080";
        description = "Where the IPFS Gateway can be reached";
      };

      apiAddress = mkOption {
        type = types.str;
        default = "/ip4/127.0.0.1/tcp/5001";
        description = "Where IPFS exposes its API to";
      };

      enableGC = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable automatic garbage collection.
        '';
      };

      emptyRepo = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set to true, the repo won't be initialized with help files
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        description = toString [
          "Attrset of daemon configuration to set using `ipfs config`, every time the daemon starts."
          "These are applied last, so may override configuration set by other options in this module."
          "Keep in mind that this configuration is stateful; i.e., unsetting anything in here does not reset the value to the default!"
        ];
        default = {};
        example = {
          Datastore.StorageMax = "100GB";
          Discovery.MDNS.Enabled = false;
          Bootstrap = [
            "/ip4/128.199.219.111/tcp/4001/ipfs/QmSoLSafTMBsPKadTEgaXctDQVcqN88CNLHXMkTNwMKPnu"
            "/ip4/162.243.248.213/tcp/4001/ipfs/QmSoLueR4xBeUbY9WZ9xGUUxunbKWcrNFTDAadQJmocnWm"
          ];
          Swarm.AddrFilters = null;
        };

      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = "Extra flags passed to the IPFS daemon";
        default = [];
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ wrapped ];

    users.extraUsers = mkIf (cfg.user == "ipfs") {
      ipfs = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = false;
        uid = config.ids.uids.ipfs;
        description = "IPFS daemon user";
      };
    };

    users.extraGroups = mkIf (cfg.group == "ipfs") {
      ipfs = {
        gid = config.ids.gids.ipfs;
      };
    };

    systemd.services.ipfs-init = {
      description = "IPFS Initializer";

      after = [ "local-fs.target" ];
      before = [ "ipfs.service" "ipfs-offline.service" ];

      environment.IPFS_PATH = cfg.dataDir;

      path  = [ pkgs.ipfs pkgs.su pkgs.bash ];

      preStart = ''
        install -m 0755 -o ${cfg.user} -g ${cfg.group} -d ${cfg.dataDir}
      '';
      script = ''
        if [[ ! -f ${cfg.dataDir}/config ]]; then
          ${ipfs}/bin/ipfs init ${optionalString cfg.emptyRepo "-e"}
        fi
        ${ipfs}/bin/ipfs --local config Addresses.API ${cfg.apiAddress}
        ${ipfs}/bin/ipfs --local config Addresses.Gateway ${cfg.gatewayAddress}
      '' + optionalString cfg.autoMount ''
        ${ipfs}/bin/ipfs --local config Mounts.FuseAllowOther --json true
        mkdir -p $(${ipfs}/bin/ipfs --local config Mounts.IPFS)
        mkdir -p $(${ipfs}/bin/ipfs --local config Mounts.IPNS)
      '' + concatStringsSep "\n" (collect
            isString
            (mapAttrsRecursive
              (path: value:
              # Using heredoc below so that the value is never improperly quoted
              ''
                read value <<EOF
                ${builtins.toJSON value}
                EOF
                ipfs --local config --json "${concatStringsSep "." path}" "$value"
              '')
              cfg.extraConfig)
          );

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "oneshot";
        RemainAfterExit = true;
        PermissionsStartOnly = true;
      };
    };

    systemd.services.ipfs = {
      description = "IPFS Daemon";

      wantedBy = mkIf (cfg.defaultMode == "online") [ "multi-user.target" ];

      after = [ "network.target" "local-fs.target" "ipfs-init.service" ];

      conflicts = [ "ipfs-offline.service" "ipfs-norouting.service"];
      wants = [ "ipfs-init.service" ];

      environment.IPFS_PATH = cfg.dataDir;

      path  = [ pkgs.ipfs ];

      serviceConfig = {
        ExecStart = "${ipfs}/bin/ipfs daemon ${ipfsFlags}";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    systemd.services.ipfs-offline = {
      description = "IPFS Daemon (offline mode)";

      wantedBy = mkIf (cfg.defaultMode == "offline") [ "multi-user.target" ];

      after = [ "local-fs.target" "ipfs-init.service" ];

      conflicts = [ "ipfs.service" "ipfs-norouting.service"];
      wants = [ "ipfs-init.service" ];

      environment.IPFS_PATH = cfg.dataDir;

      path  = [ pkgs.ipfs ];

      serviceConfig = {
        ExecStart = "${ipfs}/bin/ipfs daemon ${ipfsFlags} --offline";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    systemd.services.ipfs-norouting = {
      description = "IPFS Daemon (no routing mode)";

      wantedBy = mkIf (cfg.defaultMode == "norouting") [ "multi-user.target" ];

      after = [ "local-fs.target" "ipfs-init.service" ];

      conflicts = [ "ipfs.service" "ipfs-offline.service"];
      wants = [ "ipfs-init.service" ];

      environment.IPFS_PATH = cfg.dataDir;

      path  = [ pkgs.ipfs ];

      serviceConfig = {
        ExecStart = "${ipfs}/bin/ipfs daemon ${ipfsFlags} --routing=none";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

  };
}
