{ lib, ... }:

{
  options = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = ''
        Some descriptive text
      '';
    };
  };
}
