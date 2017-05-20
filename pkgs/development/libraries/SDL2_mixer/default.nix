{ stdenv, lib, fetchurl, SDL2, libogg, libvorbis, smpeg, flac, enableNativeMidi ? false, fluidsynth ? null }:

stdenv.mkDerivation rec {
  name = "SDL2_mixer-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_mixer/release/${name}.tar.gz";
    sha256 = "0pv9jzjpcjlbiaybvwrb4avmv46qk7iqxlnqrd2dfj82c4mgc92s";
  };

  propagatedBuildInputs = [ SDL2 libogg libvorbis fluidsynth smpeg flac ];

  configureFlags = [ "--disable-music-ogg-shared" ] ++ lib.optional enableNativeMidi "--enable-music-native-midi-gpl";

  meta = with stdenv.lib; {
    description = "SDL multi-channel audio mixer library";
    platforms = platforms.linux;
    homepage = "https://www.libsdl.org/projects/SDL_mixer/";
    maintainers = with maintainers; [ MP2E ];
    license = licenses.zlib;
  };
}
