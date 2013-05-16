{ stdenv, fetchurl, pkgconfig, intltool, flex, bison, autoconf, automake, libtool
, python, libxml2Python, file, expat, makedepend
, libdrm, xorg, wayland, udev, llvm, libffi
, libvdpau
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
, enableR600LlvmCompiler ? false
}:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in mesa_glu now).
    This or the mesa attribute (which also contains GLU) are small (< 3 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI and EGL drivers are compiled into $drivers output,
    which is bigger (~27 MB) and depends on LLVM (~80 MB).
    These should be searched at runtime in /run/current-system/sw/lib/*
    and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
*/

let
  version = "9.1.2";
  extraFeatures = true; # probably doesn't work with false yet
  driverLink = "/run/opengl-driver" + stdenv.lib.optionalString stdenv.isi686 "-32";
in
stdenv.mkDerivation {
  name = "mesa-noglu-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256="1ns366armqmp2bxj1l7fff95v22b5z9mnkyykbdj81lhg9gi3586"; # 9.1.2
  };

  prePatch = "patchShebangs .";

  patches = [
    ./static-gallium.patch
    ./dricore-gallium.patch
    ./fix-rounding.patch
  ];

  # Change the search path for EGL drivers from $drivers/* to driverLink
  postPatch = ''
    sed '/D_EGL_DRIVER_SEARCH_DIR=/s,EGL_DRIVER_INSTALL_DIR,${driverLink}/lib/egl,' \
      -i src/egl/main/Makefile.am
  '';

  outputs = ["out" "drivers"];

  preConfigure = "./autogen.sh";

  configureFlags = with stdenv.lib; [
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-egl-driver-dir=$(drivers)/lib/egl"
    "--with-dri-searchpath=${driverLink}/lib/dri"

    "--enable-dri"
    "--enable-glx-tls"
    "--enable-shared-glapi" "--enable-shared-gallium"
    "--enable-driglx-direct" # seems enabled anyway
    "--enable-gallium-llvm" "--with-llvm-shared-libs"

    "--with-dri-drivers=i965,r200,radeon"
    "--with-gallium-drivers=i915,nouveau,r300,r600,svga,swrast" # radeonsi complains about R600 missing in LLVM
    "--with-egl-platforms=x11,wayland,drm" "--enable-gbm" "--enable-shared-glapi"
  ]
    ++ optional enableR600LlvmCompiler "--enable-r600-llvm-compiler" # complains about R600 missing in LLVM
    ++ optional enableTextureFloats "--enable-texture-float"
    ++ optionals extraFeatures [
      "--enable-gles1" "--enable-gles2"
      "--enable-xa"
      "--enable-osmesa"
      "--enable-openvg" "--enable-gallium-egl" # not needed for EGL in Gallium, but OpenVG might be useful
      #"--enable-xvmc" # tests segfault with 9.1.{1,2}
      "--enable-vdpau"
      #"--enable-opencl" # ToDo: opencl seems to need libclc for clover
    ];

  nativeBuildInputs = [ pkgconfig python makedepend file flex bison ];

  buildInputs = with xorg; [
    autoconf automake libtool intltool expat libxml2Python udev llvm
    libdrm libXxf86vm libXfixes libXdamage glproto dri2proto libX11 libXext libxcb libXt
    libffi wayland
  ] ++ stdenv.lib.optionals extraFeatures [ /*libXvMC*/ libvdpau ];

  enableParallelBuilding = true;
  doCheck = true;

  # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
  # ToDo: probably not all .la files are completely fixed, but it shouldn't matter
  postInstall = ''
    mv -t "$drivers/lib/" \
      $out/lib/libdricore* \
      $out/lib/libgallium.* \
      $out/lib/gallium-pipe \
      $out/lib/gbm \
      $out/lib/libxatracker* \
      `#$out/lib/libXvMC*` \
      $out/lib/vdpau \
      $out/lib/libOSMesa*
  '' + /* now fix references in .la files */ ''
    sed "/^libdir=/s,$out,$drivers," -i \
      $drivers/lib/gallium-pipe/*.la \
      $drivers/lib/libgallium.la \
      $drivers/lib/libdricore*.la \
      `#$drivers/lib/libXvMC*.la` \
      $drivers/lib/vdpau/*.la \
      $drivers/lib/libOSMesa*.la
    sed "s,$out\(/lib/\(libdricore[0-9\.]*\|libgallium\).la\),$drivers\1,g" \
      -i $drivers/lib/*.la $drivers/lib/*/*.la
  '' + /* work around bug #529, but maybe $drivers should also be patchelf-ed */ ''
    find $drivers/ -type f -executable -print0 | xargs -0 strip -S || true
  '' + /* add RPATH so the drivers can find the moved libgallium and libdricore9 */ ''
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '';
  #ToDo: @vcunat isn't sure if drirc will be found when in $out/etc/, but it doesn't seem important ATM

  passthru = { inherit libdrm; inherit version; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
