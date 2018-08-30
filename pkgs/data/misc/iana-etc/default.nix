{ stdenv, fetchzip }:

let
  version = "20180711";
in fetchzip {
  name = "iana-etc-${version}";

  url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
  sha256 = "0vbgk3paix2v4rlh90a8yh1l39s322awng06izqj44zcg704fjbj";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    install -D -m0644 -t $out/etc services protocols
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Mic92/iana-etc;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
