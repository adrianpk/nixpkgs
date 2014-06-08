{ cabal }:

cabal.mkDerivation (self: {
  pname = "monoid-transformer";
  version = "0.0.3";
  sha256 = "1f06ppvv50w5pacm4bs89zwkydih626cgbd2z6xqbp8cmhg6dj4l";
  meta = {
    description = "Monoid counterparts to some ubiquitous monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
