{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "backports.shutil_which";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16sa3adkf71862cb9pk747pw80a2f1v5m915ijb4fgj309xrlhyx";
  };

  # Tests fail: "ValueError: underlying buffer has been detached"
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Backport of shutil.which from Python 3.3";
    homepage = https://github.com/minrk/backports.shutil_which;
    license = licenses.psfl;
    maintainers = with maintainers; [ jluttine ];
  };
}
