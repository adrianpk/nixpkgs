# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, hxt, mtl, parsec, split, text }:

cabal.mkDerivation (self: {
  pname = "vcswrapper";
  version = "0.1.0";
  sha256 = "058xbfgxsp3g4x4rwbp57dqgr9mwnmj623js39dbmiqkixsda31a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath hxt mtl parsec split text ];
  meta = {
    homepage = "https://github.com/forste/haskellVCSWrapper";
    description = "Wrapper for source code management systems";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
