{ stdenv, fetchzip, perl, pkgconfig, libbson
, openssl, which
}:

stdenv.mkDerivation rec {
  name = "mongoc-${version}";
  version = "1.8.0";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "1vnnk3pwbcmwva1010bl111kdcdx3yb2w7j7a78hhvrm1k9r1wp8";
  };

  propagatedBuildInputs = [ libbson ];
  buildInputs = [ openssl perl pkgconfig which ];

  meta = with stdenv.lib; {
    description = "The official C client library for MongoDB";
    homepage = "https://github.com/mongodb/mongo-c-driver";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
