{config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.usbguard;

  # valid policy options
  policy = (types.enum [ "allow" "block" "reject" "keep" "apply-policy" ]);

  # decide what file to use for rules
  ruleFile = if cfg.rules != null then pkgs.writeText "usbguard-rules" cfg.rules else cfg.ruleFile;

  daemonConf = ''
      # generated by nixos/modules/services/security/usbguard.nix
      RuleFile=${ruleFile}
      ImplicitPolicyTarget=${cfg.implictPolicyTarget}
      PresentDevicePolicy=${cfg.presentDevicePolicy}
      PresentControllerPolicy=${cfg.presentControllerPolicy}
      InsertedDevicePolicy=${cfg.insertedDevicePolicy}
      RestoreControllerDeviceState=${if cfg.restoreControllerDeviceState then "true" else "false"}
      # this does not seem useful for endusers to change
      DeviceManagerBackend=uevent
      IPCAllowedUsers=${concatStringsSep " " cfg.IPCAllowedUsers}
      IPCAllowedGroups=${concatStringsSep " " cfg.IPCAllowedGroups}
      IPCAccessControlFiles=${cfg.IPCAccessControlFiles}
      DeviceRulesWithPort=${if cfg.deviceRulesWithPort then "true" else "false"}
      AuditFilePath=${cfg.auditFilePath}
    '';

    daemonConfFile = pkgs.writeText "usbguard-daemon-conf" daemonConf;

in {

  ###### interface

  options = {
    services.usbguard = {
      enable = mkEnableOption "USBGuard daemon";

      ruleFile = mkOption {
        type = types.path;
        default = "/var/lib/usbguard/rules.conf";
        description = ''
          The USBGuard daemon will use this file to load the policy rule set
          from it and to write new rules received via the IPC interface.

          Running the command <literal>usbguard generate-policy</literal> as
          root will generate a config for your currently plugged in devices.
          For a in depth guide consult the official documentation.

          Setting the <literal>rules</literal> option will ignore the
          <literal>ruleFile</literal> option.
        '';
      };

      rules = mkOption {
        type = types.nullOr types.lines;
        default = null;
        example = ''
          allow with-interface equals { 08:*:* }
        '';
        description = ''
          The USBGuard daemon will load this policy rule set. Modifying it via
          the IPC interface won't work if you use this option, since the
          contents of this option will be written into the nix-store it will be
          read-only.

          You can still use <literal> usbguard generate-policy</literal> to
          generate rules, but you would have to insert them here.

          Setting the <literal>rules</literal> option will ignore the
          <literal>ruleFile</literal> option.
        '';
      };

      implictPolicyTarget = mkOption {
        type = policy;
        default = "block";
        description = ''
          How to treat USB devices that don't match any rule in the policy.
          Target should be one of allow, block or reject (logically remove the
          device node from the system).
        '';
      };

      presentDevicePolicy = mkOption {
        type = policy;
        default = "apply-policy";
        description = ''
          How to treat USB devices that are already connected when the daemon
          starts. Policy should be one of allow, block, reject, keep (keep
          whatever state the device is currently in) or apply-policy (evaluate
          the rule set for every present device).
        '';
      };

      presentControllerPolicy = mkOption {
        type = policy;
        default = "keep";
        description = ''
          How to treat USB controller devices that are already connected when
          the daemon starts. One of allow, block, reject, keep or apply-policy.
        '';
      };

      insertedDevicePolicy = mkOption {
        type = policy;
        default = "apply-policy";
        description = ''
          How to treat USB devices that are already connected after the daemon
          starts. One of block, reject, apply-policy.
        '';
      };

      restoreControllerDeviceState = mkOption {
        type = types.bool;
        default = false;
        description = ''
          The  USBGuard  daemon  modifies  some attributes of controller
          devices like the default authorization state of new child device
          instances. Using this setting, you can controll whether the daemon
          will try to restore the attribute values to the state before
          modificaton on shutdown.
        '';
      };

      IPCAllowedUsers = mkOption {
        type = types.listOf types.str;
        default = [ "root" ];
        example = [ "root" "yourusername" ];
        description = ''
          A list of usernames that the daemon will accept IPC connections from.
        '';
      };

      IPCAllowedGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "wheel" ];
        description = ''
          A list of groupnames that the daemon will accept IPC connections
          from.
        '';
      };

      IPCAccessControlFiles = mkOption {
        type = types.path;
        default = "/var/lib/usbguard/IPCAccessControl.d/";
        description = ''
          The files at this location will be interpreted by the daemon as IPC
          access control definition files. See the IPC ACCESS CONTROL section
          in <citerefentry><refentrytitle>usbguard-daemon.conf</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for more details.
        '';
      };

      deviceRulesWithPort = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Generate device specific rules including the "via-port" attribute.
        '';
      };

      auditFilePath = mkOption {
        type = types.path;
        default = "/var/log/usbguard/usbguard-audit.log";
        description = ''
          USBGuard audit events log file path.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.usbguard ];

    systemd.services.usbguard = {
      description = "USBGuard daemon";

      wantedBy = [ "basic.target" ];
      wants = [ "systemd-udevd.service" "local-fs.target" ];

      # make sure an empty rule file and required directories exist
      preStart = ''mkdir -p $(dirname "${cfg.ruleFile}") "${cfg.IPCAccessControlFiles}" && ([ -f "${cfg.ruleFile}" ] || touch ${cfg.ruleFile})'';

      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.usbguard}/bin/usbguard-daemon -d -k -c ${daemonConfFile}'';
        Restart = "on-failure";
      };
    };
  };
}
