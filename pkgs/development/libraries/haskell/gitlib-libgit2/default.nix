{ cabal, conduit, conduitCombinators, exceptions, fastLogger
, filepath, gitlib, gitlibTest, hlibgit2, hspec, hspecExpectations
, HUnit, liftedAsync, liftedBase, missingForeign, mmorph
, monadControl, monadLogger, monadLoops, mtl, resourcet, stm
, stmConduit, tagged, text, textIcu, time, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "gitlib-libgit2";
  version = "3.1.0";
  sha256 = "1kjwc36fd14j2ipw53j8hdsy29gxir1qrm54wxgpp5n4q2kcs9pq";
  buildDepends = [
    conduit conduitCombinators exceptions fastLogger filepath gitlib
    hlibgit2 liftedAsync liftedBase missingForeign mmorph monadControl
    monadLogger monadLoops mtl resourcet stm stmConduit tagged text
    textIcu time transformers transformersBase
  ];
  testDepends = [
    exceptions gitlib gitlibTest hspec hspecExpectations HUnit
    monadLogger transformers
  ];
  meta = {
    description = "Libgit2 backend for gitlib";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
