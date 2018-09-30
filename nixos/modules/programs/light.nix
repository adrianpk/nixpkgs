{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.light;

in
{
  options = {
    programs.light = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install Light backlight control command and udev rules.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.light ];
    services.udev.packages = [ pkgs.light ];
  };
}
