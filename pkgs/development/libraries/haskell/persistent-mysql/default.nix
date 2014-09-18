# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, blazeBuilder, conduit, monadControl, monadLogger
, mysql, mysqlSimple, persistent, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-mysql";
  version = "2.0.1";
  sha256 = "02hqklndyzff8swcll5n7ck6iy9ci50kj1s5l1r43kcgh7cqili3";
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
