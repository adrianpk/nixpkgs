{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg
, astring, fmt, fpath, logs, rresult
}:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-bos-${version}";
	version = "0.2.0";
	src = fetchurl {
		url = "http://erratique.ch/software/bos/releases/bos-${version}.tbz";
		sha256 = "1s10iqx8rgnxr5n93lf4blwirjf8nlm272yg5sipr7lsr35v49wc";
	};

	unpackCmd = "tar xjf $src";

	buildInputs = [ ocaml findlib ocamlbuild topkg ];
	propagatedBuildInputs = [ astring fmt fpath logs rresult ];

	inherit (topkg) buildPhase installPhase;

	meta = {
		description = "Basic OS interaction for OCaml";
		homepage = http://erratique.ch/software/bos;
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
