{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ycva69bqssalhqg45rbrfipz3l6hmycszy26k0351fhq990c0xx";
  };

  # lots of networking failures
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/feedparser/;
    description = "Universal feed parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
