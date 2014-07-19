# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, hspec, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.7";
  sha256 = "16wqrpzi5njv26za1rckn74jsqmyswndb6k38yz1567h1y4w7ai5";
  buildDepends = [ mtl parsec ];
  testDepends = [ doctest hspec parsec ];
  meta = {
    homepage = "http://github.com/peti/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
