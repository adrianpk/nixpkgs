{ stdenv, fetchurl, python, utillinux, openssl_1_0_2, http-parser, zlib, libuv }:

let
  version = "3.0.0";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = "0maxxmr6y7z3y3r88nhcnfzmpvbhs5p8knyz886bh2shgzd6nzqf";
  };

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  configureFlags = [ "--shared-openssl" "--shared-http-parser" "--shared-zlib" "--shared-libuv" ];

  # iojs has --enable-static but no --disable-static. Automatically adding --disable-static
  # causes configure to fail, so don't add --disable-static.
  dontDisableStatic = true;

  buildInputs = [ python openssl_1_0_2 http-parser zlib libuv ] ++ (optional stdenv.isLinux utillinux);
  setupHook = ../nodejs/setup-hook.sh;

  passthru.interpreterName = "iojs";

  meta = {
    description = "A friendly fork of Node.js with an open governance model";
    homepage = https://iojs.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.havvy ];
  };
}
