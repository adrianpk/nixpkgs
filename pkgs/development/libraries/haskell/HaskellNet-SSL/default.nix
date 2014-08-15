{ cabal, connection, dataDefault, HaskellNet, network, tls }:

cabal.mkDerivation (self: {
  pname = "HaskellNet-SSL";
  version = "0.2.4";
  sha256 = "0rwj69rz8i84qj6n1zd9fllp4333azfxppd7blzd486bczzkgkbb";
  buildDepends = [ connection dataDefault HaskellNet network tls ];
  meta = {
    homepage = "https://github.com/dpwright/HaskellNet-SSL";
    description = "Helpers to connect to SSL/TLS mail servers with HaskellNet";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
