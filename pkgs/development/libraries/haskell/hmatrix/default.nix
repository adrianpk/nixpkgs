{ cabal, binary, blas, deepseq, gsl, liblapack, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.15.2.1";
  sha256 = "0pcs3dsxmaznsb82r71f4kf7xbwvj94cy1fmyya52nv3nldnk1jg";
  buildDepends = [ binary deepseq random storableComplex vector ];
  extraLibraries = [ blas gsl liblapack ];
  meta = {
    homepage = "https://github.com/albertoruiz/hmatrix";
    description = "Linear algebra and numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.guibert
    ];
  };
})
