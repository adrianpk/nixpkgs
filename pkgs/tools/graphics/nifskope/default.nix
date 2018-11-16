{ stdenv, fetchFromGitHub, qmake, qtbase, qttools, substituteAll, libGLU, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nifskope-${version}";
  version = "2.0.dev7";

  src = fetchFromGitHub {
    owner = "niftools";
    repo = "nifskope";
    rev = "47b788d26ae0fa12e60e8e7a4f0fa945a510c7b2"; # `v${version}` doesn't work with submodules
    sha256 = "1wqpn53rkq28ws3apqghkzyrib4wis91x171ns64g8kp4q6mfczi";
    fetchSubmodules = true;
  };

  patches = [
    ./external-lib-paths.patch
    (substituteAll {
      src = ./qttools-bins.patch;
      qttools = "${qttools.dev}/bin";
    })
  ];

  buildInputs = [ qtbase qttools libGLU.dev makeWrapper ];
  nativeBuildInputs = [ qmake ];

  preConfigure = ''
    shopt -s globstar
    for i in **/*.cpp; do
      substituteInPlace $i --replace /usr/share/nifskope $out/share/nifskope
    done
  '';

  enableParallelBuilding = true;

  # Inspired by install/linux-install/nifskope.spec.in.
  installPhase = let
    qtVersion = "5.${stdenv.lib.versions.minor qtbase.version}";
  in ''
    runHook preInstall

    d=$out/share/nifskope
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $d/{shaders,lang}
    cp release/NifSkope $out/bin/
    cp ./res/nifskope.png $out/share/pixmaps/
    cp release/{nif.xml,kfm.xml,style.qss} $d/
    cp res/shaders/*.frag res/shaders/*.prog res/shaders/*.vert $d/shaders/
    cp ./res/lang/*.ts ./res/lang/*.tm $d/lang/
    cp ./install/linux-install/nifskope.desktop $out/share/applications

    substituteInPlace $out/share/applications/nifskope.desktop \
      --replace 'Exec=nifskope' "Exec=$out/bin/NifSkope" \
      --replace 'Icon=nifskope' "Icon=$out/share/pixmaps/nifskope.png"

    find $out/share -type f -exec chmod -x {} \;

    wrapProgram $out/bin/NifSkope --prefix QT_PLUGIN_PATH : "${qtbase}/lib/qt-${qtVersion}/plugins"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://niftools.sourceforge.net/wiki/NifSkope;
    description = "A tool for analyzing and editing NetImmerse/Gamebryo '*.nif' files";
    maintainers = with maintainers; [ eelco ma27 ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
