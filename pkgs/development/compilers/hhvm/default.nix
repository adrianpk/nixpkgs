{ stdenv, fetchgit, cmake, pkgconfig, boost, libunwind, libmemcached, pcre
, libevent, gd, curl, libxml2, icu, flex, bison, openssl, zlib, php
, expat, libcap, oniguruma, libdwarf, libmcrypt, tbb, gperftools, glog, libkrb5
, bzip2, openldap, readline, libelf, uwimap, binutils, cyrus_sasl, pam, libpng
, libxslt, ocaml, freetype, gdb, git, perl, mariadb, gmp, libyaml, libedit
, libvpx, imagemagick, fribidi, gperf, which
}:

stdenv.mkDerivation rec {
  name    = "hhvm-${version}";
  version = "3.21";

  # use git version since we need submodules
  src = fetchgit {
    url    = "https://github.com/facebook/hhvm.git";
    rev    = "56483773e2edd9e61782f1901ce40e47959e71b8";
    sha256 = "0dmdk98nv04m0fv6909gfbsxqlkckn369yi7kadhir0r7vxsj7wa";
    fetchSubmodules = true;
  };

  buildInputs =
    [ cmake pkgconfig boost libunwind mariadb.client libmemcached pcre gdb git perl
      libevent gd curl libxml2 icu flex bison openssl zlib php expat libcap
      oniguruma libdwarf libmcrypt tbb gperftools bzip2 openldap readline
      libelf uwimap binutils cyrus_sasl pam glog libpng libxslt ocaml libkrb5
      gmp libyaml libedit libvpx imagemagick fribidi gperf which
    ];

  patches = [
    ./flexible-array-members-gcc6.patch
  ];

  enableParallelBuilding = false; # occasional build problems;
  dontUseCmakeBuildDir = true;
  NIX_LDFLAGS = "-lpam -L${pam}/lib";

  # work around broken build system
  NIX_CFLAGS_COMPILE = "-I${freetype.dev}/include/freetype2";

  # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
  # (setting it to an absolute path causes include files to go to $out/$out/include,
  #  because the absolute path is interpreted with root at $out).
  cmakeFlags = "-DCMAKE_INSTALL_INCLUDEDIR=include";

  prePatch = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/env bash" ${stdenv.shell}
    substituteInPlace ./third-party/ocaml/CMakeLists.txt \
      --replace "/bin/bash" ${stdenv.shell}
    perl -pi -e 's/([ \t(])(isnan|isinf)\(/$1std::$2(/g' \
      hphp/runtime/base/*.cpp \
      hphp/runtime/ext/std/*.cpp \
      hphp/runtime/ext_zend_compat/php-src/main/*.cpp \
      hphp/runtime/ext_zend_compat/php-src/main/*.h
    patchShebangs .
  '';

  meta = {
    description = "High-performance JIT compiler for PHP/Hack";
    homepage    = "http://hhvm.com";
    license     = "PHP/Zend";
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
