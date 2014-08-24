# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, nats, semigroups, terminfo, text, transformers
, wlPprintExtras
}:

cabal.mkDerivation (self: {
  pname = "wl-pprint-terminfo";
  version = "3.7.1.1";
  sha256 = "1mjnbkk3cw2v7nda7qxdkl21pmclz6m17sviqp4qf3rc8rgin3zd";
  buildDepends = [
    nats semigroups terminfo text transformers wlPprintExtras
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-terminfo/";
    description = "A color pretty printer with terminfo support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
