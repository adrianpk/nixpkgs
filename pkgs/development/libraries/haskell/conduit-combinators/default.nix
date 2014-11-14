# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, base16Bytestring, base64Bytestring, chunkedData, conduit
, conduitExtra, hspec, monadControl, monoTraversable, mtl
, mwcRandom, primitive, QuickCheck, resourcet, safe, silently
, systemFileio, systemFilepath, text, transformers
, transformersBase, unixCompat, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.3.0.4";
  sha256 = "1aphk79r3ibpb9gykdnz55isp7kf48jhz4h4vgplb0ndbmz8f8zm";
  buildDepends = [
    base16Bytestring base64Bytestring chunkedData conduit conduitExtra
    monadControl monoTraversable mwcRandom primitive resourcet
    systemFileio systemFilepath text transformers transformersBase
    unixCompat vector void
  ];
  testDepends = [
    base16Bytestring base64Bytestring chunkedData conduit hspec
    monoTraversable mtl mwcRandom QuickCheck safe silently
    systemFilepath text transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/conduit-combinators";
    description = "Commonly used conduit functions, for both chunked and unchunked data";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
