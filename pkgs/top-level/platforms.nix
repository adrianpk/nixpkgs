{ system, pkgs}:
with pkgs;
{
  pc = assert system == "i686-linux" || system == "x86_64-linux"; {
    name = "pc";
    uboot = null;
    kernelBaseConfig = "defconfig";
    # Build whatever possible as a module, if not stated in the extra config.
    kernelAutoModules = true;
    kernelExtraConfig =
      ''
        # Virtualisation (KVM, Xen...).
        PARAVIRT_GUEST y
        KVM_CLOCK y
        KVM_GUEST y
        XEN y
        KSM y

        # We need 64 GB (PAE) support for Xen guest support.
        HIGHMEM64G? y
      '';
  };

  sheevaplug = assert system == "armv5tel-linux"; {
    name = "sheevaplug";
    kernelBaseConfig = "kirkwood_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        MD y

        # Fail to build
        DRM n
        SCSI_ADVANSYS n
        USB_ISP1362_HCD n
        SND_SOC n
        SND_ALI5451 n
        FB_SAVAGE n
        SCSI_NSP32 n
        ATA_SFF n
        SUNGEM n
        IRDA n
        ATM_HE n
        SCSI_ACARD n
        BLK_DEV_CMD640_ENHANCED n
      '';
    inherit uboot;
  };

  versatileARM = assert system == "armv5tel-linux"; {
    name = "versatileARM";
    kernelBaseConfig = "versatile_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    uboot = null;
  };
}
