{ cabal, ansiTerminal, deepseq, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, random, setenv, tfRandom, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.9.4";
  sha256 = "0x2r8aqwpjdcykhd9hwxnz9a42x9rbkhjygz9af4wvlmifv1kwfm";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal deepseq filepath hspecExpectations HUnit QuickCheck
    quickcheckIo random setenv tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
