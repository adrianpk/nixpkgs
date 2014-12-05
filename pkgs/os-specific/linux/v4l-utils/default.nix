{stdenv, fetchurl, which, libjpeg
, withQt4 ? false, qt4 ? null}:

assert withQt4 -> qt4 != null;

stdenv.mkDerivation rec {
  name = "v4l-utils-1.0.0";

  src = fetchurl {
    url = "http://linuxtv.org/downloads/v4l-utils/${name}.tar.bz2";
    sha256 = "0c2z500ijxr1ldzb4snasfpwi2icp04f8pk7akiqjkp0k4h8iqqx";
  };

  buildInputs = [ which ];
  propagatedBuildInputs = [ libjpeg ] ++ stdenv.lib.optional withQt4 qt4;

  preConfigure = ''configureFlags="--with-udevdir=$out/lib/udev"'';

  meta = {
    homepage = http://linuxtv.org/projects.php;
    description = "V4L utils and libv4l, that provides common image formats regardless of the v4l device";
    license = stdenv.lib.licenses.free; # The libs are of LGPLv2.1+, some other pieces are GPL.
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
