{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
, texinfo ? null
, gmp, mpfr
}:

assert langC;

with import ../../../lib;

let version = "4.3.1"; in

stdenv.mkDerivation {
  name = "gcc-${version}";
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "18spk152j1vqa9bzhi93i7cgrmf7gncv0h1lm1mxxgn1ahrnnw67";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "0r74s60hylr8xrnb2j3x0dmf3cnxxg609g4h07r6ida8vk33bd25";
    }) ++
    optional langF77 (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "1fl76sajlz1ihnsmqsbs3i8g0h77w9hm35pwb1s2w6p4h5xy5dnb";
    });
    
  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [texinfo gmp mpfr];

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC   "c"
        ++ optional langCC  "c++"
        ++ optional langF77 "f77"
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
  ";

  NIX_EXTRA_LDFLAGS = if staticCompiler then "-static" else "";

  inherit gmp mpfr;
  #X_CFLAGS = "-I${gmp}/include -I${mpfr}/include -L${gmp}/lib -L${mpfr}/lib";

  passthru = { inherit langC langCC langF77; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.3.x";
  };
}
