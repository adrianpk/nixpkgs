{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.63";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "06iw95d3xpr9y5kbf889g4zvqlp7z68yabk3sjylbjdzapyqhgz6";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
  };
}
