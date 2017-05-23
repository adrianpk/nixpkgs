{ stdenv, lib, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "0.9.1";
  scalaVersion = "2.12";

  src = fetchurl {
    url = "https://github.com/lihaoyi/Ammonite/releases/download/${version}/${scalaVersion}-${version}";
    sha256 = "0mc59hfic3211v4ai5zhis56hck9cpalf29pz0kl75wd7g9ymidv";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper ] ;

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/amm
    chmod +x $out/bin/amm
    wrapProgram $out/bin/amm --prefix PATH ":" ${jre}/bin ;
  '';

  meta = {
    description = "Improved Scala REPL";
    longDescription = ''
        The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
        It is much more featureful than the default REPL and comes
        with a lot of ergonomic improvements and configurability
        that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
    '';
    homepage = http://www.lihaoyi.com/Ammonite/;
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainer = [ lib.maintainers.nequissimus ];
  };
}
