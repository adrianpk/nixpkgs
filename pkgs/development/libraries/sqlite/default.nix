{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sqlite-2.8.16";

  src = fetchurl {
    url = http://www.sqlite.org/sqlite-2.8.16.tar.gz;
    md5 = "9c79b461ff30240a6f9d70dd67f8faea";
  };
}
