# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cmdargs, cpphs, filepath, haskellSrcExts, hscolour
, transformers, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.9.3";
  sha256 = "1sdz981yq0amsw9q6hx0aqkd0ayrax5p77s3n3gz4bphpk37n09b";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs cpphs filepath haskellSrcExts hscolour transformers
    uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
