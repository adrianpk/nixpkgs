{ fetchurl, makeWrapper, patchelf, pkgs, stdenv, libXft, libX11, freetype, fontconfig, libXrender, libXScrnSaver, libXext }:

stdenv.mkDerivation rec {
  name = "gorilla-bin-${version}";
  version = "1.5.3.7";

  src = fetchurl {
    name = "gorilla1537_64.bin";
    url = "http://gorilla.dp100.com/downloads/gorilla1537_64.bin";
    sha256 = "19ir6x4c01825hpx2wbbcxkk70ymwbw4j03v8b2xc13ayylwzx0r";
  };

  buildInputs = [ patchelf makeWrapper ];
  phases = [ "unpackPhase" "installPhase" ];

  unpackCmd = ''
    mkdir gorilla;
    cp $curSrc gorilla/gorilla-${version};
  '';

  installPhase = let
    interpreter = "$(< \"$NIX_BINUTILS/nix-support/dynamic-linker\")";
    libPath = stdenv.lib.makeLibraryPath [ libXft libX11 freetype fontconfig libXrender libXScrnSaver libXext ];
  in ''
    mkdir -p $out/opt/password-gorilla
    mkdir -p $out/bin
    cp gorilla-${version} $out/opt/password-gorilla
    chmod ugo+x $out/opt/password-gorilla/gorilla-${version}
    patchelf --set-interpreter "${interpreter}" "$out/opt/password-gorilla/gorilla-${version}"
    makeWrapper "$out/opt/password-gorilla/gorilla-${version}" "$out/bin/gorilla" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = {
    description = "Password Gorilla is a Tk based password manager";
    homepage = https://github.com/zdia/gorilla/wiki;
    maintainers = [ stdenv.lib.maintainers.namore ];
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.gpl2;
  };
}
