{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  xEnv = config.systemd.services."display-manager".environment;
  cfg = dmcfg.lightdm;

  inherit (pkgs) stdenv lightdm writeScript writeText;

  # lightdm runs with clearenv(), but we need a few things in the enviornment for X to startup
  xserverWrapper = writeScript "xserver-wrapper"
    ''
      #! /bin/sh
      ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
      exec ${dmcfg.xserverBin} ${dmcfg.xserverArgs}
    '';

  # The default greeter provided with this expression is the GTK greeter.
  # Again, we need a few things in the environment for the greeter to run with
  # fonts/icons.
  wrappedGtkGreeter = stdenv.mkDerivation {
    name = "lightdm-gtk-greeter";
    buildInputs = [ pkgs.makeWrapper ];

    buildCommand = ''
      # This wrapper ensures that we actually get themes
      makeWrapper ${pkgs.lightdm_gtk_greeter}/sbin/lightdm-gtk-greeter \
        $out/greeter \
        --prefix PATH : "${pkgs.glibc}/bin" \
        --set GTK_DATA_PREFIX "${pkgs.gnome3.gnome_themes_standard}" \
        --set GTK_EXE_PREFIX "${pkgs.gnome3.gnome_themes_standard}" \
        --set GTK_PATH "${pkgs.gnome3.gnome_themes_standard}" \
        --set XDG_DATA_DIRS "${pkgs.gnome3.gnome_themes_standard}/share:${pkgs.gnome3.gnome_icon_theme}/share" \
        --set XDG_CONFIG_HOME ${pkgs.gnome3.gnome_themes_standard}/share

      cat - > $out/lightdm-gtk-greeter.desktop << EOF
      [Desktop Entry]
      Name=LightDM Greeter
      Comment=This runs the LightDM Greeter
      Exec=$out/greeter
      Type=Application
      EOF
    '';
  };

  hiddenUsers = config.services.xserver.displayManager.hiddenUsers;

  usersConf = writeText "users.conf"
    ''
      [UserList]
      minimum-uid=500
      hidden-users=${concatStringsSep " " hiddenUsers}
      hidden-shells=/run/current-system/sw/sbin/nologin
    '';

  lightdmConf = writeText "lightdm.conf"
    ''
      [LightDM]
      greeter-user = ${config.users.extraUsers.lightdm.name}
      greeters-directory = ${cfg.greeter.package}
      sessions-directory = ${dmcfg.session.desktops}

      [SeatDefaults]
      xserver-command = ${xserverWrapper}
      session-wrapper = ${dmcfg.session.script}
      greeter-session = ${cfg.greeter.name}
    '';

  gtkGreeterConf = writeText "lightdm-gtk-greeter.conf"
    ''
    [greeter]
    theme-name = Adwaita
    icon-theme-name = Adwaita
    '';

in
{
  options = {
    services.xserver.displayManager.lightdm = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable lightdm as the display manager.
        '';
      };

      greeter = mkOption {
        description = ''
          The LightDM greeter to login via. The package should be a directory
          containing a .desktop file matching the name in the 'name' option.
        '';
        default = {
          name = "lightdm-gtk-greeter";
          package = wrappedGtkGreeter;
        };
      };

    };
  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.slim.enable = false;

    services.xserver.displayManager.job = {
      logsXsession = true;

      # lightdm relaunches itself via just `lightdm`, so needs to be on the PATH
      execCmd = ''
        export PATH=${lightdm}/sbin:$PATH
        exec ${lightdm}/sbin/lightdm --log-dir=/var/log --run-dir=/run
      '';
    };

    environment.etc."lightdm/lightdm-gtk-greeter.conf".source = gtkGreeterConf;
    environment.etc."lightdm/lightdm.conf".source = lightdmConf;
    environment.etc."lightdm/users.conf".source = usersConf;

    services.dbus.enable = true;
    services.dbus.packages = [ lightdm ];

    security.pam.services.lightdm = { allowNullPassword = true; startSession = true; };
    security.pam.services.lightdm-greeter = { allowNullPassword = true; startSession = true; };

    users.extraUsers.lightdm = {
      createHome = true;
      home = "/var/lib/lightdm";
      group = "lightdm";
      uid = config.ids.uids.lightdm;
    };

    users.extraGroups.lightdm.gid = config.ids.gids.lightdm;
  };
}
