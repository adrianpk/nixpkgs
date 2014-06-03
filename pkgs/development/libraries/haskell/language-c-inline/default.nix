{ cabal, filepath, languageCQuote, mainlandPretty }:

cabal.mkDerivation (self: {
  pname = "language-c-inline";
  version = "0.6.0.0";
  sha256 = "08a22sr01kch365p5536fv32rxsfmdd6hkhcq1j7vhchjrsy3f6w";
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
