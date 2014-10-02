# This file was auto-generated by cabal2nix. Please do NOT edit manually!
# This file was later edited manually in order to add happy and cpphs
# build tools, configurePhase and meta.

{ cabal, bash, happy, cpphs }:

cabal.mkDerivation (self: {
  pname = "ghc-parser";
  version = "0.1.3.0";
  sha256 = "13p09mj92jh4y0v2r672d49fmlz3l5r2r1lqg0jjy6kj045wcfdn";
  buildTools = [ happy cpphs ];
  configurePhase = ''
    ghc --make Setup.hs
    substituteInPlace build-parser.sh --replace "/bin/bash" "${bash}/bin/bash"
    ./Setup configure --verbose --prefix="$out"
  '';
  meta = with self.stdenv.lib; {
    homepage = "https://github.com/gibiansky/IHaskell";
    description = "Haskell source parser from GHC";
    license = licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = with maintainers; [ edwtjo ];
  };
})
