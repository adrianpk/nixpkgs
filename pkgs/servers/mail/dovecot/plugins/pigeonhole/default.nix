{ stdenv, fetchurl, dovecot, openssl }:

stdenv.mkDerivation rec {
  name = "dovecot-pigeonhole-${version}";
  version = "0.4.21";

  src = fetchurl {
    url = "http://pigeonhole.dovecot.org/releases/2.2/dovecot-2.2-pigeonhole-${version}.tar.gz";
    sha256 = "0snxrx9lk3j0rrcd4jlhwlqk4v31n1qfx2asgwb4scy5i2vrrq2a";
  };

  buildInputs = [ dovecot openssl ];

  preConfigure = ''
    substituteInPlace src/managesieve/managesieve-settings.c --replace \
      ".executable = \"managesieve\"" \
      ".executable = \"$out/libexec/dovecot/managesieve\""
    substituteInPlace src/managesieve-login/managesieve-login-settings.c --replace \
      ".executable = \"managesieve-login\"" \
      ".executable = \"$out/libexec/dovecot/managesieve-login\""
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--without-dovecot-install-dirs"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://pigeonhole.dovecot.org/;
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
