{ cabal, doctest, filepath, lens, profunctors, semigroupoids }:

cabal.mkDerivation (self: {
  pname = "zippers";
  version = "0.2";
  sha256 = "1rlf01dc6dcy9sx89npsisdz1yg9v4h2byd6ms602bxnmjllm1ls";
  buildDepends = [ lens profunctors semigroupoids ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/zippers/";
    description = "Traversal based zippers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
