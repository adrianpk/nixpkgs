# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.6.0.4";
  sha256 = "1b3ymdqwcn84m8kkybshx10bfylby49i0yhbassvlgf0n096lp12";
  buildDepends = [ Diff filepath parsec split time utf8String xml ];
  testDepends = [ Diff filepath HUnit mtl time ];
  jailbreak = true;
  meta = {
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
