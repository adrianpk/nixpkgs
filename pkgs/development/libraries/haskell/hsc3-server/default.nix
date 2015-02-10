# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, bitset, dataDefault, failure, hashtables, hosc, hsc3
, hsc3Process, liftedBase, ListZipper, monadControl, QuickCheck
, random, resourcet, testFramework, testFrameworkQuickcheck2
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "hsc3-server";
  version = "0.9.2";
  sha256 = "1lq4y57d555jb0yi10n4j69h4whwsm5h2k6j4r7f9avds5ahh6s2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    bitset dataDefault failure hashtables hosc hsc3 hsc3Process
    liftedBase ListZipper monadControl random resourcet transformers
    transformersBase
  ];
  testDepends = [
    failure QuickCheck random testFramework testFrameworkQuickcheck2
    transformers
  ];
  meta = {
    homepage = "https://github.com/kaoskorobase/hsc3-server";
    description = "SuperCollider server resource management and synchronization";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
