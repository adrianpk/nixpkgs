{ cabal, async, smallcheck, tagged, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-smallcheck";
  version = "0.8";
  sha256 = "0c4ccmhql118j4dlvy5cmrnma454b0rdv1wq2ds6xhpdhx20h1br";
  buildDepends = [ async smallcheck tagged tasty ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty";
    description = "SmallCheck support for the Tasty test framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
