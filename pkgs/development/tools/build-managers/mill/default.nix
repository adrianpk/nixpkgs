{ stdenv, fetchurl, jre, makeWrapper }:
stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.3.5";

  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "19ka81f6vjr85gd8cadn0fv0i0qcdspx2skslfksklxdxs2gasf8";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "true";
  dontConfigure = true;
  dontBuild = true;
    
  installPhase = ''
    runHook preInstall
    install -Dm555 "$src" "$out/bin/.mill-wrapped"
    # can't use wrapProgram because it sets --argv0
    makeWrapper "$out/bin/.mill-wrapped" "$out/bin/mill" --prefix PATH : ${stdenv.lib.makeBinPath [ jre ]}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://www.lihaoyi.com/mill;
    license = licenses.mit;
    description = "A build tool for Scala, Java and more";
    longDescription = ''
      Mill is a build tool borrowing ideas from modern tools like Bazel, to let you build
      your projects in a way that's simple, fast, and predictable. Mill has built in
      support for the Scala programming language, and can serve as a replacement for
      SBT, but can also be extended to support any other language or platform via
      modules (written in Java or Scala) or through an external subprocesses.
    '';
    maintainers = with maintainers; [ scalavision ];
    platforms = stdenv.lib.platforms.all;
  };

}
