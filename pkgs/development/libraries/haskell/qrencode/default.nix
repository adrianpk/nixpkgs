{ cabal, qrencode }:

cabal.mkDerivation (self: {
  pname = "haskell-qrencode";
  version = "1.0.4";
  sha256 = "1cq6fpz4vsx1kfnxnxnqz0pi5nzfg86s76vd0hcqvyqxnqbcd8hj";
  extraLibraries = [ qrencode ];
  meta = {
    homepage = "https://github.com/jamessanders/haskell-qrencode";
    description = "Haskell bindings for libqrencode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
