{ stdenv
, fetchFromGitHub
, which
, cmake
, clang
, llvmPackages
, libunwind
, gettext
, openssl
, python2
, icu
, lttng-ust
, liburcu
, libuuid
, libkrb5
, ed
, debug ? false
}:

stdenv.mkDerivation rec {
  name = "coreclr-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "dotnet";
    repo   = "coreclr";
    rev    = "v${version}";
    sha256 = "16z58ix8kmk8csfy5qsqz8z30czhrap2vb8s8vdflmbcfnq31jcw";
  };

  buildInputs = [
    which
    cmake
    clang
    llvmPackages.llvm
    llvmPackages.lldb
    libunwind
    gettext
    openssl
    python2
    icu
    lttng-ust
    liburcu
    libuuid
    libkrb5
    ed
  ];

  configurePhase = ''
    patchShebangs build.sh
    patchShebangs src/pal/tools/gen-buildsys-clang.sh
  '';

  BuildArch = if stdenv.is64bit then "x64" else "x86";
  BuildType = if debug then "Debug" else "Release";

  hardeningDisable = [ "strictoverflow" "format" ];
  NIX_CFLAGS_COMPILE = [
    "-Wno-error=unused-result" "-Wno-error=delete-non-virtual-dtor"
    "-Wno-error=null-dereference"
  ];

  buildPhase = ''
    ./build.sh $BuildArch $BuildType

    # Try to make some sensible hierarchy out of the output
    pushd bin/Product/Linux.$BuildArch.$BuildType
    mkdir lib2
    mv *.so *.so.dbg lib2
    mv bin lib3
    mkdir lib4
    mv Loader lib4
    mv inc include
    mv gcinfo include
    mkdir bin
    mkdir -p share/doc
    mv sosdocsunix.txt share/doc
    for f in * ; do test -f $f && mv -v $f bin; done
    popd
  '';

  installPhase = ''
    mkdir -p $out
    cp -rv bin/Product/Linux.$BuildArch.$BuildType/* $out
  '';

  meta = {
    homepage = http://dotnet.github.io/core/;
    description = ".NET is a general purpose development platform";
    platforms = [ "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ obadz ];
    license = stdenv.lib.licenses.mit;
  };
}
