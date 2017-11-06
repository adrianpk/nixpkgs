{pkgs, config, lib, ...}:

let

  inherit (lib) mkOption mkIf;

  inherit (pkgs) heimdalFull;

  stateDir = "/var/heimdal";
in

{

  ###### interface

  options = {

    services.kerberos_server = {

      enable = mkOption {
        default = false;
        description = ''
          Enable the kerberos authentification server.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.kerberos_server.enable {

    environment.systemPackages = [ heimdalFull ];
    systemd.services.kadmind = {
      description = "Kerberos Administration Daemon";
      script = "${pkgs.heimdalFull}/libexec/heimdal/kadmind";
    };

    systemd.services.kdc = {
      description = "Key Distribution Center daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      script = "${heimdalFull}/libexec/heimdal/kdc";
    };

    systemd.services.kpasswdd = {
      description = "Kerberos Password Changing daemon";
      wantedBy = [ "multi-user.target" ];
      script = "${heimdalFull}/libexec/heimdal/kpasswdd";
    };
  };
}
