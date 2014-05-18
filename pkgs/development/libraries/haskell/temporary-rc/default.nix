{ cabal, exceptions, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "temporary-rc";
  version = "1.2.0.3";
  sha256 = "1nqih0qks439k3pr5kmbbc8rjdw730slrxlflqb27fbxbzb8skqs";
  buildDepends = [ exceptions filepath transformers ];
  meta = {
    homepage = "http://www.github.com/feuerbach/temporary";
    description = "Portable temporary file and directory support for Windows and Unix, based on code from Cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
