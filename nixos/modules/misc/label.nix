{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system.nixos;
in

{

  options.system = {

    nixos.label = mkOption {
      type = types.str;
      description = ''
        NixOS version name to be used in the names of generated
        outputs and boot labels.

        If you ever wanted to influence the labels in your GRUB menu,
        this is the option for you.
      '';
    };

  };

  config = {
    # This is set here rather than up there so that changing it would
    # not rebuild the manual
    system.nixos.label = mkDefault cfg.version;
  };

}
