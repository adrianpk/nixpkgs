{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  cfg = config.hardware.opengl;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

in

{
  options = {
    hardware.opengl.enable = mkOption {
      description = "Whether this configuration requires OpenGL.";
      type = types.bool;
      default = false;
      internal = true;
    };

    hardware.opengl.driSupport = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable accelerated OpenGL rendering through the
        Direct Rendering Interface (DRI).
      '';
    };

    hardware.opengl.driSupport32Bit = mkOption {
      type = types.bool;
      default = false;
      description = ''
        On 64-bit systems, whether to support Direct Rendering for
        32-bit applications (such as Wine).  This is currently only
        supported for the <literal>nvidia</literal> driver and for
        <literal>Mesa</literal>.
      '';
    };

    hardware.opengl.s3tcSupport = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make S3TC(S3 Texture Compression) via libtxc_dxtn available
        to OpenGL drivers instead of the patent-free S2TC replacement.

        Using this library may require a patent license depending on your location.
      '';
    };

  };

  config = mkIf cfg.enable {
    assertions = pkgs.lib.singleton {
      assertion = cfg.driSupport32Bit -> pkgs.stdenv.isx86_64;
      message = "Option driSupport32Bit only makes sens on a 64-bit system.";
    };

    system.activationScripts.setup-opengl.deps = [];
    system.activationScripts.setup-opengl.text = ''
      rm -f /run/opengl-driver{,-32}
      ${optionalString (pkgs.stdenv.isi686) "ln -sf opengl-driver /run/opengl-driver-32"}
    ''
      #TODO:  The OpenGL driver should depend on what's detected at runtime.
     +( if elem "nvidia" videoDrivers then
          ''
            ln -sf ${kernelPackages.nvidia_x11} /run/opengl-driver
            ${optionalString cfg.driSupport32Bit
              "ln -sf ${pkgs_i686.linuxPackages.nvidia_x11.override { libsOnly = true; kernel = null; } } /run/opengl-driver-32"}
          ''
        else if elem "nvidiaLegacy173" videoDrivers then
          "ln -sf ${kernelPackages.nvidia_x11_legacy173} /run/opengl-driver"
        else if elem "nvidiaLegacy304" videoDrivers then
          ''
            ln -sf ${kernelPackages.nvidia_x11_legacy304} /run/opengl-driver
            ${optionalString cfg.driSupport32Bit
              "ln -sf ${pkgs_i686.linuxPackages.nvidia_x11_legacy304.override { libsOnly = true; kernel = null; } } /run/opengl-driver-32"}
          ''
        else if elem "ati_unfree" videoDrivers then
          "ln -sf ${kernelPackages.ati_drivers_x11} /run/opengl-driver"
        else
          let
            lib_fun = p: p.buildEnv {
              name = "mesa-drivers+txc-${p.mesa_drivers.version}";
              paths = [
                p.mesa_drivers
                p.mesa_noglu # mainly for libGL
                (if cfg.s3tcSupport then p.libtxc_dxtn else p.libtxc_dxtn_s2tc)
              ];
            };
          in
          ''
            ${optionalString cfg.driSupport "ln -sf ${lib_fun pkgs} /run/opengl-driver"}
            ${optionalString cfg.driSupport32Bit
              "ln -sf ${lib_fun pkgs_i686} /run/opengl-driver-32"}
          ''
      );

    environment.variables.LD_LIBRARY_PATH =
      [ "/run/opengl-driver/lib" "/run/opengl-driver-32/lib" ];

    boot.extraModulePackages =
      optional (elem "nvidia" videoDrivers) kernelPackages.nvidia_x11 ++
      optional (elem "nvidiaLegacy173" videoDrivers) kernelPackages.nvidia_x11_legacy173 ++
      optional (elem "nvidiaLegacy304" videoDrivers) kernelPackages.nvidia_x11_legacy304 ++
      optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions ++
      optional (elem "ati_unfree" videoDrivers) kernelPackages.ati_drivers_x11;

    boot.blacklistedKernelModules =
      optionals (elem "nvidia" videoDrivers) [ "nouveau" "nvidiafb" ];

    environment.etc =
      (optionalAttrs (elem "ati_unfree" videoDrivers) {
        "ati".source = "${kernelPackages.ati_drivers_x11}/etc/ati";
      })
      // (optionalAttrs (elem "nvidia" videoDrivers) {
        "OpenCL/vendors/nvidia.icd".source = "${kernelPackages.nvidia_x11}/lib/vendors/nvidia.icd";
      });
  };
}
