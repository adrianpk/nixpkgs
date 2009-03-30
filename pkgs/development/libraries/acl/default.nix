{stdenv, fetchurl, gettext, attr, libtool}:

stdenv.mkDerivation {
  name = "acl-2.2.47";

  src = fetchurl {
    # The SGI site throws away old versions, so don't use it.
    url = mirror://gentoo/distfiles/acl_2.2.47-1.tar.gz;
    sha256 = "1j39g62fki0iyji9s62slgwdfskpkqy7rmjlqcnmsvsnxbxhc294";
  };

  buildInputs = [gettext attr libtool];

  configureFlags = "MAKE=make LIBTOOL=libtool MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ZIP=gzip ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";

  meta = {
    homepage = ftp://oss.sgi.com/projects/xfs/cmd_tars/;
    description = "Library and tools for manipulating access control lists";
  };
}
