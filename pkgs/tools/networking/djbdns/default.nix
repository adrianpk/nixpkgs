{ stdenv, fetchurl, glibc } :

let
  version = "1.05";

  manSrc = fetchurl {
    url = "http://smarden.org/pape/djb/manpages/djbdns-${version}-man-20031023.tar.gz";
    sha256 = "0sg51gjy6j1hnrra406q1qhf5kvk1m00y8qqhs6r0a699gqmh75s";
  };

in

stdenv.mkDerivation {
  name = "djbdns-${version}";

  src = fetchurl {
    url = "https://cr.yp.to/djbdns/djbdns-${version}.tar.gz";
    sha256 = "0j3baf92vkczr5fxww7rp1b7gmczxmmgrqc8w2dy7kgk09m85k9w";
  };

  patches = [ ./hier.patch ./fix-nix-usernamespace-build.patch ];

  postPatch = ''
    echo gcc -O2 -include ${glibc.dev}/include/errno.h > conf-cc
    echo $out > conf-home
    sed -i "s|/etc/dnsroots.global|$out/etc/dnsroots.global|" dnscache-conf.c
  '';

  installPhase = ''
    mkdir -pv $out/etc;
    make setup
    cd $out;
    tar xzvf ${manSrc};
    for n in 1 5 8; do
      mkdir -p man/man$n;
      mv -iv djbdns-man/*.$n man/man$n;
    done;
    rm -rv djbdns-man;
  '';

  meta = with stdenv.lib; {
    description = "A collection of Domain Name System tools";
    longDescription = "Includes software for all the fundamental DNS operations: DNS cache: finding addresses of Internet hosts; DNS server: publishing addresses of Internet hosts; and DNS client: talking to a DNS cache.";
    homepage = https://cr.yp.to/djbdns.html;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jerith666 ];
  };
}
