{ stdenv
, fetchFromGitHub
, pcre
, pkgconfig
, check
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "r3";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "c9s";
    repo = "r3";
    rev = version;
    sha256 = "09cixbms817p6nb77wz3rxp0znnac8ybycvsrrzgwlbfn58a3zwl";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ pcre check ];

  strictDeps = true;

  meta = {
    description = "A high-performance path dispatching library";
    homepage = https://github.com/c9s/r3;
    license = [ stdenv.lib.licenses.mit ];
  };

}
