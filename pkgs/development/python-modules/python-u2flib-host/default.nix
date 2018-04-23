{ stdenv, fetchPypi, buildPythonPackage, coverage, coveralls
, cryptography, hidapi
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "python-u2flib-host";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02pwafd5kyjpc310ys0pgnd0adff1laz18naxxwsfrllqafqnrxb";
  };

  buildInputs = [ coverage coveralls cryptography hidapi ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
