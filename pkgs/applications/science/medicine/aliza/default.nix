{ stdenv, fetchurl, rpmextract, makeWrapper, patchelf, qt4, zlib, libX11, libXt, libSM, libICE, libXext, mesa }:

with stdenv.lib;
stdenv.mkDerivation {
  name = "aliza";
  src = fetchurl {
    # Hosted on muoniurn's google drive
    url = "https://drive.google.com/uc?export=download&id=0B0s_Yf4jjfZ4RFgwRmxLX1VaVnM";
    sha256 = "0cakck4axfgzryh3w086p44ls90czjz65662mgdhfas1z4q5iibr";
    name = "aliza.rpm";
  };

  buildInputs = [ rpmextract makeWrapper ];

  unpackCmd = "rpmextract $curSrc";

  patchPhase = ''
    sed -i 's/^Exec.*$/Exec=aliza %F/' share/applications/aliza.desktop
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin share $out

    runHook postInstall
  '';

  postInstall = let
    libs = stdenv.lib.makeLibraryPath [ qt4 zlib stdenv.cc.cc libSM libICE libX11 libXext libXt mesa ];
  in ''
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/aliza

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/aliza-vtkvol

    wrapProgram $out/bin/aliza \
      --prefix LD_LIBRARY_PATH : ${libs}

    wrapProgram $out/bin/aliza-vtkvol \
      --prefix LD_LIBRARY_PATH : ${libs}
  '';

  meta = {
    description = "Medical imaging software with 2D, 3D and 4D capabilities";
    homepage = "http://www.aliza-dicom-viewer.com";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mounium ];
  };
}
