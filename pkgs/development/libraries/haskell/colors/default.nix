# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, profunctors }:

cabal.mkDerivation (self: {
  pname = "colors";
  version = "0.2.0.1";
  sha256 = "0xl7hdp1di8gl0g28vz2lm6pbj7hihdkfnr18843016736hll4qn";
  buildDepends = [ profunctors ];
  meta = {
    homepage = "https://github.com/fumieval/colors";
    description = "A type for colors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
