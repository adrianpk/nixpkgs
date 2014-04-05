{ stdenv, fetchurl, cmake, qt4, perl, shared_mime_info, libvorbis, taglib
, flac, libsamplerate, libdvdread, lame, libsndfile, libmad, gettext
, kdelibs, kdemultimedia, automoc4, phonon, libkcddb ? null
, makeWrapper, cdrkit, cdrdao, dvdplusrwtools
}:

let
  runtimeDeps = [ cdrkit cdrdao dvdplusrwtools ];
in
stdenv.mkDerivation rec {
  name = "k3b-2.0.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/k3b/${name}.tar.bz2";
    sha256 = "1kdpylz3w9bg02jg4mjhqz8bq1yb4xi4fqfl9139qcyjq4lny5xg";
  };

  buildInputs =
    [ cmake qt4 perl shared_mime_info libvorbis taglib
      flac libsamplerate libdvdread lame libsndfile
      libmad gettext stdenv.gcc.libc
      kdelibs kdemultimedia automoc4 phonon
      libkcddb makeWrapper
    ]
    # Runtime dependencies are *not* propagated so they are easy to override.
    ++ runtimeDeps;

  enableParallelBuilding = true;

  postInstall =
    # Wrap k3b with PATH to required tools, so they can be found without being
    # installed in a profile. The PATH is suffixed so that profile-installed
    # tools take preference.
    let extraPath = stdenv.lib.makeSearchPath "bin" runtimeDeps;
    in ''
      wrapProgram "$out/bin/k3b" --suffix PATH : ${extraPath}
      wrapProgram "$out/bin/k3bsetup" --suffix PATH : ${extraPath}
    '';
                  
  meta = with stdenv.lib; {
    description = "CD/DVD Burning Application for KDE";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sander maintainers.urkud maintainers.phreedom ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
