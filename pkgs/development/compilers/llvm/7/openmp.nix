{ stdenv
, fetch
, cmake
, llvm
, perl
, version
}:

stdenv.mkDerivation {
  name = "openmp-${version}";

  src = fetch "openmp" "198iljq5hhm5rxfzslzbi73sq80jlwfr24a3khdk32lghdj2skdw";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  enableParallelBuilding = true;

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = http://openmp.llvm.org/;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.all;
  };
}
