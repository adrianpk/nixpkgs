{ stdenv, fetchurl, cmake, pkgconfig, udev, libcec_platform }:

let version = "4.0.3"; in

stdenv.mkDerivation {
  name = "libcec-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}.tar.gz";
    sha256 = "1713qs4nrynkcr3mgs1i7xj10lcyaxqipwiz9p0lfn4xrzjdd47g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake udev libcec_platform ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=1" ];

  # Fix dlopen path
  patchPhase = ''
    substituteInPlace include/cecloader.h --replace "libcec.so" "$out/lib/libcec.so"
  '';

  meta = with stdenv.lib; {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = http://libcec.pulse-eight.com;
    repositories.git = "https://github.com/Pulse-Eight/libcec.git";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
