# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "enummapset";
  version = "0.5.2.0";
  sha256 = "065gxljrjw59rdf7abq0v0c29wg1ymg984ckixnjrcs1yks0c2js";
  buildDepends = [ deepseq ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/michalt/enummapset";
    description = "IntMap and IntSet with Enum keys/elements";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
