{ stdenv, dpkg, fetchurl }:

let
  generic = { version, sha256, suffix ? "" }:
  stdenv.mkDerivation rec {
    name = "unifi-controller-${version}";

    src = fetchurl {
      url = "https://dl.ubnt.com/unifi/${version}${suffix}/unifi_sysvinit_all.deb";
      inherit sha256;
    };

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src ./
      runHook postUnpack
    '';

    doConfigure = false;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cd ./usr/lib/unifi
      cp -ar dl lib webapps $out

      runHook postInstall
    '';

    meta = with stdenv.lib; {
      homepage = http://www.ubnt.com/;
      description = "Controller for Ubiquiti UniFi access points";
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [ wkennington ];
    };
  };

in rec {

  # https://help.ubnt.com/hc/en-us/articles/115000441548-UniFi-Current-Controller-Versions

  unifiLTS = generic {
    version = "5.6.39";
    sha256  = "025qq517j32r1pnabg2q8lhy65c6qsk17kzw3aijhrc2gpgj2pa7";
  };

  unifiStable = generic {
    version = "5.7.23";
    sha256  = "14jkhp9jl341zsyk5adh3g98mhqwfbd42c7wahzc31bxq8a0idp7";
  };

  unifiTesting = generic {
    version = "5.8.14";
    suffix  = "-7ef9535d1b";
    sha256  = "09gr7zkck6npjhhmd27c9ymyna6anwj3w9v9zjicz9skbrddkccq";
  };
}
