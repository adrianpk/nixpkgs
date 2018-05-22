{ stdenv, fetchurl, fetchpatch, ncurses, which, perl
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gnupg ? null
, gpgme ? null
, kerberos ? null
, headerCache  ? true
, sslSupport   ? true
, saslSupport  ? true
, smimeSupport ? false
, gpgSupport   ? false
, gpgmeSupport ? true
, imapSupport  ? true
, withSidebar  ? true
, gssSupport   ? true
}:

assert headerCache  -> gdbm       != null;
assert sslSupport   -> openssl    != null;
assert saslSupport  -> cyrus_sasl != null;
assert smimeSupport -> openssl    != null;
assert gpgSupport   -> gnupg      != null;
assert gpgmeSupport -> gpgme      != null && openssl != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mutt-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/${name}.tar.gz";
    sha256 = "0nskymwr2cdapxlfv0ysz3bjwhb4kcvl5a3c39237k7r1vwva582";
  };

  patches = optional smimeSupport (fetchpatch {
    url    = "https://sources.debian.net/src/mutt/1.7.2-1/debian/patches/misc/smime.rc.patch";
    sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
  });

  buildInputs =
    [ ncurses which perl ]
    ++ optional headerCache  gdbm
    ++ optional sslSupport   openssl
    ++ optional gssSupport   kerberos
    ++ optional saslSupport  cyrus_sasl
    ++ optional gpgmeSupport gpgme;

  configureFlags = [
    (enableFeature headerCache  "hcache")
    (enableFeature gpgmeSupport "gpgme")
    (enableFeature imapSupport  "imap")
    (enableFeature withSidebar  "sidebar")
    "--enable-smtp"
    "--enable-pop"
    "--with-mailpath="

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"

    # This allows calls with "-d N", that output debug info into ~/.muttdebug*
    "--enable-debug"

    # The next allows building mutt without having anything setgid
    # set by the installer, and removing the need for the group 'mail'
    # I set the value 'mailbox' because it is a default in the configure script
    "--with-homespool=mailbox"
  ] ++ optional sslSupport  "--with-ssl"
    ++ optional gssSupport  "--with-gss"
    ++ optional saslSupport "--with-sasl";

  postPatch = optionalString (smimeSupport || gpgmeSupport) ''
    sed -i 's#/usr/bin/openssl#${openssl}/bin/openssl#' smime_keys.pl
  '';

  postInstall = optionalString smimeSupport ''
    # S/MIME setup
    cp contrib/smime.rc $out/etc/smime.rc
    sed -i 's#openssl#${openssl}/bin/openssl#' $out/etc/smime.rc
    echo "source $out/etc/smime.rc" >> $out/etc/Muttrc
  '' + optionalString gpgSupport ''
    # GnuPG setup
    cp contrib/gpg.rc $out/etc/gpg.rc
    sed -i 's#\(command="\)gpg #\1${gnupg}/bin/gpg #' $out/etc/gpg.rc
    echo "source $out/etc/gpg.rc" >> $out/etc/Muttrc
  '';

  meta = {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny rnhmjoj ];
  };
}
