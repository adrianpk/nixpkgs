# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, lazysmallcheck, preludeSafeenum, QuickCheck, reflection
, smallcheck, tagged
}:

cabal.mkDerivation (self: {
  pname = "data-fin";
  version = "0.1.1.3";
  sha256 = "02n3dr4gj73z549vwq5h7h1kvmx2j8vaxjcggpdlppps9wl6flry";
  buildDepends = [
    lazysmallcheck preludeSafeenum QuickCheck reflection smallcheck
    tagged
  ];
  jailbreak = true;
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Finite totally ordered sets";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
