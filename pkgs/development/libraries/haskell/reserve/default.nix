# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, baseCompat, hspec, httpConduit, httpKit, httpTypes
, network, QuickCheck, warp
}:

cabal.mkDerivation (self: {
  pname = "reserve";
  version = "0.1.0";
  sha256 = "09b570l6hyn0wfd4nb9xpqrpdb97gbaxnbjlz25y6s0pfg5s1yzp";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ baseCompat httpKit httpTypes network ];
  testDepends = [
    baseCompat hspec httpConduit httpKit httpTypes network QuickCheck
    warp
  ];
  meta = {
    description = "Reserve reloads web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
