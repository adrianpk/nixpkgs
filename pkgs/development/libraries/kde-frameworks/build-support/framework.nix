{ kdeDerivation, lib, fetchurl }:

let
  mirror = "mirror://kde";
  srcs = import ../srcs.nix { inherit fetchurl mirror; };
in

args:

let
  inherit (args) name;
  inherit (srcs."${name}") src version;
in kdeDerivation (args // {
  name = "${name}-${version}";
  inherit src;

  meta = {
    license = with lib.licenses; [
      lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
    ];
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
  } // (args.meta or {});
})
