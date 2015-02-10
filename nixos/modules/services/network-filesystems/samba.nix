{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.samba;

  samba = cfg.package;

  setupScript =
    ''
      mkdir -p /var/lock/samba /var/log/samba /var/cache/samba /var/lib/samba/private
    '';

  shareConfig = name:
    let share = getAttr name cfg.shares; in
    "[${name}]\n " + (toString (
       map
         (key: "${key} = ${toString (getAttr key share)}\n")
         (attrNames share)
    ));

  configFile = pkgs.writeText "smb.conf"
    (if cfg.configText != null then cfg.configText else
    ''
      [ global ]
      security = ${cfg.securityType}
      passwd program = /var/setuid-wrappers/passwd %u
      pam password change = ${toString cfg.syncPasswordsByPam}
      invalid users = ${toString cfg.invalidUsers}

      ${cfg.extraConfig}

      ${toString (map shareConfig (attrNames cfg.shares))}
    '');

  # This may include nss_ldap, needed for samba if it has to use ldap.
  nssModulesPath = config.system.nssModules.path;

  daemonService = appName: args:
    { description = "Samba Service Daemon ${appName}";

      requiredBy = [ "samba.target" ];
      partOf = [ "samba.target" ];

      environment = {
        LD_LIBRARY_PATH = nssModulesPath;
        LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
      };

      serviceConfig = {
        ExecStart = "${samba}/sbin/${appName} ${args}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };

      restartTriggers = [ configFile ];
    };

in

{

  ###### interface

  options = {

    # !!! clean up the descriptions.

    services.samba = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Samba, which provides file and print
          services to Windows clients through the SMB/CIFS protocol.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.samba;
        example = pkgs.samba4;
        description = ''
          Defines which package should be used for the samba server.
        '';
      };

      syncPasswordsByPam = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enabling this will add a line directly after pam_unix.so.
          Whenever a password is changed the samba password will be updated as well.
          However you still yave to add the samba password once using smbpasswd -a user
          If you don't want to maintain an extra pwd database you still can send plain text
          passwords which is not secure.
        '';
      };

      invalidUsers = mkOption {
        type = types.listOf types.str;
        default = [ "root" ];
        description = ''
          List of users who are denied to login via Samba.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional global section and extra section lines go in here.
        '';
      };

      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Verbatim contents of smb.conf. If null (default), use the
          autogenerated file from NixOS instead.
        '';
      };

      securityType = mkOption {
        type = types.str;
        default = "user";
        example = "share";
        description = "Samba security type";
      };

      nsswins = mkOption {
        default = false;
        type = types.uniq types.bool;
        description = ''
          Whether to enable the WINS NSS (Name Service Switch) plug-in.
          Enabling it allows applications to resolve WINS/NetBIOS names (a.k.a.
          Windows machine names) by transparently querying the winbindd daemon.
        '';
      };

      shares = mkOption {
        default = {};
        description = ''
          A set describing shared resources.
          See <command>man smb.conf</command> for options.
        '';
        type = types.attrsOf (types.attrsOf types.unspecified);
        example =
          { srv =
             { path = "/srv";
               "read only" = "yes";
                comment = "Public samba share.";
             };
          };
      };

    };

  };


  ###### implementation

  config = mkMerge
    [ { # Always provide a smb.conf to shut up programs like smbclient and smbspool.
        environment.etc = singleton
          { source =
              if cfg.enable then configFile
              else pkgs.writeText "smb-dummy.conf" "# Samba is disabled.";
            target = "samba/smb.conf";
          };
      }

      (mkIf config.services.samba.enable {

        system.nssModules = optional cfg.nsswins samba;

        systemd = {
          targets.samba = {
            description = "Samba Server";
            requires = [ "samba-setup.service" ];
            after = [ "samba-setup.service" "network.target" ];
            wantedBy = [ "multi-user.target" ];
          };

          services = {
            "samba-nmbd" = daemonService "nmbd" "-F";
            "samba-smbd" = daemonService "smbd" "-F";
            "samba-winbindd" = daemonService "winbindd" "-F";
            "samba-setup" = {
              description = "Samba Setup Task";
              script = setupScript;
              unitConfig.RequiresMountsFor = "/var/samba /var/log/samba";
            };
          };
        };

        security.pam.services.sambda = {};

      })
    ];

}
