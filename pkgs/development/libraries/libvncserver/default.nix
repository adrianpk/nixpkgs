{stdenv, fetchurl,
 libtool, libjpeg, openssl, zlib, libgcrypt, autoreconfHook, pkgconfig, libpng,
 systemd
}:

let
  s = # Generated upstream information
  rec {
    baseName="libvncserver";
    version="0.9.11";
    name="${baseName}-${version}";
    url="https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${version}.tar.gz";
    sha256="15189n09r1pg2nqrpgxqrcvad89cdcrca9gx6qhm6akjf81n6g8r";
  };
in
stdenv.mkDerivation {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preConfigure = ''
    sed -e 's@/usr/include/linux@${stdenv.cc.libc}/include/linux@g' -i configure
  '';
  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    libtool libjpeg openssl libgcrypt libpng
  ] ++ stdenv.lib.optional stdenv.isLinux systemd;
  propagatedBuildInputs = [ zlib ];
  meta = {
    inherit (s) version;
    description =  "VNC server library";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
