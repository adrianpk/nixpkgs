{ stdenv, fetchurl, fetchpatch, perl
, searchNixProfiles ? true
}:

stdenv.mkDerivation rec {
  name = "aspell-0.60.6.1";

  src = fetchurl {
    url = "mirror://gnu/aspell/${name}.tar.gz";
    sha256 = "1qgn5psfyhbrnap275xjfrzppf5a83fb67gpql0kfqv37al869gm";
  };

  patches = [
    (fetchpatch { # remove in >= 0.60.7
      name = "gcc-7.patch";
      url = "https://github.com/GNUAspell/aspell/commit/8089fa02122fed0a.diff";
      sha256 = "1b3p1zy2lqr2fknddckm58hyk95hw4scf6hzjny1v9iaic2p37ix";
    })
  ] ++ stdenv.lib.optional searchNixProfiles ./data-dirs-from-nix-profiles.patch;

  postPatch = ''
    patch interfaces/cc/aspell.h < ${./clang.patch}
  '';

  buildInputs = [ perl ];

  doCheck = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-pkglibdir=$out/lib/aspell
      --enable-pkgdatadir=$out/lib/aspell
    );
  '';

  meta = {
    description = "Spell checker for many languages";
    homepage = http://aspell.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = with stdenv.lib.platforms; all;
  };
}
