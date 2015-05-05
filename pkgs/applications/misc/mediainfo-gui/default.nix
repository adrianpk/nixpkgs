{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, libmediainfo, wxGTK, desktop_file_utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "0.7.73";
  name = "mediainfo-gui-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.bz2";
    sha256 = "14mbiy1xhj4nlp7hnfqvi518xn1f718b2vbl8xkjqr2sqjdf5jm7";
  };

  buildInputs = [ automake autoconf libtool pkgconfig libzen libmediainfo wxGTK desktop_file_utils libSM imagemagick ];

  sourceRoot = "./MediaInfo/Project/GNU/GUI/";

  preConfigure = "sh autogen";

  meta = {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
