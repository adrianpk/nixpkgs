{stdenv, fetchurl, aspell, which}:

let

  /* Function to compile an Aspell dictionary.  Fortunately, they all
     build in the exact same way. */
  buildDict =
    {shortName, fullName, src, postInstall ? ""}:

    stdenv.mkDerivation {
      name = "aspell-dict-${shortName}";

      inherit src;

      buildInputs = [aspell which];

      dontAddPrefix = true;

      preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

      inherit postInstall;

      meta = {
        description = "Aspell dictionary for ${fullName}";
        platforms = stdenv.lib.platforms.all;
      };
    };

in {

  de = buildDict {
    shortName = "de-20120607";
    fullName = "German";
    src = fetchurl {
      url = https://www.j3e.de/ispell/igerman98/dict/igerman98-20120607.tar.bz2;
      sha256 = "1m9jzxwrh0hwsrjs6l98v88miia45y643nbayzjjria2harq7yy5";
    };
  };
    
  en = buildDict {
    shortName = "en-7.1-0";
    fullName = "English";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/en/aspell6-en-7.1-0.tar.bz2;
      sha256 = "02ldfiny4iakgfgy4sdrzjqdzi7l1rmb6y30lv31kfy5x31g77gz";
    };
  };
    
  es = buildDict {
    shortName = "es-1.11-2";
    fullName = "Spanish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2;
      sha256 = "1k5g328ac1hdpp6fsg57d8md6i0aqcwlszp3gbmp5706wyhpydmd";
    };
  };
    
  eo = buildDict {
    shortName = "eo-2.1.20000225a-2";
    fullName = "Esperanto";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2;
      sha256 = "09vf0mbiicbmyb4bwb7v7lgpabnylg0wy7m3hlhl5rjdda6x3lj1";
    };
  };

  fr = buildDict {
    shortName = "fr-0.50-3";
    fullName = "French";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2;
      sha256 = "14ffy9mn5jqqpp437kannc3559bfdrpk7r36ljkzjalxa53i0hpr";
    };
  };
    
  it = buildDict {
    shortName = "it-2.2_20050523-0";
    fullName = "Italian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2;
      sha256 = "1gdf7bc1a0kmxsmphdqq8pl01h667mjsj6hihy6kqy14k5qdq69v";
    };
  };
    
  la = buildDict {
    shortName = "la-20020503-0";
    fullName = "Latin";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2;
      sha256 = "1199inwi16dznzl087v4skn66fl7h555hi2palx6s1f3s54b11nl";
    };
  };
    
  nl = buildDict {
    shortName = "nl-0.50-2";
    fullName = "Dutch";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2;
      sha256 = "0ffb87yjsh211hllpc4b9khqqrblial4pzi1h9r3v465z1yhn3j4";
    };
    # Emacs expects a language called "nederlands".
    postInstall = ''
      echo "add nl.rws" > $out/lib/aspell/nederlands.multi
    '';
  };
    
  pl = buildDict {
    shortName = "pl-6.0_20061121-0";
    fullName = "Polish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2;
      sha256 = "0kap4kh6bqbb22ypja1m5z3krc06vv4n0hakiiqmv20anzy42xq1";
    };
  };
     
  ru = buildDict {
    shortName = "ru-0.99f7-1";
    fullName = "Russian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2;
      sha256 = "0ip6nq43hcr7vvzbv4lwwmlwgfa60hrhsldh9xy3zg2prv6bcaaw";
    };
  };
    
}
