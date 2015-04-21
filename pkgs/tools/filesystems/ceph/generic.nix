{ stdenv, autoconf, automake, makeWrapper, pkgconfig, libtool, which
, boost, python, pythonPackages, libxml2

# Optional Dependencies
, snappy ? null, leveldb ? null, yasm ? null, fcgi ? null, expat ? null
, curl ? null, fuse ? null, accelio ? null, libibverbs ? null, librdmacm ? null
, libedit ? null, libatomic_ops ? null, kinetic-cpp-client ? null
, rocksdb ? null, libs3 ? null

# Mallocs
, jemalloc ? null, gperftools ? null

# Crypto Dependencies
, cryptopp ? null
, nss ? null, nspr ? null

# Linux Only Dependencies
, linuxHeaders, libuuid, udev, keyutils, libaio ? null, libxfs ? null
, zfs ? null

# Version specific arguments
, version, src, patches ? []
, ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

with stdenv.lib;
let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  # TODO: Backport patches to support xio
  accelio = null;

  hasServer = snappy != null && leveldb != null;
  hasMon = hasServer;
  hasMds = hasServer;
  hasOsd = hasServer;
  hasRadosgw = fcgi != null && expat != null && curl != null && libedit != null;

  hasXio = (stdenv.isLinux || stdenv.isFreebsd) &&
    accelio != null && libibverbs != null && librdmacm != null;

  # Malloc implementation (can be jemalloc, tcmalloc or null)
  malloc = if jemalloc != null then jemalloc else gperftools;

  # We prefer nss over cryptopp
  cryptoStr = if nss != null && nspr != null then "nss" else
    if cryptopp != null then "cryptopp" else "none";
  cryptoLibsMap = {
    nss = [ nss nspr ];
    cryptopp = [ cryptopp ];
    none = [ ];
  };

  # TODO: Fix Rocksdb which is currently too new
  rocksdb = null;
  # TODO: Fix Kinetic which is also in a mismatched state
  kinetic-cpp-client = null;

  wrapArgs = "--prefix PYTHONPATH : \"$(toPythonPath $lib)\""
    + " --prefix PYTHONPATH : \"$(toPythonPath ${python.modules.readline})\""
    + " --prefix PYTHONPATH : \"$(toPythonPath ${pythonPackages.flask})\""
    + " --prefix PATH : \"$out/bin\"";
in
stdenv.mkDerivation {
  name="ceph-${version}";

  inherit src;

  patches = patches ++ [
    ./0001-Makefile-env-Don-t-force-sbin.patch
  ];

  nativeBuildInputs = [ autoconf automake makeWrapper pkgconfig libtool which ];
  buildInputs = cryptoLibsMap.${cryptoStr} ++ [
    boost python libxml2 yasm libatomic_ops kinetic-cpp-client rocksdb libs3 malloc
  ] ++ stdenv.lib.optional stdenv.isLinux [
    linuxHeaders libuuid udev keyutils libaio libxfs zfs
  ] ++ stdenv.lib.optional hasServer [
    snappy leveldb
  ] ++ stdenv.lib.optional hasRadosgw [
    fcgi expat curl fuse libedit
  ] ++ stdenv.lib.optional hasXio [
    accelio libibverbs librdmacm
  ];

  postPatch = ''
    # Fix zfs pkgconfig detection
    sed -i 's,\[zfs\],\[libzfs\],g' configure.ac

    # Fix seagate kinetic linking
    sed -i 's,libcrypto.a,-lcrypto,g' src/os/Makefile.am
  '';

  preConfigure = ''
    # Ceph expects the arch command to be usable during configure
    # for detecting the assembly type
    mkdir mybin
    echo "#${stdenv.shell} -e" >> mybin/arch
    echo "uname -m" >> mybin/arch
    chmod +x mybin/arch
    PATH="$PATH:$(pwd)/mybin"

    ./autogen.sh

    # Fix the python site-packages install directory
    sed -i "s,\(PYTHON\(\|_EXEC\)_PREFIX=\).*,\1'$lib',g" configure
  '';

  configureFlags = [
    "--exec_prefix=\${out}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--libdir=\${lib}/lib"
    "--includedir=\${lib}/include"

    (mkWith   true                         "rbd"               null)
    (mkWith   true                         "cephfs"            null)
    (mkWith   hasRadosgw                   "radosgw"           null)
    (mkWith   true                         "radosstriper"      null)
    (mkWith   hasServer                    "mon"               null)
    (mkWith   hasServer                    "osd"               null)
    (mkWith   hasServer                    "mds"               null)
    (mkEnable true                         "client"            null)
    (mkEnable hasServer                    "server"            null)
    (mkWith   (cryptoStr == "cryptopp")    "cryptopp"          null)
    (mkWith   (cryptoStr == "nss")         "nss"               null)
    (mkEnable false                        "root-make-check"   null)
    (mkWith   false                        "profiler"          null)
    (mkWith   false                        "debug"             null)
    (mkEnable false                        "coverage"          null)
    (mkWith   (fuse != null)               "fuse"              null)
    (mkWith   (malloc == jemalloc)         "jemalloc"          null)
    (mkWith   (malloc == gperftools)       "tcmalloc"          null)
    (mkEnable false                        "pgrefdebugging"    null)
    (mkEnable false                        "cephfs-java"       null)
    (mkEnable hasXio                       "xio"               null)
    (mkWith   (libatomic_ops != null)      "libatomic-ops"     null)
    (mkWith   true                         "ocf"               null)
    (mkWith   (kinetic-cpp-client != null) "kinetic"           null)
    (mkWith   (rocksdb != null)            "librocksdb"        null)
    (mkWith   false                        "librocksdb-static" null)
    (mkWith   (libs3 != null)              "system-libs3"      null)
    (mkWith   true                         "rest-bench"        null)
  ] ++ optional stdenv.isLinux [
    (mkWith   (libaio != null)             "libaio"            null)
    (mkWith   (libxfs != null)             "libxfs"            null)
    (mkWith   (zfs != null)                "libzfs"            null)
  ];

  installFlags = [ "sysconfdir=\${out}/etc" ];

  outputs = [ "out" "lib" ];

  postInstall = ''
    # Wrap all of the python scripts
    wrapProgram $out/bin/ceph ${wrapArgs}
    wrapProgram $out/bin/ceph-brag ${wrapArgs}
    wrapProgram $out/bin/ceph-rest-api ${wrapArgs}
    wrapProgram $out/sbin/ceph-create-keys ${wrapArgs}
    wrapProgram $out/sbin/ceph-disk ${wrapArgs}

    # Bring in lib as a native build input
    mkdir -p $out/nix-support
    echo "$lib" > $out/nix-support/propagated-native-build-inputs

    # Fix the python library loading
    find $lib/lib -name \*.pyc -or -name \*.pyd -exec rm {} \;
    for PY in $(find $lib/lib -name \*.py); do
      LIB="$(sed -n "s/.*find_library('\([^)]*\)').*/\1/p" "$PY")"
      REALLIB="$lib/lib/lib$LIB.so"
      sed -i "s,\(library_path[ ]*=[ ]*\).*,\1'$REALLIB',g" "$PY"

      # Reapply compilation optimizations
      NAME=$(basename -s .py "$PY")
      (cd "$(dirname $PY)"; python -c "import $NAME"; python -O -c "import $NAME")
    done
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ak wkennington ];
    platforms = with platforms; unix;
  };

  passthru.version = version;
}
