{ stdenv, fetchurl, zlib, apngSupport ? false }:

assert zlib != null;

let
  version = "1.6.8";
  sha256 = "109h2fcjspd792lvh5q4xnkpsv7rjczmrdl15i4ajx0xbs5kvxr4";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-1.6.7-apng.patch.gz";
    sha256 = "1g5hmlb9smwl9qv6wb2d7795jqcfrx8g3dhrya5dshrj909jb95k";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    inherit sha256;
  };

  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
