# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, hspec, pipes, pipesBytestring, pipesSafe, stm
, stmChans, text
}:

cabal.mkDerivation (self: {
  pname = "pipes-shell";
  version = "0.1.2";
  sha256 = "18ikjkppds7k9fgjn39qvdp8avj8vv3csiqcrhgrpfqy1d0hgrlw";
  buildDepends = [
    async pipes pipesBytestring pipesSafe stm stmChans text
  ];
  testDepends = [
    async hspec pipes pipesBytestring pipesSafe stm stmChans text
  ];
  doCheck = false;
  meta = {
    description = "Create proper Pipes from System.Process";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
