{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.10.0";

  src = fetchurl {
    url = "http://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "1gzi7j97zymzfj6b7mlih35djflwfgg93b63q9rbs5w1kclmsrgz";
  };

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=implicit-function-declaration" ];

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = http://lttng.org/;
    license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = builtins.compareVersions kernel.version "3.18" == -1
      || builtins.compareVersions kernel.version "4.11" == 1;
  };

}
