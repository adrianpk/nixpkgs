{ stdenv, fetchFromGitHub, cmake, pkgconfig, pandoc
, ethtool, iproute, libnl, udev, python, perl
} :

let
  version = "22";

in stdenv.mkDerivation {
  name = "rdma-core-${version}";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${version}";
    sha256 = "1xkd51bz6p85gahsw18knrvirn404ca98lqmp1assyn4irs7khx8";
  };

  nativeBuildInputs = [ cmake pkgconfig pandoc ];
  buildInputs = [ libnl ethtool iproute udev python perl ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_RUNDIR=/run"
    "-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib"
  ];

  postPatch = ''
    substituteInPlace providers/rxe/rxe_cfg.in \
      --replace ethtool "${ethtool}/bin/ethtool" \
      --replace 'ip addr' "${iproute}/bin/ip addr" \
      --replace 'ip link' "${iproute}/bin/ip link"
  '';

  meta = with stdenv.lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = https://github.com/linux-rdma/rdma-core;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
