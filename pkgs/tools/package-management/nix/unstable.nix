{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc, perlPackages
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.1pre2714_2f3f413";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/2724747/download/4/${name}.tar.bz2";
    sha256 = "ec026709405dfcbff387418c007915711312ac574c046c38798990666bd339a6";
  };

  buildNativeInputs = [ perl pkgconfig ];

  buildInputs = [ curl openssl boehmgc sqlite ];

  # Note: bzip2 is not passed as a build input, because the unpack phase
  # would end up using the wrong bzip2 when cross-compiling.
  # XXX: The right thing would be to reinstate `--with-bzip2' in Nix.
  postUnpack =
    '' export CPATH="${bzip2}/include"
       export LIBRARY_PATH="${bzip2}/lib"
    '';

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir}
      --with-dbi=${perlPackages.DBI}/lib/perl5/site_perl
      --with-dbd-sqlite=${perlPackages.DBDSQLite}/lib/perl5/site_perl
      --disable-init-state
      --enable-gc
      CFLAGS=-O3 CXXFLAGS=-O3
    '';

  doInstallCheck = true;

  crossAttrs = {
    postUnpack =
      '' export CPATH="${bzip2.hostDrv}/include"
         export NIX_CROSS_LDFLAGS="-L${bzip2.hostDrv}/lib -rpath-link ${bzip2.hostDrv}/lib $NIX_CROSS_LDFLAGS"
      '';

    configureFlags =
      ''
        --with-store-dir=${storeDir} --localstatedir=${stateDir}
        --with-dbi=${perlPackages.DBI}/lib/perl5/site_perl
        --with-dbd-sqlite=${perlPackages.DBDSQLite}/lib/perl5/site_perl
        --disable-init-state
        --enable-gc
        CFLAGS=-O3 CXXFLAGS=-O3
      '' + stdenv.lib.optionalString (
          stdenv.cross ? nix && stdenv.cross.nix ? system
      ) ''--with-system=${stdenv.cross.nix.system}'';
    doInstallCheck = false;
  };

  enableParallelBuilding = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}
