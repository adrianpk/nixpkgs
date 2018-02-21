{ stdenv
, buildPythonPackage
, fetchPypi
, lxml
, networkx
, dateutil
, six
, pydotplus
, rdflib
}:

buildPythonPackage rec {
  pname = "prov";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "640dc158d931403bc6c1a0ad80702caae71f810bac21f90ec605865c8444b7bb";
  };

  propagatedBuildInputs = [
    lxml
    networkx
    dateutil
    six
    pydotplus
    rdflib
  ];
  doCheck = false; # takes ~60 mins

  meta = with stdenv.lib; {
    description = "A Python library for W3C Provenance Data Model (PROV)";
    homepage = https://github.com/trungdong/prov;
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
