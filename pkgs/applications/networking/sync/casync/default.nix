{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig, sphinx, acl, curl, fuse, libselinux, udev, xz, zstd }:

stdenv.mkDerivation rec {
  name = "casync-${version}";
  version = "2-152-ge4a3c5e";

  src = fetchFromGitHub {
    owner  = "systemd";
    repo   = "casync";
    rev    = "e4a3c5efc8f11e0e99f8cc97bd417665d92b40a9";
    sha256 = "0zx6zvj5a6rr3w9s207rvpfw7gwssiqmp1p3c75bsirmz4nmsdf0";
  };

  buildInputs = [ acl curl fuse libselinux udev xz zstd ];
  nativeBuildInputs = [ meson ninja pkgconfig sphinx ];

  PKG_CONFIG_UDEV_UDEVDIR = "lib/udev";

  meta = with stdenv.lib; {
    description = "Content-Addressable Data Synchronizer";
    homepage    = https://github.com/systemd/casync;
    license     = licenses.lgpl21;
    platforms   = platforms.all;
    maintainers = with maintainers; [ flokli ];
  };
}
