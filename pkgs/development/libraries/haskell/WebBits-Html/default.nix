{cabal, WebBits, mtl, parsec, syb} :

cabal.mkDerivation (self : {
  pname = "WebBits-Html";
  version = "1.0.2";
  sha256 = "18dd52970cd27kra4l89vvrx2mrdbqd4w4f76xrq3142daxsagal";
  propagatedBuildInputs = [ WebBits mtl parsec syb ];
  meta = {
    homepage = "http://www.cs.brown.edu/research/plt/";
    description = "JavaScript analysis tools";
    license = "LGPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
