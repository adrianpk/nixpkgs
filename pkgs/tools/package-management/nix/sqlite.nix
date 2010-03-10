{ stdenv, fetchurl, aterm, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20493";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/316254/download/4/${name}.tar.bz2";
    sha256 = "da80ea3beaf9c6c62620850ff770202f43553a6719bb8046eb2be6ece4a26fec";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2} --with-sqlite=${sqlite}
    --disable-init-state
  '';

  doCheck = true;

  passthru = { inherit aterm; };

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
