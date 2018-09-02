{ stdenv, skawarePackages }:

with skawarePackages;

let
  pname = "s6-portable-utils";

in buildPackage {
  pname = pname;
  version = "2.2.1.2";
  sha256 = "1zfanja5mbyafmzw28dlx1bb3fixa7lidbs62sxf849ly3z0zqp2";

  description = "A set of tiny general Unix utilities optimized for simplicity and small size";

  outputs = [ "bin" "dev" "doc" "out" ];

  configureFlags = [
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm seekablepipe

    mv doc $doc/share/doc/${pname}/html
  '';


}
