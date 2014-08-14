# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, conduit, conduitExtra, exceptions
, fastLogger, liftedBase, monadControl, monadLoops, mtl, resourcet
, stm, stmChans, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.7.1";
  sha256 = "0imr1bgcpfm19a91r4i6lii7gycx77ysfrdri030zr2jjrvggh9i";
  buildDepends = [
    blazeBuilder conduit conduitExtra exceptions fastLogger liftedBase
    monadControl monadLoops mtl resourcet stm stmChans text
    transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
