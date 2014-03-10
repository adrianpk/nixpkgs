{ stdenv, requireFile, xpwn }:

stdenv.mkDerivation rec {
  name = "xcode-${version}";
  version = "5.0.2";

  src = requireFile {
    name = "xcode_${version}.dmg";
    url = meta.homepage;
    sha256 = "0mrligqkfqwx8cy883pxm4w5w7a17nfh227zdspfll23r9agf32k";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  unpackCmd = let
    basePath = "Xcode.app/Contents/Developer/Platforms/MacOSX.platform";
    sdkPath = "${basePath}/Developer/SDKs";
  in ''
    ${xpwn}/bin/dmg extract "$curSrc" main.hfs > /dev/null
    ${xpwn}/bin/hfsplus main.hfs extractall "${sdkPath}" > /dev/null
  '';

  setSourceRoot = "sourceRoot=MacOSX10.9.sdk";

  installPhase = ''
    ensureDir "$out/share/sysroot"
    cp -a * "$out/share/sysroot/"
    ln -s "$out/usr/lib" "$out/lib"
    ln -s "$out/usr/include" "$out/include"
  '';

  meta = {
    homepage = "https://developer.apple.com/downloads/";
    description = "Apple's XCode SDK";
    license = stdenv.lib.licenses.unfree;
  };
}
