{stdenv, fetchurl, fuse, bison, flex, openssl, python, ncurses, readline}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.4.1";
    name="${baseName}-${version}";
    hash="0fdp3bifd7n20xlmsmj374pbp11k7np71f7ibzycsvmqqviv9wdm";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.1/glusterfs-3.4.1.tar.gz";
    sha256="0fdp3bifd7n20xlmsmj374pbp11k7np71f7ibzycsvmqqviv9wdm";
  };
  buildInputs = [
    fuse bison flex openssl python ncurses readline
  ];
in
stdenv.mkDerivation
rec {
  inherit (s) name version;
  inherit buildInputs;
  configureFlags = [
    ''--with-mountutildir="$out/sbin"''
    ];
  src = fetchurl {
    inherit (s) url sha256;
  };

  meta = {
    inherit (s) version;
    description = "Distributed storage system";
    maintainers = [
      stdenv.lib.maintainers.raskin
    ];
    platforms = with stdenv.lib.platforms; 
      linux ++ freebsd;
  };
}
