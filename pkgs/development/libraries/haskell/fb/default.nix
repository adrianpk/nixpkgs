# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, base16Bytestring, base64Bytestring
, cereal, conduit, conduitExtra, cryptoApi, cryptohash
, cryptohashCryptoapi, dataDefault, hspec, httpConduit, httpTypes
, HUnit, liftedBase, monadControl, monadLogger, QuickCheck
, resourcet, text, time, transformers, transformersBase
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "fb";
  version = "1.0.7";
  sha256 = "0ghyddxf4aqidqvbm93pjgaban0whfj4y1w11b7nxy89srhyjhh8";
  buildDepends = [
    aeson attoparsec base16Bytestring base64Bytestring cereal conduit
    conduitExtra cryptoApi cryptohash cryptohashCryptoapi dataDefault
    httpConduit httpTypes liftedBase monadControl monadLogger resourcet
    text time transformers transformersBase unorderedContainers
  ];
  testDepends = [
    aeson conduit dataDefault hspec httpConduit HUnit liftedBase
    monadControl QuickCheck resourcet text time transformers
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/prowdsponsor/fb";
    description = "Bindings to Facebook's API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
