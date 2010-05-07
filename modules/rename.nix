{pkgs, options, config, ...}:


let
  to = throw "This is just a dummy keyword";

  alias = from: to: {
    name = "Alias";
    msg.use = x: x;
    msg.define = x: x;
  };

  obsolete = from: to: {
    name = "Obsolete name";
    msg.use = x:
      builtins.trace "Obsolete option `${from}' is used instead of `${to}'." x;
    msg.define = x:
      builtins.trace "Obsolete option `${from}' is defined instead of `${to}'." x;
  };

  deprecated = from: to: {
    name = "Deprecated name";
    msg.use = x:
      abort "Deprecated option `${from}' is used instead of `${to}'.";
    msg.define = x:
      abort "Deprecated option `${from}' is defined instead of `${to}'.";
  };


  zipModules = list: with pkgs.lib;
    zip (n: v:
      if tail v != [] then zipModules v else head v
    ) list;

  rename = statusTemplate: from: keyword: to: with pkgs.lib;
    let
      status = statusTemplate from to;
      setTo = setAttrByPath (splitString "." to);
      setFrom = setAttrByPath (splitString "." from);
      toOf = attrByPath (splitString "." to)
        (abort "Renaming error: option `${to}' does not exists.");
      fromOf = attrByPath (splitString "." from)
        (abort "Internal error: option `${from}' should be declared.");
    in
      [{
        options = setFrom (mkOption {
          description = "${status.name} of <option>${to}</option>.";
          apply = x: status.msg.use (toOf config);
        });
      }] ++
      [{
        options = setTo (mkOption {
          extraConfigs =
            let externalDefs = (fromOf options).definitions; in
            if externalDefs == [] then []
            else map (def: def.value) (status.msg.define externalDefs);
        });
      }];

in zipModules ([]

# usage example:
# ++ rename alias "services.xserver.slim.theme" to "services.xserver.displayManager.slim.theme"
++ rename obsolete "environment.extraPackages" to "environment.systemPackages"

# Old Grub-related options.
++ rename obsolete "boot.copyKernels" to "boot.loader.grub.copyKernels"
++ rename obsolete "boot.extraGrubEntries" to "boot.loader.grub.extraEntries"
++ rename obsolete "boot.extraGrubEntriesBeforeNixos" to "boot.loader.grub.extraEntriesBeforeNixOS"
++ rename obsolete "boot.grubDevice" to "boot.loader.grub.device"
++ rename obsolete "boot.bootMount" to "boot.loader.grub.bootDevice"
++ rename obsolete "boot.grubSplashImage" to "boot.loader.grub.splashImage"

++ rename obsolete "boot.initrd.extraKernelModules" to "boot.initrd.kernelModules"

# OpenSSH
++ rename obsolete "services.sshd.ports" to "services.openssh.ports"
++ rename obsolete "services.sshd.enable" to "services.openssh.enable"
++ rename obsolete "services.sshd.allowSFTP" to "services.openssh.allowSFTP"
++ rename obsolete "services.sshd.forwardX11" to "services.openssh.forwardX11"
++ rename obsolete "services.sshd.gatewayPorts" to "services.openssh.gatewayPorts"
++ rename obsolete "services.sshd.permitRootLogin" to "services.openssh.permitRootLogin"
++ rename obsolete "services.xserver.startSSHAgent" to "services.xserver.startOpenSSHAgent"

# KDE
++ rename deprecated "kde.extraPackages" to "environment.kdePackages"


) # do not add renaming after this.
