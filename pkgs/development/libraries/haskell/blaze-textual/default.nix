{ cabal, blazeBuilder, doubleConversion, QuickCheck, testFramework
, testFrameworkQuickcheck2, text, time, vector
}:

cabal.mkDerivation (self: {
  pname = "blaze-textual";
  version = "0.2.0.9";
  sha256 = "1gwy1pjnc2ikxfxn9c751rnydry1hmlfk13k29xnns9vwglf81f0";
  buildDepends = [ blazeBuilder text time vector ];
  testDepends = [
    blazeBuilder doubleConversion QuickCheck testFramework
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/bos/blaze-textual";
    description = "Fast rendering of common datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
