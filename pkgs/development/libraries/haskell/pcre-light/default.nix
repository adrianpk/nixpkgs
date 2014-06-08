{ cabal, pcre }:

cabal.mkDerivation (self: {
  pname = "pcre-light";
  version = "0.4.0.2";
  sha256 = "0baq46d3k376mhh98gkfi6phndk8ba25c2kll9zms1y07mn3bnnx";
  extraLibraries = [ pcre ];
  meta = {
    homepage = "https://github.com/Daniel-Diaz/pcre-light";
    description = "A small, efficient and portable regex library for Perl 5 compatible regular expressions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
