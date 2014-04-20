{ cabal, bzlib, filepath, HUnit, mtl, network, pureMD5, QuickCheck
, random, regexCompat, time, Unixutils, zlib
}:

cabal.mkDerivation (self: {
  pname = "Extra";
  version = "1.46.1";
  sha256 = "0dgj72s60mhc36x7hpfdcdvxydq5d5aj006gxma9zz3hqzy5nnz9";
  buildDepends = [
    bzlib filepath HUnit mtl network pureMD5 QuickCheck random
    regexCompat time Unixutils zlib
  ];
  meta = {
    homepage = "http://src.seereason.com/haskell-extra";
    description = "A grab bag of modules";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
