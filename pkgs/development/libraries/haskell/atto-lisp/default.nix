# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, HUnit
, testFramework, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "atto-lisp";
  version = "0.2.2";
  sha256 = "13lhdalam4gn9faa58c3c7nssdwp2y0jsfl1lnnvr3dx6wzp0jhc";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual deepseq text
  ];
  testDepends = [
    attoparsec HUnit testFramework testFrameworkHunit text
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/nominolo/atto-lisp";
    description = "Efficient parsing and serialisation of S-Expressions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
