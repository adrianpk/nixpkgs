{ stdenv
, lib
, fetchurl
, unzip
, makeDesktopItem
, jre
}:

let
  desktopItem = makeDesktopItem {
    name = "jmol";
    exec = "jmol";
    desktopName = "JMol";
    genericName = "Molecular Modeler";
    mimeType = "chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;";
    categories = "Graphics;Education;Science;Chemistry;";
  };
in
stdenv.mkDerivation rec {
  version = "14.29.28";
  pname = "jmol";
  name = "${pname}-${version}";

  src = let 
    baseVersion = "${lib.versions.major version}.${lib.versions.minor version}";
  in fetchurl {
    url = "mirror://sourceforge/jmol/Jmol/Version%20${baseVersion}/Jmol%20${version}/Jmol-${version}-binary.tar.gz";
    sha256 = "0m72w5qsnsc07p7jjya78i4yz7zrdjqj8zpk65sa0xa2fh1y01g0";
  };

  patchPhase = ''
    sed -i -e "4s:.*:command=${jre}/bin/java:" -e "10s:.*:jarpath=$out/share/jmol/Jmol.jar:" -e "11,21d" jmol
  '';

  installPhase = ''
    mkdir -p "$out/share/jmol" "$out/bin"

    ${unzip}/bin/unzip jsmol.zip -d "$out/share/"

    cp *.jar jmol.sh "$out/share/jmol"
    cp -r ${desktopItem}/share/applications $out/share
    cp jmol $out/bin
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
     description = "A Java 3D viewer for chemical structures";
     homepage = https://sourceforge.net/projects/jmol;
     license = licenses.lgpl2;
     platforms = platforms.all;
     maintainers = with maintainers; [ timokau mounium ];
  };
}
