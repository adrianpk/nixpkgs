{ stdenv, fetchurl, kernel }:

let base = "batman-adv-2017.3"; in

stdenv.mkDerivation rec {
  name = "${base}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${base}/${base}.tar.gz";
    sha256 = "1m541czjwgi4rfhjr6rg9r9c3cp2ncnif4ln7ri926zigwlxs3l3";
  };

  hardeningDisable = [ "pic" ];

  preBuild = ''
    makeFlags="KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  meta = {
    homepage = https://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
