{ stdenv, fetchFromGitHub

# Optional Arguments
, snappy ? null, google-gflags ? null, zlib ? null, bzip2 ? null, lz4 ? null
, numactl ? null

# Malloc implementation
, jemalloc ? null, gperftools ? null
}:

let
  malloc = if jemalloc != null then jemalloc else gperftools;
in
stdenv.mkDerivation rec {
  name = "rocksdb-${version}";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "rocksdb";
    rev = "rocksdb-${version}";
    sha256 = "0cjwr7n5l2wdzdv4b0p90k0ijg9ka28akpq2aqa8lknsa1kb1cyv";
  };

  buildInputs = [ snappy google-gflags zlib bzip2 lz4 numactl malloc ];

  postPatch = ''
    # Hack to fix typos
    sed -i 's,#inlcude,#include,g' build_tools/build_detect_platform
  '';

  # Environment vars used for building certain configurations
  PORTABLE = "1";
  USE_SSE = "1";
  JEMALLOC_LIB = stdenv.lib.optionalString (malloc == jemalloc) "-ljemalloc";

  buildFlags = [
    "static_lib"
    "shared_lib"
  ];

  installFlags = [
    "INSTALL_PATH=\${out}"
  ];

  postInstall = ''
    # Might eventually remove this when we are confident in the build process
    echo "BUILD CONFIGURATION FOR SANITY CHECKING"
    cat make_config.mk
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://rocksdb.org;
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
