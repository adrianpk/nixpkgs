# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, colour, dataDefaultClass, lens, mtl, operational, time }:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "1.2.4";
  sha256 = "0zizrkxsligvxs5x5r2j0pynf6ncjl4mgyzbh1zfqgnz29frylh7";
  buildDepends = [
    colour dataDefaultClass lens mtl operational time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "A library for generating 2D Charts and Plots";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
