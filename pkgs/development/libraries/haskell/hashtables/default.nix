# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, hashable, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "hashtables";
  version = "1.2.0.0";
  sha256 = "0q2zzrsx899wkhjvyqiwj0jkjr81dl3ghlrvgk0vzkkz9g901k0x";
  buildDepends = [ hashable primitive vector ];
  meta = {
    homepage = "http://github.com/gregorycollins/hashtables";
    description = "Mutable hash tables in the ST monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
