# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, attoparsecConduit, conduit, conduitExtra
, exceptions, lens, mtl, strict, text, transformers, xmlConduit
, xmlTypes, xournalTypes, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "xournal-parser";
  version = "0.5.0.3";
  sha256 = "1r99xv7w2gxms1ff5qpj36dcb3gb5lpccr1mjjdnkcij81i748ly";
  buildDepends = [
    attoparsec attoparsecConduit conduit conduitExtra exceptions lens
    mtl strict text transformers xmlConduit xmlTypes xournalTypes
    zlibConduit
  ];
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Xournal file parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ianwookim ];
  };
})
