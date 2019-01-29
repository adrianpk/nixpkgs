{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "5.0.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "00yznbrm9q04wgd4b831km8iwlvwvsnwv87igf79g5vj9yakr88q";
  };
  name = "libosip2-${version}";

  meta = {
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = https://www.gnu.org/software/osip/;
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
