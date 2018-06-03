{ stdenv, fetchFromGitHub, python, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxslt, re2c }:

stdenv.mkDerivation rec {
  name = "ninja-${version}";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "ninja-build";
    repo = "ninja";
    rev = "v${version}";
    sha256 = "16scq9hcq6c5ap6sy8j4qi75qps1zvrf3p79j1vbrvnqzp928i5f";
  };

  nativeBuildInputs = [ python asciidoc docbook_xml_dtd_45 docbook_xsl libxslt.bin re2c ];

  buildPhase = ''
    python configure.py --bootstrap
    ./ninja manual
  '';

  installPhase = ''
    install -Dm555 -t $out/bin ninja
    install -Dm444 -t $out/share/doc/ninja doc/manual.asciidoc doc/manual.html
    install -Dm444 misc/bash-completion $out/share/bash-completion/completions/ninja
    install -Dm444 misc/zsh-completion $out/share/zsh/site-functions/_ninja
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Small build system with a focus on speed";
    longDescription = ''
      Ninja is a small build system with a focus on speed. It differs from
      other build systems in two major respects: it is designed to have its
      input files generated by a higher-level build system, and it is designed
      to run builds as fast as possible.
    '';
    homepage = https://ninja-build.org/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice bjornfor orivej ];
  };
}
