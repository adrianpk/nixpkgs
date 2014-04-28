{ cabal, semigroupoids, semigroups, tagged }:

cabal.mkDerivation (self: {
  pname = "bifunctors";
  version = "4.1.1.1";
  sha256 = "0b31q6ypndaj6fa9cnkld5k0x3lncp9i28vfkkh6vv4jnnjd6pqi";
  buildDepends = [ semigroupoids semigroups tagged ];
  meta = {
    homepage = "http://github.com/ekmett/bifunctors/";
    description = "Bifunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
