{
stdenv, fetchFromGitHub, cmake, makeWrapper
,qtbase, qttools, python, libGLU_combined
,libXt, qtx11extras, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name = "paraview-${version}";
  version = "5.4.1";

  # fetching from GitHub instead of taking an "official" source
  # tarball because of missing submodules there
  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "ParaView";
    rev = "v${version}";
    sha256 = "1ma02sdkz2apxnwcsyvxb26ibwnjh60p71gicw6nlp042acs6v74";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DPARAVIEW_ENABLE_PYTHON=ON"
    "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON"
    "-DPARAVIEW_ENABLE_EMBEDDED_DOCUMENTATION=OFF"
  ];

  # During build, binaries are called that rely on freshly built
  # libraries.  These reside in build/lib, and are not found by
  # default.
  preBuild = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    python
    python.pkgs.numpy
    libGLU_combined
    libXt
    qtbase
    qtx11extras
    qttools
    qtxmlpatterns
  ];

  # Paraview links into the Python library, resolving symbolic links on the way,
  # so we need to put the correct sitePackages (with numpy) back on the path
  postInstall = ''
    wrapProgram $out/bin/paraview \
      --set PYTHONPATH "${python.pkgs.numpy}/${python.sitePackages}"
    wrapProgram $out/bin/pvbatch \
      --set PYTHONPATH "${python.pkgs.numpy}/${python.sitePackages}"
    wrapProgram $out/bin/pvpython \
      --set PYTHONPATH "${python.pkgs.numpy}/${python.sitePackages}"
  '';

  meta = {
    homepage = http://www.paraview.org/;
    description = "3D Data analysis and visualization application";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric guibert];
    platforms = with stdenv.lib.platforms; linux;
  };
}
