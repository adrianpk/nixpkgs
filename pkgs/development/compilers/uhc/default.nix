{ stdenv, coreutils, fetchgit, m4, libtool, clang, ghcWithPackages }:

let wrappedGhc = ghcWithPackages (hpkgs: with hpkgs; [shuffle hashable mtl network uhc-util uulib] );
in stdenv.mkDerivation rec {
  version = "1.1.9.1";
  name = "uhc-${version}";

  src = fetchgit {
    url = "https://github.com/UU-ComputerScience/uhc.git";
    rev = "c4955d01089485cdcfec785fe2bbcdf2253bee4b";
    sha256 = "1n2bfbzni2hwv90z3mgn0x3l3jwc7sy8ryk81p5mlvlis1wzxnq3";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/EHC";

  buildInputs = [ m4 wrappedGhc clang libtool ];

  configureFlags = [ "--with-gcc=${clang}/bin/clang" ];

  # UHC builds packages during compilation; these are by default
  # installed in the user-specific package config file. We do not
  # want that, and hack the build process to use a temporary package
  # configuration file instead.
  preConfigure = ''
    p=`pwd`/uhc-local-packages/
    ghc-pkg init $p
    sed -i "s|--user|--package-db=$p|g" mk/shared.mk.in
    sed -i "s|-fglasgow-exts|-fglasgow-exts -package-conf=$p|g" mk/shared.mk.in
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/dist.mk
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/config.mk.in
    sed -i "s|--make|--make -package-db=$p|g" src/ehc/files2.mk
    sed -i "s|--make|--make -package-db=$p|g" src/gen/files.mk
  '';

  inherit clang;

  meta = with stdenv.lib; {
    homepage = "http://www.cs.uu.nl/wiki/UHC";
    description = "Utrecht Haskell Compiler";
    maintainers = [ maintainers.phausmann ];

    # UHC i686 support is broken, see
    # https://github.com/UU-ComputerScience/uhc/issues/52
    #
    # Darwin build is broken as well at the moment.
    # On Darwin, the GNU libtool is used, which does not
    # support the -static flag and thus breaks the build.
    platforms = ["x86_64-linux"];
  };
}
