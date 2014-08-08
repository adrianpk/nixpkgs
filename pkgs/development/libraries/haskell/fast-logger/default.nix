# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, autoUpdate, blazeBuilder, filepath, hspec, text }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "2.2.0";
  sha256 = "02gc5f7vgwfdlhfawki4xxrl33lbdl05wh64qm3mb3h2dv1gnwrr";
  buildDepends = [ autoUpdate blazeBuilder filepath text ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
