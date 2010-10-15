{ stdenv, fetchurl, perl, texinfo }:

assert stdenv ? glibc;

let version = "0.9.25"; in
  stdenv.mkDerivation {
    name = "tinycc-${version}";

    src = fetchurl {
      url = "mirror://savannah/tinycc/tcc-${version}.tar.bz2";
      sha256 = "0dfycf80x73dz67c97j1ry29wrv35393ai5ry46i1x1fzfq6rv8v";
    };

    buildInputs = [ perl texinfo ];

    patchPhase = ''
      substituteInPlace "texi2pod.pl" \
        --replace "/usr/bin/perl" "${perl}/bin/perl"

      # To produce executables, `tcc' needs to know where `crt*.o' are.
      sed -i "tcc.c" \
        -e's|define CONFIG_TCC_CRT_PREFIX.*$|define CONFIG_TCC_CRT_PREFIX "${stdenv.glibc}/lib"|g ;
           s|tcc_add_library_path(s, "/usr/lib");|tcc_add_library_path(s, "${stdenv.glibc}/lib");|g'

      # Tell it about the loader's location.
      sed -i "tccelf.c" \
        -e's|".*/ld-linux\([^"]\+\)"|"${stdenv.glibc}/lib/ld-linux\1"|g'
    ''; # "

    postInstall = ''
      makeinfo --force tcc-doc.texi || true

      ensureDir "$out/share/info"
      mv tcc-doc.info* "$out/share/info"

      echo 'int main () { printf ("it works!\n"); exit(0); }' | \
         "$out/bin/tcc" -run -
    '';

    meta = {
      description = "TinyCC, a small, fast, and embeddable C compiler and interpreter";

      longDescription =
        '' TinyCC (aka TCC) is a small but hyper fast C compiler.  Unlike
           other C compilers, it is meant to be self-sufficient: you do not
           need an external assembler or linker because TCC does that for
           you.

           TCC compiles so fast that even for big projects Makefiles may not
           be necessary.

           TCC not only supports ANSI C, but also most of the new ISO C99
           standard and many GNU C extensions.

           TCC can also be used to make C scripts, i.e. pieces of C source
           that you run as a Perl or Python script.  Compilation is so fast
           that your script will be as fast as if it was an executable.

           TCC can also automatically generate memory and bound checks while
           allowing all C pointers operations.  TCC can do these checks even
           if non patched libraries are used.

           With libtcc, you can use TCC as a backend for dynamic code
           generation.
        '';

      homepage = http://www.tinycc.org/;
      license = "LGPLv2+";

      platforms = stdenv.lib.platforms.unix;
      maintainers = [ stdenv.lib.platforms.ludo ];
    };
  }
