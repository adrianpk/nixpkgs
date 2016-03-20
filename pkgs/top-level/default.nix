/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */


{ # The system (e.g., `i686-linux') for which to build the packages.
  system ? builtins.currentSystem

, # The standard environment to use.  Only used for bootstrapping.  If
  # null, the default standard environment is used.
  bootStdenv ? null

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for
  # files in standard system directories (/usr/include, etc.)
  noSysDirs ? (system != "x86_64-freebsd" && system != "i686-freebsd"
               && system != "x86_64-solaris"
               && system != "x86_64-kfreebsd-gnu")

  # More flags for the bootstrapping of stdenv.
, gccWithCC ? true
, gccWithProfiling ? true

, # Allow a configuration attribute set to be passed in as an
  # argument.  Otherwise, it's read from $NIXPKGS_CONFIG or
  # ~/.nixpkgs/config.nix.
  config ? null

, crossSystem ? null
, platform ? null
}:


let config_ = config; platform_ = platform; in # rename the function arguments

let

  lib = import ../../lib;

  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  # for NIXOS (nixos-rebuild): use nixpkgs.config option
  config =
    let
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      configExpr =
        if config_ != null then config_
        else if configFile != "" && pathExists configFile then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2 then import (toPath configFile2)
        else {};

    in
      # allow both:
      # { /* the config */ } and
      # { pkgs, ... } : { /* the config */ }
      if builtins.isFunction configExpr
        then configExpr { inherit pkgs; }
        else configExpr;

  # Allow setting the platform in the config file. Otherwise, let's use a reasonable default (pc)

  platformAuto = let
      platforms = (import ./platforms.nix);
    in
      if system == "armv6l-linux" then platforms.raspberrypi
      else if system == "armv7l-linux" then platforms.armv7l-hf-multiplatform
      else if system == "armv5tel-linux" then platforms.sheevaplug
      else if system == "mips64el-linux" then platforms.fuloong2f_n32
      else if system == "x86_64-linux" then platforms.pc64
      else if system == "i686-linux" then platforms.pc32
      else platforms.pcBase;

  platform = if platform_ != null then platform_
    else config.platform or platformAuto;

  topLevelArguments = {
    inherit system bootStdenv noSysDirs gccWithCC gccWithProfiling config
      crossSystem platform lib;
  };

  # Allow packages to be overriden globally via the `packageOverrides'
  # configuration option, which must be a function that takes `pkgs'
  # as an argument and returns a set of new or overriden packages.
  # The `packageOverrides' function is called with the *original*
  # (un-overriden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  pkgs = pkgsWithOverrides (self: config.packageOverrides or (super: {}));

  # stdenvOverrides is used to avoid circular dependencies for building the
  # standard build environment. This mechanism use the override mechanism to
  # implement some staged compilation of the stdenv.
  #
  # We don't want stdenv overrides in the case of cross-building, or
  # otherwise the basic overrided packages will not be built with the
  # crossStdenv adapter.
  stdenvOverrides = self: pkgs:
    lib.optionalAttrs (crossSystem == null && pkgs.stdenv ? overrides)
      (pkgs.stdenv.overrides pkgs);

  # Return the complete set of packages, after applying the overrides
  # returned by the `overrider' function (see above).  Warning: this
  # function is very expensive!
  pkgsWithOverrides = overrider:
    let
      stdenvAdapters = self: super:
        let res = import ../stdenv/adapters.nix self; in res // {
          stdenvAdapters = res;
        };

      trivialBuilders = self: super:
        (import ../build-support/trivial-builders.nix {
          inherit lib; inherit (self) stdenv; inherit (self.xorg) lndir;
        });

      stdenvDefault = self: super: (import ./stdenv.nix topLevelArguments) {} pkgs;

      allPackagesArgs = topLevelArguments // { inherit pkgsWithOverrides; };
      allPackages = self: super:
        let res = import ./all-packages.nix allPackagesArgs res self;
        in res;

      aliases = self: super: import ./aliases.nix super;

      customOverrides = self: super:
        lib.optionalAttrs (bootStdenv == null) (overrider self super);
    in
      lib.fix' (
        lib.extends customOverrides (
          lib.extends stdenvOverrides (
            lib.extends aliases (
              lib.extends allPackages (
                lib.extends stdenvDefault (
                  lib.extends trivialBuilders (
                    lib.extends stdenvAdapters (
                      self: {}))))))));
in
  pkgs
