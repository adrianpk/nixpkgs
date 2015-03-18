{ stdenv, fetchurl, python, asciidoc, re2c }:

stdenv.mkDerivation rec {
  name = "ninja-${version}";
  version = "1.5.3";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/martine/ninja/archive/v${version}.tar.gz";
    sha256 = "1h3yfwcfl61v493vna6jia2fizh8rpig7qw2504cvkr6gid3p5bw";
  };

  buildInputs = [ python asciidoc re2c ];

  buildPhase = ''
    python bootstrap.py
    asciidoc doc/manual.asciidoc
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ninja $out/bin/

    mkdir -p $out/share/doc/ninja
    cp doc/manual.asciidoc $out/share/doc/ninja/
    cp doc/manual.html $out/share/doc/ninja/
  '';

  meta = with stdenv.lib; {
    description = "Small build system with a focus on speed";
    longDescription = ''
      Ninja is a small build system with a focus on speed. It differs from
      other build systems in two major respects: it is designed to have its
      input files generated by a higher-level build system, and it is designed
      to run builds as fast as possible.
    '';
    homepage = http://martine.github.io/ninja/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.bjornfor ];
  };
}
