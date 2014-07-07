# This module allows you to export something from configuration
# Use case: export kernel source expression for ease of configuring

{ config, lib, ... }:

{
  options = {
    passthru = lib.mkOption {
      visible = false;
      description = ''
        This attribute set will be exported as a system attribute.
        You can put whatever you want here.
      '';
    };
  };
}
