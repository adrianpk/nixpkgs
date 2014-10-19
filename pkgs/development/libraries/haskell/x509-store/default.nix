# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, asn1Encoding, asn1Types, cryptoPubkeyTypes, filepath, mtl
, pem, x509
}:

cabal.mkDerivation (self: {
  pname = "x509-store";
  version = "1.5.0";
  sha256 = "1w9sqb007s4avjzvrdwq13a4c528h7h2lg3m8cl31syrgznc9ny5";
  buildDepends = [
    asn1Encoding asn1Types cryptoPubkeyTypes filepath mtl pem x509
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "X.509 collection accessing and storing methods";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
