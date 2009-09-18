# This module includes the NixOS man-pages in the system environment,
# and optionally starts a browser that shows the NixOS manual on one
# of the virtual consoles.  The latter is useful for the installation
# CD.

{pkgs, config, options, ...}:

let

  inherit (pkgs.lib) mkOption mkIf types;

  cfg = config.services.nixosManual;

  manual = import ../../../doc/manual {
    inherit (cfg) revision;
    inherit pkgs options;
  };
    
in

{

  options = {

    services.nixosManual.enable = mkOption {
      default = true;
      description = ''
        Whether to build the NixOS manual pages.
      '';
    };

    services.nixosManual.showManual = mkOption {
      default = false;
      description = ''
        Whether to show the NixOS manual on one of the virtual
        consoles.
      '';
    };

    services.nixosManual.ttyNumber = mkOption {
      default = "8";
      description = ''
        Virtual console on which to show the manual.
      '';
    };

    services.nixosManual.browser = mkOption {
      default = "${pkgs.w3m}/bin/w3m";
      description = ''
        Browser used to show the manual.
      '';
    };

    services.nixosManual.revision = mkOption {
      default = "local";
      type = types.uniq types.string;
      description = ''
        Revision of the targeted source file.  This value can either be
        <literate>"local"</literate>, <literate>"HEAD"</literate> or any
        revision number embedded in a string.
      '';
    };

  };


  config = mkIf cfg.enable {

    environment.systemPackages = [manual];

    boot.extraTTYs = mkIf cfg.showManual [cfg.ttyNumber];

    services.extraJobs = mkIf cfg.showManual (pkgs.lib.singleton
      { name = "nixos-manual";

        job = ''
          description "NixOS manual"

          start on udev
          stop on shutdown
          respawn ${cfg.browser} ${manual}/share/doc/nixos/manual.html \
            < /dev/tty${toString cfg.ttyNumber} > /dev/tty${toString cfg.ttyNumber} 2>&1
        '';
      });

    services.ttyBackgrounds.specificThemes = mkIf cfg.showManual 
      [ { tty = cfg.ttyNumber;
          theme = pkgs.themes "green";
        }
      ];

    services.mingetty.helpLine = mkIf cfg.showManual
      "\nPress <Alt-F${toString cfg.ttyNumber}> for the NixOS manual.";
      
  };

}
