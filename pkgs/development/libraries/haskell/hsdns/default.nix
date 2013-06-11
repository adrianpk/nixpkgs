{ cabal, adns, network }:

cabal.mkDerivation (self: {
  pname = "hsdns";
  version = "1.6.1";
  sha256 = "0s63acjy1n75k7gjm4kam7v5d4a5kn0aw178mygkqwr5frflghb4";
  buildDepends = [ network ];
  extraLibraries = [ adns ];
  meta = {
    homepage = "http://github.com/peti/hsdns";
    description = "Asynchronous DNS Resolver";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
