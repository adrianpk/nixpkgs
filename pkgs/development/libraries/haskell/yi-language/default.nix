# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, alex, binary, dataDefault, derive, filepath, hashable
, hspec, lens, ooPrototypes, pointedlist, QuickCheck, regexBase
, regexTdfa, transformersBase, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "yi-language";
  version = "0.1.0.7";
  sha256 = "1d6r5lvpngrhgyfam8hf675h9ylglhyzv11pabczbh8rz4jk40w1";
  buildDepends = [
    binary dataDefault derive hashable lens ooPrototypes pointedlist
    regexBase regexTdfa transformersBase unorderedContainers
  ];
  testDepends = [
    binary dataDefault derive filepath hashable hspec lens pointedlist
    QuickCheck regexBase regexTdfa transformersBase unorderedContainers
  ];
  buildTools = [ alex ];
  meta = {
    homepage = "https://github.com/yi-editor/yi-language";
    description = "Collection of language-related Yi libraries";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
