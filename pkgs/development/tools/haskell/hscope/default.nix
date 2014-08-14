{ cabal, cereal, cpphs, deepseq, haskellSrcExts, mtl, pureCdb
, uniplate, vector
}:

cabal.mkDerivation (self: {
  pname = "hscope";
  version = "0.4";
  sha256 = "1jb2d61c1as6li54zw33jsyvfap214pqxpkr2m6lkzaizh8396hg";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    cereal cpphs deepseq haskellSrcExts mtl pureCdb uniplate vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bosu/hscope";
    description = "cscope like browser for Haskell code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
