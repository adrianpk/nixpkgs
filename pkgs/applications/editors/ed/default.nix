{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ed-0.9";
  src = fetchurl {
    url = "mirror://gnu/ed/${name}.tar.bz2";
    sha256 = "1xy746g7ai9gmv6iq2x1ll8x6wy4fi9anfh7gj5ifsdnaiahgyi2";
  };

  meta = {
    description = "GNU ed, an implementation of the standard Unix stream editor";

    longDescription = ''
      GNU ed is a line-oriented text editor.  It is used to create,
      display, modify and otherwise manipulate text files, both
      interactively and via shell scripts.  A restricted version of ed,
      red, can only edit files in the current directory and cannot
      execute shell commands.  Ed is the "standard" text editor in the
      sense that it is the original editor for Unix, and thus widely
      available.  For most purposes, however, it is superseded by
      full-screen editors such as GNU Emacs or GNU Moe.
    '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/ed/;
  };
}
