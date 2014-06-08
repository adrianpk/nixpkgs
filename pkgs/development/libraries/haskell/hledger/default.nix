{ cabal, cmdargs, csv, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, prettyShow, regexpr, safe, shakespeare, shakespeareText
, split, tabular, testFramework, testFrameworkHunit, text, time
, transformers, utf8String, wizards
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.23.2";
  sha256 = "1q57mb37qkngdvivaj4dykrkg4sb2pchg2ssdxx8ss4zhbsrk713";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs filepath haskeline hledgerLib HUnit mtl parsec prettyShow
    regexpr safe shakespeare shakespeareText split tabular text time
    utf8String wizards
  ];
  testDepends = [
    cmdargs csv filepath haskeline hledgerLib HUnit mtl parsec
    prettyShow regexpr safe shakespeare shakespeareText split tabular
    testFramework testFrameworkHunit text time transformers wizards
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
