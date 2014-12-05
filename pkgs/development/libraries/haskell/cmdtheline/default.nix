# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, HUnit, parsec, testFramework, testFrameworkHunit
, transformers, fetchpatch
}:

cabal.mkDerivation (self: {
  pname = "cmdtheline";
  version = "0.2.3";
  sha256 = "1jwbr34xgccjbz6nm58bdsg1vqyv87rh45yia5j36vlfbaclyb04";
  doCheck = false;
  patches = [ (fetchpatch { url = "https://github.com/eli-frey/cmdtheline/pull/29.patch"; sha256 = "089rfvvjc44wnhph2ricpbz4iifhyvm1qzg8wsd596v81gy0zvrr"; }) ];
  buildDepends = [ filepath parsec transformers ];
  testDepends = [
    filepath HUnit parsec testFramework testFrameworkHunit transformers
  ];
  meta = {
    homepage = "http://github.com/eli-frey/cmdtheline";
    description = "Declarative command-line option parsing and documentation library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
