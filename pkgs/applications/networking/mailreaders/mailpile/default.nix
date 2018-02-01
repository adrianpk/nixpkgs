{ stdenv, fetchFromGitHub, python2Packages, gnupg1orig, makeWrapper, openssl, git }:

python2Packages.buildPythonApplication rec {
  name = "mailpile-${version}";
  version = "1.0.0rc1";

  src = fetchFromGitHub {
    owner = "mailpile";
    repo = "Mailpile";
    rev = "${version}";
    sha256 = "0hl42ljdzk57ndndff9f1yh08znxwj01kjdmx019vmml0arv0jga";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = with python2Packages; [ pbr git ];
  PBR_VERSION=version;

  propagatedBuildInputs = with python2Packages; [
    appdirs
    cryptography
    fasteners
    gnupg1orig
    jinja2
    pgpdump
    pillow
    python2Packages.lxml
    spambayes
  ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg1orig openssl ]}" \
      --set-default MAILPILE_SHARED "$out/share/mailpile"
  '';

  # No tests were found
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
    knownVulnerabilities = [
      "Numerous and uncounted, upstream has requested we not package it. See more: https://github.com/NixOS/nixpkgs/pull/23058#issuecomment-283515104"
    ];
  };
}
