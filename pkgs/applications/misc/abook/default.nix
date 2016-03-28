{ stdenv, fetchurl, fetchpatch, pkgconfig, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "abook-0.6.0pre2";

  src = fetchurl {
    url = "http://abook.sourceforge.net/devel/${name}.tar.gz";
    sha256 = "11fkyq9bqw7s6jf38yglk8bsx0ar2wik0fq0ds0rdp8985849m2r";
  };

  patches = [
    (fetchpatch {
       url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/gcc5.patch?h=packages/abook";
       name = "gcc5.patch";
       sha256 = "13n3qd6yy45i5n8ppjn9hj6y63ymjrq96280683xk7f7rjavw5nn";
     })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses readline ];

  # Changed inline semantics in GCC5, need to export symbols for inline funcs
  postPatch = ''
    substituteInPlace database.c --replace inline extern
  '';

  meta = {
    homepage = "http://abook.sourceforge.net/";
    description = "Text-based addressbook program designed to use with mutt mail client";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
