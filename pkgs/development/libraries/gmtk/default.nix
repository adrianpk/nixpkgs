{stdenv, substituteAll, fetchFromGitHub, libtool, pkgconfig, intltool, glib, gtk3
, libpulseaudio, mplayer, gnome_mplayer }:

stdenv.mkDerivation rec {
  name = "gmtk-${version}";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "kdekorte";
    repo = "gmtk";
    rev = "v${version}";
    sha256 = "1zb5m1y1gckal3140gvx31572a6xpccwfmdwa1w5lx2wdq1pwk1i";
  };

  nativeBuildInputs = [ libtool pkgconfig intltool ];
  buildInputs = [ glib gtk3 libpulseaudio ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      mplayer = "${mplayer}/bin/mplayer";
    })
  ];

  meta = with stdenv.lib; {
    description = "Common functions for gnome-mplayer and gecko-mediaplayer";
    homepage = https://sites.google.com/site/kdekorte2/gnomemplayer;
    license = licenses.gpl2;
    maintainers = gnome_mplayer.meta.maintainers;
    platforms = platforms.linux;
  };
}
