{ stdenv, fetchurl, pythonPackages, pkgconfig, SDL2
, libpng, ffmpeg, freetype, glew, libGLU_combined, fribidi, zlib
, glib
}:

with pythonPackages;

stdenv.mkDerivation rec {
  name = "renpy-${version}";
  version = "7.1.3";

  meta = with stdenv.lib; {
    description = "Ren'Py Visual Novel Engine";
    homepage = https://renpy.org/;
    license = licenses.mit;
    platforms = platforms.linux;
  };

  src = fetchurl {
    url = "https://www.renpy.org/dl/${version}/renpy-${version}-source.tar.bz2";
    sha256 = "0z6s1vzjb5jh0i79pv5kgynfrzqj1a1f3afrpmp2aaqbrljkidbn";
  };

  patches = [
    ./launcherenv.patch
  ];

  postPatch = ''
    substituteInPlace launcher/game/choose_directory.rpy --replace /usr/bin/python ${python.interpreter}
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python cython wrapPython tkinter
    SDL2 libpng ffmpeg freetype glew libGLU_combined fribidi zlib pygame_sdl2 glib
  ];

  pythonPath = [ pygame_sdl2 tkinter ];

  RENPY_DEPS_INSTALL = stdenv.lib.concatStringsSep "::" (map (path: "${path}") [
    SDL2 SDL2.dev libpng ffmpeg ffmpeg.out freetype glew.dev glew.out libGLU_combined fribidi zlib
  ]);

  buildPhase = ''
    python module/setup.py build
  '';

  installPhase = ''
    mkdir -p $out/share/renpy
    cp -vr * $out/share/renpy
    rm -rf $out/share/renpy/module

    python module/setup.py install --prefix=$out --install-lib=$out/share/renpy/module

    makeWrapper ${python}/bin/python $out/bin/renpy \
      --set PYTHONPATH $PYTHONPATH \
      --set RENPY_BASE $out/share/renpy \
      --add-flags "-O $out/share/renpy/renpy.py"
  '';

  NIX_CFLAGS_COMPILE = "-I${pygame_sdl2}/include/${python.libPrefix}";
}
