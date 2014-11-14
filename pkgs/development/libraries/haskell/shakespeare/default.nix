# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, blazeHtml, blazeMarkup, exceptions, hspec, HUnit
, parsec, systemFileio, systemFilepath, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "2.0.2";
  sha256 = "18yzihkjxgchb4358pbm45xk9zcmpgbp3rr27mx08nj5n0mdkwyy";
  buildDepends = [
    aeson blazeHtml blazeMarkup exceptions parsec systemFileio
    systemFilepath text time transformers
  ];
  testDepends = [
    aeson blazeHtml blazeMarkup exceptions hspec HUnit parsec
    systemFileio systemFilepath text time transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
