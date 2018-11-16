{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lombok-1.18.4";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/${name}.jar";
    sha256 = "0hlpycnmzd71ihn59hzf445dvwky2lkv57jimx91i6v7xcnr5wrr";
  };

  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/lombok.jar
  '';

  meta = {
    description = "A library that can write a lot of boilerplate for your Java project";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
    homepage = https://projectlombok.org/;
    maintainers = [ stdenv.lib.maintainers.CrystalGamma ];
  };
}
