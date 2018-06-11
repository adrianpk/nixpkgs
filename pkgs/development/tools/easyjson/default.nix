# This file was generated by https://github.com/kamilchm/go2nix v1.2.1
{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "easyjson-unstable-${version}";
  version = "2018-06-06";
  rev = "3fdea8d05856a0c8df22ed4bc71b3219245e4485";

  goPackagePath = "github.com/mailru/easyjson";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/mailru/easyjson";
    sha256 = "0g3crph77yhv4ipdnwqc32z4cp87ahi4ikad5kyy6q4znnxliz74";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for golang";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
