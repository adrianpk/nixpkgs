{ stdenv, fetchFromGitHub, cmake, zlib, boost,
  openal, glm, freetype, libGLU_combined, glew, SDL2,
  dejavu_fonts, inkscape, optipng, imagemagick }:

stdenv.mkDerivation rec {
  name = "arx-libertatis-${version}";
  version = "2017-10-30";

  src = fetchFromGitHub {
    owner  = "arx";
    repo   = "ArxLibertatis";
    rev    = "e5ea4e8f0f7e86102cfc9113c53daeb0bdee6dd3";
    sha256 = "11z0ndhk802jr3w3z5gfqw064g98v99xin883q1qd36jw96s27p5";
  };

  buildInputs = [
    cmake zlib boost openal glm
    freetype libGLU_combined glew SDL2 inkscape
    optipng imagemagick
  ];

  cmakeFlags = [
    "-DDATA_DIR_PREFIXES=$out/share"
    "-DImageMagick_convert_EXECUTABLE=${imagemagick.out}/bin/convert"
    "-DImageMagick_mogrify_EXECUTABLE=${imagemagick.out}/bin/mogrify"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      $out/share/games/arx/misc/dejavusansmono.ttf
  '';
  
  meta = with stdenv.lib; {
    description = ''
      A cross-platform, open source port of Arx Fatalis, a 2002
      first-person role-playing game / dungeon crawler
      developed by Arkane Studios.
    '';
    homepage = http://arx-libertatis.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.linux;
  };

}
