{ cabal, mtl, network, text }:

cabal.mkDerivation (self: {
  pname = "hstatsd";
  version = "0.1";
  sha256 = "092q52yyb1xdji1y72bdcgvp8by2w1z9j717sl1gmh2p89cpjrs4";
  buildDepends = [ mtl network text ];
  meta = {
    homepage = "https://github.com/mokus0/hstatsd";
    description = "Quick and dirty statsd interface";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
