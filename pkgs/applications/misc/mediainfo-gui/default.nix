{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, libmediainfo, wxGTK
, desktop-file-utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "18.03.1";
  name = "mediainfo-gui-${version}";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "1mpwbqvw6awni5jq7i5yqvf6wgwjc37sl42q20rdq2agdlslqrkr";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libzen libmediainfo wxGTK desktop-file-utils libSM
                  imagemagick ];

  sourceRoot = "./MediaInfo/Project/GNU/GUI/";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = https://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.devhell ];
  };
}
