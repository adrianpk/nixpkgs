# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, lensFamilyCore, pipes, pipesBytestring, pipesParse
, smallcheck, tasty, tastyHunit, tastySmallcheck, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-binary";
  version = "0.4.0.3";
  sha256 = "0r56h5f9i6hy4zb2bhfi26y7y3z0j4nacdb2dgkxmh5mqjd33f0q";
  buildDepends = [
    binary pipes pipesBytestring pipesParse transformers
  ];
  testDepends = [
    binary lensFamilyCore pipes pipesParse smallcheck tasty tastyHunit
    tastySmallcheck transformers
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/k0001/pipes-binary";
    description = "Encode and decode binary streams using the pipes and binary libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
