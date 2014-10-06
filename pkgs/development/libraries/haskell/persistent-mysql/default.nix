# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, blazeBuilder, conduit, monadControl, monadLogger
, mysql, mysqlSimple, persistent, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-mysql";
  version = "2.0.5";
  sha256 = "1zhva0wikp3d57fsz5phqwi0b3vbgnapf6bw46xmmrp8r21zsnk5";
  buildDepends = [
    aeson blazeBuilder conduit monadControl monadLogger mysql
    mysqlSimple persistent resourcet text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using MySQL database server";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
