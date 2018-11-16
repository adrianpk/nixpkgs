# This file was generated by https://github.com/kamilchm/go2nix v1.2.1
{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "ws-${version}";
  version = "0.2.1";
  rev = "e9404cb37e339333088b36f6a7909ff3be76931d";

  goPackagePath = "github.com/hashrocket/ws";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/hashrocket/ws";
    sha256 = "192slrz1cj1chzmfrl0d9ai8bq6s4w0iwpvxkhxb9krga7mkp9xb";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "websocket command line tool";
    homepage    = https://github.com/hashrocket/ws;
    license     = licenses.mit;
    maintainers = [ maintainers.the-kenny ];
    platforms   = platforms.unix;
  };
}
