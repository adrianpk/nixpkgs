{ gcc, cabal, binary, deepseq, extra, filepath, hashable, jsFlot
, jsJquery, QuickCheck, random, time, transformers
, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.14.2";
  sha256 = "0wb4rvnkw6gag1jffv9z2by7y8gifp58pnw3n7dyc01yglbys72m";
  isLibrary = true;
  isExecutable = true;
  buildTools = [ gcc ];
  buildDepends = [
    binary deepseq extra filepath hashable jsFlot jsJquery random time
    transformers unorderedContainers utf8String
  ];
  testDepends = [
    binary deepseq extra filepath hashable jsFlot jsJquery QuickCheck
    random time transformers unorderedContainers utf8String
  ];
  meta = {
    homepage = "http://www.shakebuild.com/";
    description = "Build system library, like Make, but more accurate dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
