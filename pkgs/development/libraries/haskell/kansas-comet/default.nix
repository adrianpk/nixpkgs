# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, dataDefault, scotty, stm, text, time, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "kansas-comet";
  version = "0.3.1";
  sha256 = "0xbapi4clmkighxh0jb12zpzgrz9sqyfpwdkvrj6cdq6i6a22qx1";
  buildDepends = [
    aeson dataDefault scotty stm text time transformers
    unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/ku-fpg/kansas-comet/";
    description = "A JavaScript push mechanism based on the comet idiom";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
