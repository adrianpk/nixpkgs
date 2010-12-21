{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre25179";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/811883/download/4/${name}.tar.bz2";
    sha256 = "4a6f7ca69428d24f253f8f199589d25fca1e7146a6591288392423634e3303f7";
  };

  buildInputs = [ perl curl openssl pkgconfig boehmgc ];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-bzip2=${bzip2} --with-sqlite=${sqlite}
    --disable-init-state
    --enable-gc
    CFLAGS=-O3 CXXFLAGS=-O3
  '';

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}
