{ stdenv, fetchurl, pkgconfig, glib, freetype, cairo, libintlOrEmpty
, icu, graphite2
, withIcu ? false # recommended by upstream as default, but most don't needed and it's big
, withGraphite2 ? true # it is small and major distros do include it
}:

# TODO: split non-icu and icu lib into different outputs?
# (icu is a ~30 MB dependency, the rest is very small in comparison)

stdenv.mkDerivation rec {
  name = "harfbuzz-1.0.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "1a0fxw4sb6p82lz407d2wy31wln08v839ln1lpxjqbsab2nsg89j";
  };

  outputs = [ "out" "doc" ];

  configureFlags = [
    ( "--with-graphite2=" + (if withGraphite2 then "yes" else "no") ) # not auto-detected by default
    ( "--with-icu=" +       (if withIcu       then "yes" else "no") )
  ];

  buildInputs = [ pkgconfig glib freetype cairo ] # recommended by upstream
    ++ libintlOrEmpty;
  propagatedBuildInputs = []
    ++ stdenv.lib.optional withGraphite2 graphite2
    ++ stdenv.lib.optional withIcu icu
    ;

  meta = {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
