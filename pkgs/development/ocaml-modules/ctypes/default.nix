{stdenv, buildOcaml, fetchurl, libffi, pkgconfig, ncurses}:

buildOcaml rec {
  name = "ctypes";
  version = "0.11.2";

  minimumSupportedOcamlVersion = "4";

  src = fetchurl {
    url = "https://github.com/ocamllabs/ocaml-ctypes/archive/${version}.tar.gz";
    sha256 = "1ml80i8j5lpg3qwc074fks2hgxjq5cfdm9r6cznv605s05ajr3kh";
  };

  buildInputs = [ ncurses pkgconfig ];
  propagatedBuildInputs = [ libffi ];

  hasSharedObjects = true;

  buildPhase =  ''
     make XEN=false libffi.config ctypes-base ctypes-stubs
     make XEN=false ctypes-foreign
  '';

  installPhase =  ''
    make install XEN=false
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ocamllabs/ocaml-ctypes;
    description = "Library for binding to C libraries using pure OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
