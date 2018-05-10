{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper
, lua52Packages, libXft, ncurses, ninja, readline, zlib }:

stdenv.mkDerivation rec {
  name = "wordgrinder-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    repo = "wordgrinder";
    owner = "davidgiven";
    rev = "${version}";
    sha256 = "19n4vn8zyvcvgwygm63d3jcmiwh6a2ikrrqqmkm8fvhdvwkqgr9k";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "LUA_INCLUDE=${lua52Packages.lua}/include"
    "LUA_LIB=${lua52Packages.lua}/lib/liblua.so"
  ] ++ stdenv.lib.optional stdenv.isLinux "XFT_PACKAGE=--libs=\{-lX11 -lXft\}";

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
    ninja
  ];

  buildInputs = [
    libXft
    lua52Packages.lua
    ncurses
    readline
    zlib
  ];

  # To be able to find <Xft.h>
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isLinux "-I${libXft.dev}/include/X11";

  # Binaries look for LuaFileSystem library (lfs.so) at runtime
  postInstall = ''
    wrapProgram $out/bin/wordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/xwordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '';

  meta = with stdenv.lib; {
    description = "Text-based word processor";
    homepage = https://cowlark.com/wordgrinder;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
