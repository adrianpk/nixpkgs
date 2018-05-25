{ stdenv, fetchFromGitHub, pkgs, python3Packages, glfw, libunistring, harfbuzz,
  fontconfig, zlib, pkgconfig, ncurses, imagemagick, makeWrapper, xsel,
  libstartup_notification, libX11, libXrandr, libXinerama, libXcursor,
  libxkbcommon, libXi, libXext }:

with python3Packages;
buildPythonApplication rec {
  version = "0.10.1";
  name = "kitty-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "1xwrrj0g70hh8zsjbd05x0js776xlf7c6mdsmrqlw4y7jfnlgl45";
  };

  buildInputs = [
    fontconfig glfw ncurses libunistring harfbuzz libX11
    libXrandr libXinerama libXcursor libxkbcommon libXi libXext
  ];

  nativeBuildInputs = [ pkgconfig ];

  postPatch = ''
    substituteInPlace kitty/utils.py \
      --replace "find_library('startup-notification-1')" "'${libstartup_notification}/lib/libstartup-notification-1.so'"
    '';

  buildPhase = ''
    python3 setup.py linux-package
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r linux-package/{bin,share,lib} $out
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${stdenv.lib.makeBinPath [ imagemagick xsel ]}"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kovidgoyal/kitty;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tex ];
  };
}
