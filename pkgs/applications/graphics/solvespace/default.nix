{ stdenv, fetchgit, cmake, pkgconfig, zlib, libpng, cairo, freetype
, json_c, fontconfig, gtkmm3, pangomm, glew, libGLU, xorg, pcre
, wrapGAppsHook
}:
stdenv.mkDerivation rec {
  name = "solvespace-2.3-20180906";
  rev = "258545a334098cf25c1c9f4cd59b778dfe0b0d29";
  src = fetchgit {
    url = https://github.com/solvespace/solvespace;
    inherit rev;
    sha256 = "1wimh6l0zpk0vywcsd2minijjf6g550z8i3l8lpmfnl5przymc2v";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig cmake wrapGAppsHook
  ];
  buildInputs = [
    zlib libpng cairo freetype
    json_c fontconfig gtkmm3 pangomm glew libGLU
    xorg.libpthreadstubs xorg.libXdmcp pcre
  ];
  enableParallelBuilding = true;

  preConfigure = ''
    patch CMakeLists.txt <<EOF
    @@ -20,9 +20,9 @@
     # NOTE TO PACKAGERS: The embedded git commit hash is critical for rapid bug triage when the builds
     # can come from a variety of sources. If you are mirroring the sources or otherwise build when
     # the .git directory is not present, please comment the following line:
    -include(GetGitCommitHash)
    +# include(GetGitCommitHash)
     # and instead uncomment the following, adding the complete git hash of the checkout you are using:
    -# set(GIT_COMMIT_HASH 0000000000000000000000000000000000000000)
    +set(GIT_COMMIT_HASH $rev)
    EOF
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/solvespace.desktop \
      --replace /usr/bin/ $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A parametric 3d CAD program";
    license = licenses.gpl3;
    maintainers = [ maintainers.edef ];
    platforms = platforms.linux;
    homepage = http://solvespace.com;
  };
}
