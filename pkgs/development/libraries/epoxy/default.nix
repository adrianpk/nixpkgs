{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, utilmacros, python
, mesa_noglu, libX11
}:

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = "libepoxy";
    rev = "v${version}";
    sha256 = "0dfkd4xbp7v5gwsf6qwaraz54yzizf3lj5ymyc0msjn0adq3j5yl";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig utilmacros python ];
  buildInputs = [ mesa_noglu libX11 ];

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    substituteInPlace configure --replace build_glx=no build_glx=yes
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  '';

  # add mesa_nonglu to rpath because libepoxy dlopen()s libEGL
  postFixup = ''
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ mesa_noglu ]}:$(patchelf --print-rpath $out/lib/libepoxy.so.0.0.0)" $out/lib/libepoxy.so.0.0.0
  '';

  meta = with stdenv.lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
