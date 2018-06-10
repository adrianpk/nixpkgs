{ stdenv, fetchurl, openssl, lzo, zlib, iproute, which, ronn }:

stdenv.mkDerivation rec {
  version = "1.2.8";
  name = "zerotierone-${version}";

  src = fetchurl {
    url = "https://github.com/zerotier/ZeroTierOne/archive/${version}.tar.gz";
    sha256 = "0iwaaicf3wa1xi20k2w18q01d0dlmf5w9akf227bcsqdalsdzqh8";
  };

  preConfigure = ''
      substituteInPlace ./osdep/LinuxEthernetTap.cpp \
        --replace 'execlp("ip",' 'execlp("${iproute}/bin/ip",'

      patchShebangs ./doc/build.sh
      substituteInPlace ./doc/build.sh \
        --replace '/usr/bin/ronn' '${ronn}/bin/ronn' \
        --replace 'ronn -r' '${ronn}/bin/ronn -r'
  '';

  buildInputs = [ openssl lzo zlib iproute which ronn ];

  installPhase = ''
    install -Dt "$out/bin/" zerotier-one
    ln -s $out/bin/zerotier-one $out/bin/zerotier-idtool
    ln -s $out/bin/zerotier-one $out/bin/zerotier-cli

    mkdir -p $man/share/man/man8
    for cmd in zerotier-one.8 zerotier-cli.1 zerotier-idtool.1; do
      cat doc/$cmd | gzip -9n > $man/share/man/man8/$cmd.gz
    done
  '';

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = https://www.zerotier.com;
    license = licenses.gpl3;
    maintainers = with maintainers; [ sjmackenzie zimbatm ehmry obadz ];
    platforms = platforms.x86_64 ++ platforms.aarch64;
  };
}
