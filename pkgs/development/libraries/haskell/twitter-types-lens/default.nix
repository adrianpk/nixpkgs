# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, lens, text, twitterTypes }:

cabal.mkDerivation (self: {
  pname = "twitter-types-lens";
  version = "0.6.0";
  sha256 = "0n2z7v2mcvj2czkszkp87sf7cv4zj82yccygs9ah5ax28dw823v3";
  buildDepends = [ lens text twitterTypes ];
  meta = {
    homepage = "https://github.com/himura/twitter-types-lens";
    description = "Twitter JSON types (lens powered)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
