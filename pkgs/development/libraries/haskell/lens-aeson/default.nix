# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, doctest, filepath, genericDeriving
, lens, scientific, semigroups, simpleReflect, text
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "lens-aeson";
  version = "1.0.0.3";
  sha256 = "0wfbnazarwcza5dn3icsdvsmkyf9ki5lr5d5yidmgijhs63ak7ac";
  buildDepends = [
    aeson attoparsec lens scientific text unorderedContainers vector
  ];
  testDepends = [
    doctest filepath genericDeriving semigroups simpleReflect
  ];
  meta = {
    homepage = "http://github.com/lens/lens-aeson/";
    description = "Law-abiding lenses for aeson";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
