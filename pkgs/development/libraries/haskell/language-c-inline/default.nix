# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, languageCQuote, mainlandPretty }:

cabal.mkDerivation (self: {
  pname = "language-c-inline";
  version = "0.7.6.0";
  sha256 = "01imdfjqkx49pcwplvmd5lqbal5hq1cx11zcig3na1x46ggiavah";
  buildDepends = [ filepath languageCQuote mainlandPretty ];
  testDepends = [ languageCQuote ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/mchakravarty/language-c-inline/";
    description = "Inline C & Objective-C code in Haskell for language interoperability";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
