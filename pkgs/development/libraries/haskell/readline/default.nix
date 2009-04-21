{ cabal, readline } :

cabal.mkDerivation (self : {
  pname = "readline";
  version = "1.0.1.0";
  sha256 = "07f2f039f32bf18838a4875d0f3caa3ed9436dd52b962b2061f0bb8a3316fa1d";
  propagatedBuildInputs = [ readline ];
  meta = {
    description = "An interface to the GNU readline library";
  };
})  

