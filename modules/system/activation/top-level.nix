{pkgs, config, ...}:

let

  options = {
  
    system.build = pkgs.lib.mkOption {
      default = {};
      description = ''
        Attribute set of derivations used to setup the system.
      '';
    };

    nesting.children = pkgs.lib.mkOption {
      default = [];
      description = ''
        Additional configurations to build.
      '';
    };

    system.boot.loader.id = pkgs.lib.mkOption {
      default = "";
      description = ''
        Id string of the used bootloader.
      '';
    };

    system.boot.loader.kernelFile = pkgs.lib.mkOption {
      default = "";
      description = ''
        Name of the kernel file to be passed to the bootloader.
      '';
    };
    
  };

    
  # This attribute is responsible for creating boot entries for 
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration 
  # as you use, but with another kernel
  # !!! fix this
  children = map (x: ((import ../../../default.nix)
    { configuration = x//{boot=((x.boot)//{grubDevice = "";});};}).system) 
    config.nesting.children;


  systemBuilder =
    let
      kernelPath = "${config.boot.kernelPackages.kernel}/" +
        "${config.system.boot.loader.kernelFile}";
    in 
      ''
      ensureDir $out

      if [ ! -f ${kernelPath} ]; then
        echo "The bootloader cannot find the proper kernel image."
        echo "(Expecting ${kernelPath})"
      fi
      ln -s ${kernelPath} $out/kernel
      if [ -n "$grub" ]; then 
        ln -s $grub $out/grub
      fi
      ln -s ${config.system.build.bootStage2} $out/init
      ln -s ${config.system.build.initialRamdisk}/initrd $out/initrd
      ln -s ${config.system.activationScripts.script} $out/activate
      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw
      ln -s ${pkgs.upstart} $out/upstart

      echo "$kernelParams" > $out/kernel-params
      echo "$configurationName" > $out/configuration-name
      echo "${toString pkgs.upstart.interfaceVersion}" > $out/upstart-interface-version

      mkdir $out/fine-tune
      childCount=0;
      for i in $children; do 
        childCount=$(( childCount + 1 ));
        ln -s $i $out/fine-tune/child-$childCount;
      done

      ensureDir $out/bin
      substituteAll ${./switch-to-configuration.sh} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration
    '';

  
  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.stdenv.mkDerivation {
    name = "system";
    buildCommand = systemBuilder;
    inherit children;
    kernelParams =
      config.boot.kernelParams ++ config.boot.extraKernelParams;
    menuBuilder = config.system.build.menuBuilder;
    # Most of these are needed by grub-install.
    path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.findutils
      pkgs.diffutils
      pkgs.upstart # for initctl
    ];

    # Boot loaders
    bootLoader = config.system.boot.loader.id;
    grub =
      if config.boot.loader.grub.enable
      then (if config.boot.loader.grub.version == 1
            then pkgs.grub
            else pkgs.grub2)
      else null;
    grubDevice = config.boot.loader.grub.device;
    configurationName = config.boot.loader.grub.configurationName;
  };


in {
  require = [options];

  system.build.toplevel = system;
}
