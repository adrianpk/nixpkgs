args: with args;
stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "1.2310";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "3394bd1c9d0f3640803dc65ebbb42ee945db47e06f1a2b84ad257bad5e3c10f3";
  };

  buildInputs = [fuse pkgconfig];

  preConfigure="sed -e 's:/sbin:@sbindir@:' -i src/Makefile.in";
  configureFlags="--enable-shared --disable-static --disable-ldconfig --exec-prefix=\${prefix}";

  meta = {
    homepage = http://www.ntfs-3g.org;
    description = "FUSE-base ntfs driver with full write support";
  };
}
