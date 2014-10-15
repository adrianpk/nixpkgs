{ stdenv, fetchurl, lua5, luasocket, luasec, luaexpat, luafilesystem, libidn, openssl, makeWrapper }:

let
  libs        = [ luasocket luasec luaexpat luafilesystem ];
  getPath     = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath  = lib : getPath lib "lua";
  getLuaCPath = lib : getPath lib "so";
  luaPath     = stdenv.lib.concatStringsSep ";" (map getLuaPath  libs);
  luaCPath    = stdenv.lib.concatStringsSep ";" (map getLuaCPath libs);
in

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "prosody-${version}";
  src = fetchurl {
    url = "http://prosody.im/downloads/source/${name}.tar.gz";
    sha256 = "1gcvmdsyx3fjiqybgkp8vr847p9rlfz42lywxpph3jc14yh63z3n";
  };

  buildInputs = [ lua5 luasocket luasec luaexpat libidn openssl makeWrapper ];

  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${lua5}/include"
    "--with-lua=${lua5}"
  ];

  postInstall = ''
      wrapProgram $out/bin/prosody \
        --set LUA_PATH '"${luaPath};"' \
        --set LUA_CPATH '"${luaCPath};"'
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH '"${luaPath};"' \
        --set LUA_CPATH '"${luaCPath};"'
    '';

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = stdenv.lib.licenses.mit;
    homepage = http://www.prosody.im;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
