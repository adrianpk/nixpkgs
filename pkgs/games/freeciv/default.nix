{ stdenv, fetchurl, zlib, bzip2, pkgconfig, curl, lzma, gettext, libiconv
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype, fluidsynth
, gtkClient ? false, gtk2
, server ? true, readline
, enableSqlite ? true, sqlite
}:

let
  inherit (stdenv.lib) optional optionals;

  name = "freeciv";
  version = "2.5.11";
in
stdenv.mkDerivation {
  name = "${name}-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/freeciv/${name}-${version}.tar.bz2";
    sha256 = "1bcs4mj4kzkpyrr0yryydmn0dzcqazvwrf02nfs7r5zya9lm572c";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib bzip2 curl lzma gettext libiconv ]
    ++ optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype fluidsynth ]
    ++ optionals gtkClient [ gtk2 ]
    ++ optional server readline
    ++ optional enableSqlite sqlite;

  configureFlags = [ "--enable-shared" ]
    ++ optional sdlClient "--enable-client=sdl"
    ++ optional enableSqlite "--enable-fcdb=sqlite3"
    ++ optional (!gtkClient) "--enable-fcmp=cli"
    ++ optional (!server) "--disable-server";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Multiplayer (or single player), turn-based strategy game";

    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';

    homepage = http://freeciv.wikia.com/;
    license = licenses.gpl2;

    maintainers = with maintainers; [ pierron ];
    platforms = platforms.unix;
  };
}
