{ stdenv, lib, kernel, fetchurl, pkgconfig, libvirt }:

assert lib.versionAtLeast kernel.version "3.18";

stdenv.mkDerivation rec {
  name = "dpdk-${version}-${kernel.version}";
  version = "16.04";

  src = fetchurl {
    url = "http://dpdk.org/browse/dpdk/snapshot/dpdk-${version}.tar.gz";
    sha256 = "0yrz3nnhv65v2jzz726bjswkn8ffqc1sr699qypc9m78qrdljcfn";
  };

  buildInputs = [ pkgconfig libvirt ];

  RTE_KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  # we need ssse3 instructions to build
  NIX_CFLAGS_COMPILE = [ "-march=core2" ];

  enableParallelBuilding = true;
  outputs = [ "out" "kmod" "examples" ];

  buildPhase = ''
    make T=x86_64-native-linuxapp-gcc config
    make T=x86_64-native-linuxapp-gcc install
    make T=x86_64-native-linuxapp-gcc examples
  '';

  installPhase = ''
    mkdir $out
    cp -pr x86_64-native-linuxapp-gcc/{lib,include} $out/

    mkdir -p $kmod/lib/modules/${kernel.modDirVersion}/kernel/drivers/net
    cp ${RTE_TARGET}/kmod/*.ko $kmod/lib/modules/${kernel.modDirVersion}/kernel/drivers/net

    mkdir -p $examples/bin
    find examples ${RTE_TARGET}/app -type f -executable -exec cp {} $examples/bin \;
  '';

  meta = with stdenv.lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = http://dpdk.org/;
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.domenkozar ];
  };
}
