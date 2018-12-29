{ stdenv, lib, fetchFromGitHub,
  pkgconfig, autoreconfHook,
  flex, yacc, zlib, libxml2 }:

stdenv.mkDerivation rec {
  pname = "igraph";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = pname;
    rev = version;
    sha256 = "1wsy0r511gk069il6iqjs27q8cjvqz20gf0a7inybx1bw84845z8";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ flex yacc zlib libxml2 ];

  # This file is normally generated by igraph's bootstrap.sh, but we can do it
  # ourselves. ~ C.
  postPatch = ''
    echo "${version}" > VERSION
  '';

  meta = {
    description = "The network analysis package";
    homepage = http://igraph.org/;
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
