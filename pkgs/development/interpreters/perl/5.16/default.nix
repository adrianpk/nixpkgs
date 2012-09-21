{ stdenv, fetchurl }:

let

  libc = if stdenv.gcc.libc or null != null then stdenv.gcc.libc else "/usr";

in

stdenv.mkDerivation rec {
  name = "perl-5.16.1";

  src = fetchurl {
    url = "mirror://cpan/src/${name}.tar.gz";
    sha256 = "15qxzba3a50c9nik5ydgyfp62x7h9vxxn12yd1jgl93hb1wj96km";
  };

  patches =
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
    ]
    ++ stdenv.lib.optional stdenv.isDarwin ./no-libutil.patch;

  # Build a thread-safe Perl with a dynamic libperls.o.  We need the
  # "installstyle" option to ensure that modules are put under
  # $out/lib/perl5 - this is the general default, but because $out
  # contains the string "perl", Configure would select $out/lib.
  # Miniperl needs -lm. perl needs -lrt.
  configureFlags =
    [ "-de"
      "-Dcc=gcc"
      "-Uinstallusrbinperl"
      "-Dinstallstyle=lib/perl5"
      "-Duseshrplib"
      "-Dlocincpth=${libc}/include"
      "-Dloclibpth=${libc}/lib"
    ]
    ++ stdenv.lib.optional (stdenv ? glibc) "-Dusethreads";

  configureScript = "${stdenv.shell} ./Configure";

  dontAddPrefix = true;

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureFlags="$configureFlags -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"

      ${stdenv.lib.optionalString stdenv.isArm ''
        configureFlagsArray=(-Dldflags="-lm -lrt")
      ''}
    '';

  preBuild = stdenv.lib.optionalString (!(stdenv ? gcc && stdenv.gcc.nativeTools))
    ''
      # Make Cwd work on NixOS (where we don't have a /bin/pwd).
      substituteInPlace dist/Cwd/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
    '';

  setupHook = ./setup-hook.sh;

  passthru.libPrefix = "lib/perl5/site_perl";
}
