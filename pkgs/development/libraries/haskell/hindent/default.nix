# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, dataDefault, haskellSrcExts, hspec, monadLoops, mtl, text
}:

cabal.mkDerivation (self: {
  pname = "hindent";
  version = "3.9";
  sha256 = "0x8qm39rmaw1s0fbljr9zp6vnqxfcs1w6a3ylrknwqgwbzzr5hbn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ dataDefault haskellSrcExts monadLoops mtl text ];
  testDepends = [
    dataDefault haskellSrcExts hspec monadLoops mtl text
  ];
  meta = {
    description = "Extensible Haskell pretty printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
