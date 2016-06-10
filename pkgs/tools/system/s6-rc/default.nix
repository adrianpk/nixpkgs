{ stdenv, execline, fetchgit, skalibs, s6 }:

let

  version = "0.0.2.1";

in stdenv.mkDerivation rec {

  name = "s6-rc-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6-rc";
    rev = "refs/tags/v${version}";
    sha256 = "1gh72q1h1ds53yrzp481nvzaxkhhpm2kv59pfx4x564gxwdvq3a6";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-include=${execline}/include"
    "--with-include=${s6}/include"
    "--with-lib=${skalibs}/lib"
    "--with-lib=${execline}/lib"
    "--with-lib=${s6}/lib/s6"
    "--with-dynlib=${skalibs}/lib"
    "--with-dynlib=${execline}/lib"
    "--with-dynlib=${s6}/lib"
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  ++ (stdenv.lib.optional stdenv.isDarwin "--target=${stdenv.system}");

  meta = {
    homepage = http://skarnet.org/software/s6-rc/;
    description = "a service manager for s6-based systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
