{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.11.3.1";
  sha256 = "0mmyab3a9mgmfxj1kc7xgxkmmcdj90ph9nzniv7bf2vyf8vhvirl";
  buildDepends = [ deepseq scientific text ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2 text
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
