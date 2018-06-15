{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.mtr;
in {
  options = {
    programs.mtr = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add mtr to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mtr ];
    security.wrappers.mtr-packet = {
      source = "${pkgs.mtr}/bin/mtr-packet";
      capabilities = "cap_net_raw+p";
    };
  };
}
