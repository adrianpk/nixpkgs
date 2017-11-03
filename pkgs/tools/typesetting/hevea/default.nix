{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "hevea-2.31";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "15xrnnqlacz8dpr09h7jgijm65wss99rmy9mb1zmapplmwhavmzv";
  };

  buildInputs = with ocamlPackages; [ ocaml ocamlbuild ];

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = http://pauillac.inria.fr/~maranget/hevea/;
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
