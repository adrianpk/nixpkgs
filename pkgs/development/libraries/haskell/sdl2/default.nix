# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, SDL2 }:

cabal.mkDerivation (self: {
  pname = "sdl2";
  version = "1.1.2";
  sha256 = "1viy6f8iqbw264hmsvfqjf8b27h8klyybywd5976yin6ianbqm2a";
  extraLibraries = [ SDL2 ];
  pkgconfigDepends = [ SDL2 ];
  meta = {
    description = "Low-level bindings to SDL2";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
