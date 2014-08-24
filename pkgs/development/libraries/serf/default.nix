{ stdenv, fetchurl, apr, scons, openssl, aprutil, zlib, krb5, pkgconfig }:

stdenv.mkDerivation rec {
  name = "serf-1.3.7";

  src = fetchurl {
    url = "http://serf.googlecode.com/svn/src_releases/${name}.tar.bz2";
    sha1 = "db9ae339dba10a2b47f9bdacf30a58fd8e36683a";
  };

  buildInputs = [ apr scons openssl aprutil zlib krb5 pkgconfig ];

  configurePhase = ''
    sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"PATH":os.environ["PATH"]})' -i SConstruct
    sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"NIX_CFLAGS_COMPILE":os.environ["NIX_CFLAGS_COMPILE"]})' -i SConstruct
    sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"NIX_LDFLAGS":os.environ["NIX_LDFLAGS"]})' -i SConstruct
  '';

  buildPhase = ''
    scons PREFIX="$out" OPENSSL="${openssl}" ZLIB="${zlib}" APR="$(echo "${apr}"/bin/*-config)" \
        APU="$(echo "${aprutil}"/bin/*-config)" GSSAPI="${krb5}" CC="${stdenv.gcc}/bin/gcc"
  '';

  installPhase = ''
    scons install
  '';

  meta = {
    description = "HTTP client library based on APR";
    license = stdenv.lib.licenses.asl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    hydraPlatforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
