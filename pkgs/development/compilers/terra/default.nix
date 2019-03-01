{ stdenv, fetchFromGitHub, fetchurl, llvmPackages, ncurses, lua }:

let
  luajitArchive = "LuaJIT-2.0.5.tar.gz";
  luajitSrc = fetchurl {
    url = "http://luajit.org/download/${luajitArchive}";
    sha256 = "0yg9q4q6v028bgh85317ykc9whgxgysp76qzaqgq55y6jy11yjw7";
  };
in

stdenv.mkDerivation rec {
  name = "terra-git-${version}";
  version = "1.0.0-beta1";

  src = fetchFromGitHub {
    owner = "zdevito";
    repo = "terra";
    rev = "release-${version}";
    sha256 = "1blv3mbmlwb6fxkck6487ck4qq67cbwq6s1zlp86hy2wckgf8q2c";
  };

  outputs = [ "bin" "dev" "out" "static" ];

  postPatch = ''
    substituteInPlace Makefile --replace \
      '-lcurses' '-lncurses'
  '';

  preBuild = ''
    cat >Makefile.inc<<EOF
    CLANG = ${stdenv.lib.getBin llvmPackages.clang-unwrapped}/bin/clang
    LLVM_CONFIG = ${stdenv.lib.getBin llvmPackages.llvm}/bin/llvm-config
    EOF

    mkdir -p build
    cp ${luajitSrc} build/${luajitArchive}
  '';

  installPhase = ''
    mkdir -pv $out/lib
    cp -v release/lib/terra.so $out/lib

    mkdir -pv $bin/bin
    cp -v release/bin/terra $bin/bin

    mkdir -pv $static/lib
    cp -v release/lib/libterra.a $static/lib

    mkdir -pv $dev/include
    cp -rv release/include/terra $dev/include
  ''
  ;

  buildInputs = with llvmPackages; [ lua llvm clang-unwrapped ncurses ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A low-level counterpart to Lua";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
