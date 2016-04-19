{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "gzip-${version}";
  version = "1.7";

  src = fetchurl {
    url = "mirror://gnu/gzip/${name}.tar.xz";
    sha256 = "1as1ddq58spflzz5kxm0ni0xfpswrkkrncjpxyb3aw77gizcacgv";
  };

  outputs = [ "out" "man" "info" ];

  enableParallelBuilding = true;

  buildInputs = [ xz.bin ];

  preConfigure = if stdenv.isCygwin then ''
    sed -i lib/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  # In stdenv-linux, prevent a dependency on bootstrap-tools.
  makeFlags = "SHELL=/bin/sh GREP=grep";

  meta = {
    homepage = https://www.gnu.org/software/gzip/;
    description = "GNU zip compression program";

    longDescription =
      ''gzip (GNU zip) is a popular data compression program written by
        Jean-loup Gailly for the GNU project.  Mark Adler wrote the
        decompression part.

        We developed this program as a replacement for compress because of
        the Unisys and IBM patents covering the LZW algorithm used by
        compress.  These patents made it impossible for us to use compress,
        and we needed a replacement.  The superior compression ratio of gzip
        is just a bonus.
      '';

    platforms = stdenv.lib.platforms.all;

    license = stdenv.lib.licenses.gpl3Plus;
  };
}
