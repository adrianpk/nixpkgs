{ pkgs, stdenv, stdenvNoCC, gccStdenv, lib, recurseIntoAttrs }:

# To whomever it may concern:
#
# This directory menaces with spikes of Nix code. It is terrifying.
#
# If this is your first time here, you should probably install the dwarf-fortress-full package,
# for instance with:
#
# environment.systemPackages = [ pkgs.dwarf-fortress-packages.dwarf-fortress-full ];
#
# You can adjust its settings by using override, or compile your own package by
# using the other packages here.
#
# For example, you can enable the FPS indicator, disable the intro, pick a
# theme other than phoebus (the default for dwarf-fortress-full), _and_ use
# an older version with something like:
#
# environment.systemPackages = [
#   (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
#      dfVersion = "0.44.11";
#      theme = "cla";
#      enableIntro = false;
#      enableFPS = true;
#   })
# ]
#
# Take a look at lazy-pack.nix to see all the other options.
#
# You will find the configuration files in ~/.local/share/df_linux/data/init. If
# you un-symlink them and edit, then the scripts will avoid overwriting your
# changes on later launches, but consider extending the wrapper with your
# desired options instead.

with lib;

let
  callPackage = pkgs.newScope self;

  # The latest Dwarf Fortress version. Maintainers: when a new version comes
  # out, ensure that (unfuck|dfhack|twbt) are all up to date before changing
  # this.
  latestVersion = "0.44.12";

  # Converts a version to a package name.
  versionToName = version: "dwarf-fortress_${lib.replaceStrings ["."] ["_"] version}";

  # A map of names to each Dwarf Fortress package we know about.
  df-games = lib.listToAttrs (map (dfVersion: {
    name = versionToName dfVersion;
    value =
      let
        # I can't believe this syntax works. Spikes of Nix code indeed...
        dwarf-fortress = callPackage ./game.nix {
          inherit dfVersion;
          inherit dwarf-fortress-unfuck;
        };

        # unfuck is linux-only right now, we will only use it there.
        dwarf-fortress-unfuck = if stdenv.isLinux then callPackage ./unfuck.nix { inherit dfVersion; }
                                else null;

        twbt = callPackage ./twbt { inherit dfVersion; };

        dfhack = callPackage ./dfhack {
          inherit (pkgs.perlPackages) XMLLibXML XMLLibXSLT;
          inherit dfVersion;
          inherit twbt;
          stdenv = gccStdenv;
        };
      in
      callPackage ./wrapper {
        inherit (self) themes;

        dwarf-fortress = dwarf-fortress;
        dwarf-fortress-unfuck = dwarf-fortress-unfuck;
        twbt = twbt;
        dfhack = dfhack;
      };
  }) (lib.attrNames self.df-hashes));

  self = rec {
    df-hashes = builtins.fromJSON (builtins.readFile ./game.json);
    
    dwarf-fortress = getAttr (versionToName latestVersion) df-games;

    dwarf-fortress-full = callPackage ./lazy-pack.nix {
      inherit versionToName;
      inherit latestVersion;
      inherit df-games;
    };

    soundSense = callPackage ./soundsense.nix { };

    dwarf-therapist = callPackage ./dwarf-therapist/wrapper.nix {
      inherit (dwarf-fortress) dwarf-fortress;
      dwarf-therapist = pkgs.qt5.callPackage ./dwarf-therapist {
        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic float caption wrapfig adjmulticol sidecap preprint enumitem;
        };
      };
    };

    legends-browser = callPackage ./legends-browser {};

    themes = recurseIntoAttrs (callPackage ./themes {
      stdenv = stdenvNoCC;
    });

    # aliases
    phoebus-theme = themes.phoebus;
    cla-theme = themes.cla;
    dwarf-fortress-original = dwarf-fortress.dwarf-fortress;
  };

in self // df-games
