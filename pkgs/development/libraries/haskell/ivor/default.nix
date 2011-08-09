{cabal, binary, mtl, parsec} :

cabal.mkDerivation (self : {
  pname = "ivor";
  version = "0.1.14.1";
  sha256 = "0r9ykfkxpwsrhsvv691r361pf79a7y511hxy2mvd6ysz1441mych";
  propagatedBuildInputs = [ binary mtl parsec ];
  meta = {
    homepage = "http://www.dcs.st-and.ac.uk/~eb/Ivor/";
    description = "Theorem proving library based on dependent type theory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
