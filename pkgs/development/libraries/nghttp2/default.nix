{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, openssl ? null, libev ? null, zlib ? null, jansson ? null, boost ? null
, libxml2 ? null, jemalloc ? null
}:

stdenv.mkDerivation rec {
  name = "nghttp2-${version}";
  version = "1.10.0";

  # Don't use fetchFromGitHub since this needs a bootstrap curl
  src = fetchurl {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.bz2";
    sha256 = "1m95j3lhxp6k16aa2m03rsky13nmj8ky1kk96cwl88vbsrliz4mh";
  };

  # Configure script searches for a symbol which does not exist in jemalloc on Darwin
  # Reported upstream in https://github.com/tatsuhiro-t/nghttp2/issues/233
  postPatch = if stdenv.isDarwin && jemalloc != null then ''
    substituteInPlace configure --replace "malloc_stats_print" "je_malloc_stats_print"
  '' else null;

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libev zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nghttp2.org/;
    description = "A C implementation of HTTP/2";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
