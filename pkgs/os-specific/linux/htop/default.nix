{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-${version}";
  version = "2.0.1";

  src = fetchurl {
    sha256 = "0rjn9ybqx5sav7z4gn18f1q6k23nmqyb6yydfgghzdznz9nn447l";
    url = "http://hisham.hm/htop/releases/${version}/${name}.tar.gz";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = http://htop.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rob simons relrod nckx ];
  };
}
