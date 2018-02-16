{ stdenv, lib, fetchurl, fetchgit, makeStaticLibraries, gambit,
  coreutils, rsync, bash,
  openssl, zlib, sqlite, libxml2, libyaml, mysql, lmdb, leveldb, postgresql }:

# TODO: distinct packages for gerbil-release and gerbil-devel
# TODO: make static compilation work

stdenv.mkDerivation rec {
  name    = "gerbil-${version}";

  version = "0.12-DEV-1404-g0a266db";
  src = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "0a266db5e2e241272711bc150cc2607204bf2b78";
    sha256 = "1lvawqn8havfyxkkgfqffc213zq2pgm179l42yj49fy3fhpzia4m";
  };

  # Use makeStaticLibraries to enable creation of statically linked binaries
  buildInputs_libraries = [ openssl zlib sqlite libxml2 libyaml mysql.connector-c lmdb leveldb postgresql ];
  buildInputs_staticLibraries = map makeStaticLibraries buildInputs_libraries;

  buildInputs = [ gambit coreutils rsync bash ]
    ++ buildInputs_libraries ++ buildInputs_staticLibraries;

  NIX_CFLAGS_COMPILE = [ "-I${mysql.connector-c}/include/mysql" "-L${mysql.connector-c}/lib/mysql" ];

  postPatch = ''
    echo '(define (gerbil-version-string) "v${version}")' > src/gerbil/runtime/gx-version.scm

    patchShebangs .

    find . -type f -executable -print0 | while IFS= read -r -d ''$'\0' f; do
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    done

    cat > etc/gerbil_static_libraries.sh <<EOF
#OPENSSL_LIBCRYPTO=${makeStaticLibraries openssl}/lib/libcrypto.a # MISSING!
#OPENSSL_LIBSSL=${makeStaticLibraries openssl}/lib/libssl.a # MISSING!
ZLIB=${makeStaticLibraries zlib}/lib/libz.a
# SQLITE=${makeStaticLibraries sqlite}/lib/sqlite.a # MISSING!
# LIBXML2=${makeStaticLibraries libxml2}/lib/libxml2.a # MISSING!
# YAML=${makeStaticLibraries libyaml}/lib/libyaml.a # MISSING!
MYSQL=${makeStaticLibraries mysql.connector-c}/lib/mariadb/libmariadb.a
# LMDB=${makeStaticLibraries lmdb}/lib/mysql/libmysqlclient_r.a # MISSING!
LEVELDB=${makeStaticLibraries lmdb}/lib/libleveldb.a
EOF
  '';

  buildPhase = ''
    runHook preBuild

    # Enable all optional libraries
    substituteInPlace "src/std/build-features.ss" --replace '#f' '#t'

    # gxprof testing uses $HOME/.cache/gerbil/gxc
    export HOME=$$PWD

    # Build, replacing make by build.sh
    ( cd src && sh build.sh )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -fa bin lib etc doc $out/

    cat > $out/bin/gxi <<EOF
#!${bash}/bin/bash -e
export GERBIL_HOME=$out
case "\$1" in -:*) GSIOPTIONS=\$1 ; shift ;; esac
if [[ \$# = 0 ]] ; then
  exec ${gambit}/bin/gsi \$GSIOPTIONS \$GERBIL_HOME/lib/gxi-init \$GERBIL_HOME/lib/gxi-interactive - ;
else
  exec ${gambit}/bin/gsi \$GSIOPTIONS \$GERBIL_HOME/lib/gxi-init "\$@"
fi
EOF
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Gerbil Scheme";
    homepage    = "https://github.com/vyzo/gerbil";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fare ];
  };
}
