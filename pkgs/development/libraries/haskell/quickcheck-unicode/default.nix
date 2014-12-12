# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "quickcheck-unicode";
  version = "1.0.0.0";
  sha256 = "0yp7d2hwvipw2sdjf4sm45v3iiijc1yi4qk21kq12fi6x6xxwcxq";
  buildDepends = [ QuickCheck ];
  meta = {
    homepage = "https://github.com/bos/quickcheck-unicode";
    description = "Generator and shrink functions for testing Unicode-related software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
