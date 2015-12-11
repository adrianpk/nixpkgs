{ stdenv, fetchurl, unzip, curl, makeWrapper, gcc }:

stdenv.mkDerivation {
  name = "dmd-2.067.1";

  src = fetchurl {
    url = http://downloads.dlang.org/releases/2015/dmd.2.067.1.zip;
    sha256 = "0ny99vfllvvgcl79pwisxcdnb3732i827k9zg8c0j4s0n79k5z94";
  };

  buildInputs = [ unzip curl makeWrapper ];

  # Allow to use "clang++", commented in Makefile
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/dmd/posix.mak --replace g++ clang++
  '';

  # Buid and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
      cd src/dmd
      make -f posix.mak INSTALL_DIR=$out
      export DMD=$PWD/dmd
      cd ../druntime
      make -f posix.mak INSTALL_DIR=$out DMD=$DMD
      cd ../phobos
      make -f posix.mak INSTALL_DIR=$out DMD=$DMD
      cd ../..
  '';

  installPhase = ''
      cd src/dmd
      mkdir $out
      mkdir $out/bin
      cp dmd $out/bin

      cd ../druntime
      mkdir $out/include
      mkdir $out/include/d2
      cp -r import/* $out/include/d2

      cd ../phobos
      mkdir $out/lib
      ${let bits = if stdenv.is64bit then "64" else "32";
            osname = if stdenv.isDarwin then "osx" else "linux"; in
      "cp generated/${osname}/release/${bits}/libphobos2.a $out/lib"
      }

      cp -r std $out/include/d2
      cp -r etc $out/include/d2

      wrapProgram $out/bin/dmd --prefix PATH ":" "${gcc}/bin/"

      cd $out/bin
      tee dmd.conf << EOF
      [Environment]
      DFLAGS=-I$out/include/d2 -L-L$out/lib ${stdenv.lib.optionalString (!stdenv.cc.isClang) "-L--no-warn-search-mismatch -L--export-dynamic"}
      EOF
  '';

  meta = with stdenv.lib; {
    description = "D language compiler";
    homepage = http://dlang.org/;
    license = licenses.free; # parts under different licenses
    platforms = platforms.unix;
  };
}
