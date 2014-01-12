{ cabal, cereal, entropy, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.13";
  sha256 = "00zw9cymjhsdiy2p4prjvmmy7xnk12qggdpvxrp0hjnwlakfvyb2";
  buildDepends = [ cereal entropy tagged transformers ];
  meta = {
    homepage = "https://github.com/TomMD/crypto-api";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
