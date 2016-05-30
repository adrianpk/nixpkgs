{ stdenv, fetchurl, cmake, pkgconfig, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf
, pango, gettext, boost, freetype, libvorbis, fribidi, dbus, libpng, pcre
, enableTools ? false
}:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.13.4";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "1ys25ijwphld11002cad9iz5mc5rqazmjn8866l8gcdfrrhk943s";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf pango gettext boost
                  libvorbis fribidi dbus libpng pcre ];

  cmakeFlags = [ "-DENABLE_TOOLS=${if enableTools then "ON" else "OFF"}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = http://www.wesnoth.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
