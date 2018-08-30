# Udisks daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.udisks2 = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Udisks, a DBus service that allows
          applications to query and manipulate storage devices.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.udisks2.enable {

    environment.systemPackages = [ pkgs.udisks2 ];

    services.dbus.packages = [ pkgs.udisks2 ];

    system.activationScripts.udisks2 =
      ''
        mkdir -m 0755 -p /var/lib/udisks2
      '';

    services.udev.packages = [ pkgs.udisks2 ];

    systemd.packages = [ pkgs.udisks2 ];
  };

}
