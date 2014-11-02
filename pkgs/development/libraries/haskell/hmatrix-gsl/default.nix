# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, gsl, hmatrix, random, vector }:

cabal.mkDerivation (self: {
  pname = "hmatrix-gsl";
  version = "0.16.0.2";
  sha256 = "1l865v2vpjl7f5741z58m9gw1ksskgzfm5gzp9pxiqazsgb2h5ym";
  buildDepends = [ hmatrix random vector ];
  pkgconfigDepends = [ gsl ];
  meta = {
    homepage = "https://github.com/albertoruiz/hmatrix";
    description = "Numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
