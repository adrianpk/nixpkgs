{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "sonarr-${version}";
  version = "2.0.0.5228";

  src = fetchurl {
    url = "https://download.sonarr.tv/v2/master/mono/NzbDrone.master.${version}.mono.tar.gz";
    sha256 = "0nys6livqzdn19f9qazs6w9mz35d1wj2f2fgcrccshrbwafrxdw1";
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    makeWrapper "${mono}/bin/mono" $out/bin/NzbDrone \
      --add-flags "$out/bin/NzbDrone.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = https://sonarr.tv/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
