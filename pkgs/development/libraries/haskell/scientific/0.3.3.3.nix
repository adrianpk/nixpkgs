# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, hashable, QuickCheck, smallcheck, tasty
, tastyAntXml, tastyHunit, tastyQuickcheck, tastySmallcheck, text
}:

cabal.mkDerivation (self: {
  pname = "scientific";
  version = "0.3.3.3";
  sha256 = "1hngkmd1kggc84sz4mddc0yj2vyzc87dz5dkkywjgxczys51mhqn";
  buildDepends = [ deepseq hashable text ];
  testDepends = [
    QuickCheck smallcheck tasty tastyAntXml tastyHunit tastyQuickcheck
    tastySmallcheck text
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/basvandijk/scientific";
    description = "Numbers represented using scientific notation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
