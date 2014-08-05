{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "generics-sop";
  version = "0.1.0.2";
  sha256 = "01s3v3a29wdsps9vas8in2ks5p4d2arqp3qvmzqa7v2sz786xjra";
  buildDepends = [ tagged ];
  meta = {
    description = "Generic Programming using True Sums of Products";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
