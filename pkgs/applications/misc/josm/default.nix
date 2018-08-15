{ fetchurl, stdenv, makeDesktopItem, makeWrapper, unzip, jre10 }:

stdenv.mkDerivation rec {
  name = "josm-${version}";
  version = "14066";

  src = fetchurl {
    url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
    sha256 = "06mhaz5vr19ydqc5irhgcbl0s8fifwvaq60iz2nsnlxb1pw89xia";
  };

  buildInputs = [ jre10 makeWrapper ];

  desktopItem = makeDesktopItem {
    name = "josm";
    exec = "josm";
    icon = "josm";
    desktopName = "JOSM";
    genericName = "OpenStreetMap Editor";
    comment = meta.description;
    categories = "Education;Geoscience;Maps;";
  };

  buildCommand = ''
    mkdir -p $out/bin $out/share/java
    cp -v $src $out/share/java/josm.jar

    makeWrapper ${jre10}/bin/java $out/bin/josm \
      --add-flags "-jar $out/share/java/josm.jar"

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    mkdir -p $out/share/pixmaps
    ${unzip}/bin/unzip -p $src images/logo_48x48x32.png > $out/share/pixmaps/josm.png
  '';

  meta = with stdenv.lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = https://josm.openstreetmap.de/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
