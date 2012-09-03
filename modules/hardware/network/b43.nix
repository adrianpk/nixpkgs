{pkgs, config, ...}:

let kernelVersion = config.boot.kernelPackages.kernel.version; in

{

  ###### interface

  options = {

    networking.enableB43Firmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the NICs supported by the b43 module.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.networking.enableB43Firmware {
    assertions = [ {
      assertion = builtins.lessThan (builtins.compareVersions kernelVersion "3.2") 0;
      message = "b43 firmware for kernels older than 3.2 not packaged yet!";
    } ];
    hardware.firmware = [ pkgs.b43Firmware_5_1_138 ];
  };

}
