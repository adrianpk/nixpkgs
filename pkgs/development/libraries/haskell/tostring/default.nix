# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, caseInsensitive, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "tostring";
  version = "0.2.1";
  sha256 = "0lvfvjs1q6hndbchij3zn1xi6vb1v53r379jvyc2m92sqqcfnylw";
  buildDepends = [ caseInsensitive text utf8String ];
  meta = {
    description = "The ToString class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
