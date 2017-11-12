{ stdenv, fetchurl, which, coq, coquelicot, flocq, mathcomp, bignums }:

let param =
  if stdenv.lib.versionAtLeast coq.coq-version "8.5"
  then {
    version = "3.3.0";
    url = "https://gforge.inria.fr/frs/download.php/file/37077/interval-3.3.0.tar.gz";
    sha256 = "08fdcf3hbwqphglvwprvqzgkg0qbimpyhnqsgv3gac4y1ap0f903";
  } else {
    version = "3.1.1";
    url = "https://gforge.inria.fr/frs/download.php/file/36723/interval-3.1.1.tar.gz";
    sha256 = "1sqsf075c7s98mwi291bhnrv5fgd7brrqrzx51747394hndlvfw3";
  };
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-interval-${param.version}";

  src = fetchurl {
    inherit (param) url sha256;
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq bignums ];
  propagatedBuildInputs = [ coquelicot flocq mathcomp ];

  configurePhase = "./configure --libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Interval";
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = with stdenv.lib; {
    homepage = http://coq-interval.gforge.inria.fr/;
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };
}
