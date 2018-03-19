{ lib, buildPythonPackage, fetchurl, arrow-cpp, cmake, cython, futures, numpy, pandas, pytest, pkgconfig, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "pyarrow";
  version = "0.8.0";

  src = fetchurl {
    url = "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "1i79sh9ip32agbrn4n51pjn9266i45s8spk5jsi8ax0hqy1vhhmi";
  };

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [ cmake cython pkgconfig setuptools_scm ];
  propagatedBuildInputs = [ futures numpy six ];
  checkInputs = [ pandas pytest ];

  PYARROW_BUILD_TYPE = "release";
  PYARROW_BUNDLE_ARROW_CPP = 1; # sets RPATH on darwin

  preBuild = ''
    substituteInPlace CMakeLists.txt --replace "''${ARROW_SO_VERSION}" '"0"'
  '';

  preCheck = ''
    rm pyarrow/tests/test_hdfs.py

    # fails: "ArrowNotImplementedError: Unsupported numpy type 22"
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_timedelta_with_nulls" "_disabled"

    # runs out of memory on @grahamcofborg linux box
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_large_dataframe" "_disabled"

    # probably broken on python2
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_unicode_filename" "_disabled"
  '';

  ARROW_HOME = arrow-cpp;

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = lib.licenses.asl20;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
