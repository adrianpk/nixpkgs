# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, haskellSrc, mtl, network, random, regexCompat
, regexPosix, syb, tagsoup, utf8String, zlib
}:

cabal.mkDerivation (self: {
  pname = "lambdabot-utils";
  version = "4.2.2";
  sha256 = "0mmz9rn6vv8xnavmz66g164h1liir3rzg1n7lmbcsgwcyhm925d7";
  buildDepends = [
    binary haskellSrc mtl network random regexCompat regexPosix syb
    tagsoup utf8String zlib
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Lambdabot";
    description = "Utility libraries for the advanced IRC bot, Lambdabot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    broken = true;
  };
})
