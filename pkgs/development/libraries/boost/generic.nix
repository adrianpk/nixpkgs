{ stdenv, icu, expat, zlib, bzip2, python, fixDarwinDylibNames, makeSetupHook
, toolset ? null
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? true
, enableStatic ? false
, enablePIC ? false
, enableExceptions ? false
, taggedLayout ? ((enableRelease && enableDebug) || (enableSingleThreaded && enableMultiThreaded) || (enableShared && enableStatic))

# Attributes inherit from specific versions
, version, src
, ...
}:

# We must build at least one type of libraries
assert !enableShared -> enableStatic;

with stdenv.lib;
let

  variant = concatStringsSep ","
    (optional enableRelease "release" ++
     optional enableDebug "debug");

  threading = concatStringsSep ","
    (optional enableSingleThreaded "single" ++
     optional enableMultiThreaded "multi");

  link = concatStringsSep ","
    (optional enableShared "shared" ++
     optional enableStatic "static");

  runtime-link = if enableShared then "shared" else "static";

  # To avoid library name collisions
  layout = if taggedLayout then "tagged" else "system";

  cflags = if enablePIC && enableExceptions then
             "cflags=\"-fPIC -fexceptions\" cxxflags=-fPIC linkflags=-fPIC"
           else if enablePIC then
             "cflags=-fPIC cxxflags=-fPIC linkflags=-fPIC"
           else if enableExceptions then
             "cflags=-fexceptions"
           else
             "";

  withToolset = stdenv.lib.optionalString (toolset != null) "--with-toolset=${toolset}";

  genericB2Flags = [
    "--includedir=$dev/include"
    "--libdir=$lib/lib"
    "-j$NIX_BUILD_CORES"
    "--layout=${layout}"
    "variant=${variant}"
    "threading=${threading}"
    "runtime-link=${runtime-link}"
    "link=${link}"
    "${cflags}"
  ] ++ optional (variant == "release") "debug-symbols=off";

  nativeB2Flags = [
    "-sEXPAT_INCLUDE=${expat}/include"
    "-sEXPAT_LIBPATH=${expat}/lib"
  ] ++ optional (toolset != null) "toolset=${toolset}";
  nativeB2Args = concatStringsSep " " (genericB2Flags ++ nativeB2Flags);

  crossB2Flags = [
    "-sEXPAT_INCLUDE=${expat.crossDrv}/include"
    "-sEXPAT_LIBPATH=${expat.crossDrv}/lib"
    "--user-config=user-config.jam"
    "toolset=gcc-cross"
    "--without-python"
  ];
  crossB2Args = concatMapStringsSep " " (genericB2Flags ++ crossB2Flags);

  builder = b2Args: ''
    ./b2 ${b2Args}
  '';

  installer = b2Args: ''
    # boostbook is needed by some applications
    mkdir -p $dev/share/boostbook
    cp -a tools/boostbook/{xsl,dtd} $dev/share/boostbook/

    # Let boost install everything else
    ./b2 ${b2Args} install

    # Create a derivation which encompasses everything, making buildInputs nicer
    mkdir -p $out/nix-support
    echo "${stripHeaderPathHook} $dev $lib" > $out/nix-support/propagated-native-build-inputs
  '';

  commonConfigureFlags = [
    "--includedir=$(dev)/include"
    "--libdir=$(lib)/lib"
  ];

  stripHeaderPathHook = makeSetupHook { } ./strip-header-path.sh;

in

stdenv.mkDerivation {
  name = "boost-${version}";

  inherit src;

  meta = {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = "boost-license";

    platforms = platforms.unix;
    maintainers = with maintainers; [ simons wkennington ];
  };

  preConfigure = ''
    NIX_LDFLAGS="$(echo $NIX_LDFLAGS | sed "s,$out,$lib,g")"
  '';

  enableParallelBuilding = true;

  buildInputs = [ icu expat zlib bzip2 python ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  configureScript = "./bootstrap.sh";
  configureFlags = commonConfigureFlags ++ [
    "--with-icu=${icu}"
    "--with-python=${python}/bin/python"
  ] ++ optional (toolset != null) "--with-toolset=${toolset}";

  buildPhase = ''
    ${stdenv.lib.optionalString (toolset == "clang") "unset NIX_ENFORCE_PURITY"}
  '' + builder nativeB2Args;

  installPhase = installer nativeB2Args;

  outputs = [ "out" "dev" "lib" ];

  crossAttrs = rec {
    buildInputs = [ expat.crossDrv zlib.crossDrv bzip2.crossDrv ];
    # all buildInputs set previously fell into propagatedBuildInputs, as usual, so we have to
    # override them.
    propagatedBuildInputs = buildInputs;
    # We want to substitute the contents of configureFlags, removing thus the
    # usual --build and --host added on cross building.
    preConfigure = ''
      export configureFlags="--without-icu ${concatStringsSep " " commonConfigureFlags}"
      set -x
      cat << EOF > user-config.jam
      using gcc : cross : $crossConfig-g++ ;
      EOF
    '';
    buildPhase = builder crossB2Args;
    installPhase = installer crossB2Args;
  };
}
