# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, lens, singletons }:

cabal.mkDerivation (self: {
  pname = "vinyl";
  version = "0.5";
  sha256 = "0jm31cynhl8ggmi6ndj7lhfm85cqml67svxm4v3kc8mnw5gj3c59";
  testDepends = [ doctest lens singletons ];
  meta = {
    description = "Extensible Records";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
