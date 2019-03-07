{ stdenv, fetchurl, python2Packages, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  name = "yoda-${version}";
  version = "1.7.4";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "0w9s3qv87hrmpq4dkrxcrl2hn2vcsbvy8ml99w85404wksw1dwrx";
  };

  pythonPath = []; # python wrapper support

  buildInputs = with python2Packages; [ python numpy matplotlib makeWrapper ]
    ++ stdenv.lib.optional withRootSupport root;
  propagatedBuildInputs = [ zlib ];

  enableParallelBuilding = true;

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license     = stdenv.lib.licenses.gpl3;
    homepage    = https://yoda.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
