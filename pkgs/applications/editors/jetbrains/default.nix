{ stdenv, callPackage, fetchurl, makeDesktopItem, makeWrapper, patchelf
, coreutils, gnugrep, which, git, python, unzip, p7zip
, androidsdk, jdk
}:

assert stdenv.isLinux;

let
  mkJetBrainsProduct = callPackage ./common.nix { };

  buildClion = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "CLion";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/clion/";
        inherit description license;
        longDescription = ''
          Enhancing productivity for every C and C++
          developer on Linux, OS X and Windows.
        '';
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildIdea = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "IDEA";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/idea/";
        inherit description license;
        longDescription = ''
          IDE for Java SE, Groovy & Scala development Powerful
          environment for building Google Android apps Integration
          with JUnit, TestNG, popular SCMs, Ant & Maven.
        '';
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildRubyMine = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "RubyMine";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/ruby/";
        inherit description license;
        longDescription = description;
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildPhpStorm = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "PhpStorm";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/phpstorm/";
        inherit description license;
        longDescription = ''
          PhpStorm provides an editor for PHP, HTML and JavaScript
          with on-the-fly code analysis, error prevention and
          automated refactorings for PHP and JavaScript code.
        '';
        maintainers = with maintainers; [ schristo ];
        platforms = platforms.linux;
      };
    });

  buildWebStorm = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "WebStorm";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/webstorm/";
        inherit description license;
        longDescription = ''
          WebStorm provides an editor for HTML, JavaScript (incl. Node.js),
          and CSS with on-the-fly code analysis, error prevention and
          automated refactorings for JavaScript code.
        '';
        maintainers = with maintainers; [ abaldeau ];
        platforms = platforms.linux;
      };
    });

  buildPycharm = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "PyCharm";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/pycharm/";
        inherit description license;
        longDescription = ''
          Python IDE with complete set of tools for productive
          development with Python programming language. In addition, the
          IDE provides high-class capabilities for professional Web
          development with Django framework and Google App Engine. It
          has powerful coding assistance, navigation, a lot of
          refactoring features, tight integration with various Version
          Control Systems, Unit testing, powerful all-singing
          all-dancing Debugger and entire customization. PyCharm is
          developer driven IDE. It was developed with the aim of
          providing you almost everything you need for your comfortable
          and productive development!
        '';
        maintainers = with maintainers; [ jgeerds ];
        platforms = platforms.linux;
      };
    }).override {
      propagatedUserEnvPkgs = [ python ];
    };

  buildDataGrip = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "DataGrip";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/datagrip/";
        inherit description license;
        longDescription = ''
          DataGrip is a new IDE from JetBrains built for database admins.
          It allows you to quickly migrate and refactor relational databases,
          construct efficient, statically checked SQL queries and much more.
        '';
        maintainers = with maintainers; [ loskutov ];
        platforms = platforms.linux;
      };
    });
in

{
  clion = buildClion rec {
    name = "clion-${version}";
    version = "2016.3.3";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "1zziyg0y51lfybflq83qwd94wcypkv4gh0cdkwfybbk4yidpnz05";
    };
    wmClass = "jetbrains-clion";
  };

  idea14-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "14.1.7";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1i4mdjm9dd6zvxlpdgd3bqg45ir0cfc9hl55cdc0hg5qwbz683fz";
    };
    wmClass = "jetbrains-idea-ce";
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2017.2.2"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "c719af3d538bef23d061ef62d4acbf503198ff62322a3c0c5b3c38ab7ac36c4f"; /* updated by script */
    };
    wmClass = "jetbrains-idea-ce";
  };

  idea14-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "14.1.7";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "1hhga1i2zbsipgq283gn19kv9n94inhr1bxh2yx19gz7yr4r49d2";
    };
    wmClass = "jetbrains-idea";
  };

  idea15-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "15.0.6";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "012aap2qn0jx4x34bdv9ivrsr86vvf683srb5vpj27hc4l6rw6ll";
    };
    wmClass = "jetbrains-idea";
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2017.2.2"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jdk.tar.gz";
      sha256 = "b8eb9d612800cc896eb6b6fbefbf9f49d92d2350ae1c3c4598e5e12bf93be401"; /* updated by script */
    };
    wmClass = "jetbrains-idea";
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "2016.3.1";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "10d1ba6qpizhz4d7fz0ya565pdvkgcmsdgs7b8dv98s9hxfjsldy";
    };
    wmClass = "jetbrains-rubymine";
  };

  ruby-mine7 = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "7.1.5";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "04fcxj1xlap9mxmwf051s926p2darlj5kwl4lms2gy5d8b2lhd5l";
    };
    wmClass = "jetbrains-rubymine";
  };

  ruby-mine8 = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "8.0.4";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "0hipxib7377232w1jbf8h98bmh0djkllsrq3lq0w3fdxqglma43a";
    };
    wmClass = "jetbrains-rubymine";
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "2017.2.2"; /* updated by script */
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "4eacc9bf512406bebf71546ccb4b6c14ea8e06748fd76be6ca409ea1955e1f53"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm-ce";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2017.2.2"; /* updated by script */
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "21aedfd189115fcfee0e8c8df88eccbd8f19b998667af3c55ce5d56d4eaa37a9"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2017.1.4";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0zrbcziznz6dwh56snr27752xcsnl2gsxzi6jiraplkd92f2xlaf";
    };
    wmClass = "jetbrains-phpstorm";
  };

  phpstorm10 = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "10.0.4";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0fi042zvjpg5pn2mnhj3bbrdkl1b9vmhpf2l6ca4nr0rhjjv7dsm";
    };
    wmClass = "jetbrains-phpstorm";
  };

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "2017.2.2"; /* updated by script */
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "d6b7b103f8543e25d2602657f12d029856529895af6354e1a0875ed40bd05180"; /* updated by script */
    };
    wmClass = "jetbrains-webstorm";
  };

  webstorm10 = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "10.0.5";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "0a5s6f99wyql5pgjl94pf4ljdbviik3b8dbr1s6b7c6jn1gk62ic";
    };
    wmClass = "jetbrains-webstorm";
  };

  webstorm11 = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "11.0.4";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "17agyqdyz6naxyx6p0y240ar93gja0ypw01nm2qmfzvh7ch03r24";
    };
    wmClass = "jetbrains-webstorm";
  };

  datagrip = buildDataGrip rec {
    name = "datagrip-${version}";
    version = "2016.3.2";
    description = "Your Swiss Army Knife for Databases and SQL";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/datagrip/${name}.tar.gz";
      sha256 = "19njb6i7nl6szql7cy99jmig59b304c6im3988p1dd8dj2j6csv3";
    };
    wmClass = "jetbrains-datagrip";
  };
}
