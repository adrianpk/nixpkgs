# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, SDL2 }:

cabal.mkDerivation (self: {
  pname = "sdl2";
  version = "1.2.0";
  sha256 = "19q7x74b9ismxmlsblqvfy4w91bspl9n1fjccz8w1qylyilr6ca2";
  extraLibraries = [ SDL2 ];
  pkgconfigDepends = [ SDL2 ];
  meta = {
    description = "Low-level bindings to SDL2";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
