{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "1.2.4";

  src = fetchurl {
    urls = [
      "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz"
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz"
      "https://cocl.us/sbt-${version}.tgz"
    ];
    sha256 = "06zv1mm4rhl0h6qa7m4w5lbwjcyqp43r183q36q9zlyip965mnrn";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  installPhase = ''
    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -s $out/share/sbt/bin/sbt $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://www.scala-sbt.org/;
    license = licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ nequissimus rickynils ];
    platforms = platforms.unix;
  };
}
