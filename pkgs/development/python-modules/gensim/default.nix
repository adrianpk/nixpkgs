{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, scipy
, smart_open
, scikitlearn
, testfixtures
, unittest2
}:

buildPythonPackage rec {
  pname = "gensim";
  name = "${pname}-${version}";
  version = "3.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "6b2a813887583e63c8cedd26a91782e5f1e416a11f85394a92ae3ff908e0be03";
  };

  propagatedBuildInputs = [ smart_open numpy six scipy
                            # scikitlearn testfixtures unittest2 # for tests
                          ];
  doCheck = false;

  # Two tests fail.

  # ERROR: testAddMorphemesToEmbeddings (gensim.test.test_varembed_wrapper.TestVarembed)
  # ImportError: Could not import morfessor.
  # This package is not in nix

  # ERROR: testWmdistance (gensim.test.test_fasttext_wrapper.TestFastText)
  # ImportError: Please install pyemd Python package to compute WMD.
  # This package is not in nix

  meta = {
    description = "Topic-modelling library";
    homepage = https://radimrehurek.com/gensim/;
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jyp ];
  };
}
