{ fetchurl, stdenv, bison, flex, pam, sendmailPath ? "/run/wrappers/bin/sendmail" }:

stdenv.mkDerivation rec {
  name = "at-${version}";
  version = "3.1.20";

  src = fetchurl {
    # Debian is apparently the last location where it can be found.
    url = "mirror://debian/pool/main/a/at/at_${version}.orig.tar.gz";
    sha256 = "1fgsrqpx0r6qcjxmlsqnwilydhfxn976c870mjc0n1bkmcy94w88";
  };

  patches = [ ./install.patch ];

  buildInputs =
    [ bison flex pam ];

  preConfigure =
    ''
      export SENDMAIL=${sendmailPath}
      # Purity: force atd.pid to be placed in /var/run regardless of
      # whether it exists now.
      substituteInPlace ./configure --replace "test -d /var/run" "true"
    '';

  configureFlags =
    ''
       --with-etcdir=/etc/at
       --with-jobdir=/var/spool/atjobs --with-atspool=/var/spool/atspool
       --with-daemon_username=atd --with-daemon_groupname=atd
    '';

  meta = {
    description = ''The classical Unix `at' job scheduling command'';
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = https://packages.qa.debian.org/at;
    platforms = stdenv.lib.platforms.linux;
  };
}
