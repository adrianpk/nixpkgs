{ cabal, deepseq, hashable, HUnit, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "1.1.0.3";
  sha256 = "0fr69lfb976gflr8w6d68zn4pz86jfxbb2i49fw3mmam67k5y9bv";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
