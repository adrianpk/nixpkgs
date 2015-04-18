# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, yi }:

cabal.mkDerivation (self: {
  pname = "yi-monokai";
  version = "0.1.1.2";
  sha256 = "1nghfyiy8jdz144nbw0c2cdy8n6xyjmk31g6z24jk8dij7iwb60l";
  buildDepends = [ yi ];
  meta = {
    homepage = "https://github.com/Fuuzetsu/yi-monokai";
    description = "Monokai colour theme for the Yi text editor";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
