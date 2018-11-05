{ stdenv, fetchurl, coq, ncurses, which
, graphviz, withDoc ? false
}:

let param =

  if stdenv.lib.versionAtLeast coq.coq-version "8.6" then
  {
    version = "1.7.0";
    sha256 = "05zgyi4wmasi1rcyn5jq42w0bi9713q9m8dl1fdgl66nmacixh39";
  }
  else if stdenv.lib.versionAtLeast coq.coq-version "8.5" then
  {
    version = "1.6.1";
    sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
  }
  else throw "No version of SSReflect is available for Coq ${coq.coq-version}";

in

stdenv.mkDerivation {

  name = "coq${coq.coq-version}-ssreflect-${param.version}";
  src = fetchurl {
    url = "https://github.com/math-comp/math-comp/archive/mathcomp-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq ncurses which ] ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ]);

  enableParallelBuilding = true;

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep || true
    cd mathcomp/ssreflect
    export COQBIN=${coq}/bin/
  '';

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  postInstall = stdenv.lib.optionalString withDoc ''
    mkdir -p $out/share/doc/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect/
    cp -r html $out/share/doc/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = with maintainers; [ vbgl jwiegley ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.5";
  };

}
