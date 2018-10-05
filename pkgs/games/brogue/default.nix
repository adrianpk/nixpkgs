{ stdenv, fetchurl, SDL, ncurses, libtcod }:

stdenv.mkDerivation rec {
  name = "brogue-${version}";
  version = "1.7.5";

  src = fetchurl {
    url = "https://sites.google.com/site/broguegame/brogue-${version}-linux-amd64.tbz2";
    sha256 = "0i042zb3axjf0cpgpdh8hvfn66dbfizidyvw0iymjk2n760z2kx7";
  };

  prePatch = ''
    sed -i Makefile -e 's,LIBTCODDIR=.*,LIBTCODDIR=${libtcod},g' \
                    -e 's,sdl-config,${SDL.dev}/bin/sdl-config,g'
    sed -i src/platform/tcod-platform.c -e "s,fonts/font,$out/share/brogue/fonts/font,g"
    make clean
    rm -rf src/libtcod*
  '';

  buildInputs = [ SDL ncurses libtcod ];

  installPhase = ''
    install -m 555 -D bin/brogue $out/bin/brogue
    mkdir -p $out/share/brogue
    cp -r bin/fonts $out/share/brogue/
  '';

  # fix crash; shouldn’t be a security risk because it’s an offline game
  hardeningDisable = [ "stackprotector" "fortify" ];

  meta = with stdenv.lib; {
    description = "A roguelike game";
    homepage = https://sites.google.com/site/broguegame/;
    license = licenses.agpl3;
    maintainers = [ maintainers.skeidel ];
    platforms = [ "x86_64-linux" ];
  };
}
