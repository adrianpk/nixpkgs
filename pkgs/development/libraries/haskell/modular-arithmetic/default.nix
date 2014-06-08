{ cabal }:

cabal.mkDerivation (self: {
  pname = "modular-arithmetic";
  version = "1.2.0.0";
  sha256 = "1qlvi0xjdvr4730xj303i6gp610mz4xrlrk191yy8hr7afjysm0k";
  meta = {
    description = "A type for integers modulo some constant";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
