{ stdenv, fetchFromGitHub, pkgconfig, wrapGAppsHook
, help2man, lua5, luafilesystem, luajit, sqlite
, webkitgtk, gtk3, gst_all_1, glib-networking
}:

let
  lualibs = [luafilesystem];
  getPath       = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath    = lib : getPath lib "lua";
  getLuaCPath   = lib : getPath lib "so";
  luaPath       = stdenv.lib.concatStringsSep ";" (map getLuaPath lualibs);
  luaCPath      = stdenv.lib.concatStringsSep ";" (map getLuaCPath lualibs);

in stdenv.mkDerivation rec {
  pname = "luakit";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "luakit";
    repo = "luakit";
    rev = version;
    sha256 = "05mm76g72fs48410pbij4mw0s3nqji3r7f3mnr2fvhv02xqj05aa";
  };

  nativeBuildInputs = [
    pkgconfig help2man wrapGAppsHook
  ];

  buildInputs = [
    webkitgtk lua5 luafilesystem luajit sqlite gtk3
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    glib-networking # TLS support
  ];

  preBuild = ''
    # build-utils/docgen/gen.lua:2: module 'lib.lousy.util' not found
    # TODO: why is not this the default?
    LUA_PATH=?.lua
  '';

  makeFlags = [
    "DEVELOPMENT_PATHS=0"
    "USE_LUAJIT=1"
    "INSTALLDIR=${placeholder "out"}"
    "PREFIX=${placeholder "out"}"
    "USE_GTK3=1"
    "XDGPREFIX=${placeholder "out"}/etc/xdg"
  ];

  preFixup = let
    luaKitPath = "$out/share/luakit/lib/?/init.lua;$out/share/luakit/lib/?.lua";
  in ''
    gappsWrapperArgs+=(
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"
      --set LUA_PATH '${luaKitPath};${luaPath};'
      --set LUA_CPATH '${luaCPath};'
    )
  '';

  meta = with stdenv.lib; {
    description = "Fast, small, webkit based browser framework extensible in Lua";
    homepage    = http://luakit.org;
    license     = licenses.gpl3;
    platforms   = platforms.linux; # Only tested linux
  };
}
