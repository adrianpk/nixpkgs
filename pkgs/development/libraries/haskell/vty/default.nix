# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, Cabal, dataDefault, deepseq, filepath
, hashable, HUnit, lens, mtl, parallel, parsec, QuickCheck
, quickcheckAssertions, random, smallcheck, stringQq, terminfo
, testFramework, testFrameworkHunit, testFrameworkSmallcheck, text
, transformers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "5.2.5";
  sha256 = "15c49nzmkld4vcdmjbh0azlzsqrqmfb0z87zfixqxcl0bafpzrjy";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder dataDefault deepseq filepath hashable lens mtl
    parallel parsec terminfo text transformers utf8String vector
  ];
  testDepends = [
    blazeBuilder Cabal dataDefault deepseq HUnit lens mtl QuickCheck
    quickcheckAssertions random smallcheck stringQq terminfo
    testFramework testFrameworkHunit testFrameworkSmallcheck text
    utf8String vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal UI library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
