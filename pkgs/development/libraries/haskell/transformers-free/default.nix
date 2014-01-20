{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-free";
  version = "1.0.1";
  sha256 = "0fbzkr7ifvqng8wqi3332vwvmx36f8z167angyskfdd0a5rik2z0";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/Gabriel439/Haskell-Transformers-Free-Library";
    description = "Free monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
