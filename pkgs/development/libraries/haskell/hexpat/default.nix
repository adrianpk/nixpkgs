{ cabal, deepseq, List, text, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "hexpat";
  version = "0.20.6";
  sha256 = "02ms6lchj6k0krqjk47bibfb0cbpbc16ip9f22c4rgp04qkzp60b";
  buildDepends = [ deepseq List text transformers utf8String ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Hexpat/";
    description = "XML parser/formatter based on expat";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
