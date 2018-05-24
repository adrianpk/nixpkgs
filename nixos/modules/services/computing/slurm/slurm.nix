{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.slurm;
  # configuration file can be generated by http://slurm.schedmd.com/configurator.html
  configFile = pkgs.writeTextDir "slurm.conf"
    ''
      ${optionalString (cfg.controlMachine != null) ''controlMachine=${cfg.controlMachine}''}
      ${optionalString (cfg.controlAddr != null) ''controlAddr=${cfg.controlAddr}''}
      ${optionalString (cfg.nodeName != null) ''nodeName=${cfg.nodeName}''}
      ${optionalString (cfg.partitionName != null) ''partitionName=${cfg.partitionName}''}
      PlugStackConfig=${plugStackConfig}
      ProctrackType=${cfg.procTrackType}
      ${cfg.extraConfig}
    '';

  plugStackConfig = pkgs.writeTextDir "plugstack.conf"
    ''
      ${optionalString cfg.enableSrunX11 ''optional ${pkgs.slurm-spank-x11}/lib/x11.so''}
      ${cfg.extraPlugstackConfig}
    '';


  cgroupConfig = pkgs.writeTextDir "cgroup.conf"
   ''
     ${cfg.extraCgroupConfig}
   '';

  # slurm expects some additional config files to be
  # in the same directory as slurm.conf
  etcSlurm = pkgs.symlinkJoin {
    name = "etc-slurm";
    paths = [ configFile cgroupConfig plugStackConfig ];
  };

in

{

  ###### interface

  options = {

    services.slurm = {

      server = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Wether to enable the slurm control daemon.
            Note that the standard authentication method is "munge".
            The "munge" service needs to be provided with a password file in order for
            slurm to work properly (see <literal>services.munge.password</literal>).
          '';
        };
      };

      client = {
        enable = mkEnableOption "slurm client daemon";
      };

      enableStools = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Wether to provide a slurm.conf file.
          Enable this option if you do not run a slurm daemon on this host
          (i.e. <literal>server.enable</literal> and <literal>client.enable</literal> are <literal>false</literal>)
          but you still want to run slurm commands from this host.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.slurm;
        defaultText = "pkgs.slurm";
        example = literalExample "pkgs.slurm-full";
        description = ''
          The package to use for slurm binaries.
        '';
      };

      controlMachine = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = null;
        description = ''
          The short hostname of the machine where SLURM control functions are
          executed (i.e. the name returned by the command "hostname -s", use "tux001"
          rather than "tux001.my.com").
        '';
      };

      controlAddr = mkOption {
        type = types.nullOr types.str;
        default = cfg.controlMachine;
        example = null;
        description = ''
          Name that ControlMachine should be referred to in establishing a
          communications path.
        '';
      };

      nodeName = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "linux[1-32] CPUs=1 State=UNKNOWN";
        description = ''
          Name that SLURM uses to refer to a node (or base partition for BlueGene
          systems). Typically this would be the string that "/bin/hostname -s"
          returns. Note that now you have to write node's parameters after the name.
        '';
      };

      partitionName = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "debug Nodes=linux[1-32] Default=YES MaxTime=INFINITE State=UP";
        description = ''
          Name by which the partition may be referenced. Note that now you have
          to write the partition's parameters after the name.
        '';
      };

      enableSrunX11 = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If enabled srun will accept the option "--x11" to allow for X11 forwarding
          from within an interactive session or a batch job. This activates the
          slurm-spank-x11 module. Note that this option also enables
          'services.openssh.forwardX11' on the client.
        '';
      };

      procTrackType = mkOption {
        type = types.string;
        default = "proctrack/linuxproc";
        description = ''
          Plugin to be used for process tracking on a job step basis.
          The slurmd daemon uses this mechanism to identify all processes
          which are children of processes it spawns for a user job step.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration options that will be added verbatim at
          the end of the slurm configuration file.
        '';
      };

      extraPlugstackConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration that will be added to the end of <literal>plugstack.conf</literal>.
        '';
      };

      extraCgroupConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration for <literal>cgroup.conf</literal>. This file is
          used when <literal>procTrackType=proctrack/cgroup</literal>.
        '';
      };
    };

  };


  ###### implementation

  config =
    let
      wrappedSlurm = pkgs.stdenv.mkDerivation {
        name = "wrappedSlurm";

        propagatedBuildInputs = [ cfg.package etcSlurm ];

        builder = pkgs.writeText "builder.sh" ''
          source $stdenv/setup
          mkdir -p $out/bin
          find  ${getBin cfg.package}/bin -type f -executable | while read EXE
          do
            exename="$(basename $EXE)"
            wrappername="$out/bin/$exename"
            cat > "$wrappername" <<EOT
          #!/bin/sh
          if [ -z "$SLURM_CONF" ]
          then
            SLURM_CONF="${etcSlurm}/slurm.conf" "$EXE" "\$@"
          else
            "$EXE" "\$0"
          fi
          EOT
            chmod +x "$wrappername"
          done
        '';
      };

  in mkIf (cfg.enableStools || cfg.client.enable || cfg.server.enable) {

    environment.systemPackages = [ wrappedSlurm ];

    services.munge.enable = mkDefault true;

    systemd.services.slurmd = mkIf (cfg.client.enable) {
      path = with pkgs; [ wrappedSlurm coreutils ]
        ++ lib.optional cfg.enableSrunX11 slurm-spank-x11;

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-tmpfiles-clean.service" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${wrappedSlurm}/bin/slurmd";
        PIDFile = "/run/slurmd.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };

      preStart = ''
        mkdir -p /var/spool
      '';
    };

    services.openssh.forwardX11 = mkIf cfg.client.enable (mkDefault true);

    systemd.services.slurmctld = mkIf (cfg.server.enable) {
      path = with pkgs; [ wrappedSlurm munge coreutils ]
        ++ lib.optional cfg.enableSrunX11 slurm-spank-x11;

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "munged.service" ];
      requires = [ "munged.service" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${wrappedSlurm}/bin/slurmctld";
        PIDFile = "/run/slurmctld.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };

  };

}
