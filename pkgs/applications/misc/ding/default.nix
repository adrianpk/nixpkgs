{ aspell, aspellDicts_de, aspellDicts_en, buildEnv, fetchurl, fortune, gnugrep, makeWrapper, stdenv, tk, tre }:
let
  aspellEnv = buildEnv {
    name = "env-ding-aspell";
    paths = [
      aspell
      aspellDicts_de
      aspellDicts_en
    ];
  };
in
stdenv.mkDerivation rec {
  name = "ding-1.8.1";

  src = fetchurl {
    url = "http://ftp.tu-chemnitz.de/pub/Local/urz/ding/${name}.tar.gz";
    sha256 = "0chjqs3z9zs1w3l7b5lsaj682rgnkf9kibcbzhggqqcn1pbvl5sq";
  };

  buildInputs = [ aspellEnv fortune gnugrep makeWrapper tk tre ];

  patches = [ ./dict.patch ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/dict
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps

    for f in ding ding.1; do
      sed -i "s@/usr/share@$out/share@g" "$f"
    done

    sed -i "s@/usr/bin/fortune@fortune@g" ding

    sed -i "s@/usr/bin/ding@$out/bin/ding@g" ding.desktop

    cp -v ding $out/bin/
    cp -v de-en.txt $out/share/dict/
    cp -v ding.1 $out/share/man/man1/
    cp -v ding.png $out/share/pixmaps/
    cp -v ding.desktop $out/share/applications/

    wrapProgram $out/bin/ding --prefix PATH : ${stdenv.lib.makeBinPath [ gnugrep aspellEnv tk fortune ]} --prefix ASPELL_CONF : "\"prefix ${aspellEnv};\""
  '';

  meta = with stdenv.lib; {
    description = "Simple and fast dictionary lookup tool";
    homepage = https://www-user.tu-chemnitz.de/~fri/ding/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux; # homepage says: unix-like except darwin
    maintainers = [ maintainers.exi ];
  };
}
