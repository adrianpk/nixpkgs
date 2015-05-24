{ stdenv, fetchurl, cmake, yasm
, debugSupport ? false # Run-time sanity checks (debugging)
, highbitdepthSupport ? false # false=8bits per channel, true=10/12bits per channel
, werrorSupport ? false # Warnings as errors
, ppaSupport ? false # PPA profiling instrumentation
, vtuneSupport ? false # Vtune profiling instrumentation
, custatsSupport ? false # Internal profiling of encoder work
, cliSupport ? true # Build standalone CLI application
, unittestsSupport ? false # Unit tests
}:

let
  mkFlag = optSet: flag: if optSet then "-D${flag}=ON" else "-D${flag}=OFF";
  inherit (stdenv) is64bit;
in

stdenv.mkDerivation rec {
  name = "x265-${version}";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/videolan/x265/archive/${version}.tar.gz";
    sha256 = "18w3whmbjlalvysny51kdq9b228iwg3rdav4kmifazksvrm4yacq";
  };

  patchPhase = ''
    sed -i 's/unknown/${version}/g' source/cmake/version.cmake
  '';

  cmakeFlags = [
    (mkFlag debugSupport "CHECKED_BUILD")
    "-DSTATIC_LINK_CRT=OFF"
    (mkFlag (highbitdepthSupport && is64bit) "HIGH_BIT_DEPTH")
    (mkFlag werrorSupport "WARNINGS_AS_ERRORS")
    (mkFlag ppaSupport "ENABLE_PPA")
    (mkFlag vtuneSupport "ENABLE_VTUNE")
    (mkFlag custatsSupport "DETAILED_CU_STATS")
    "-DENABLE_SHARED=ON"
    (mkFlag cliSupport "ENABLE_CLI")
    (mkFlag unittestsSupport "ENABLE_TESTS")
  ];

  preConfigure = ''
    cd source
  '';

  nativeBuildInputs = [ cmake yasm ];

  meta = with stdenv.lib; {
    description = "Library for encoding h.265/HEVC video streams";
    homepage    = http://x265.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
