{ buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "py4j";

  version = "0.10.6";

  src = fetchPypi {
    inherit pname version;
    extension= "zip";
    sha256 = "10shayghsmcdr03w12a7sdm6vsxpjm8alw3ym3mr1hki45yarryk";
  };

  propagatedBuildInputs = [  ];

  meta = with stdenv.lib; {
    description = "Py4J enables Python programs running in a Python interpreter to dynamically access Java objects in a Java Virtual Machine. Methods are called as if the Java objects resided in the Python interpreter and Java collections can be accessed through standard Python collection methods. Py4J also enables Java programs to call back Python objects.";
    homepage = https://www.py4j.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.shlevy ];
  };
}
