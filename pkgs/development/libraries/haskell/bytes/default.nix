# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, cereal, doctest, filepath, mtl, text, time
, transformers, transformersCompat, void
}:

cabal.mkDerivation (self: {
  pname = "bytes";
  version = "0.14.1.2";
  sha256 = "1v1nnp1m5i4bfr0fshbps163v6yn6var53p0vcvav6g4w5wffd7d";
  buildDepends = [
    binary cereal mtl text time transformers transformersCompat void
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/analytics/bytes";
    description = "Sharing code for serialization between binary and cereal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
