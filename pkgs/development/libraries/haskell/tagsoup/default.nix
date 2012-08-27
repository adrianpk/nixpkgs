{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "tagsoup";
  version = "0.12.7";
  sha256 = "0f4f0552n9qkycvh01jyk52190nk4frlp9za8vyczayrm3vmw268";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ text ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/tagsoup/";
    description = "Parsing and extracting information from (possibly malformed) HTML/XML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
