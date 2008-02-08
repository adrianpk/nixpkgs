{ platform ? __currentSystem
, relName ?
    if builtins.pathExists ../relname
    then builtins.readFile ../relname
    else "nixos-${builtins.readFile ../VERSION}"
}:

rec {

  
  nixpkgsRel = "nixpkgs-0.12pre10553";


  configuration = {
  
    boot = {
      autoDetectRootDevice = true;
      isLiveCD = true;
      # The label used to identify the installation CD.
      rootLabel = "NIXOS";
      extraTTYs = [7 8]; # manual, rogue
      extraModulePackages = [pkgs.aufs];
      
      initrd = {
        extraKernelModules = [
          # The initrd should contain any modules necessary for
          # mounting the CD.
        
          # SATA/PATA support.
          "ahci"

          "ata_piix"
          
          "sata_inic162x" "sata_nv" "sata_promise" "sata_qstor"
          "sata_sil" "sata_sil24" "sata_sis" "sata_svw" "sata_sx4"
          "sata_uli" "sata_via" "sata_vsc"

          "pata_ali" "pata_amd" "pata_artop" "pata_atiixp"
          "pata_cs5520" "pata_cs5530" /* "pata_cs5535" */ "pata_efar"
          "pata_hpt366" "pata_hpt37x" "pata_hpt3x2n" "pata_hpt3x3"
          "pata_it8213" "pata_it821x" "pata_jmicron" "pata_marvell"
          "pata_mpiix" "pata_netcell" "pata_ns87410" "pata_oldpiix"
          "pata_pcmcia" "pata_pdc2027x" /* "pata_qdi" */ "pata_rz1000"
          "pata_sc1200" "pata_serverworks" "pata_sil680" "pata_sis"
          "pata_sl82c105" "pata_triflex" "pata_via"
          # "pata_winbond" <-- causes timeouts in sd_mod

          # SCSI support (incomplete).
          "3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr" 
        
          # USB support, especially for booting from USB CD-ROM
          # drives.  Also include USB keyboard support for when
          # something goes wrong in stage 1.
          "ehci_hcd"
          "ohci_hcd"
          "usbhid"
          "usb_storage"

          # Firewire support.  Not tested.
          "ohci1394" "sbp2"

          # Wait for SCSI devices to appear.
          "scsi_wait_scan"

          # Needed for live-CD operation.
          "aufs"
        ];
      };
    };

    networking = {
      enableIntel3945ABGFirmware = true;
    };
    
    services = {
    
      sshd = {
        enable = false;
        forwardX11 = false;
      };
      
      xserver = {
        enable = false;
      };

      extraJobs = [
        # Unpack the NixOS/Nixpkgs sources to /etc/nixos.
        # !!! run this synchronously
        { name = "unpack-sources";
          job = "
            start on startup
            script
              export PATH=${pkgs.gnutar}/bin:${pkgs.bzip2}/bin:$PATH

              mkdir -p /mnt

              ${system.nix}/bin/nix-store --load-db < /nix-path-registration

              mkdir -p /etc/nixos/nixos
              tar xjf /install/nixos.tar.bz2 -C /etc/nixos/nixos
              tar xjf /install/nixpkgs.tar.bz2 -C /etc/nixos
              mv /etc/nixos/nixpkgs-* /etc/nixos/nixpkgs
              ln -sfn ../nixpkgs/pkgs /etc/nixos/nixos/pkgs
              chown -R root.root /etc/nixos
            end script
          ";
        }
      
        # Show the NixOS manual on tty7.
        { name = "manual";
          job = "
            env HOME=/root
            start on udev
            stop on shutdown
            respawn ${pkgs.w3m}/bin/w3m ${manual} < /dev/tty7 > /dev/tty7 2>&1
          ";
        }

        # Allow the user to do something useful on tty8 while waiting
        # for the installation to finish.
        { name = "rogue";
          job = "
            env HOME=/root
            chdir /root
            start on udev
            stop on shutdown
            respawn ${pkgs.rogue}/bin/rogue < /dev/tty8 > /dev/tty8 2>&1
          ";
        }
      ];

      # And a background to go with that.
      ttyBackgrounds = {
        specificThemes = [
          { tty = 7;
            # Theme is GPL according to http://kde-look.org/content/show.php/Green?content=58501.
            theme = pkgs.fetchurl {
              url = http://www.kde-look.org/CONTENT/content-files/58501-green.tar.gz;
              sha256 = "0sdykpziij1f3w4braq8r8nqg4lnsd7i7gi1k5d7c31m2q3b9a7r";
            };
          }
          { tty = 8;
            theme = pkgs.fetchurl {
              url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
              md5 = "61969309d23c631e57b0a311102ef034";
            };
          }
        ];
      };

      mingetty = {
        helpLine = ''
        
          Log in as "root" with an empty password.  Press <Alt-F7> for help.
        '';
      };
      
    };

    fonts = {
      enableFontConfig = false;
    };
    
    installer = {
      nixpkgsURL = http://nix.cs.uu.nl/dist/nix/ + nixpkgsRel;
    };

    security = {
      sudo = {
        enable = false;
      };
    };
 
    environment = {
      extraPackages = pkgs: [
        pkgs.vim
        pkgs.subversion # for nixos-checkout
        pkgs.w3m # needed for the manual anyway
        pkgs.gdb # for debugging Nix
        pkgs.testdisk # useful for repairing boot problems
        pkgs.mssys # for writing Microsoft boot sectors / MBRs
      ];
    };
   
  };


  system = import ../system/system.nix {
    inherit configuration platform;
    stage2Init = "/init";
  };


  pkgs = system.pkgs;


  # The NixOS manual, with a backward compatibility hack for Nix <=
  # 0.11 (you won't get the manual).
  manual =
    if builtins ? unsafeDiscardStringContext
    then "${import ../doc/manual}/manual.html"
    else pkgs.writeText "dummy-manual" "Manual not included in this build!";


  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD.  We put them in a tarball because accessing that many small
  # files from a slow device like a CD-ROM takes too long.
  makeTarball = tarName: input: pkgs.runCommand "tarball" {inherit tarName;} "
    ensureDir $out
    (cd ${input} && tar cvfj $out/${tarName} . \\
      --exclude '*~' \\
      --exclude 'pkgs' --exclude 'result')
  ";

  
  # Put the current directory in a tarball (making sure to filter
  # out crap like the .svn directories).
  nixosTarball =
    let filter = name: type:
      let base = baseNameOf (toString name);
      in base != ".svn" && base != "result";
    in
      makeTarball "nixos.tar.bz2" (builtins.filterSource filter ./..);


  # Get a recent copy of Nixpkgs.
  nixpkgsTarball = pkgs.fetchurl {
    url = configuration.installer.nixpkgsURL + "/" + nixpkgsRel + ".tar.bz2";
    md5 = "a6f1cd8486b7d588ecc7d98f5baf6a73";
  };


  # The configuration file for Grub.
  grubCfg = pkgs.writeText "menu.lst" ''
    default 0
    timeout 10
    splashimage /boot/background.xpm.gz
    
    title NixOS Installer / Rescue
      kernel /boot/vmlinuz ${toString system.config.boot.kernelParams}
      initrd /boot/initrd

    title Memtest86+
      kernel /boot/memtest.bin
  '';


  # Create an ISO image containing the Grub boot loader, the kernel,
  # the initrd produced above, and the closure of the stage 2 init.
  rescueCD = import ../helpers/make-iso9660-image.nix {
    inherit (pkgs) stdenv perl cdrkit;
    isoName = "${relName}-${platform}.iso";

    # Single files to be copied to fixed locations on the CD.
    contents = [
      { source = "${pkgs.grub}/lib/grub/i386-pc/stage2_eltorito";
        target = "boot/grub/stage2_eltorito";
      }
      { source = grubCfg;
        target = "boot/grub/menu.lst";
      }
      { source = pkgs.kernel + "/vmlinuz";
        target = "boot/vmlinuz";
      }
      { source = system.initialRamdisk + "/initrd";
        target = "boot/initrd";
      }
      { source = pkgs.memtest86 + "/memtest.bin";
        target = "boot/memtest.bin";
      }
      { source = system.config.boot.grubSplashImage;
        target = "boot/background.xpm.gz";
      }
      { source = nixosTarball + "/" + nixosTarball.tarName;
        target = "/install/" + nixosTarball.tarName;
      }
      { source = nixpkgsTarball;
        target = "/install/nixpkgs.tar.bz2";
      }
      { source = pkgs.writeText "label" "";
        target = "/${configuration.boot.rootLabel}";
      }
    ];

    # Closures to be copied to the Nix store on the CD.
    storeContents = [
      { object = system.bootStage2;
        symlink = "/init";
      }
      { object = system.system;
        symlink = "/system";
      }
      # To speed up the installation, provide the full stdenv.
      { object = pkgs.stdenv;
        symlink = "none";
      }
    ];
    
    bootable = true;
    bootImage = "boot/grub/stage2_eltorito";
  };


}
