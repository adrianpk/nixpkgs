# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, base64Bytestring, cpphs, Diff, filepath
, haskellSrcExts, HUnit, liftedBase, monadControl, mtl, QuickCheck
, random, regexCompat, temporary, text, time, unorderedContainers
, vector, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.12.1.0";
  sha256 = "1symg1y6i47rd1jshj84cwpn5vgmvh6v07jidjg5w5w3syyxqnz4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson base64Bytestring cpphs Diff haskellSrcExts HUnit liftedBase
    monadControl mtl QuickCheck random regexCompat text time vector
    xmlgen
  ];
  testDepends = [
    aeson filepath HUnit mtl random regexCompat temporary text
    unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
