{ cabal, aeson, aesonPretty, attoparsec, base64Bytestring, binary
, cairo, cereal, configurator, coroutineObject, dbus, Diff, dyre
, either, errors, filepath, fsnotify, gd, gtk, hoodleBuilder
, hoodleParser, hoodleRender, hoodleTypes, lens, libX11, libXi
, monadLoops, mtl, network, networkInfo, networkSimple, pango
, poppler, pureMD5, stm, strict, svgcairo, systemFilepath, text
, time, transformers, transformersFree, unorderedContainers, uuid
, vector, xournalParser
}:

cabal.mkDerivation (self: {
  pname = "hoodle-core";
  version = "0.14";
  sha256 = "1njkjxcbnwh9b7mg0xcqkc0clfz64n5h9jqf3323npyw8bhw34b8";
  buildDepends = [
    aeson aesonPretty attoparsec base64Bytestring binary cairo cereal
    configurator coroutineObject dbus Diff dyre either errors filepath
    fsnotify gd gtk hoodleBuilder hoodleParser hoodleRender hoodleTypes
    lens monadLoops mtl network networkInfo networkSimple pango poppler
    pureMD5 stm strict svgcairo systemFilepath text time transformers
    transformersFree unorderedContainers uuid vector xournalParser
  ];
  extraLibraries = [ libX11 libXi ];
  noHaddock = true;
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Core library for hoodle";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
