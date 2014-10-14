# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, base64Bytestring, binary, dataDefault, doctest, mtl
, network, scientific, text, time, unorderedContainers, utf8String
, vector
}:

cabal.mkDerivation (self: {
  pname = "rethinkdb";
  version = "1.15.0.0";
  sha256 = "0zswbz73c8h7h31ppw5251l6spn6y5ha3hm9hb90j04hjg8g235i";
  buildDepends = [
    aeson base64Bytestring binary dataDefault mtl network scientific
    text time unorderedContainers utf8String vector
  ];
  testDepends = [ doctest ];
  meta = {
    homepage = "http://github.com/atnnn/haskell-rethinkdb";
    description = "A driver for the RethinkDB database server";
    license = self.stdenv.lib.licenses.asl20;
    platforms = self.ghc.meta.platforms;
    broken = true;
  };
})
