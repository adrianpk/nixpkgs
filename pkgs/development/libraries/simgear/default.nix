x@{builderDefsPackage
  , plib, freeglut, xproto, libX11, libXext, xextproto, libXi , inputproto
  , libICE, libSM, libXt, libXmu, mesa, boost, zlib, libjpeg , freealut
  , openscenegraph, openal, expat, cmake, apr
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="simgear";
    version="2.12.1";
    name="${baseName}-${version}";
    extension="tar.bz2";
    url="http://mirrors.ibiblio.org/pub/mirrors/simgear/ftp/Source/${name}.${extension}";
    hash="0w8drzglgp01019frx96062qcigzfflsyq59f8shpwmzjb2hzli4";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = [ "doCmake" "doMakeInstall" ];

  meta = {
    description = "Simulation construction toolkit";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "ftp://ftp.goflyflightgear.com/simgear/Source/";
    };
  };
}) x

