# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, profunctors }:

cabal.mkDerivation (self: {
  pname = "colors";
  version = "0.2";
  sha256 = "009qkab6m1gnvxc23ayhv5h2v9mpiji5hasiym7a8nm69p8678xa";
  buildDepends = [ profunctors ];
  meta = {
    homepage = "https://github.com/fumieval/colors";
    description = "A type for colors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
