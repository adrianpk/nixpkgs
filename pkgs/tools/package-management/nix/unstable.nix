{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

let version = "0.12pre10069"; in

stdenv.mkDerivation {
  name = "nix-${version}";
  
  src = fetchurl {
    url = "http://nix.cs.uu.nl/dist/nix/nix-${version}/nix-${version}.tar.bz2";
    md5 = "bf05ebe9463f0453beae2c43f05ac13d";
  };

  buildInputs = [perl curl openssl];

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state";

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nix.cs.uu.nl/;
    license = "LGPL";
  };
}
