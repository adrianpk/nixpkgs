{ stdenv, targetPackages
, buildPlatform, hostPlatform, targetPlatform

# build-tools
, bootPkgs, hscolour
, coreutils, fetchurl, perl, sphinx

, libffi, libiconv ? null, ncurses

, useLLVM ? !targetPlatform.isx86
, # LLVM is conceptually a run-time-only depedendency, but for
  # non-x86, we need LLVM to bootstrap later stages, so it becomes a
  # build-time dependency too.
  buildLlvmPackages, llvmPackages

, # If enabled, GHC will be built with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
  enableIntegerSimple ? false, gmp ? null

, # If enabled, use -fPIC when compiling static libs.
  enableRelocatedStaticLibs ? targetPlatform != hostPlatform

, # Whether to build dynamic libs for the standard library (on the target
  # platform). Static libs are always built.
  enableShared ? true
}:

assert !enableIntegerSimple -> gmp != null;

let
  inherit (bootPkgs) ghc;

  # TODO(@Ericson2314) Make unconditional
  targetPrefix = stdenv.lib.optionalString
    (targetPlatform != hostPlatform)
    "${targetPlatform.config}-";

  buildMK = ''
    DYNAMIC_GHC_PROGRAMS = ${if enableShared then "YES" else "NO"}
  '' + stdenv.lib.optionalString enableIntegerSimple ''
    INTEGER_LIBRARY = integer-simple
  '' + stdenv.lib.optionalString (targetPlatform != hostPlatform) ''
    BuildFlavour = perf-cross
    Stage1Only = YES
    HADDOCK_DOCS = NO
  '' + stdenv.lib.optionalString enableRelocatedStaticLibs ''
    GhcLibHcOpts += -fPIC
    GhcRtsHcOpts += -fPIC
  '';

  # Splicer will pull out correct variations
  libDeps = platform: [ ncurses ]
    ++ stdenv.lib.optional (!enableIntegerSimple) gmp
    ++ stdenv.lib.optional (platform.libc != "glibc") libiconv;

  toolsForTarget =
    if hostPlatform == buildPlatform then
      [ targetPackages.stdenv.cc ] ++ stdenv.lib.optional useLLVM llvmPackages.llvm
    else assert targetPlatform == hostPlatform; # build != host == target
      [ stdenv.cc ] ++ stdenv.lib.optional useLLVM buildLlvmPackages.llvm;

  targetCC = builtins.head toolsForTarget;

in
stdenv.mkDerivation rec {
  version = "8.0.2";
  name = "${targetPrefix}ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/${version}/ghc-${version}-src.tar.xz";
    sha256 = "1c8qc4fhkycynk4g1f9hvk53dj6a1vvqi6bklqznns6hw59m8qhi";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "man" "doc" ];

  patches = [ ./ghc-gold-linker.patch ]
    ++ stdenv.lib.optional stdenv.isLinux ./ghc-no-madv-free.patch
    ++ stdenv.lib.optional stdenv.isDarwin ./ghc-8.0.2-no-cpp-warnings.patch;

  preConfigure = ''
    echo -n "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ]
    ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";
  # `--with` flags for libraries needed for RTS linker
  configureFlags = [
    "--datadir=$doc/share/doc/ghc"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
  ] ++ stdenv.lib.optional (targetPlatform == hostPlatform && ! enableIntegerSimple) [
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
  ] ++ stdenv.lib.optional (targetPlatform == hostPlatform && hostPlatform.libc != "glibc") [
    "--with-iconv-includes=${libiconv}/include" "--with-iconv-libraries=${libiconv}/lib"
  ] ++ stdenv.lib.optionals (targetPlatform != hostPlatform) [
    "--enable-bootstrap-with-devel-snapshot"
  ] ++ stdenv.lib.optionals (targetPlatform.isDarwin && targetPlatform.isAarch64) [
    # fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
    "--disable-large-address-space"
  ];

  # Hack to make sure we never to the relaxation `$PATH` and hooks support for
  # compatability. This will be replaced with something clearer in a future
  # masss-rebuild.
  crossConfig = true;

  nativeBuildInputs = [ ghc perl hscolour sphinx ];

  # For building runtime libs
  depsBuildTarget = toolsForTarget;

  buildInputs = libDeps hostPlatform;

  propagatedBuildInputs = [ targetPackages.stdenv.cc ]
    ++ stdenv.lib.optional useLLVM llvmPackages.llvm;

  depsTargetTarget = map stdenv.lib.getDev (libDeps targetPlatform);
  depsTargetTargetPropagated = map (stdenv.lib.getOutput "out") (libDeps targetPlatform);

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!targetPlatform.isDarwin) "--keep-file-symbols";

  # zsh and other shells are smart about `{ghc}` but bash isn't, and doesn't
  # treat that as a unary `{x,y,z,..}` repetition.
  postInstall = ''
    paxmark m $out/lib/${name}/bin/${if targetPlatform != hostPlatform then "ghc" else "{ghc,haddock}"}

    # Install the bash completion file.
    install -D -m 444 utils/completion/ghc.bash $out/share/bash-completion/completions/${targetPrefix}ghc

    # Patch scripts to include "readelf" and "cat" in $PATH.
    for i in "$out/bin/"*; do
      test ! -h $i || continue
      egrep --quiet '^#!' <(head -n 1 $i) || continue
      sed -i -e '2i export PATH="$PATH:${stdenv.lib.makeBinPath [ targetPackages.stdenv.cc.bintools coreutils ]}"' $i
    done
  '';

  passthru = {
    inherit bootPkgs targetPrefix;

    inherit llvmPackages;
  };

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
