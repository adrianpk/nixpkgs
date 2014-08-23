# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, monoidExtras, newtype, semigroups }:

cabal.mkDerivation (self: {
  pname = "dual-tree";
  version = "0.2.0.4";
  sha256 = "0visavx0zqgmcjcq07vfhk6dn867269w2gxa8nvc79gya56c6wdp";
  buildDepends = [ monoidExtras newtype semigroups ];
  jailbreak = true;
  meta = {
    description = "Rose trees with cached and accumulating monoidal annotations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
