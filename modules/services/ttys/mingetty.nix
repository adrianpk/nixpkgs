{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.mingetty = {

      ttys = mkOption {
        default =
          if pkgs.stdenv.isArm
          then [ "ttyS0" ] # presumably an embedded platform such as a plug
          else [ "tty1" "tty2" "tty3" "tty4" "tty5" "tty6" ];
        description = ''
          The list of tty devices on which to start a login prompt.
        '';
      };

      waitOnMounts = mkOption {
        default = false;
        description = ''
          Whether the login prompts on the virtual consoles will be
          started before or after all file systems have been mounted.  By
          default we don't wait, but if for example your /home is on a
          separate partition, you may want to turn this on.
        '';
      };

      greetingLine = mkOption {
        default = ''<<< Welcome to NixOS (\m) - \s \r (\l) >>>'';
        description = ''
          Welcome line printed by mingetty.
        '';
      };

      helpLine = mkOption {
        default = "";
        description = ''
          Help line printed by mingetty below the welcome line.
          Used by the installation CD to give some hints on
          how to proceed.
        '';
      };

    };

  };


  ###### implementation

  config = {

    # Generate a separate job for each tty.
    jobs = listToAttrs (map (tty: nameValuePair tty {

      startOn = "started udev and filesystem";

      exec = "${pkgs.mingetty}/sbin/mingetty --loginprog=${pkgs.shadow}/bin/login --noclear ${tty}";

      environment = {
        LOCALE_ARCHIVE = "/var/run/current-system/sw/lib/locale/locale-archive";
      };

    }) config.services.mingetty.ttys);

    environment.etc = singleton
      { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''

          [1;32m${config.services.mingetty.greetingLine}[0m
          ${config.services.mingetty.helpLine}

        '';
        target = "issue";
      };
  };

}
