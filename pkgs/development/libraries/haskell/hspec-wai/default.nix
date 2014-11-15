# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, caseInsensitive, hspec, hspecCore, hspecExpectations
, httpTypes, text, transformers, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "hspec-wai";
  version = "0.6.0";
  sha256 = "1zynikaa57pb1npmhckfcaad1q9p4xdzll9g3yfka55yc4x59nwr";
  buildDepends = [
    caseInsensitive hspecCore hspecExpectations httpTypes text
    transformers wai waiExtra
  ];
  testDepends = [
    caseInsensitive hspec hspecCore hspecExpectations httpTypes text
    transformers wai waiExtra
  ];
  meta = {
    description = "Experimental Hspec support for testing WAI applications (depends on hspec2!)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
