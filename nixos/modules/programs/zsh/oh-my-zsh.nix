{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.oh-my-zsh;
in
  {
    options = {
      programs.zsh.oh-my-zsh = {
        enable = mkOption {
          default = false;
          description = ''
            Enable oh-my-zsh.
          '';
        };

        plugins = mkOption {
          default = [];
          type = types.listOf(types.str);
          description = ''
            List of oh-my-zsh plugins
          '';
        };

        custom = mkOption {
          default = "";
          type = types.str;
          description = ''
            Path to a custom oh-my-zsh package to override config of oh-my-zsh.
          '';
        };

        theme = mkOption {
          default = "";
          type = types.str;
          description = ''
            Name of the theme to be used by oh-my-zsh.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ oh-my-zsh ];

      programs.zsh.interactiveShellInit = with pkgs; with builtins; ''
        # oh-my-zsh configuration generated by NixOS
        export ZSH=${oh-my-zsh}/share/oh-my-zsh

        ${optionalString (length(cfg.plugins) > 0)
          "plugins=(${concatStringsSep " " cfg.plugins})"
        }

        ${optionalString (stringLength(cfg.custom) > 0)
          "ZSH_CUSTOM=\"${cfg.custom}\""
        }

        ${optionalString (stringLength(cfg.theme) > 0)
          "ZSH_THEME=\"${cfg.theme}\""
        }

        source $ZSH/oh-my-zsh.sh
      '';
    };
  }
