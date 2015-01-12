{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "capnproto-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "https://capnproto.org/capnproto-c++-${version}.tar.gz";
    sha256 = "01fsf60zlyc6rlhnrh8gd9jj5gs52ancb50ml3w7gwq55zgx2rf7";
  };

  meta = with stdenv.lib; {
    homepage    = "http://kentonv.github.io/capnproto";
    description = "Cap'n Proto cerealization protocol";
    longDescription = ''
      Cap’n Proto is an insanely fast data interchange format and
      capability-based RPC system. Think JSON, except binary. Or think Protocol
      Buffers, except faster.
    '';
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ cstrahan ];
  };
}
