{ cabal, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "tostring";
  version = "0.2.0.1";
  sha256 = "1gihls2xslr9fzad2659zv8af9k4cm84888nhx3z9bwasviyg448";
  buildDepends = [ text utf8String ];
  meta = {
    description = "The ToString class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
