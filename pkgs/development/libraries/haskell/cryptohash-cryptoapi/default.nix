{ cabal, cereal, cryptoApi, cryptohash, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash-cryptoapi";
  version = "0.1.3";
  sha256 = "0wj53p32js8lfg0i8akrljpash0jdiyv2vcqpmjbd4dq2fx81w2n";
  buildDepends = [ cereal cryptoApi cryptohash tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash-cryptoapi";
    description = "Crypto-api interfaces for cryptohash";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
