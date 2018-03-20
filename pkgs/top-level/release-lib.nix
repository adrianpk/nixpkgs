{ supportedSystems
, packageSet ? (import ../..)
, scrubJobs ? true
, # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? { config = { allowUnfree = false; inHydra = true; }; }
}:

let
  lib = import ../../lib;
in with lib;

rec {

  allPackages = args: packageSet (args // nixpkgsArgs);

  pkgs = packageSet (lib.recursiveUpdate { system = "x86_64-linux"; config.allowUnsupportedSystem = true; } nixpkgsArgs);
  inherit lib;


  hydraJob' = if scrubJobs then hydraJob else id;


  /* !!! Hack: poor man's memoisation function.  Necessary to prevent
     Nixpkgs from being evaluated again and again for every
     job/platform pair. */
  pkgsFor = system:
    if system == "x86_64-linux" then pkgs_x86_64_linux
    else if system == "i686-linux" then pkgs_i686_linux
    else if system == "aarch64-linux" then pkgs_aarch64_linux
    else if system == "armv6l-linux" then pkgs_armv6l_linux
    else if system == "armv7l-linux" then pkgs_armv7l_linux
    else if system == "x86_64-darwin" then pkgs_x86_64_darwin
    else if system == "x86_64-freebsd" then pkgs_x86_64_freebsd
    else if system == "i686-freebsd" then pkgs_i686_freebsd
    else if system == "i686-cygwin" then pkgs_i686_cygwin
    else if system == "x86_64-cygwin" then pkgs_x86_64_cygwin
    else abort "unsupported system type: ${system}";

  pkgs_x86_64_linux = allPackages { system = "x86_64-linux"; };
  pkgs_i686_linux = allPackages { system = "i686-linux"; };
  pkgs_aarch64_linux = allPackages { system = "aarch64-linux"; };
  pkgs_armv6l_linux = allPackages { system = "armv6l-linux"; };
  pkgs_armv7l_linux = allPackages { system = "armv7l-linux"; };
  pkgs_x86_64_darwin = allPackages { system = "x86_64-darwin"; };
  pkgs_x86_64_freebsd = allPackages { system = "x86_64-freebsd"; };
  pkgs_i686_freebsd = allPackages { system = "i686-freebsd"; };
  pkgs_i686_cygwin = allPackages { system = "i686-cygwin"; };
  pkgs_x86_64_cygwin = allPackages { system = "x86_64-cygwin"; };


  # Given a list of 'meta.platforms'-style patterns, return the sublist of
  # `supportedSystems` containing systems that matches at least one of the given
  # patterns.
  #
  # This is written in a funny way so that we only elaborate the systems once.
  supportedMatches = let
      supportedPlatforms = map
        (system: lib.systems.elaborate { inherit system; })
        supportedSystems;
    in metaPatterns: let
      anyMatch = platform:
        lib.any (lib.meta.platformMatch platform) metaPatterns;
      matchingPlatforms = lib.filter anyMatch supportedPlatforms;
    in map ({ system, ...}: system) matchingPlatforms;


  assertTrue = bool:
    if bool
    then pkgs.runCommand "evaluated-to-true" {} "touch $out"
    else pkgs.runCommand "evaluated-to-false" {} "false";


  /* The working or failing mails for cross builds will be sent only to
     the following maintainers, as most package maintainers will not be
     interested in the result of cross building a package. */
  crossMaintainers = [ maintainers.viric ];


  # Generate attributes for all supported systems.
  forAllSystems = genAttrs supportedSystems;


  # Generate attributes for all sytems matching at least one of the given
  # patterns
  forMatchingSystems = metaPatterns: genAttrs (supportedMatches metaPatterns);


  /* Build a package on the given set of platforms.  The function `f'
     is called for each supported platform with Nixpkgs for that
     platform as an argument .  We return an attribute set containing
     a derivation for each supported platform, i.e. ‘{ x86_64-linux =
     f pkgs_x86_64_linux; i686-linux = f pkgs_i686_linux; ... }’. */
  testOn = metaPatterns: f: forMatchingSystems metaPatterns
    (system: hydraJob' (f (pkgsFor system)));


  /* Similar to the testOn function, but with an additional
     'crossSystem' parameter for allPackages, defining the target
     platform for cross builds. */
  testOnCross = crossSystem: metaPatterns: f: forMatchingSystems metaPatterns
    (system: hydraJob' (f (allPackages { inherit system crossSystem; })));


  /* Given a nested set where the leaf nodes are lists of platforms,
     map each leaf node to `testOn [platforms...] (pkgs:
     pkgs.<attrPath>)'. */
  mapTestOn = mapAttrsRecursive
    (path: metaPatterns: testOn metaPatterns (pkgs: getAttrFromPath path pkgs));


  /* Similar to the testOn function, but with an additional 'crossSystem'
   * parameter for allPackages, defining the target platform for cross builds,
   * and triggering the build of the host derivation (cross built - crossDrv). */
  mapTestOnCross = crossSystem: mapAttrsRecursive
    (path: metaPatterns: testOnCross crossSystem metaPatterns
      (pkgs: addMetaAttrs { maintainers = crossMaintainers; } (getAttrFromPath path pkgs)));


  /* Recursively map a (nested) set of derivations to an isomorphic
     set of meta.platforms values. */
  packagePlatforms = mapAttrs (name: value:
    let res = builtins.tryEval (
      if isDerivation value then
        value.meta.hydraPlatforms
          or supportedMatches (value.meta.platforms or [ "x86_64-linux" ])
      else if value.recurseForDerivations or false || value.recurseForRelease or false then
        packagePlatforms value
      else
        []);
    in if res.success then res.value else []
    );


  /* Common platform groups on which to test packages. */
  inherit (platforms) unix linux darwin cygwin all mesaPlatforms;

  /* Platform groups for specific kinds of applications. */
  x11Supported = linux;
  gtkSupported = linux;
  ghcSupported = linux;

}
