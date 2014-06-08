{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, prettyShow
, regexpr, regexTdfa, safe, split, testFramework
, testFrameworkHunit, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.23.2";
  sha256 = "1z9gxbah649r9vzq012mqnk07rfnd6c4ik82klksk0zzd4yxf07d";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexpr regexTdfa
    safe split time transformers utf8String
  ];
  testDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexpr regexTdfa
    safe split testFramework testFrameworkHunit time transformers
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Core data types, parsers and utilities for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
