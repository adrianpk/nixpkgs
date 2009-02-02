{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gnum4-1.4.12";

  src = fetchurl {
    url = mirror://gnu/m4/m4-1.4.12.tar.bz2;
    sha256 = "18qvi12843kvqkpcmrjxz1929s833q5d0jzm8hc965j663g1fll5";
  };

  doCheck = !stdenv.isDarwin;

  meta = {
    homepage = http://www.gnu.org/software/m4/;
    description = "GNU M4, a macro processor";

    longDescription = ''
      GNU M4 is an implementation of the traditional Unix macro
      processor.  It is mostly SVR4 compatible although it has some
      extensions (for example, handling more than 9 positional
      parameters to macros).  GNU M4 also has built-in functions for
      including files, running shell commands, doing arithmetic, etc.

      GNU M4 is a macro processor in the sense that it copies its
      input to the output expanding macros as it goes.  Macros are
      either builtin or user-defined and can take any number of
      arguments.  Besides just doing macro expansion, m4 has builtin
      functions for including named files, running UNIX commands,
      doing integer arithmetic, manipulating text in various ways,
      recursion etc...  m4 can be used either as a front-end to a
      compiler or as a macro processor in its own right.
    '';

    license = "GPLv3+";
  };

}
