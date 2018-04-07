/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as much code as the function itself. */

{pkgs, overrides}:

let self = _self // overrides; _self = with self; {

  inherit (pkgs) buildPerlPackage fetchurl fetchFromGitHub stdenv perl fetchsvn gnused;

  inherit (stdenv.lib) maintainers;

  # Helper functions for packages that use Module::Build to build.
  buildPerlModule = { buildInputs ? [], ... } @ args:
    buildPerlPackage (args // {
      buildInputs = buildInputs ++ [ ModuleBuild ];
      preConfigure = "touch Makefile.PL";
      buildPhase = "perl Build.PL --prefix=$out; ./Build build";
      installPhase = "./Build install";
      checkPhase = "./Build test";
    });


  ack = buildPerlPackage rec {
    name = "ack-2.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0v0gdv1ja12ks4yp1nb93z1lh14s869dr4mfjb3nkgw6pkdl3i02";
    };
    outputs = ["out" "man"];
    # use gnused so that the preCheck command passes
    buildInputs = stdenv.lib.optional stdenv.isDarwin gnused;
    propagatedBuildInputs = [ FileNext ];
    meta = with stdenv.lib; {
      description = "A grep-like tool tailored to working with large trees of source code";
      homepage    = http://betterthangrep.com/;
      license     = licenses.artistic2;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
    # tests fails on nixos and hydra because of different purity issues
    doCheck = false;
  };

  AlgorithmAnnotate = buildPerlPackage {
    name = "Algorithm-Annotate-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz;
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
  };

  AlgorithmC3 = buildPerlPackage rec {
    name = "Algorithm-C3-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "01hlcaxndls86bl92rkd3fvf9pfa3inxqaimv88bxs95803kmkss";
    };
    meta = {
      description = "A module for merging hierarchies using the C3 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmDiff = let version = "1.1903"; in buildPerlPackage {
    name = "Algorithm-Diff-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TY/TYEMQ/Algorithm-Diff-${version}.tar.gz";
      sha256 = "0l8pk7ziz72d022hsn4xldhhb9f5649j5cgpjdibch0xng24ms1h";
    };
    buildInputs = [ pkgs.unzip ];
  };

  AlgorithmMerge = buildPerlPackage rec {
    name = "Algorithm-Merge-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSMITH/Algorithm-Merge-0.08.tar.gz;
      sha256 = "1kqn13wd0lfjrf6h19b9kgdqqwp7k2d9yfq5i0wvii0xi8jqh1lw";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  aliased = buildPerlModule rec {
    name = "aliased-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1syyqzy462501kn5ma9gl6xbmcahqcn4qpafhsmpz0nd0x2m4l63";
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  asa = buildPerlPackage rec {
     name = "asa-1.03";
     src = fetchurl {
       url = mirror://cpan/authors/id/A/AD/ADAMK/asa-1.03.tar.gz;
       sha256 = "1w97m0gf3n9av61d0qcw7d1i1rac4gm0fd2ba5wyh53df9d7p0i2";
     };
     meta = {
       description = "Lets your class/object say it works like something else";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  AlienTidyp = buildPerlModule rec {
    name = "Alien-Tidyp-${version}";
    version = "1.4.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Alien-Tidyp-v${version}.tar.gz";
      sha256 = "0raapwp4155lqag1kzhsd20z4if10hav9wx4d7mc1xpvf7dcnr5r";
    };

    buildInputs = [ ArchiveExtract ];
    TIDYP_DIR = "${pkgs.tidyp}";
    propagatedBuildInputs = [ FileShareDir ];
  };

  AlienWxWidgets = buildPerlModule rec {
    name = "Alien-wxWidgets-0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "0jg2dmkzhj03f6b0vmv597yryfw9cclsdn9ynvvlrzzgpd5lw8jk";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig pkgs.gtk2 pkgs.wxGTK ModulePluggable ];
    buildInputs = [ LWPProtocolHttps ];
  };

  AnyEvent = buildPerlPackage rec {
    name = "AnyEvent-7.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "539358d225bad34b4a64f5217f8c2a707b15e3a28c74120c9dd2270c7cca7d2a";
    };
    buildInputs = [ CanaryStability ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventCacheDNS = buildPerlModule rec {
    name = "AnyEvent-CacheDNS-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/${name}.tar.gz";
      sha256 = "41c1faf183b61806b55889ceea1237750c1f61b9ce2735fdf33dc05536712dae";
    };
    propagatedBuildInputs = [ AnyEvent ];
    doCheck = false; # does an DNS lookup
    meta = {
      homepage = https://github.com/potyl/perl-AnyEvent-CacheDNS;
      description = "Simple DNS resolver with caching";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventHTTP = buildPerlPackage rec {
    name = "AnyEvent-HTTP-2.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "2e3376d03bfa5f172f43d4c615ba496281c9ffe3093a828c539683e17e2fbbcb";
    };
    propagatedBuildInputs = [ AnyEvent commonsense ];
  };

  AnyEventI3 = buildPerlPackage rec {
    name = "AnyEvent-I3-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/${name}.tar.gz";
      sha256 = "5382c984c9f138395f29f0c00af81aa0c8f4b765582055c73ede4b13f04a6d63";
    };
    propagatedBuildInputs = [ AnyEvent JSONXS ];
    meta = {
      description = "Communicate with the i3 window manager";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventRabbitMQ = buildPerlPackage rec {
    name = "AnyEvent-RabbitMQ-1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAMBLEY/${name}.tar.gz";
      sha256 = "a440ec2fa5a4018ad44739baaa9601cc460ad497282e89110ba8e3cf23312f0a";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyEvent DevelGlobalDestruction FileShareDir ListMoreUtils NetAMQP Readonly namespaceclean ];
    meta = {
      description = "An asynchronous and multi channel Perl AMQP client";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyMoose = buildPerlPackage rec {
    name = "Any-Moose-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0dc55mpayrixwx8dwql0vj0jalg4rlb3k64rprc84bl0z8vkx9m8";
    };
    propagatedBuildInputs = [ Moose Mouse ];
  };

  ApacheLogFormatCompiler = buildPerlModule rec {
    name = "Apache-LogFormat-Compiler-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "06i70ydxk2wa2rcqn16842kra2qz3jwk0vk1abq8lah4180c0m0n";
    };
    buildInputs = [ HTTPMessage ModuleBuildTiny TestMockTime TestRequires TryTiny URI ];
    propagatedBuildInputs = [ POSIXstrftimeCompiler ];
    # We cannot change the timezone on the fly.
    prePatch = "rm t/04_tz.t";
    meta = {
      homepage = https://github.com/kazeburo/Apache-LogFormat-Compiler;
      description = "Compile a log format string to perl-code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheSession = buildPerlModule {
    name = "Apache-Session-1.93";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Apache-Session-1.93.tar.gz;
      sha256 = "8e5a4882ac8ec657d1018d74d3ba37854e2688a41ddd0e1d73955ea59f276e8d";
    };
    buildInputs = [ TestDeep TestException ];
    meta = {
      description = "A persistence framework for session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheTest = buildPerlPackage {
    name = "Apache-Test-1.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/Apache-Test-1.40.tar.gz;
      sha256 = "0h5fsi0is6nhclsd3wwkkqx2hfgl3bpdazxycafm9sqxr3qkgx9w";
    };
    doCheck = false;
    meta = {
      description = "Test.pm wrapper with helpers for testing Apache";
      license = stdenv.lib.licenses.asl20;
    };
  };

  AppCLI = buildPerlPackage {
    name = "App-CLI-0.49";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PT/PTC/App-CLI-0.49.tar.gz;
      sha256 = "0gv4dcscxiacdrb9aqxc9mdl1w8wszicmg2q86zlz31ya5spjvv3";
    };
    propagatedBuildInputs = [ CaptureTiny ClassLoad ];
    buildInputs = [ TestKwalitee TestPod ];
  };

  AppCmd = buildPerlPackage rec {
    name = "App-Cmd-0.331";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4a5d3df0006bd278880d01f4957aaa652a8f91fe8f66e93adf70fba0c3ecb680";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CaptureTiny ClassLoad GetoptLongDescriptive IOTieCombine ModulePluggable StringRewritePrefix ];
    meta = {
      homepage = https://github.com/rjbs/App-Cmd;
      description = "Write command line apps with less suffering";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  AppConfig = buildPerlPackage rec {
    name = "AppConfig-1.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "03vvi3mk4833mx2c6dkm9zhvakf02mb2b7wz9pk9xc7c4mq04xqi";
    };
    meta = {
      description = "A bundle of Perl5 modules for reading configuration files and parsing command line arguments";
    };
    buildInputs = [ TestPod ];
  };

  AppFatPacker = buildPerlPackage rec {
     name = "App-FatPacker-0.010007";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MS/MSTROUT/App-FatPacker-0.010007.tar.gz;
       sha256 = "1g9nff9fdg7dvja0ix2yv32w5xcj963ybcf7x22j61g6r81845fi";
     };
     meta = {
       description = "pack your dependencies onto your script file";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  Appcpanminus = buildPerlPackage rec {
    name = "App-cpanminus-1.7043";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "68a06f7da80882a95bc02c92c7ee305846fb6ab648cf83678ea945e44ad65c65";
    };
    meta = {
      homepage = https://github.com/miyagawa/cpanminus;
      description = "Get, unpack, build and install modules from CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  Appperlbrew = buildPerlPackage rec {
    name = "App-perlbrew-0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GU/GUGOD/${name}.tar.gz";
      sha256 = "0p6l5i85zp89f5sh0gyz7didla672zg169yprbqcf97icmr46g80";
    };
    buildInputs = [ pkgs.curl FileWhich IOAll PathClass PodMarkdown TestException TestNoWarnings TestOutput TestSpec ];
    propagatedBuildInputs = [ CPANPerlReleases CaptureTiny DevelPatchPerl PodUsage locallib ];

    preConfigure = ''
      patchShebangs .
    '';

    doCheck = false;

    meta = {
      description = "Manage perl installations in your $HOME";
      license = stdenv.lib.licenses.mit;
    };
  };

  ArchiveAnyLite = buildPerlPackage rec {
     name = "Archive-Any-Lite-0.11";
     src = fetchurl {
       url = mirror://cpan/authors/id/I/IS/ISHIGAKI/Archive-Any-Lite-0.11.tar.gz;
       sha256 = "0w2i50fd81ip674zmnrb15nadw162fdpiw4rampbd94k74jqih8m";
     };
     propagatedBuildInputs = [ ArchiveZip ];
     buildInputs = [ ExtUtilsMakeMakerCPANfile TestUseAllModules ];
     meta = {
       description = "simple CPAN package extractor";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  AppSqitch = buildPerlModule rec {
    version = "0.9997";
    name = "App-Sqitch-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "985ade1a4181bef776016a287194711051e79c7a3c18f1ee1ec47e22ccf319d2";
    };
    buildInputs = [ CaptureTiny TestDeep TestDir TestException TestFile TestFileContents TestMockModule TestNoWarnings ];
    propagatedBuildInputs = [ Clone ConfigGitLike DBI DateTime EncodeLocale FileHomeDir HashMerge IOPager IPCRun3 IPCSystemSimple ListMoreUtils PathClass PerlIOutf8_strict StringFormatter StringShellQuote TemplateTiny Throwable TypeTiny URIdb libintl_perl ];
    doCheck = false;  # Can't find home directory.
    meta = {
      homepage = http://sqitch.org/;
      description = "Sane database change management";
      license = stdenv.lib.licenses.mit;
    };
  };

  AppSt = buildPerlPackage rec {
    name = "App-St-1.1.2";
    src = fetchurl {
      url = https://github.com/nferraz/st/archive/v1.1.2.tar.gz;
      sha256 = "1j1iwcxl16m4x5kl1vcv0linb93r55ndh3jm0w6qf459jl4x38s6";
    };
    postInstall =
      ''
        sed -e "1 s|\(.*\)|\1 -I $out/lib/perl5/site_perl|" -i $out/bin/st
        ($out/bin/st --help || true) | grep Usage
      '';
    meta = {
      description = "A command that computes simple statistics";
      license = stdenv.lib.licenses.mit;
      homepage = https://github.com/nferraz/st;
      maintainers = [ maintainers.eelco ];
    };
  };

  AttributeHandlers = buildPerlPackage {
    name = "Attribute-Handlers-0.99";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Attribute-Handlers-0.99.tar.gz;
      sha256 = "937ea3ebfc9b14f4a4148bf3c32803709edbd12a387137a26370b38ee1fc9835";
    };
    meta = {
      description = "Simpler definition of attribute handlers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AttributeParamsValidate = buildPerlPackage {
    name = "Attribute-Params-Validate-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Attribute-Params-Validate-1.21.tar.gz;
      sha256 = "586b939ceffdb37188b7c461dd1a8f9f35695184c8703b05c35f6d508c8090f5";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ParamsValidate ];
    doCheck = false;
    meta = {
      homepage = https://metacpan.org/release/Attribute-Params-Validate;
      description = "Define validation through subroutine attributes";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ArrayCompare = buildPerlModule rec {
    name = "Array-Compare-3.0.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-v3.0.1.tar.gz;
      sha256 = "0fyj6jdfshga4kj4567529a1aiqy49awxg62lslx54166j4mhkzb";
    };

    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ Moo TypeTiny ];
  };

  ArrayDiff = buildPerlPackage rec {
     name = "Array-Diff-0.07";
     src = fetchurl {
       url = mirror://cpan/authors/id/T/TY/TYPESTER/Array-Diff-0.07.tar.gz;
       sha256 = "0il3izx45wkh71fli2hvaq32jyin95k8x3qrnwby2x2c6yix7rvq";
     };
     propagatedBuildInputs = [ AlgorithmDiff ClassAccessor ];
     meta = {
       description = "Find the differences between two arrays";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  ArrayFIFO = buildPerlPackage rec {
    name = "Array-FIFO-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBURKE/${name}.tar.gz";
      sha256 = "8082b7ca456d02c7c862ba409cbd62a9cafdb8c5832f5d7fb1d37ba8698ee5b1";
    };
    buildInputs = [ TestDeep TestSpec TestTrap ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      homepage = https://github.com/dwburke/perl-Array-FIFO;
      description = "A Simple limitable FIFO array, with sum and average methods";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ListCompare = buildPerlPackage rec {
    name = "List-Compare-0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/${name}.tar.gz";
      sha256 = "fdbf4ff67b3135d44475fef7fcac0cd4706407d5720d26dca914860eb10f8550";
    };
    buildInputs = [ IOCaptureOutput ];
    meta = {
      homepage = http://thenceforward.net/perl/modules/List-Compare/;
      description = "Compare elements of two or more lists";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveCpio = buildPerlPackage rec {
    name = "Archive-Cpio-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PI/PIXEL/${name}.tar.gz";
      sha256 = "246fb31669764e78336b2191134122e07c44f2d82dc4f37d552ab28f8668bed3";
    };
    meta = {
      description = "Module for manipulations of cpio archives";
      # See https://rt.cpan.org/Public/Bug/Display.html?id=43597#txn-569710
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  ArchiveExtract = buildPerlPackage rec {
    name = "Archive-Extract-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "25cbc2d5626c14d39a0b5e4fe8383941e085c9a7e0aa873d86e81b6e709025f4";
    };
    propagatedBuildInputs = [ ModuleLoadConditional ];
    meta = {
      description = "Generic archive extracting mechanism";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveTar = buildPerlPackage rec {
    name = "Archive-Tar-2.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "01246ffbadb6e76a04a32bf689894cf56ef9d34d58101ff1c51af8f6f1ef5843";
    };
    meta = {
      description = "Manipulates TAR archives";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveZip = buildPerlPackage {
    name = "Archive-Zip-1.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Archive-Zip-1.60.tar.gz;
      sha256 = "02y2ylq83hy9kgj57sc0239x65br9sm98c0chsm61s08yc2mpiza";
    };
    buildInputs = [ TestMockModule ];
  };

  ArchiveZip_1_53 = buildPerlPackage {
    name = "Archive-Zip-1.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Archive-Zip-1.60.tar.gz;
      sha256 = "eac75b05f308e860aa860c3094aa4e7915d3d31080e953e49bc9c38130f5c20b";
    };
    meta = {
      description = "Provide an interface to ZIP archive files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestMockModule ];
  };

  AudioScan = buildPerlPackage rec {
    name = "Audio-Scan-0.99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "00092cjj89sp019b35fm3qiz4iczqznwa3yhx5jdkazlwjhlmmma";
    };
    buildInputs = [ pkgs.zlib TestWarn ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.zlib.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.zlib.out}/lib -lz";
    meta = {
      description = "Fast C metadata and tag reader for all common audio file formats";
      license = stdenv.lib.licenses.gpl2;
    };
  };

  AuthenDecHpwd = buildPerlModule rec {
    name = "Authen-DecHpwd-2.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "f43a93bb02b41f7327d92f9e963b69505f67350a52e8f50796f98afc4fb3f177";
    };
    propagatedBuildInputs = [ DataInteger DigestCRC ScalarString ];
    meta = {
      description = "DEC VMS password hashing";
      license = stdenv.lib.licenses.gpl1Plus;
    };
  };

  AuthenHtpasswd = buildPerlPackage rec {
    name = "Authen-Htpasswd-0.171";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Authen-Htpasswd-0.171.tar.gz;
      sha256 = "0rw06hwpxg388d26l0jvirczx304f768ijvc20l4b2ll7xzg9ymm";
    };
    propagatedBuildInputs = [ ClassAccessor CryptPasswdMD5 DigestSHA1 IOLockedFile ];
    meta = {
      description = "Interface to read and modify Apache .htpasswd files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenPassphrase = buildPerlModule rec {
    name = "Authen-Passphrase-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "55db4520617d859d88c0ee54965da815b7226d792b8cdc8debf92073559e0463";
    };
    propagatedBuildInputs = [ AuthenDecHpwd CryptDES CryptEksblowfish CryptMySQL CryptPasswdMD5 CryptUnixCryptXS DataEntropy DigestMD4 ModuleRuntime ];
    meta = {
      description = "Hashed passwords/passphrases as objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenRadius = buildPerlPackage rec {
    name = "Authen-Radius-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/PORTAONE/Authen-Radius-0.26.tar.gz;
      sha256 = "4f272c19b8a9f6514a1107e98efae6773208233df4db11f2dc4764b4784b17c3";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ DataHexDump NetIP ];
    meta = {
      description = "Provide simple Radius client facilities  ";
      license = with stdenv.lib.licenses; [ artistic2 ];
    };
  };

  AuthenSASL = buildPerlPackage rec {
    name = "Authen-SASL-2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/${name}.tar.gz";
      sha256 = "02afhlrdq5hh5g8b32fa79fqq5i76qzwfqqvfi9zi57h31szl536";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    meta = {
      description = "SASL Authentication framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenSimple = buildPerlPackage rec {
    name = "Authen-Simple-0.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/${name}.tar.gz";
      sha256 = "02cddab47f8bf1a1cbd4c9bf8d258f6d05111499c33f8315e7244812f72613aa";
    };
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable CryptPasswdMD5 ParamsValidate ];
    meta = {
      description = "Simple Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenSimplePasswd = buildPerlModule rec {
     name = "Authen-Simple-Passwd-0.6";
     src = fetchurl {
       url = mirror://cpan/authors/id/C/CH/CHANSEN/Authen-Simple-Passwd-0.6.tar.gz;
       sha256 = "1ckl2ry9r5nb1rcn1ik2l5b5pp1i3g4bmllsmzb0zpwy4lvbqmfg";
     };
     propagatedBuildInputs = [ AuthenSimple ];
     meta = {
       description = "Simple Passwd authentication";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  autobox = buildPerlPackage rec {
    name = "autobox-2.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/${name}.tar.gz";
      sha256 = "d0b8d0f27f3d1c1e8ef47f806fa06b9c229c3ca84057004fedc35dbbc0341140";
    };
    propagatedBuildInputs = [ ScopeGuard ];
    meta = {
      description = "Call methods on native types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Autobox = self.autobox;

  Autodia = buildPerlPackage rec {
    name = "Autodia-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEEJAY/${name}.tar.gz";
      sha256 = "08pl5y18nsvy8ihfzdsbd8rz6a8al09wqfna07zdjfdyib42b0dc";
    };
    propagatedBuildInputs = [ TemplateToolkit XMLSimple ];

    meta = {
      description = "AutoDia, create UML diagrams from source code";

      longDescription = ''
        AutoDia is a modular application that parses source code, XML or data
        and produces an XML document in Dia format (or images via graphviz
        and vcg).  Its goal is to be a UML / DB Schema diagram autocreation
        package.  The diagrams its creates are standard UML diagrams showing
        dependencies, superclasses, packages, classes and inheritances, as
        well as the methods, etc of each class.

        AutoDia supports any language that a Handler has been written for,
        which includes C, C++, Java, Perl, Python, and more.
      '';

      homepage = http://www.aarontrevena.co.uk/opensource/autodia/;
      license = stdenv.lib.licenses.gpl2Plus;

      maintainers = [ ];
    };
    buildInputs = [ DBI ];
  };

  autodie = null; # part of Perl

  AutoLoader = buildPerlPackage {
    name = "AutoLoader-5.74";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/AutoLoader-5.74.tar.gz;
      sha256 = "2fac75b05309f71a6871804cd25e1a3ba0a28f43f294fb54528077558da3aff4";
    };
    meta = {
      description = "Load subroutines only on demand";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  autovivification = buildPerlPackage rec {
    name = "autovivification-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "01giacr2sx6b9bgfz6aqw7ndcnf08j8n6kwhm7880a94hmb9g69d";
    };
    meta = {
      homepage = http://search.cpan.org/dist/autovivification/;
      description = "Lexically disable autovivification";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  base = buildPerlPackage {
    name = "base-2.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/base-2.23.tar.gz;
      sha256 = "40f55841299a9fe6fab03cd098f94e9221fb516978e9ef40fd8ff2cbd6625dde";
    };
  };

  BC = buildPerlPackage rec {
    name = "B-C-1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "d07e5af5fb798fcd3f4eda5e40744a14c1b3ef9e585a7dca55b5db31cb1d28d3";
    };
    propagatedBuildInputs = [ BFlags IPCRun Opcodes ];
    meta = {
      homepage = https://github.com/rurban/perl-compiler;
      description = "Perl compiler";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  BFlags = buildPerlPackage rec {
    name = "B-Flags-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "1chhgkaw2h3qniz71dykynggqp0r6b6mi2f4nh4x3ghm2g89gny1";
    };
    meta = {
      description = "Friendlier flags for B";
    };
  };

  BerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit buildPerlPackage fetchurl;
    inherit (pkgs) db;
  };

  BHooksEndOfScope = buildPerlPackage rec {
    name = "B-Hooks-EndOfScope-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0b70vbpabsy9ia366k330cz1zbdyb1pwhb0l7j28pmpih045iwwh";
    };
    propagatedBuildInputs = [ ModuleImplementation SubExporterProgressive ];
    meta = {
      homepage = https://metacpan.org/release/B-Hooks-EndOfScope;
      description = "Execute code after a scope finished compilation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksOPCheck = buildPerlPackage {
    name = "B-Hooks-OP-Check-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-OP-Check-0.22.tar.gz;
      sha256 = "1kfdv25gn6yik8jrwik4ajp99gi44s6idcvyyrzhiycyynzd3df7";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Wrap OP check callbacks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  bignum = buildPerlPackage rec {
    name = "bignum-0.49";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "28685b271251927d327851e5951e38649524a4e50cb0d1d35d649e2b814f212d";
    };
    meta = {
      description = "Transparent BigNumber support for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ MathBigInt ];
  };

  BitVector = buildPerlPackage {
    name = "Bit-Vector-7.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-7.4.tar.gz;
      sha256 = "09m96p8c0ipgz42li2ywdgy0vxb57mb5nf59j9gw7yzc3xkslv9w";
    };
    propagatedBuildInputs = [ CarpClan ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  BKeywords = buildPerlPackage rec {
    name = "B-Keywords-1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "0f5bb2fpbq5jzdb2jfs73hrggrq2gnpacd2kkxgifjl7q7xd9ck5";
    };
    meta = {
      description = "Lists of reserved barewords and symbol names";
      license = with stdenv.lib.licenses; [ artistic1 gpl2 ];
    };
  };

  boolean = buildPerlPackage rec {
    name = "boolean-0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "95c088085c3e83bf680fe6ce16d8264ec26310490f7d1680e416ea7a118f156a";
    };
    meta = {
      homepage = https://github.com/ingydotnet/boolean-pm;
      description = "Boolean support for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BoostGeometryUtils = buildPerlModule rec {
    name = "Boost-Geometry-Utils-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AA/AAR/${name}.tar.gz";
      sha256 = "1jnihz3029x51a455nxa0jx2z125x38q3vkkggsgdlrvawzxsm00";
    };
    patches = [
      # Fix out of memory error on Perl 5.19.4 and later.
      ../development/perl-modules/boost-geometry-utils-fix-oom.patch
    ];
    perlPreHook = "export LD=$CC";
    buildInputs = [ ExtUtilsCppGuess ExtUtilsTypemapsDefault ExtUtilsXSpp ModuleBuildWithXSpp ];
  };

  BSDResource = buildPerlPackage rec {
    name = "BSD-Resource-1.2911";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHI/BSD-Resource-1.2911.tar.gz;
      sha256 = "0g8c7825ng2m0yz5sy6838rvfdl8j3vm29524wjgf66ccfhgn74x";
    };
    meta = {
      maintainers = [ maintainers.limeytexan ];
      description = "BSD process resource limit and priority functions";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  BUtils = buildPerlPackage rec {
     name = "B-Utils-0.27";
     src = fetchurl {
       url = mirror://cpan/authors/id/E/ET/ETHER/B-Utils-0.27.tar.gz;
       sha256 = "1spzhmk3z6c4blmra3kn84nq20fira2b3vjg86m0j085lgv56zzr";
     };
     propagatedBuildInputs = [ TaskWeaken ];
     buildInputs = [ ExtUtilsDepends ];
     meta = {
       description = "Helper functions for op tree manipulation";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "http://search.cpan.org/dist/B-Utils";
     };
  };

  BusinessHours = buildPerlPackage rec {
    name = "Business-Hours-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RUZ/Business-Hours-0.12.tar.gz;
      sha256 = "15c5g278m1x121blspf4bymxp89vysizr3z6s1g3sbpfdkrn4gyv";
    };
    propagatedBuildInputs = [ SetIntSpan ];
    meta = {
      description = "Calculate business hours in a time period";
    };
  };

  BusinessISBN = buildPerlPackage rec {
    name = "Business-ISBN-3.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "07l3zfv8hagv37i3clvj5a1zc2jarr5phg80c93ks35zaz6llx9i";
    };
    propagatedBuildInputs = [ BusinessISBNData ];
    meta = {
      description = "Parse and validate ISBNs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISBNData = buildPerlPackage rec {
    name = "Business-ISBN-Data-20140910.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "1jc5jrjwkr6pqga7998zkgw0yrxgb5n1y7lzgddawxibkf608mn7";
    };
    meta = {
      description = "Data pack for Business::ISBN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISMN = buildPerlPackage rec {
    name = "Business-ISMN-1.131";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "1xyc7x4c4xl930rz7grs1l52f1vg4rbiv0c6xlxdsim8qsh7k94g";
    };
    propagatedBuildInputs = [ TieCycle ];
    meta = {
      description = "Work with International Standard Music Numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISSN = buildPerlPackage {
    name = "Business-ISSN-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Business-ISSN-0.91.tar.gz;
      sha256 = "f15b192c0f547bb2967811072b3d343b94bc5ea58d02704c19122f7ae0a9d6b5";
    };
    meta = {
      description = "Work with International Standard Serial Numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheCache = buildPerlPackage rec {
    name = "Cache-Cache-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Cache-Cache-1.08.tar.gz;
      sha256 = "1s6i670dc3yb6ngvdk48y6szdk5n1f4icdcjv2vi1l2xp9fzviyj";
    };
    propagatedBuildInputs = [ DigestSHA1 Error IPCShareLite ];
    doCheck = false; # randomly fails
  };

  CacheFastMmap = buildPerlPackage rec {
    name = "Cache-FastMmap-1.46";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.46.tar.gz;
      sha256 = "0061kwlbv398b2hb0kx1r6lmqf4kb6dnq9j4lsikczyk981sxs98";
    };
  };

  CacheMemcached = buildPerlPackage rec {
    name = "Cache-Memcached-1.30";
    src = fetchurl {
      url =
      mirror://cpan/authors/id/D/DO/DORMANDO/Cache-Memcached-1.30.tar.gz;
      sha256 = "1aa2mjn5767b13063nnsrwcikrnbspby7j1c5q007bzaq0gcbcri";
    };
    propagatedBuildInputs = [ StringCRC32 ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheMemcachedFast = buildPerlPackage {
    name = "Cache-Memcached-Fast-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAZ/Cache-Memcached-Fast-0.25.tar.gz;
      sha256 = "0ijw5hlzas1aprp3s6wzabch426m1d8cvp1wn9qphrn4jj82aakq";
    };
    meta = {
      description = "Perl client for B<memcached>, in C language";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheMemory = buildPerlModule {
    name = "Cache-2.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Cache-2.11.tar.gz;
      sha256 = "14m513f4g02daklmnvdm7vqh3w3ick65wvmvqnmnc4cqfybdilp1";
    };
    propagatedBuildInputs = [ DBFile FileNFSLock HeapFibonacci IOString TimeDate ];
    doCheck = false; # can time out
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheSimpleTimedExpiry = buildPerlPackage {
    name = "Cache-Simple-TimedExpiry-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Cache-Simple-TimedExpiry-0.27.tar.gz;
      sha256 = "4e78b7e4dd231b5571a48cd0ee1b63953f5e34790c9d020e1595a7c7d0abbe49";
    };
    meta = {
      description = "A lightweight cache with timed expiration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Cairo = buildPerlPackage rec {
    name = "Cairo-1.106";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1i25kks408c54k2zxskvg54l5k3qadzm8n72ffga9jy7ic0h6j76";
    };
    buildInputs = [ pkgs.cairo ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl interface to the cairo 2D vector graphics library";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig ];
  };

  cam_pdf = buildPerlModule rec {
    name = "CAM-PDF-1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CD/CDOLAN/${name}.tar.gz";
      sha256 = "12dv5ssf3y7yjz9mrrqnfzx8nf4ydk1qijf5fx59495671zzqsp7";
    };
    propagatedBuildInputs = [ CryptRC4 TextPDF ];
  };

  capitalization = buildPerlPackage rec {
     name = "capitalization-0.03";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MI/MIYAGAWA/capitalization-0.03.tar.gz;
       sha256 = "0g7fpckydzxsf8mjkfbyj0pv42dzym4hwbizqahnh7wlfbaicdgi";
     };
     propagatedBuildInputs = [ DevelSymdump ];
     meta = {
     };
  };

  CanaryStability = buildPerlPackage rec {
    name = "Canary-Stability-2012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "fd240b111d834dbae9630c59b42fae2145ca35addc1965ea311edf0d07817107";
    };
    meta = {
      license = stdenv.lib.licenses.gpl1Plus;
    };
  };

  CaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCaptcha-0.99";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SU/SUNNYP/Captcha-reCaptcha-0.99.tar.gz;
      sha256 = "14j3lk6fhfzda5d3d7z6f373ng3fzxazzwpjyziysrhic1v3b4mq";
    };
    propagatedBuildInputs = [ HTMLTiny LWP ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CaptureTiny = buildPerlPackage rec {
    name = "Capture-Tiny-0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "05bhlx6d4nzamhkkh0pkckg7wlvaq6mazf7q1fbb5wpp1j1nlyjx";
    };
    meta = {
      homepage = https://metacpan.org/release/Capture-Tiny;
      description = "Capture STDOUT and STDERR from Perl, XS or external programs";
      license = stdenv.lib.licenses.asl20;
    };
  };

  Carp = buildPerlPackage rec {
    name = "Carp-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "00bijwwc0ix27h2ma3lvsf3b56biar96bl9dikxgx7cmpcycxad5";
    };
    meta = with stdenv.lib; {
      description = "Alternative warn and die for modules";
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  CarpAlways = buildPerlPackage rec {
    name = "Carp-Always-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "0i2rifkr7ybfcdsqana52487z7vxp2l5qdra0f6ik0ddhn6rzii1";
    };
    meta = {
      description = "Warns and dies noisily with stack backtraces";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestBase ];
  };

  CarpAssert = buildPerlPackage {
    name = "Carp-Assert-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Carp-Assert-0.21.tar.gz;
      sha256 = "0km5fc6r6whxh6h5yd7g1j0bi96sgk0gkda6cardicrw9qmqwkwj";
    };
    meta = {
    };
  };

  CarpAssertMore = buildPerlPackage {
    name = "Carp-Assert-More-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Carp-Assert-More-1.16.tar.gz;
      sha256 = "1x9jd6s3lq97na6gz7g0zaq62l8z297xsfpdj2v42p3ijpfirl4f";
    };
    propagatedBuildInputs = [ CarpAssert ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      license = stdenv.lib.licenses.artistic2;
    };
    buildInputs = [ TestException ];
  };

  CarpClan = buildPerlPackage {
    name = "Carp-Clan-6.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/Carp-Clan-6.06.tar.gz;
      sha256 = "1m6902n6s627nsvyn2vyrk29q7lh6808hsdk7ka5cirm27vchjpa";
    };
    meta = {
      description = "Report errors from perspective of caller of a \"clan\" of modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestException ];
  };

  CatalystActionRenderView = buildPerlPackage rec {
    name = "Catalyst-Action-RenderView-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "8565203950a057d43ecd64e9593715d565c2fbd8b02c91f43c53b2111acd3948";
    };
    buildInputs = [ HTTPRequestAsCGI ];
    propagatedBuildInputs = [ CatalystRuntime DataVisitor MROCompat ];
    meta = {
      description = "Sensible default end action";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystActionREST = buildPerlPackage rec {
    name = "Catalyst-Action-REST-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-Action-REST-1.20.tar.gz;
      sha256 = "c0470541ec0016b837db3186ed77915813c8b856b941db89b86db8602e31ead6";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CatalystRuntime ClassInspector JSONMaybeXS MROCompat ModulePluggable Moose ParamsValidate URIFind namespaceautoclean ];
    meta = {
      description = "Automated REST Method Dispatching";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystAuthenticationCredentialHTTP = buildPerlPackage {
    name = "Catalyst-Authentication-Credential-HTTP-1.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Authentication-Credential-HTTP-1.015.tar.gz;
      sha256 = "02gyq0vkhj2psd7hvw4b095mvsz7vbq8kv4k8lq748jnx5kmnfrq";
    };
    buildInputs = [ TestException TestMockObject ];
    propagatedBuildInputs = [ CatalystPluginAuthentication CatalystRuntime ClassAccessorFast DataUUID StringEscape URI ];
    meta = {
      description = "HTTP Basic and Digest authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystAuthenticationStoreHtpasswd = buildPerlPackage rec {
    name = "Catalyst-Authentication-Store-Htpasswd-1.003";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "09mn0wjwfvnfi28y47g816nx50zdpvwvbxp0nrpsap0ir1m80wi3";
    };
    buildInputs = [ TestWWWMechanizeCatalyst Testuseok ];
    propagatedBuildInputs =
      [ CatalystPluginAuthentication ClassAccessor CryptPasswdMD5 AuthenHtpasswd HTMLForm ];
  };

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.1506";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Authentication-Store-DBIx-Class-0.1506.tar.gz;
      sha256 = "0i5ja7690fs9nhxcij6lw51j804sm8s06m5mvk1n8pi8jljrymvw";
    };
    propagatedBuildInputs = [ CatalystModelDBICSchema CatalystPluginAuthentication CatalystRuntime DBIxClass ListMoreUtils Moose namespaceautoclean TryTiny ];
    meta = {
      description = "A storage class for Catalyst Authentication using DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystComponentInstancePerContext = buildPerlPackage rec {
    name = "Catalyst-Component-InstancePerContext-0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "7f63f930e1e613f15955c9e6d73873675c50c0a3bc2a61a034733361ed26d271";
    };
    propagatedBuildInputs = [ CatalystRuntime Moose ];
    meta = {
      description = "Moose role to create only one instance of component per context";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystControllerHTMLFormFu = buildPerlPackage rec {
    name = "Catalyst-Controller-HTML-FormFu-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "84329b287716cdc6d3c5a9ee185458cd2ce7abd9d902eac1c6240ef17572f12c";
    };
    buildInputs = [ CatalystActionRenderView CatalystPluginSession CatalystPluginSessionStateCookie CatalystPluginSessionStoreFile CatalystViewTT TemplateToolkit TestAggregate TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystComponentInstancePerContext CatalystRuntime ConfigAny HTMLFormFu Moose MooseXAttributeChained RegexpAssemble TaskWeaken namespaceautoclean ];
    meta = {
      description = "Catalyst integration for HTML::FormFu";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystControllerPOD = buildPerlPackage rec {
    name = "Catalyst-Controller-POD-1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "ee2a4bb3ed78baa1464335408f284345b6ba0ef6576ad7bfbd7b656c788a39f9";
    };
    buildInputs = [ CatalystRuntime ModuleBuild ModuleInstall TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystPluginStaticSimple CatalystRuntime ClassAccessor FileShareDir FileSlurp JSONXS LWP ListMoreUtils PathClass PodPOM PodPOMViewTOC TestWWWMechanizeCatalyst XMLSimple ];
    meta = {
      homepage = http://search.cpan.org/dist/Catalyst-Controller-POD/;
      description = "Serves PODs right from your Catalyst application";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ maintainers.rycee ];
    };
  };

  CatalystDevel = buildPerlPackage rec {
    name = "Catalyst-Devel-1.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "bce371ba801c7d79eff3257e0af907cf62f140de968f0d63bf55be37d702a58a";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CatalystActionRenderView CatalystPluginConfigLoader CatalystPluginStaticSimple CatalystRuntime ConfigGeneral FileChangeNotify FileCopyRecursive FileShareDir ModuleInstall Moose MooseXDaemonize MooseXEmulateClassAccessorFast PathClass TemplateToolkit Starman namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "Catalyst Development Tools";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  CatalystDispatchTypeRegex = buildPerlModule rec {
    name = "Catalyst-DispatchType-Regex-5.90035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MG/MGRIMES/${name}.tar.gz";
      sha256 = "06jq1lmpq88rmp9zik5gqczg234xac0hiyc3l698iif7zsgcyb80";
    };
    propagatedBuildInputs = [ Moose TextSimpleTable ];
    meta = {
      description = "Regex DispatchType";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystEngineHTTPPrefork = buildPerlPackage rec {
    name = "Catalyst-Engine-HTTP-Prefork-0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "1ygmrzc9akjaqfxid8br11ajj9qgfvhkimakcv4ffk4s5v7q2sii";
    };
    propagatedBuildInputs = [
      CatalystRuntime HTTPBody NetServer
      CookieXS HTTPHeaderParserXS
    ];
    buildInputs = [TestPod TestPodCoverage];
    patches = [
      # Fix chunked transfers (they were missing the final CR/LF at
      # the end, which makes curl barf).
      ../development/perl-modules/catalyst-fix-chunked-encoding.patch
    ];

    meta = {
      # Depends on some old version of Catalyst-Runtime that contains
      # Catalyst::Engine::CGI. But those version do not compile.
      broken = true;
    };
  };

  CatalystManual = buildPerlPackage rec {
    name = "Catalyst-Manual-5.9009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1z6l0vdjxzisqgb5w447m3m73sfvkhwm7qw2l1dpcdng3zaypllh";
    };
    meta = {
      description = "The Catalyst developer's manual";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystModelDBICSchema = buildPerlPackage {
    name = "Catalyst-Model-DBIC-Schema-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBJK/Catalyst-Model-DBIC-Schema-0.65.tar.gz;
      sha256 = "26a911ef5ef7ffc81b6ce65c3156f71fb35083c456ad27e6d82d2dc02493eeea";
    };
    buildInputs = [ DBDSQLite TestException TestRequires ];
    propagatedBuildInputs = [ CarpClan CatalystComponentInstancePerContext CatalystRuntime CatalystXComponentTraits DBIxClass DBIxClassSchemaLoader HashMerge ListMoreUtils ModuleRuntime Moose MooseXMarkAsMethods MooseXNonMoose MooseXTypes MooseXTypesLoadableClass TieIxHash TryTiny namespaceautoclean namespaceclean ];
    meta = {
      description = "DBIx::Class::Schema Model Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystRuntime = buildPerlPackage rec {
    name = "Catalyst-Runtime-5.90104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "91d551944beb3a0ae8635c78d5f2e1583ef1e7873d5c8ee407e2f64380ad870b";
    };
    buildInputs = [ DataDump HTTPMessage IOstringy JSONMaybeXS TestFatal TypeTiny ];
    propagatedBuildInputs = [ CGISimple CGIStruct ClassC3AdoptNEXT ClassDataInheritable ClassLoad DataDump DataOptList HTMLParser HTTPBody HTTPMessage HTTPRequestAsCGI HashMultiValue JSONMaybeXS LWP ListMoreUtils MROCompat ModulePluggable Moose MooseXEmulateClassAccessorFast MooseXGetopt MooseXMethodAttributes MooseXRoleWithOverloading PathClass Plack PlackMiddlewareFixMissingBodyInRedirect PlackMiddlewareMethodOverride PlackMiddlewareRemoveRedundantBody PlackMiddlewareReverseProxy PlackTestExternalServer SafeIsa StreamBuffered StringRewritePrefix SubExporter TaskWeaken TextSimpleTable TreeSimple TreeSimpleVisitorFactory TryTiny URI URIws namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "The Catalyst Framework Runtime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  CatalystPluginAccessLog = buildPerlPackage rec {
    name = "Catalyst-Plugin-AccessLog-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/${name}.tar.gz";
      sha256 = "873db8e4e72a994e3e17aeb53d2b837e6d524b4b8b0f3539f262135c88cc2120";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime Moose namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/Catalyst-Plugin-AccessLog;
      description = "Request logging from within Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthentication = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authentication-0.10023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "0v6hb4r1wv3djrnqvnjcn3xx1scgqzx8nyjdg9lfc1ybvamrl0rn";
    };
    buildInputs = [ ClassMOP Moose TestException ];
    propagatedBuildInputs = [ CatalystPluginSession CatalystRuntime ClassInspector Moose MooseXEmulateClassAccessorFast MROCompat namespaceautoclean StringRewritePrefix TryTiny ];
    meta = {
      description = "Infrastructure plugin for the Catalyst authentication framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthorizationACL = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authorization-ACL-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "0z4328rr6l9xi45hyv6q9pwwamp0864q6skcp29jrz9f919ycdra";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassThrowable ];
  };

  CatalystPluginAuthorizationRoles = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-Roles-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authorization-Roles-0.09.tar.gz;
      sha256 = "0l83lkwmq0lngwh8b1rv3r719pn8w1gdbyhjqm74rnd0wbjl8h7f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ CatalystPluginAuthentication CatalystRuntime SetObject UNIVERSALisa ];
    meta = {
      description = "Role based authorization for Catalyst based on Catalyst::Plugin::Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginCache = buildPerlPackage {
    name = "Catalyst-Plugin-Cache-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Cache-0.12.tar.gz;
      sha256 = "1q23aipvrl888h06ldr4mmjbykz0j4rqwipxg1jv094kki2fspr9";
    };
    buildInputs = [ TestDeep TestException ];
    propagatedBuildInputs = [ CatalystRuntime MROCompat TaskWeaken ];
    meta = {
      description = "Flexible caching support for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginCacheHTTP = buildPerlPackage {
    name = "Catalyst-Plugin-Cache-HTTP-0.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRAF/Catalyst-Plugin-Cache-HTTP-0.001000.tar.gz;
      sha256 = "0v5iphbq4csc4r6wkvxnqlh97p8g0yhjky9qqmsdyqczn87agbba";
    };
    buildInputs = [ CatalystRuntime Testuseok TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ ClassAccessorFast HTTPMessage MROCompat ];
    meta = {
      description = "HTTP/1.1 cache validators for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginCaptcha = buildPerlPackage {
    name = "Catalyst-Plugin-Captcha-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DI/DIEGOK/Catalyst-Plugin-Captcha-0.04.tar.gz;
      sha256 = "0llyj3v5nx9cx46jdbbvxf1lc9s9cxq5ml22xmx3wkb201r5qgaa";
    };
    propagatedBuildInputs = [ CatalystRuntime CatalystPluginSession GDSecurityImage HTTPDate ];
    meta = {
      description = "Create and validate Captcha for Catalyst";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginConfigLoader = buildPerlPackage rec {
    name = "Catalyst-Plugin-ConfigLoader-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "19j7p4v7mbx6wrmpvmrnd974apx7hdl2s095ga3b9zcbdrl77h5q";
    };
    propagatedBuildInputs = [CatalystRuntime DataVisitor ConfigAny MROCompat];
  };

  CatalystPluginFormValidator = buildPerlPackage rec {
    name = "Catalyst-Plugin-FormValidator-0.094";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/${name}.tar.gz";
      sha256 = "5834f11bf5c9f4b5d336d65c7ce6639b76ce7bfe7a2875eb048d7ea1c82ce05a";
    };
    propagatedBuildInputs = [ CatalystRuntime DataFormValidator MROCompat Moose ];
    meta = {
      description = "Data::FormValidator";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginFormValidatorSimple = buildPerlPackage rec {
    name = "Catalyst-Plugin-FormValidator-Simple-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/${name}.tar.gz";
      sha256 = "486c6a0e8f410fd017279f4804ab9e35ba46321d33a0a9721fe1e08a391de7a0";
    };
    propagatedBuildInputs = [ CatalystPluginFormValidator CatalystRuntime FormValidatorSimple ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CatalystPluginUnicodeEncoding = buildPerlPackage {
    name = "Catalyst-Plugin-Unicode-Encoding-1.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Unicode-Encoding-1.9.tar.gz;
      sha256 = "1glxkh79zz71bmgk44hnhsi37z2mgxcwf7bkmwlnwv3jh1iaz0ah";
    };
    buildInputs = [ HTTPMessage IOStringy ];
    propagatedBuildInputs = [ CatalystRuntime ClassDataInheritable LWP TryTiny URI ];
    meta = {
      description = "Unicode aware Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginHTMLWidget = buildPerlPackage rec {
    name = "Catalyst-Plugin-HTML-Widget-1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "b4a4873162f515ec7cead6272533fc347c34711d138cc4c5e46b63fa2b74feff";
    };
    propagatedBuildInputs = [ CatalystRuntime HTMLWidget ];
    meta = {
      description = "HTML Widget Catalyst Plugin";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      broken = true;
    };
  };

  CatalystPluginLogHandler = buildPerlModule rec {
    name = "Catalyst-Plugin-Log-Handler-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEPE/${name}.tar.gz";
      sha256 = "0db3c3a57b4ee3d789ba5129890e2858913fef00d8185bdc9c5d7fde31e043ef";
    };
    propagatedBuildInputs = [ ClassAccessor LogHandler MROCompat ];
    meta = {
      description = "Catalyst Plugin for Log::Handler";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystPluginSession = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "171vi9xcl775scjaw4fcfdmqvz0rb1nr0xxg2gb3ng6bjzpslhgv";
    };
    buildInputs = [ TestDeep TestException TestWWWMechanizePSGI ];
    propagatedBuildInputs = [ CatalystRuntime Moose MooseXEmulateClassAccessorFast MROCompat namespaceclean ObjectSignature ];
    meta = {
      description = "Generic Session plugin - ties together server side storage and client side state required to maintain session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionDynamicExpiry = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-DynamicExpiry-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "7707c56734cdb1512f733dc400fadf6f4c53cb217b58207857824dad6780a079";
    };
    propagatedBuildInputs = [ CatalystPluginSession CatalystRuntime MROCompat Moose namespaceautoclean ];
    meta = {
      description = "Per-session custom expiry times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystPluginSessionStateCookie = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-State-Cookie-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1rvxbfnpf9x2pc2zgpazlcgdlr2dijmxgmcs0m5nazs0w6xikssb";
    };
    buildInputs = [ TestMockObject ];
    propagatedBuildInputs = [ CatalystRuntime CatalystPluginSession ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0x3j6zv3wr41jlwr6yb2jpmcx019ibyn11y8653ffnwhpzbpzsxs";
    };
    propagatedBuildInputs =
      [ PathClass CatalystPluginSession CacheFastMmap MROCompat ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginSessionStoreFile = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-File-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "54738e3ce76f8be8b66947092d28973c73d79d1ee19b5d92b057552f8ff09b4f";
    };
    propagatedBuildInputs = [ CacheCache CatalystPluginSession CatalystRuntime ClassDataInheritable MROCompat ];
    meta = {
      description = "File storage backend for session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystPluginStackTrace = buildPerlPackage {
    name = "Catalyst-Plugin-StackTrace-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-StackTrace-0.12.tar.gz;
      sha256 = "1b2ksz74cpigxqzf63rddar3vfmnbpwpdcbs11v0ml89pb8ar79j";
    };
    propagatedBuildInputs = [ CatalystRuntime DevelStackTrace MROCompat ];
    meta = {
      description = "Display a stack trace on the debug screen";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginStaticSimple = buildPerlPackage rec {
    name = "Catalyst-Plugin-Static-Simple-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "1h8f12bhzh0ssq9gs8r9g3hqn8zn2k0q944vc1vm8j81bns16msy";
    };
    patches = [ ../development/perl-modules/catalyst-plugin-static-simple-etag.patch ];
    propagatedBuildInputs = [ CatalystRuntime MIMETypes Moose MooseXTypes
      namespaceautoclean ];
    meta = {
      description = "Make serving static pages painless";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginStatusMessage = buildPerlPackage rec {
    name = "Catalyst-Plugin-StatusMessage-1.002000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HK/HKCLARK/${name}.tar.gz";
      sha256 = "649c894ab16f9f48ada8f9cc599a7ecbb8891ab3761ff6fd510520c6de407c1f";
    };
    propagatedBuildInputs = [ CatalystRuntime SubName strictures ];
    meta = {
      description = "Handle passing of status messages between screens of a web application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystViewCSV = buildPerlPackage rec {
    name = "Catalyst-View-CSV-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MC/MCB/${name}.tar.gz";
      sha256 = "e41326b6099891f244b432921ed10096ac619f32b8c4f8b41633313bd54662db";
    };
    buildInputs = [ CatalystActionRenderView CatalystModelDBICSchema CatalystPluginConfigLoader CatalystRuntime CatalystXComponentTraits ConfigGeneral DBDSQLite DBIxClass Moose TestException ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV URI ];
    meta = {
      description = "CSV view class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CatalystViewDownload = buildPerlPackage rec {
    name = "Catalyst-View-Download-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAUDEON/${name}.tar.gz";
      sha256 = "1qgq6y9iwfbhbkbgpw9czang2ami6z8jk1zlagrzdisy4igqzkvs";
    };
    buildInputs = [  TestWWWMechanizeCatalyst Testuseok ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV XMLSimple ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystViewJSON = buildPerlPackage rec {
    name = "Catalyst-View-JSON-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK//${name}.tar.gz";
      sha256 = "184pyghlrkl7p387bnyvswi2d9myvdg4v3lax6xrd59shskvpmkm";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ CatalystRuntime JSONAny MROCompat YAML ];
    meta = {
      description = "JSON view for your data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystViewTT = buildPerlPackage rec {
    name = "Catalyst-View-TT-0.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "06d1zg4nbb6kcyjbnyxrkf8z4zlscxr8650d94f7187jygfl8rvh";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassAccessor MROCompat PathClass TemplateToolkit TemplateTimer ];
    meta = {
      description = "Template View Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystXComponentTraits = buildPerlPackage rec {
    name = "CatalystX-Component-Traits-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "0iq4ci8m6g2c4g01fvdl568y7pjz28f3widk986v3pyhr7ll8j88";
    };
    propagatedBuildInputs =
      [ CatalystRuntime MooseXTraitsPluggable namespaceautoclean ListMoreUtils ];
  };

  CatalystXRoleApplicator = buildPerlPackage rec {
    name = "CatalystX-RoleApplicator-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/${name}.tar.gz";
      sha256 = "0vwaapxn8g5hs2xp63c4dwv9jmapmji4272fakssvgc9frklg3p2";
    };
    buildInputs = [ ];
    propagatedBuildInputs = [ MooseXRelatedClassRoles CatalystRuntime ];
  };

  CatalystTraitForRequestProxyBase = buildPerlPackage {
    name = "Catalyst-TraitFor-Request-ProxyBase-0.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-TraitFor-Request-ProxyBase-0.000005.tar.gz;
      sha256 = "a7bf0faa7e12ca5df625d9f5fc710f11bfd16ba5385837e48d42b3d286c9710a";
    };
    buildInputs = [ CatalystRuntime HTTPMessage ];
    propagatedBuildInputs = [ CatalystXRoleApplicator Moose URI namespaceautoclean ];
    meta = {
      description = "Replace request base with value passed by HTTP proxy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystXScriptServerStarman = buildPerlPackage {
    name = "CatalystX-Script-Server-Starman-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/CatalystX-Script-Server-Starman-0.02.tar.gz;
      sha256 = "0h02mpkc4cmi3jpvcd7iw7xyzx55bqvvl1qkf967gqkvpklm0qx5";
    };
    patches = [
      # See Nixpkgs issues #16074 and #17624
      ../development/perl-modules/CatalystXScriptServerStarman-fork-arg.patch
    ];
    buildInputs = [ TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystRuntime Moose namespaceautoclean Starman ];
    meta = {
      description = "Replace the development server with Starman";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CGI = buildPerlPackage rec {
    name = "CGI-4.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/${name}.tar.gz";
      sha256 = "8c58f4a529bb92a914b22b7e64c5e31185c9854a4070a6dfad44fe5cc248e7d4";
    };
    buildInputs = [ TestDeep TestNoWarnings TestWarn ];
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      homepage = https://metacpan.org/module/CGI;
      description = "Handle Common Gateway Interface requests and responses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CGICookieXS = buildPerlPackage rec {
    name = "CGI-Cookie-XS-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1iixvnm0l1q24vdlnayb4vd8fns2bdlhm6zb7fpi884ppm5cp6a6";
    };
  };

  CGIEmulatePSGI = buildPerlPackage {
    name = "CGI-Emulate-PSGI-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOKUHIROM/CGI-Emulate-PSGI-0.23.tar.gz;
      sha256 = "dd5b6c353f08fba100dae09904284f7f73f8328d31f6a67b2c136fad728d158b";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CGI HTTPMessage ];
    meta = {
      homepage = https://github.com/tokuhirom/p5-cgi-emulate-psgi;
      description = "PSGI adapter for CGI";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIExpand = buildPerlPackage {
    name = "CGI-Expand-2.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOWMANBS/CGI-Expand-2.05.tar.gz;
      sha256 = "1ad48nd067j5irjampxpw3zvzpg8wpnpan6szkdc5h64wccd30kf";
    };
    meta = {
      description = "Convert flat hash to nested data using TT2's dot convention";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ TestException ];
  };

  CGIFast = buildPerlPackage {
    name = "CGI-Fast-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEEJO/CGI-Fast-2.13.tar.gz;
      sha256 = "792f21fc3b94380e37c99faa7901ecedf01d6855191000d1ffb2a7003813b1d4";
    };
    propagatedBuildInputs = [ CGI FCGI ];
    doCheck = false;
    meta = {
      homepage = https://metacpan.org/module/CGI::Fast;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIFormBuilder = buildPerlPackage rec {
    name = "CGI-FormBuilder-3.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BIGPRESH/CGI-FormBuilder-3.10.tar.gz;
      sha256 = "163ixq9kninqq094z2rnkg9pv3bcmvjphlww4vksfrzhq3h9pjdf";
    };

    propagatedBuildInputs = [ CGI ];
  };

  CGIPSGI = buildPerlPackage {
    name = "CGI-PSGI-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/CGI-PSGI-0.15.tar.gz;
      sha256 = "c50dcb10bf8486a9843baed032ad89d879ff2f41c993342dead62f947a598d91";
    };
    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "Adapt CGI.pm to the PSGI protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGISession = buildPerlModule rec {
    name = "CGI-Session-4.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSTOS/${name}.tar.gz";
      sha256 = "1xsl2pz1jrh127pq0b01yffnj4mnp9nvkp88h5mndrscq9hn8xa6";
    };
    propagatedBuildInputs = [ CGI ];
  };

  CGISimple = buildPerlModule rec {
    name = "CGI-Simple-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANWAR/CGI-Simple-1.15.tar.gz;
      sha256 = "013dcy9k4sj9alkksk5aqz65ryxw0rxgg71c7w666y941gd8n46q";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A Simple totally OO CGI interface that is CGI.pm compliant";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestException TestNoWarnings ];
  };

  CGIStruct = buildPerlPackage {
    name = "CGI-Struct-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FU/FULLERMD/CGI-Struct-1.21.tar.gz;
      sha256 = "d13d8da7fdcd6d906054e4760fc28a718aec91bd3cf067a58927fb7cb1c09d6c";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Build structures from CGI data";
      license = stdenv.lib.licenses.bsd2;
    };
  };

  CHI = buildPerlPackage rec {
    name = "CHI-0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSWARTZ/${name}.tar.gz";
      sha256 = "c7f1a2b3570a8fede484e933f89ba1729e0abd05935791d146c522dd120ee851";
    };
    buildInputs = [ TestClass TestDeep TestException TestWarn TimeDate ];
    propagatedBuildInputs = [ CarpAssert ClassLoad DataUUID DigestJHash HashMoreUtils JSONMaybeXS ListMoreUtils LogAny Moo MooXTypesMooseLikeNumeric StringRewritePrefix TaskWeaken TimeDuration TimeDurationParse ];
    meta = {
      description = "Unified cache handling interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  Chart = buildPerlPackage rec {
    name = "Chart-2.4.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHARTGRP/Chart-2.4.10.tar.gz;
      sha256 = "84bd99a1a0ce72477b15e35881e6120398bb3f553aeeb5e8d72b088520e4f6bf";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
        description = "A series of charting modules";
        license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz;
      sha256 = "07215zzr4ydf49832vn54i3gf2q5b97lydkv8j56wb2svvjs64mz";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorChained = buildPerlModule {
    name = "Class-Accessor-Chained-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz;
      sha256 = "1lilrjy1s0q5hyr0888kf0ifxjyl2iyk4vxil4jsv0sgh39lkgx5";
    };
    propagatedBuildInputs = [ ClassAccessor ];
  };

  ClassAccessorFast = ClassAccessor;

  ClassAccessorGrouped = buildPerlPackage {
    name = "Class-Accessor-Grouped-0.10012";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/Class-Accessor-Grouped-0.10012.tar.gz;
      sha256 = "c4613ee3307939f47a9afd40e8b173f3a22f501c3b139799aa030f01b627e7fe";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Lets you build groups of accessors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorLite = buildPerlPackage {
    name = "Class-Accessor-Lite-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz;
      sha256 = "75b3b8ec8efe687677b63f0a10eef966e01f60735c56656ce75cbb44caba335a";
    };
    meta = {
      description = "A minimalistic variant of Class::Accessor";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAutouse = buildPerlPackage rec {
    name = "Class-Autouse-2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "c05b3236c05719d819c20db0fdeb6d0954747e43d7a738294eed7fbcf36ecf1b";
    };
    meta = {
      description = "Run-time load a class the first time you call a method in it";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassBase = buildPerlPackage rec {
    name = "Class-Base-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YA/YANICK/Class-Base-0.09.tar.gz;
      sha256 = "117dmsrb30a09zlrv919fb5h5rg8r4asa24i99k04n2habgbv9g1";
    };
    propagatedBuildInputs = [ Clone ];
  };

  ClassC3 = buildPerlPackage rec {
    name = "Class-C3-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "1c319k0j9knba2k0xjr8fml54kfvs71wcnc0hxp7s3lqc49mvzxf";
    };
    propagatedBuildInputs = [ AlgorithmC3 ];
    meta = {
      description = "A pragma to use the C3 method resolution order algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3AdoptNEXT = buildPerlModule rec {
    name = "Class-C3-Adopt-NEXT-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1xsbydmiskpa1qbmnf6n39cb83nlb432xgkad9kfhxnvm8jn4rw5";
    };
    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ MROCompat ];
    meta = {
      homepage = http://search.cpan.org/dist/Class-C3-Adopt-NEXT;
      description = "Make NEXT suck less";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3Componentised = buildPerlPackage {
    name = "Class-C3-Componentised-1.001002";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Class-C3-Componentised-1.001002.tar.gz;
      sha256 = "14wn1g45z3b5apqq7dcai5drk01hfyqydsd2m6hsxzhyvi3b2l9h";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassC3 ClassInspector MROCompat ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassClassgenclassgen = buildPerlPackage {
    name = "Class-Classgen-classgen-3.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHLUE/Class-Classgen-classgen-3.03.tar.gz;
      sha256 = "9b65d41b991538992e816b32cc4fa9b4a4a0bb3e9c10e7eebeff82658dbbc8f6";
    };
  };

  ClassContainer = buildPerlModule {
    name = "Class-Container-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Class-Container-0.13.tar.gz;
      sha256 = "f5d495b1dfb826d5c0c45d03b4d0e6b6047cbb06cdbf6be15fd4dc902aeeb70b";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Glues object frameworks together transparently";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassDataAccessor = buildPerlPackage {
    name = "Class-Data-Accessor-0.04004";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLACO/Class-Data-Accessor-0.04004.tar.gz;
      sha256 = "0578m3rplk41059rkkjy1009xrmrdivjnv8yxadwwdk1vzidc8n1";
    };
  };

  ClassDataInheritable = buildPerlPackage {
    name = "Class-Data-Inheritable-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz;
      sha256 = "0jpi38wy5xh6p1mg2cbyjjw76vgbccqp46685r27w8hmxb7gwrwr";
    };
  };

  ClassFactory = buildPerlPackage {
    name = "Class-Factory-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Class-Factory-1.06.tar.gz;
      sha256 = "c37a2d269eb935f36a23e113480ae0946fa7c12a12781396a1226c8e435f30f5";
    };
  };

  ClassFactoryUtil = buildPerlModule rec {
    name = "Class-Factory-Util-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
    meta = {
      description = "Provide utility methods for factory classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassInspector = buildPerlPackage {
    name = "Class-Inspector-1.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PL/PLICEASE/Class-Inspector-1.32.tar.gz;
      sha256 = "0d85rihxahdvhj8cysqrgg0kbmcqghz5hgy41dbkxr1qaf5xrynf";
    };
    meta = {
      description = "Get information about a class and its structure";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassISA = buildPerlPackage {
    name = "Class-ISA-0.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-ISA-0.36.tar.gz;
      sha256 = "0r5r574i6wgxm8zsq4bc34d0dzprrh6h6mpp1nhlks1qk97g65l8";
    };
  };

  ClassIterator = buildPerlPackage {
    name = "Class-Iterator-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TE/TEXMEC/Class-Iterator-0.3.tar.gz;
      sha256 = "db1ba87ca9107f161fe9c1e9e7e267c0026defc26fe3e73bcad8ab8ffc18ef9d";
    };
    meta = {
    };
  };

  ClassMakeMethods = buildPerlPackage rec {
    name = "Class-MakeMethods-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVO/${name}.tar.gz";
      sha256 = "0ricb0mn0i06ngfhq5y035yx8i7ahlx83yyqwixqmv6hg4p79b5c";
    };
  };

  ClassMethodMaker = buildPerlPackage rec {
    name = "Class-MethodMaker-2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/${name}.tar.gz";
      sha256 = "0a03i4k3a33qqwhykhz5k437ld5mag2vq52vvsy03gbynb65ivsy";
    };
    # Remove unnecessary, non-autoconf, configure script.
    prePatch = "rm configure";
    meta = {
      description = "A module for creating generic methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMethodModifiers = buildPerlPackage rec {
    name = "Class-Method-Modifiers-2.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1j3swa212wh14dq5r6zjarm2lzpx6mrdfplpjy65px8b09ri0k74";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      homepage = https://github.com/sartak/Class-Method-Modifiers/tree;
      description = "Provides Moose-like method modifiers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMix = buildPerlModule rec {
    name = "Class-Mix-0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "8747f643893914f8c44979f1716d0c1ec8a41394796555447944e860f1ff7c0b";
    };
    propagatedBuildInputs = [ ParamsClassify ];
    meta = {
      description = "Dynamic class mixing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMOP = Moose;

  ClassReturnValue = buildPerlPackage rec {
    name = "Class-ReturnValue-0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/${name}.tar.gz";
      sha256 = "ed3836885d78f734ccd7a98550ec422a616df7c31310c1b7b1f6459f5fb0e4bd";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "A smart return value object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassSingleton = buildPerlPackage rec {
    name = "Class-Singleton-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/${name}.tar.gz";
      sha256 = "0y7ngrjf551bjgmijp5rsidbkq6c8hb5lmy2jcqq0fify020s8iq";
    };
  };

  ClassThrowable = buildPerlPackage rec {
    name = "Class-Throwable-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/${name}.tar.gz";
      sha256 = "1kmwzdxvp9ca2z44vl0ygkfygdbxqkilzjd8vqhc4vdmvbh136nw";
    };
  };

  ClassTiny = buildPerlPackage rec {
     name = "Class-Tiny-1.006";
     src = fetchurl {
       url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Class-Tiny-1.006.tar.gz;
       sha256 = "0knbi1agcfc9d7fca0szvxr6335pb22pc5n648q1vrcba8qvvz1f";
     };
     meta = {
       description = "Minimalist class construction";
       license = with stdenv.lib.licenses; [ asl20 ];
       homepage = "https://github.com/dagolden/Class-Tiny";
     };
  };

  ClassLoad = buildPerlPackage rec {
    name = "Class-Load-0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0bb983da46c146534fc77a556d6e40d925142f2eb43103534025ee545265ca36";
    };
    buildInputs = [ TestFatal TestNeeds ];
    propagatedBuildInputs = [ DataOptList PackageStash ];
    meta = {
      homepage = https://github.com/moose/Class-Load;
      description = "A working (require \"Class::Name\") and more";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassLoadXS = buildPerlPackage rec {
    name = "Class-Load-XS-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "5bc22cf536ebfd2564c5bdaf42f0d8a4cee3d1930fc8b44b7d4a42038622add1";
    };
    buildInputs = [ TestFatal TestNeeds ];
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      homepage = https://github.com/moose/Class-Load-XS;
      description = "XS implementation of parts of Class::Load";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ClassObservable = buildPerlPackage {
    name = "Class-Observable-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWINTERS/Class-Observable-1.04.tar.gz;
      sha256 = "3ef18733a0f03c113f3bcf8ac50476e09ca1fe6234f4aaacaa24dfca95168094";
    };
    propagatedBuildInputs = [ ClassISA ];
  };

  ClassStd = buildPerlModule {
    name = "Class-Std-0.013";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Class-Std-0.013.tar.gz;
      sha256 = "bcd6d82f6c8af0fe069fced7dd165a4795b0b6e92351c7d4e5a1ab9a14fc35c6";
    };
    meta = {
      description = "Support for creating standard 'inside-out' classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassUnload = buildPerlPackage rec {
    name = "Class-Unload-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "0pqa98z3ij6a3v9wkmvc8b410kv30y0xxqf0i6if3lp4lx3rgqjj";
    };
    propagatedBuildInputs = [ ClassInspector ];
    buildInputs = [ TestRequires ];
  };

  ClassVirtual = buildPerlPackage rec {
    name = "Class-Virtual-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "c6499b42d3b4e5c6488a5e82fbc28698e6c9860165072dddfa6749355a9cfbb2";
    };
    propagatedBuildInputs = [ CarpAssert ClassDataInheritable ClassISA ];
    meta = {
      homepage = https://metacpan.org/release/Class-Virtual;
      description = "Base class for virtual base classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassXSAccessor = buildPerlPackage {
    name = "Class-XSAccessor-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-XSAccessor-1.19.tar.gz;
      sha256 = "1wm6013il899jnm0vn50a7iv9v6r4nqywbqzj0csyf8jbwwnpicr";
    };
    meta = {
      description = "Generate fast XS accessors without runtime compilation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Clipboard = buildPerlPackage {
    name = "Clipboard-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KI/KING/Clipboard-0.13.tar.gz;
      sha256 = "eebf1c9cb2484be850abdae017147967cf47f8ccd99293771517674b0046ec8a";
    };
    meta = {
      description = "Clipboard - Copy and Paste with any OS";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = stdenv.lib.optional stdenv.isDarwin MacPasteboard;
    # Disable test on darwin because MacPasteboard fails when not logged in interactively.
    # Mac OS error -4960 (coreFoundationUnknownErr): The unknown error at lib/Clipboard/MacPasteboard.pm line 3.
    # Mac-Pasteboard-0.009.readme: 'NOTE that Mac OS X appears to restrict pasteboard access to processes that are logged in interactively.
    #     Ssh sessions and cron jobs can not create the requisite pasteboard handles, giving coreFoundationUnknownErr (-4960)'
    doCheck = !stdenv.isDarwin;
  };


  Clone = buildPerlPackage rec {
    name = "Clone-0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GARU/${name}.tar.gz";
      sha256 = "0bgsidb96gxzf3zhy6v1ksj1c200vxbwykk32fqm1mj97rl4dc5c";
    };
    meta = {
      description = "Recursively copy Perl datatypes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CloneChoose = buildPerlPackage rec {
     name = "Clone-Choose-0.008";
     src = fetchurl {
       url = mirror://cpan/authors/id/H/HE/HERMES/Clone-Choose-0.008.tar.gz;
       sha256 = "0grf0bg1ldzqakaq7aaigjngwd07zybrlmwjcnb0q986q0jcfank";
     };
     buildInputs = [ Clone ClonePP ];
     meta = {
       description = "Choose appropriate clone utility";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://metacpan.org/release/Clone-Choose";
     };
  };

  ClonePP = buildPerlPackage rec {
     name = "Clone-PP-1.07";
     src = fetchurl {
       url = mirror://cpan/authors/id/N/NE/NEILB/Clone-PP-1.07.tar.gz;
       sha256 = "15dkhqvih6rx9dnngfwwljcm9s8afb0nbyl2vdvhd8frnw4y31dz";
     };
     meta = {
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  # For backwards compatibility.
  CommonSense = self.commonsense;

  commonsense = buildPerlPackage rec {
    name = "common-sense-3.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "1wxv2s0hbjkrnssvxvsds0k213awg5pgdlrpkr6xkpnimc17s7vp";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Implements some sane defaults for Perl programs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressBzip2 = buildPerlPackage {
    name = "Compress-Bzip2-2.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Compress-Bzip2-2.26.tar.gz;
      sha256 = "5132f0c5f377a54d77ee36d332aa0ece585c22a40f2c31f2619e40262f5c4f0c";
    };
    meta = {
      description = "Interface to Bzip2 compression library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  CompressRawBzip2 = buildPerlPackage rec {
    name = "Compress-Raw-Bzip2-2.074";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "0b5jwqf15zr787acnx8sfyy2zavdd7gfkd98n1dgy8fs6r8yb8a4";
    };

    # Don't build a private copy of bzip2.
    BUILD_BZIP2 = false;
    BZIP2_LIB = "${pkgs.bzip2.out}/lib";
    BZIP2_INCLUDE = "${pkgs.bzip2.dev}/include";

    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Low-Level Interface to bzip2 compression library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawZlib = import ../development/perl-modules/Compress-Raw-Zlib {
    inherit fetchurl buildPerlPackage stdenv;
    inherit (pkgs) zlib;
  };

  CompressZlib = IOCompress;

  CompressUnLZMA = buildPerlPackage rec {
    name = "Compress-unLZMA-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "1f0pcpcjjj60whqc5sc5jd0dd7z3si4fnp268w4ykmcjini03s2d";
    };
  };

  ConfigAny = buildPerlPackage rec {
    name = "Config-Any-0.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Config-Any-0.32.tar.gz;
      sha256 = "0l31sg7dwh4dwwnql42hp7arkhcm15bhsgfg4i6xvbjzy9f2mnk8";
    };
    propagatedBuildInputs = [ ModulePluggable ];
    meta = {
      description = "Load configuration from different file formats, transparently";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigAutoConf = buildPerlPackage rec {
    name = "Config-AutoConf-0.315";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RE/REHSACK/Config-AutoConf-0.315.tar.gz;
      sha256 = "0h39x9rzrhhilpg8yxlzpka269qrzsjg0iy0c1b9xflqlvhx2g2b";
    };
    propagatedBuildInputs = [ CaptureTiny ];
    meta = {
      description = "A module to implement some of AutoConf macros in pure perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGeneral = buildPerlPackage rec {
    name = "Config-General-2.63";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TL/TLINDEN/${name}.tar.gz";
      sha256 = "1bbg3wp0xcpj04cmm86j1x0j5968jqi5s2c87qs7dgmap1vzk6qa";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGitLike = buildPerlPackage {
    name = "Config-GitLike-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Config-GitLike-1.17.tar.gz;
      sha256 = "674a07b814fdcf9d323088d093245bcd066aaee24ec0914cb4decc9a943de54e";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moo MooXTypesMooseLike ];
    meta = {
      description = "Git-compatible config file parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGrammar = buildPerlPackage rec {
    name = "Config-Grammar-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSCHWEI/${name}.tar.gz";
      sha256 = "7a52a3657d96e6f1f529caaa09ec3bf7dd6a245b47875382c323902f6d9590b0";
    };
    meta = {
      homepage = https://github.com/schweikert/Config-Grammar;
      description = "A grammar-based, user-friendly config parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigINI = buildPerlPackage rec {
    name = "Config-INI-0.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "628bf76d5b91f89dde22d4813ec033026ebf71b772bb61ccda909da00c869732";
    };
    propagatedBuildInputs = [ MixinLinewise ];
    meta = {
      homepage = https://github.com/rjbs/Config-INI;
      description = "Simple .ini-file format";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ConfigIniFiles = buildPerlModule rec {
    name = "Config-IniFiles-2.95";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "414a19f98cc745769ce762aefce01fa52d031bc244403cd32fd1f6257f2dedc2";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A module for reading .ini-style configuration files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.limeytexan ];
    };
  };

  ConfigMerge = buildPerlPackage {
    name = "Config-Merge-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DRTECH/Config-Merge-1.04.tar.gz;
      sha256 = "a932477b43ae5fb04a16f071a891da7bd2086c10c680592f2888fa9d9972cccf";
    };
    buildInputs = [ YAML ];
    propagatedBuildInputs = [ ConfigAny ];
    meta = {
      description = "Load a configuration directory tree containing YAML, JSON, XML, Perl, INI or Config::General files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigMVP = buildPerlPackage {
    name = "Config-MVP-2.200010";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Config-MVP-2.200010.tar.gz;
      sha256 = "bfb5870452a12ead4d3fd485045d1fa92b2a11741c3b93b61eb43f3dcbd6099b";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModulePluggable MooseXOneArgNew RoleHasMessage RoleIdentifiable Throwable TieIxHash ];
    meta = {
      homepage = https://github.com/rjbs/Config-MVP;
      description = "Multivalue-property package-oriented configuration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ConfigMVPReaderINI = buildPerlPackage rec {
    name = "Config-MVP-Reader-INI-2.101463";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0iflnsh0sgihff3ra8sr7awiiscmqvrp1anaskkwksqi6yzidab9";
    };
    propagatedBuildInputs = [ ConfigINI ConfigMVP ];
    meta = {
      homepage = https://github.com/rjbs/Config-MVP-Reader-INI;
      description = "An MVP config reader for .ini files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigStd = buildPerlModule {
    name = "Config-Std-0.903";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICKER/Config-Std-0.903.tar.gz;
      sha256 = "b7709ff663bd279d264ab9c2f51e9e9588479a3367a8c4cfc18659c2a11480fe";
    };
    propagatedBuildInputs = [ ClassStd ];
    meta = {
      description = "Load and save configuration files in a standard format";
    };
  };

  ConfigTiny = buildPerlPackage rec {
    name = "Config-Tiny-2.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "037524cpx962cjdgcp1m8sd30s43g3zvwfn4hmjvq322xpind2ls";
    };
  };

  ConfigVersioned = buildPerlPackage {
    name = "Config-Versioned-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSCOTTY/Config-Versioned-1.01.tar.gz;
      sha256 = "bc9a4ae3738bd89f86a07bca673627ca3c92ba969737cd6dbc7ab7ad17cd2348";
    };
    propagatedBuildInputs = [ ConfigStd GitPurePerl ];
    doCheck = false;
    meta = {
      description = "Simple, versioned access to configuration data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Connector = buildPerlPackage rec {
    name = "Connector-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/${name}.tar.gz";
      sha256 = "aa178d1865817ad2dea5c79645c8e6420ca2cfb951f20c98b5154307de219016";
    };
    buildInputs = [ ConfigMerge ConfigStd ConfigVersioned CryptSSLeay DBDSQLite DBI IOSocketSSL LWPProtocolhttps LWPUserAgent TemplateToolkit YAML ];
    propagatedBuildInputs = [ LogLog4perl Moose ];
    prePatch = ''
      # Attempts to use network.
      rm t/01-proxy-http.t
    '';
    meta = {
      description = "A generic connection to a hierarchical-structured data set";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConvertASN1 = buildPerlPackage rec {
    name = "Convert-ASN1-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/${name}.tar.gz";
      sha256 = "12nmsca6hzgxq57sx7dp8yq6zxqhl41z5a6018877sf5w25ag93l";
    };
  };

  ConvertColor = buildPerlModule {
    name = "Convert-Color-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Convert-Color-0.11.tar.gz;
      sha256 = "b41217c72931034ba4417d7a9e1e2999f04580d4e6b31c70993fedccc2440d38";
    };
    buildInputs = [ TestNumberDelta ];
    propagatedBuildInputs = [ ListUtilsBy ModulePluggable ];
    meta = {
      description = "Color space conversions and named lookups";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  constant = buildPerlPackage rec {
    name = "constant-1.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/constant-1.33.tar.gz;
      sha256 = "015my616h5l2fswh52x4dp3n007gk5lax83ww9q6cmzb610mv5kr";
    };
  };

  constantboolean = buildPerlModule {
    name = "constant-boolean-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/constant-boolean-0.02.tar.gz;
      sha256 = "1s8gxfg4xqp543aqanv5lbp64vqqyw6ic4x3fm4imkk1h3amjb6d";
    };
    propagatedBuildInputs = [ SymbolUtil ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  curry = buildPerlPackage rec {
     name = "curry-1.001000";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MS/MSTROUT/curry-1.001000.tar.gz;
       sha256 = "1m2n3w67cskh8ic6vf6ik0fmap9zma875kr5rhyznr1041wn064b";
     };
     meta = {
       description = "Create automatic curried method call closures for any class or object";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  constantdefer = pkgs.perlPackages.constant-defer;

  constant-defer = buildPerlPackage rec {
    name = "constant-defer-6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "1ykgk0rd05p7kyrdxbv047fj7r0b4ix9ibpkzxp6h8nak0qjc8bv";
    };
  };

  ContextPreserve = buildPerlPackage rec {
    name = "Context-Preserve-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Context-Preserve-0.03.tar.gz;
      sha256 = "07zxgmb11bn4zj3w9g1zwbb9iv4jyk5q7hc0nv59knvv5i64m489";
    };
    buildInputs = [ TestException TestSimple13 ];
  };

  CookieBaker = buildPerlModule rec {
    name = "Cookie-Baker-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "be020a634162b319cab55b6e2bf10556a33a210a2eee8a2f1aa1b19b5e33aa4f";
    };
    buildInputs = [ ModuleBuildTiny TestTime ];
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = https://github.com/kazeburo/Cookie-Baker;
      description = "Cookie string generator / parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CookieXS = buildPerlPackage rec {
    name = "Cookie-XS-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1616rcn2qn1cwiv3rxb8mq5fmwxpj4gya1lxxxq2w952h03p3fd3";
    };
    propagatedBuildInputs = [ CGICookieXS ];
  };

  CPAN = buildPerlPackage rec {
    name = "CPAN-2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "7dbd61c172b99b05c16a2fce790140489494c744190f6c4f80c162d5ae3ccc2c";
    };
    propagatedBuildInputs = [ Expect FileWhich LWP ModuleBuild ModuleSignature TermReadKey TextGlob YAML ];
    meta = {
      description = "Query, download and build perl modules from CPAN sites";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ ArchiveZip ];
  };

  CpanelJSONXS = buildPerlPackage rec {
    name = "Cpanel-JSON-XS-4.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "e9fe45a0b5bf553076bd395ed04766d58683557f818af559cd82d33409846d20";
    };
    meta = {
      description = "CPanel fork of JSON::XS, fast and correct serializing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANChanges = buildPerlPackage rec {
    name = "CPAN-Changes-0.400002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "01eedea90d07468cb58e4a50bfa3bb1d4eeda9073596add1118fc359153abe8d";
    };
    meta = {
      description = "Read and write Changes files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  CPANDistnameInfo = buildPerlPackage rec {
     name = "CPAN-DistnameInfo-0.12";
     src = fetchurl {
       url = mirror://cpan/authors/id/G/GB/GBARR/CPAN-DistnameInfo-0.12.tar.gz;
       sha256 = "0d94kx596w7k328cvq4y96z1gz12hdhn3z1mklkbrb7fyzlzn91g";
     };
     meta = {
       description = "Extract distribution name and version from a distribution filename";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  CPANMeta = buildPerlPackage rec {
    name = "CPAN-Meta-2.150010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "1mm3dfw3ffyzb2ikpqn9l6zyqrxijb4vyywmbx2l21ryqwp0zy74";
    };
    meta = {
      homepage = https://github.com/Perl-Toolchain-Gang/CPAN-Meta;
      description = "The distribution metadata for a CPAN dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaCheck = buildPerlPackage rec {
    name = "CPAN-Meta-Check-0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "07rmdbz1rbnb7w33vswn1wixlyh947sqr93xrvcph1hwzhmmg818";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Verify requirements in a CPAN::Meta object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaRequirements = buildPerlPackage {
    name = "CPAN-Meta-Requirements-2.140";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.140.tar.gz;
      sha256 = "0898645e8e86f0922f0f0502b503f592a8eb3d3176b4fd87adcc7ba51e751fa9";
    };
    meta = {
      homepage = https://github.com/dagolden/CPAN-Meta-Requirements;
      description = "A set of version requirements for a CPAN dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaYAML = buildPerlPackage rec {
    name = "CPAN-Meta-YAML-0.018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "150jh9l7baddl2587m23qs2l0pb395qsx9bhsgdsnn6y9k4zgjik";
    };
    doCheck = true;
    meta = {
      homepage = https://github.com/dagolden/CPAN-Meta-YAML;
      description = "Read and write a subset of YAML for CPAN Meta files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPerlReleases = buildPerlPackage rec {
    name = "CPAN-Perl-Releases-3.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "1nr739rnrw58p9r9z26pr4sc4s5z7wbhgyva3r2b2spyaylp5qkz";
    };
    meta = {
      homepage = https://github.com/bingos/cpan-perl-releases;
      description = "Mapping Perl releases on CPAN to the location of the tarballs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPLUS = buildPerlPackage rec {
    name = "CPANPLUS-0.9172";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "1q4b0fkdn4sh8ym9dig21w96p7kzrhq66lqhn0dy1l3pgx413zlc";
    };
    doCheck = false;
    meta = {
      homepage = https://github.com/jib/cpanplus-devel;
      description = "Ameliorated interface to the CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANUploader = buildPerlPackage rec {
    name = "CPAN-Uploader-0.103013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "07k8ia8gvj9mrz7a2lckgd3vxjsahfr43lgrb85474dkhz94f5pq";
    };
    propagatedBuildInputs = [ FileHomeDir GetoptLongDescriptive LWPProtocolHttps TermReadKey ];
    meta = {
      homepage = https://github.com/rjbs/cpan-uploader;
      description = "Upload things to the CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptBlowfish = buildPerlPackage rec {
    name = "Crypt-Blowfish-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1cb7g8cyfs9alrfdykxhs8m6azj091fmcycz6p5vkxbbzcgl7cs6";
    };
  };

  CryptCBC = buildPerlPackage rec {
    name = "Crypt-CBC-2.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "0ig698lmpjz7fslnznxm0609lvlnvf4f3s370082nzycnqhxww3a";
    };
  };

  CryptDES = buildPerlPackage rec {
    name = "Crypt-DES-2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1rypxlhpd1jc0c327aghgl9y6ls47drmpvn0a40b4k3vhfsypc9d";
    };
  };

  CryptDH = buildPerlPackage rec {
    name = "Crypt-DH-0.07";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/M/MI/MITHALDU/${name}.tar.gz";
      sha256 = "0pvzlgwpx8fzdy64ki15155vhsj30i9zxmw6i4p7irh17d1g7368";
    };
    propagatedBuildInputs = [ MathBigIntGMP ];
  };

  CryptDHGMP = buildPerlPackage rec {
    name = "Crypt-DH-GMP-0.00012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMAKI/${name}.tar.gz";
      sha256 = "0f5gdprcql4kwzgxl2s6ngcfg1jl45lzcqh7dkv5bkwlwmxa9rsi";
    };
    buildInputs = [ pkgs.gmp DevelChecklib TestRequires ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
  };

  CryptEksblowfish = buildPerlModule rec {
    name = "Crypt-Eksblowfish-0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "3cc7126d5841107237a9be2dc5c7fbc167cf3c4b4ce34678a8448b850757014c";
    };
    propagatedBuildInputs = [ ClassMix ];
  };

  CryptJWT = buildPerlPackage rec {
    name = "Crypt-JWT-0.021";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/${name}.tar.gz";
      sha256 = "7227a10d185d6550fea855ef44bb8fb927d8c8644cfb16e0b674959bf103df5f";
    };
    propagatedBuildInputs = [ CryptX JSONMaybeXS ];
    meta = {
      description = "JSON Web Token";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPasswdMD5 = buildPerlModule {
    name = "Crypt-PasswdMD5-1.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Crypt-PasswdMD5-1.40.tgz;
      sha256 = "0j0r74f18nk63phddzqbf7wqma2ci4p4bxvrwrxsy0aklbp6lzdp";
    };
  };

  CryptPKCS10 = buildPerlModule {
    name = "Crypt-PKCS10-1.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSCOTTY/Crypt-PKCS10-1.9.tar.gz;
      sha256 = "ee0ce58cc17e9a8d7a6f33f3f26aca5be7edfc054204f7946370b3a8d291f0fd";
    };
    buildInputs = [ pkgs.unzip ModuleBuildTiny ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRandomSource = buildPerlModule {
    name = "Crypt-Random-Source-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Crypt-Random-Source-0.12.tar.gz;
      sha256 = "00mw5m52sbz9nqp3f6axyrgcrihqxn7k8gv0vi1kvm1j1nc9g29h";
    };
    buildInputs = [ ModuleBuildTiny TestException TestSimple13 ];
    propagatedBuildInputs = [ CaptureTiny ModuleFind Moo SubExporter TypeTiny namespaceclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Crypt-Random-Source;
      description = "Get weak or strong random data from pluggable sources";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CryptRC4 = buildPerlPackage rec {
    name = "Crypt-RC4-2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIFUKURT/${name}.tar.gz";
      sha256 = "1sp099cws0q225h6j4y68hmfd1lnv5877gihjs40f8n2ddf45i2y";
    };
  };

  CryptRandPasswd = buildPerlPackage {
    name = "Crypt-RandPasswd-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Crypt-RandPasswd-0.06.tar.gz;
      sha256 = "0ca8544371wp4vvqsa19lnhl02hczpkbwkgsgm65ziwwim3r1gdi";
    };
  };

  CryptMySQL = buildPerlModule rec {
    name = "Crypt-MySQL-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEBE/${name}.tar.gz";
      sha256 = "93ebdfaaefcfe9ab683f0121c85f24475d8197f0bcec46018219e4111434dde3";
    };
    propagatedBuildInputs = [ DigestSHA1 ];
  };

  CryptRijndael = buildPerlPackage rec {
    name = "Crypt-Rijndael-1.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "0ki16vkgzvzyjdx6mmvjfpngyvhf7cis46pymy6dr8z0vyk0jwnd";
    };
  };

  CryptUnixCryptXS = buildPerlPackage rec {
    name = "Crypt-UnixCrypt_XS-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/${name}.tar.gz";
      sha256 = "1ajg3x6kwxy4x9p3nw1j36qjxpjvdpi9wkca5gfd86y9q8939sv2";
    };
  };

  CryptSmbHash = buildPerlPackage rec {
    name = "Crypt-SmbHash-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BJ/BJKUIT/Crypt-SmbHash-0.12.tar.gz";
      sha256 = "0dxivcqmabkhpz5xzph6rzl8fvq9xjy26b2ci77pv5gsmdzari38";
    };
  };

  CryptOpenSSLAES = buildPerlPackage rec {
    name = "Crypt-OpenSSL-AES-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TT/TTAR/${name}.tar.gz";
      sha256 = "b66fab514edf97fc32f58da257582704a210c2b35e297d5c31b7fa2ffd08e908";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
    meta = with stdenv.lib; {
      homepage = https://metacpan.org/release/Crypt-OpenSSL-AES;
      description = "Perl wrapper around OpenSSL's AES library";
      license = with licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
      platforms = platforms.unix;
    };
  };

  CryptOpenSSLBignum = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Bignum-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz;
      sha256 = "1p22znbajq91lbk2k3yg12ig7hy5b4vy8igxwqkmbm4nhgxp4ki3";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
  };

  CryptOpenSSLRandom = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Random-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "0yjcabkibrkafywvdkmd1xpi6br48skyk3l15ni176wvlg38335v";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
  };

  CryptOpenSSLRSA = buildPerlPackage rec {
    name = "Crypt-OpenSSL-RSA-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "5357f977464bb3a8184cf2d3341851a10d5515b4b2b0dfb88bf78995c0ded7be";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
  };

  CryptSSLeay = buildPerlPackage rec {
    name = "Crypt-SSLeay-0.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NANIS/${name}.tar.gz";
      sha256 = "1s7zm6ph37kg8jzaxnhi4ff4snxl7mi5h14arxbri0kp6s0lzlzm";
    };
    makeMakerFlags = "--libpath=${pkgs.openssl.out}/lib --incpath=${pkgs.openssl.dev}/include";
    buildInputs = [ PathClass ];
    propagatedBuildInputs = [ LWPProtocolHttps ];
  };

  CSSDOM = buildPerlPackage rec {
    name = "CSS-DOM-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SP/SPROUT/${name}.tar.gz";
      sha256 = "09phb6c9czpcp9imq06khm54kspsx6hnvfrjxramx663ygmpifb5";
    };
    propagatedBuildInputs = [ Clone ];
  };

  CSSMinifierXP = buildPerlModule rec {
    name = "CSS-Minifier-XS-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GT/GTERMARS/CSS-Minifier-XS-0.09.tar.gz;
      sha256 = "1myswrmh0sqp5xjpp03x45z8arfmgkjx0srl3r6kjsyzl1zrk9l8";
    };
    meta = {
      description = "XS based CSS minifier";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CSSSquish = buildPerlPackage {
    name = "CSS-Squish-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/CSS-Squish-0.10.tar.gz;
      sha256 = "65fc0d69acd1fa33d9a4c3b09cce0fbd737d747b1fcc4e9d87ebd91050cbcb4e";
    };
    buildInputs = [ TestLongString ];
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Compact many CSS files into one big file";
      license = "unknown";
    };
  };

  Curses = let version = "1.36"; in buildPerlPackage {
    name = "Curses-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GI/GIRAFFED/Curses-${version}.tar.gz";
      sha256 = "0r6xd9wr0c25rr28zixhqipak575zqsfb7r7f2693i9il1dpj554";
    };
    propagatedBuildInputs = [ pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lncurses";
    meta = {
      inherit version;
      description = "Perl bindings to ncurses";
      license = stdenv.lib.licenses.artistic1;
    };
  };

  CryptX = buildPerlPackage rec {
    name = "CryptX-0.059";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/${name}.tar.gz";
      sha256 = "3ef0d6493f332b6a2e1b0d20eda034d060d66f19f48d47244c788c26dca09d27";
    };
    meta = {
      description = "Crypto toolkit";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CwdGuard = buildPerlModule rec {
    name = "Cwd-Guard-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "0xwf4rmii55k3lp19mpbh00mbgby7rxdk2lk84148bjhp6i7rz3s";
    };
    meta = {
      description = "Temporary changing working directory (chdir)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestRequires ];
  };

  DataClone = buildPerlPackage {
    name = "Data-Clone-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/Data-Clone-0.004.tar.gz;
      sha256 = "0g1qhi5qyk4fp0pwyaw90vxiyyn8las0i8ghzrnr4srai1wy3r9g";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Polymorphic data cloning";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DataCompare = buildPerlPackage rec {
    name = "Data-Compare-1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/${name}.tar.gz";
      sha256 = "0wzasidg9yjcfsi2gdiaw6726ikqda7n24n0v2ngpaazakdkcjqx";
    };
    propagatedBuildInputs = [ FileFindRule ];
  };

  DataDump = buildPerlPackage rec {
    name = "Data-Dump-1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "0r9ba52b7p8nnn6nw0ygm06lygi8g68piri78jmlqyrqy5gb0lxg";
    };
    meta = {
      description = "Pretty printing of data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataDumper = buildPerlPackage rec {
    name = "Data-Dumper-2.161";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "3aa4ac1b042b3880438165fb2b2139d377564a8e9928ffe689ede5304ee90558";
    };
    outputs = [ "out" ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataDumperConcise = buildPerlPackage rec {
    name = "Data-Dumper-Concise-2.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "a6c22f113caf31137590def1b7028a7e718eface3228272d0672c25e035d5853";
    };
    meta = {
      description = "Less indentation and newlines plus sub deparsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataEntropy = buildPerlModule rec {
    name = "Data-Entropy-0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "2611c4a1a3038594d79ea4ed14d9e15a9af8f77105f51667795fe4f8a53427e4";
    };
    propagatedBuildInputs = [ CryptRijndael DataFloat HTTPLite ParamsClassify ];
  };

  DataFloat = buildPerlModule rec {
    name = "Data-Float-0.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "e2b1523d858930b8bbdbd196f08235f5e678b84919ba87712e26313b9c27518a";
    };
  };

  DataFormValidator = buildPerlPackage rec {
    name = "Data-FormValidator-4.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DF/DFARRELL/${name}.tar.gz";
      sha256 = "c1a539f91c92cbcd8a8d83597ec9a7643fcd8ccf5a94e15382c3765289170066";
    };
    propagatedBuildInputs = [ DateCalc EmailValid FileMMagic ImageSize MIMETypes RegexpCommon ];
    meta = {
      description = "Validates user input (usually from an HTML form) based on input profile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ CGI ];
  };

  DataGUID = buildPerlPackage rec {
    name = "Data-GUID-0.049";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0yx7d4qwsr9n85gslip0y3mdwr5fkncfbwxz7si2a17x95yl7bxq";
    };
    propagatedBuildInputs = [ DataUUID SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/Data-GUID;
      description = "Globally unique identifiers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataHexDump = buildPerlPackage {
    name = "Data-HexDump-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FT/FTASSIN/Data-HexDump-0.02.tar.gz;
      sha256 = "1a9d843e7f667c1c6f77c67af5d77e7462ff23b41937cb17454d03535cd9be70";
    };
    meta = {
      description = "Hexadecimal Dumper";
      maintainers = with stdenv.lib.maintainers; [ AndersonTorres ];
    };
  };

  DataHierarchy = buildPerlPackage {
    name = "Data-Hierarchy-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz;
      sha256 = "1vfrkygdaq0k7006i83jwavg9wgszfcyzbl9b7fp37z2acmyda5k";
    };
    buildInputs = [ TestException ];
  };

  DataICal = buildPerlPackage {
    name = "Data-ICal-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Data-ICal-0.22.tar.gz;
      sha256 = "8ae9d20af244e5a6f606c7325e9d145dd0002676a178357af860a5e156925720";
    };
    buildInputs = [ TestLongString TestNoWarnings TestWarn ];
    propagatedBuildInputs = [ ClassReturnValue TextvFileasData ];
    meta = {
      description = "Generates iCalendar (RFC 2445) calendar files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataInteger = buildPerlModule rec {
    name = "Data-Integer-0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "0m53zxhx9sn49yqh7azlpyy9m65g54v8cd2ha98y77337gg7xdv3";
    };
  };

  DataOptList = buildPerlPackage {
    name = "Data-OptList-0.110";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-OptList-0.110.tar.gz;
      sha256 = "1hzmgr2imdg1fc3hmwx0d56fhsdfyrgmgx7jb4jkyiv6575ifq9n";
    };
    propagatedBuildInputs = [ ParamsUtil SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/data-optlist;
      description = "Parse and validate simple name/value option pairs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPage = buildPerlModule {
    name = "Data-Page-2.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Data-Page-2.02.tar.gz;
      sha256 = "1hvi92c4h2angryc6pngw7gbm3ysc2jfmyxk2wh9ia4vdwpbs554";
    };
    propagatedBuildInputs = [ ClassAccessorChained ];
    buildInputs = [ TestException ];
  };

  DataPagePageset = buildPerlModule rec {
    name = "Data-Page-Pageset-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHUNZI/Data-Page-Pageset-1.02.tar.gz;
      sha256 = "142isi8la383dbjxj7lfgcbmmrpzwckcc4wma6rdl8ryajsipb6f";
    };
    buildInputs = [ ClassAccessor DataPage TestException ];
    meta = {
      description = "change long page list to be shorter and well navigate";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPassword = buildPerlPackage {
    name = "Data-Password-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz;
      sha256 = "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961";
    };
  };

  DataPerl = buildPerlPackage rec {
    name = "Data-Perl-0.002009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTP/${name}.tar.gz";
      sha256 = "b62b2225870c2c3b16fb78c429f8729ddb8ed0e342f4209ec3c261b764c36f8b";
    };
    buildInputs = [ TestDeep TestFatal TestOutput ];
    propagatedBuildInputs = [ ClassMethodModifiers ListMoreUtils ModuleRuntime RoleTiny strictures ];
    meta = {
      homepage = https://github.com/mattp-/Data-Perl;
      description = "Base classes wrapping fundamental Perl data types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSection = buildPerlPackage rec {
    name = "Data-Section-0.200007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1pmlxca0a8sv2jjwvhwgqavq6iwys6kf457lby4anjp3f1dpx4yd";
    };
    propagatedBuildInputs = [ MROCompat SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/data-section;
      description = "Read multiple hunks of data out of your DATA section";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestFailWarnings ];
  };

  DataSerializer = buildPerlModule {
    name = "Data-Serializer-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEELY/Data-Serializer-0.60.tar.gz;
      sha256 = "0ca4s811l7f2bqkx7vnyxbpp4f0qska89g2pvsfb3k0bhhbk0jdk";
    };
    meta = {
      description = "Modules that serialize data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSpreadPagination = buildPerlPackage {
    name = "Data-SpreadPagination-0.1.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KN/KNEW/Data-SpreadPagination-0.1.2.tar.gz;
      sha256 = "74ebfd847132c38cc9e835e14e82c43f1809a95cbc98bb84d1f7ce2e4ef487e3";
    };
    propagatedBuildInputs = [ DataPage MathRound ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStreamBulk = buildPerlPackage {
    name = "Data-Stream-Bulk-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Data-Stream-Bulk-0.11.tar.gz;
      sha256 = "06e08432a6b97705606c925709b99129ad926516e477d58e4461e4b3d9f30917";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ Moose PathClass namespaceclean ];
    meta = {
      homepage = https://metacpan.org/release/Data-Stream-Bulk;
      description = "N at a time iteration API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStructureUtil = buildPerlPackage rec {
    name = "Data-Structure-Util-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "9cd42a13e65cb15f3a76296eb9a134da220168ec747c568d331a50ae7a2ddbc6";
    };
    buildInputs = [ TestPod ];
    meta = {
      description = "Change nature of data within a structure";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataTaxi = buildPerlPackage {
    name = "Data-Taxi-0.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/Data-Taxi-0.96.tar.gz;
      sha256 = "0y4wls4jlwd6prvd77szymddhq9sfj06kaqnk4frlvd0zh83djxb";
    };
    buildInputs = [ DebugShowStuff ];
  };

  DataUniqid = buildPerlPackage rec {
    name = "Data-Uniqid-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MW/MWX/${name}.tar.gz";
      sha256 = "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb";
    };
  };

  DataURIEncode = buildPerlPackage rec {
    name = "Data-URIEncode-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "51c9efbf8423853616eaa24841e4d1996b2db0036900617fb1dbc76c75a1f360";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataUUID = buildPerlPackage rec {
    name = "Data-UUID-1.221";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-UUID-1.221.tar.gz;
      sha256 = "0rw60wib0mj5z0v909mplh750y40hzyzf4z0b6h4ajxplyiv5irw";
    };
  };

  DataUUIDMT = buildPerlPackage {
    name = "Data-UUID-MT-1.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Data-UUID-MT-1.001.tar.gz;
      sha256 = "0bb7qibq1c5lhaihxa1sck9pb744p8c7172jgx5zh4c32ac4nk1h";
    };
    buildInputs = [ ListAllUtils ];
    propagatedBuildInputs = [ MathRandomMTAuto ];
    meta = {
      homepage = https://metacpan.org/release/Data-UUID-MT;
      description = "Fast random UUID generator using the Mersenne Twister algorithm";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DataValidateDomain = buildPerlPackage rec {
    name = "Data-Validate-Domain-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "4470f253b8d2720a4dd3fa3ae550995417c2269f3be7ff030e01afa04a3a9421";
    };
    buildInputs = [ Test2Suite TestSimple13 ];
    propagatedBuildInputs = [ NetDomainTLD ];
    meta = {
      homepage = https://metacpan.org/release/Data-Validate-Domain;
      description = "Domain and host name validation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DataValidateIP = buildPerlPackage rec {
    name = "Data-Validate-IP-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "e1aa92235dcb9c6fd9b6c8cda184d1af73537cc77f4f83a0f88207a8bfbfb7d6";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ NetAddrIP ];
    meta = {
      homepage = https://metacpan.org/release/Data-Validate-IP;
      description = "IPv4 and IPv6 validation methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DataValidateURI = buildPerlPackage rec {
    name = "Data-Validate-URI-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SO/SONNEN/${name}.tar.gz";
      sha256 = "f06418d2a4603913d1b6ce52b167dd13e787e13bf2be325a065df7d408f79c60";
    };
    propagatedBuildInputs = [ DataValidateDomain DataValidateIP ];
    meta = {
      description = "Common URL validation methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DataVisitor = buildPerlPackage rec {
    name = "Data-Visitor-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0m7d1505af9z2hj5aw020grcmjjlvnkjpvjam457d7k5qfy4m8lf";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ Moose TaskWeaken TieToObject namespaceclean ];
  };

  DateCalc = buildPerlPackage {
    name = "Date-Calc-6.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-6.4.tar.gz;
      sha256 = "1barz0jgdaan3jm7ciphs5n3ahwkl42imprs3y8c1dwpwyr3gqbw";
    };
    propagatedBuildInputs = [ BitVector ];
    doCheck = false; # some of the checks rely on the year being <2015
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateExtract = buildPerlPackage {
    name = "Date-Extract-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Date-Extract-0.06.tar.gz;
      sha256 = "bc7658d5c50c3525ec0efcb55236a5de2d5d4fc06fc147fa3929c8f0953cda2b";
    };
    buildInputs = [ TestMockTime ];
    propagatedBuildInputs = [ DateTimeFormatNatural ];
  };

  DateManip = buildPerlPackage rec {
    name = "Date-Manip-6.70";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/${name}.tar.gz";
      sha256 = "0r4k4ypb09xwhvq6das0vpx2c0xbhhhx83knq6jfpf8m55h8qi9r";
    };
    # for some reason, parsing /etc/localtime does not work anymore - make sure that the fallback "/bin/date +%Z" will work
    patchPhase = ''
      sed -i "s#/bin/date#${pkgs.coreutils}/bin/date#" lib/Date/Manip/TZ.pm
    '';
    meta = {
      description = "Date manipulation routines";
    };
    buildInputs = [ TestInter ];
  };

  DateSimple = buildPerlPackage {
    name = "Date-Simple-3.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz;
      sha256 = "29a1926314ce1681a312d6155c29590c771ddacf91b7485873ce449ef209dd04";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl2Plus ];
    };
  };

  DateTime = buildPerlPackage rec {
    name = "DateTime-1.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0glcsvgldrmbwbaps6hssjzipzghhx4jh3g4jdncjspdmdp481ah";
    };
    buildInputs = [ CPANMetaCheck TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTimeLocale DateTimeTimeZone ];
    meta = {
      description = "A date and time object";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeCalendarJulian = buildPerlPackage rec {
    name = "DateTime-Calendar-Julian-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PI/PIJLL/${name}.tar.gz";
      sha256 = "03h0llkwsiw2d2ci1ah5x9sp8xrvnbgd471i5hnpgl5w32nnhndv";
    };
    meta = {
      description = "Dates in the Julian calendar";
      license = stdenv.lib.licenses.artistic2;
    };
    buildInputs = [ DateTime ];
  };

  DateTimeEventICal = buildPerlPackage rec {
    name = "DateTime-Event-ICal-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/${name}.tar.gz";
      sha256 = "1skmykxbrf98ldi72d5s1v6228gfdr5iy4y0gpl0xwswxy247njk";
    };
    propagatedBuildInputs = [ DateTimeEventRecurrence ];
    meta = {
      description = "DateTime rfc2445 recurrences";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeEventRecurrence = buildPerlPackage {
    name = "DateTime-Event-Recurrence-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-Recurrence-0.19.tar.gz;
      sha256 = "f9408789a461107766ca1a232bb3ec1e702eec7ca8167401ea6ec3f4b6d0b5a5";
    };
    propagatedBuildInputs = [ DateTimeSet ];
  };

  DateTimeFormatBuilder = buildPerlPackage {
    name = "DateTime-Format-Builder-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.81.tar.gz;
      sha256 = "7cd58a8cb53bf698407cc992f89e4d49bf3dc55baf4f3f00f1def63a0fff33ef";
    };
    propagatedBuildInputs = [ ClassFactoryUtil DateTimeFormatStrptime ParamsValidate ];
    meta = {
      description = "Create DateTime parser classes and objects";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeFormatDateParse = buildPerlModule {
    name = "DateTime-Format-DateParse-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-DateParse-0.05.tar.gz;
      sha256 = "f6eca4c8be66ce9992ee150932f8fcf07809fd3d1664caf200b8a5fd3a7e5ebc";
    };
    propagatedBuildInputs = [ DateTime TimeDate ];
    meta = {
      description = "Parses Date::Parse compatible formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatFlexible = buildPerlPackage {
    name = "DateTime-Format-Flexible-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THINC/DateTime-Format-Flexible-0.30.tar.gz;
      sha256 = "e7974e0492d7801682b400dd8e9a6fbfd8a56602942883cd7867a2008734cca4";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ListMoreUtils ModulePluggable ];
    meta = {
      description = "Flexibly parse strings and turn them into DateTime objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestException TestMockTime TestNoWarnings ];
  };

  DateTimeFormatHTTP = buildPerlModule rec {
    name = "DateTime-Format-HTTP-0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CK/CKRAS/${name}.tar.gz";
      sha256 = "0h6qqdg1yzqkdxp7hqlp0qa7d1y64nilgimxs79dys2ryjfpcknh";
    };
    propagatedBuildInputs = [ DateTime HTTPDate ];
    meta = {
      description = "Date conversion routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatICal = buildPerlModule {
    name = "DateTime-Format-ICal-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ICal-0.09.tar.gz;
      sha256 = "8b09f6539f5e9c0df0e6135031699ed4ef9eef8165fc80aefeecc817ef997c33";
    };
    propagatedBuildInputs = [ DateTimeEventICal ];
    meta = {
      description = "Parse and format iCal datetime and duration strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatISO8601 = buildPerlModule {
    name = "DateTime-Format-ISO8601-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-ISO8601-0.08.tar.gz;
      sha256 = "1syccqd5jlwms8v78ksnf68xijzl97jky5vbwhnyhxi5gvgfx8xk";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    meta = {
      description = "Parses ISO8601 formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateTimeFormatMail = buildPerlPackage {
    name = "DateTime-Format-Mail-0.403";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOOK/DateTime-Format-Mail-0.403.tar.gz;
      sha256 = "8df8e35c4477388ff5c7ce8b3e8b6ae4ed30209c7a5051d41737bd14d755fcb0";
    };
    propagatedBuildInputs = [ DateTime ParamsValidate ];
    meta = {
      description = "Convert between DateTime and RFC2822/822 formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatNatural = buildPerlModule {
    name = "DateTime-Format-Natural-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SC/SCHUBIGER/DateTime-Format-Natural-1.05.tar.gz;
      sha256 = "10ldrhz5rnpsd8qmqn1a4s0w5hhfbjrr13a93yx7kpp89g85pxqv";
    };
    buildInputs = [ ModuleUtil TestMockTime ];
    propagatedBuildInputs = [ Clone DateTime ListMoreUtils ParamsValidate boolean ];
    meta = {
      description = "Create machine readable date/time with natural parsing logic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatMySQL = buildPerlModule rec {
    name = "DateTime-Format-MySQL-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XM/XMIKEW/${name}.tar.gz";
      sha256 = "07cgz60gxvrv7xqvngyll60pa8cx93h3jyx9kc9wdkn95qbd864q";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    meta = {
      description = "Parse and format MySQL dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DateTimeFormatPg = buildPerlModule {
    name = "DateTime-Format-Pg-0.16013";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMAKI/DateTime-Format-Pg-0.16013.tar.gz;
      sha256 = "16siw0f3a0ilzv5fnfas5s9n92drjy271yf6qvmmpm0vwnjjx1kz";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    meta = {
      description = "Parse and format PostgreSQL dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  DateTimeFormatStrptime = buildPerlPackage rec {
    name = "DateTime-Format-Strptime-1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "4fcfb2ac4f79d7ff2855a405f39050d2ea691ee098ce54ede8af79c8d6ab3c19";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTime PackageDeprecationManager ];
    meta = {
      homepage = https://metacpan.org/release/DateTime-Format-Strptime;
      description = "Parse and format strp and strf time patterns";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeFormatSQLite = buildPerlPackage rec {
    name = "DateTime-Format-SQLite-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/${name}.tar.gz";
      sha256 = "cc1f4e0ae1d39b0d4c3dddccfd7423c77c67a70950c4b5ecabf8ca553ab294b4";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    meta = {
      description = "Parse and format SQLite dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatW3CDTF = buildPerlPackage {
    name = "DateTime-Format-W3CDTF-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GW/GWILLIAMS/DateTime-Format-W3CDTF-0.07.tar.gz;
      sha256 = "69a02b661bbf1daa14a4813cb6786eaa66dbdf2743f0b3f458e30234c3a26268";
    };
    propagatedBuildInputs = [ DateTime ];
    meta = {
      homepage = http://search.cpan.org/dist/DateTime-Format-W3CDTF/;
      description = "Parse and format W3CDTF datetime strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeLocale = buildPerlPackage rec {
    name = "DateTime-Locale-1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0ca6598b3f89e92e3d1140e5685c69f6f795f6eed158fa482f33ce2122b35cc9";
    };
    buildInputs = [ CPANMetaCheck FileShareDirInstall TestFatal TestFileShareDir TestRequires TestWarnings ];
    propagatedBuildInputs = [ FileShareDir ParamsValidationCompiler ScalarListUtils Specio namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/DateTime-Locale;
      description = "Localization support for DateTime.pm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeSet = buildPerlModule rec {
    name = "DateTime-Set-0.3900";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/${name}.tar.gz";
      sha256 = "94f41c3924aafde4ef7fa6b58e0595d4038d8ac5ffd62ba111b13c5f4dbc0946";
    };
    propagatedBuildInputs = [ DateTime ParamsValidate SetInfinite ];
    meta = {
      description = "DateTime set objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeTimeZone = buildPerlPackage rec {
    name = "DateTime-TimeZone-2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "b7f74295650bde3f378017113dcc504cefecc054cf6ef31133dc76940e15453a";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassSingleton ParamsValidationCompiler Specio namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/DateTime-TimeZone;
      description = "Time zone object base class and factory";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeXEasy = buildPerlPackage {
    name = "DateTimeX-Easy-0.089";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROKR/DateTimeX-Easy-0.089.tar.gz;
      sha256 = "17e6d202e7ac6049523048e97bb8f195e3c79208570da1504f4313584e487a79";
    };
    buildInputs = [ TestMost ];
    propagatedBuildInputs = [ DateTimeFormatFlexible DateTimeFormatICal DateTimeFormatNatural TimeDate ];
    doCheck = false;
    meta = {
      description = "Parse a date/time string using the best method available";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DebugShowStuff = buildPerlModule {
    name = "Debug-ShowStuff-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/Debug-ShowStuff-1.16.tar.gz;
      sha256 = "1drcrnji3yrd0s3xb69bxnqa51s19c13w68vhvjad3nvswn5vpd4";
    };
    propagatedBuildInputs = [ ClassISA DevelStackTrace StringUtil TermReadKey TextTabularDisplay TieIxHash ];
    meta = {
      description = "A collection of handy debugging routines for displaying the values of variables with a minimum of coding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCaller = buildPerlPackage {
    name = "Devel-Caller-2.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Devel-Caller-2.06.tar.gz;
      sha256 = "1pxpimifzmnjnvf4icclx77myc15ahh0k56sj1djad1855mawwva";
    };
    propagatedBuildInputs = [ PadWalker ];
    meta = {
      description = "Meatier versions of C<caller>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCheckBin = buildPerlPackage rec {
     name = "Devel-CheckBin-0.04";
     src = fetchurl {
       url = mirror://cpan/authors/id/T/TO/TOKUHIROM/Devel-CheckBin-0.04.tar.gz;
       sha256 = "1r735yzgvsxkj4m6ks34xva5m21cfzp9qiis2d4ivv99kjskszqm";
     };
     meta = {
       description = "check that a command is available";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/tokuhirom/Devel-CheckBin";
     };
  };

  DevelCheckCompiler = buildPerlModule rec {
     name = "Devel-CheckCompiler-0.07";
     src = fetchurl {
       url = mirror://cpan/authors/id/S/SY/SYOHEX/Devel-CheckCompiler-0.07.tar.gz;
       sha256 = "1db973a4dbyknjxq608hywil5ai6vplnayshqxrd7m5qnjbpd2vn";
     };
     buildInputs = [ ModuleBuildTiny ];
     meta = {
       description = "Check the compiler's availability";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/tokuhirom/Devel-CheckCompiler";
     };
  };

  DevelChecklib = buildPerlPackage rec {
    name = "Devel-CheckLib-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/${name}.tar.gz";
      sha256 = "1h9jna2d83kpckkm87xwqx84kwd83d2dsynky3hnvgl0gqc1qvdx";
    };
    buildInputs = [ IOCaptureOutput MockConfig ];
  };

  DevelCheckOS = buildPerlPackage rec {
    name = "Devel-CheckOS-1.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/${name}.tar.gz";
      sha256 = "f3c17b56b79283b62616f938d36c57adc9df06bfaa295ff98be21e9014a23b10";
    };
    propagatedBuildInputs = [ DataCompare ];
  };

  DevelPatchPerl = buildPerlPackage rec {
    name = "Devel-PatchPerl-1.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "1zlh1pmlihzcabj2zyfdnrqj6kfl3n9769yfrs296wxgaa7bra96";
    };
    propagatedBuildInputs = [ Filepushd ModulePluggable ];
    meta = {
      homepage = https://github.com/bingos/devel-patchperl;
      description = "Patch perl source a la Devel::PPPort's buildperl.pl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPPPort = buildPerlPackage rec {
    name = "Devel-PPPort-3.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WO/WOLFSAGE/${name}.tar.gz";
      sha256 = "b70fb1b4e2d48983ad20052fd7ae6df4c10ceffdedbacb2d691ddc9c957afa52";
    };
    meta = {
      description = "Perl/Pollution/Portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSelfStubber = buildPerlPackage {
    name = "Devel-SelfStubber-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-SelfStubber-1.05.tar.gz;
      sha256 = "b7bd750e41ec2dbca3f2f1d48e5e8ba594dcc8bc7a923a2565611ab8d0846bf8";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Devel-SelfStubber;
      description = "Generate stubs for a SelfLoading module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSizeMe = buildPerlPackage {
    name = "Devel-SizeMe-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/Devel-SizeMe-0.19.tar.gz;
      sha256 = "546e31ba83c0bf7cef37b38a462860461850473479d7d4ac6c0dadfb78d54717";
    };
    propagatedBuildInputs = [ DBDSQLite DBI DataDumperConcise HTMLParser JSONXS Moo ];
    meta = {
      homepage = https://github.com/timbunce/devel-sizeme;
      description = "Unknown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      # See https://rt.cpan.org/Public/Bug/Display.html?id=92348
      broken = true;
    };
  };

  DevelTrace = buildPerlPackage {
    name = "Devel-Trace-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Devel-Trace-0.12.tar.gz;
      sha256 = "0s1q1a05gk3xvwqkya3k05vqjk13rvb489g0frprhzpzfvvwl0gm";
    };
    meta = {
      description = "Print out each line before it is executed (like sh -x)";
      license = stdenv.lib.licenses.publicDomain;
    };
  };

  DBDMock = buildPerlModule {
    name = "DBD-Mock-1.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DI/DICHI/DBD-Mock/DBD-Mock-1.45.tar.gz;
      sha256 = "40a80c37b31ef14536b58b4a8b483e65953b00b8fa7397817c7eb76d540bd00f";
    };
    propagatedBuildInputs = [ DBI ];
    buildInputs = [ TestException ];
  };

  DBDSQLite = import ../development/perl-modules/DBD-SQLite {
    inherit stdenv fetchurl buildPerlPackage DBI;
    inherit (pkgs) sqlite;
  };

  DBDmysql = import ../development/perl-modules/DBD-mysql {
    inherit fetchurl buildPerlPackage DBI;
    inherit (pkgs) mysql;
  };

  DBDPg = import ../development/perl-modules/DBD-Pg {
    inherit stdenv fetchurl buildPerlPackage DBI;
    inherit (pkgs) postgresql;
  };

  DBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) db;
  };

  DBI = buildPerlPackage rec {
    name = "DBI-${version}";
    version = "1.641";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/${name}.tar.gz";
      sha256 = "5509e532cdd0e3d91eda550578deaac29e2f008a12b64576e8c261bb92e8c2c1";
    };
    postInstall = stdenv.lib.optionalString (perl ? crossVersion) ''
      mkdir -p $out/lib/perl5/site_perl/cross_perl/${perl.version}/DBI
      cat > $out/lib/perl5/site_perl/cross_perl/${perl.version}/DBI.pm <<EOF
      package DBI;
      BEGIN {
      our \$VERSION = "$version";
      }
      1;
      EOF

      autodir=$(echo $out/lib/perl5/site_perl/${perl.version}/*/auto/DBI)
      cat > $out/lib/perl5/site_perl/cross_perl/${perl.version}/DBI/DBD.pm <<EOF
      package DBI::DBD;
      use Exporter ();
      use vars qw (@ISA @EXPORT);
      @ISA = qw(Exporter);
      @EXPORT = qw(dbd_postamble);
      sub dbd_postamble {
          return '
      # --- This section was generated by DBI::DBD::dbd_postamble()
      DBI_INSTARCH_DIR=$autodir
      DBI_DRIVER_XST=$autodir/Driver.xst

      # The main dependency (technically correct but probably not used)
      \$(BASEEXT).c: \$(BASEEXT).xsi

      # This dependency is needed since MakeMaker uses the .xs.o rule
      \$(BASEEXT)\$(OBJ_EXT): \$(BASEEXT).xsi

      \$(BASEEXT).xsi: \$(DBI_DRIVER_XST) $autodir/Driver_xst.h
        \$(PERL) -p -e "s/~DRIVER~/\$(BASEEXT)/g" \$(DBI_DRIVER_XST) > \$(BASEEXT).xsi

      # ---
      ';
      }
      1;
      EOF
    '';
    meta = {
      homepage = http://dbi.perl.org/;
      description = "Database independent interface for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  DBIxClass = buildPerlPackage rec {
    name = "DBIx-Class-0.082841";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "d705f85825aced299020534349778537524526d64f524217ca362787f683c3bd";
    };
    buildInputs = [ DBDSQLite TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ ClassAccessorGrouped ClassC3Componentised ConfigAny ContextPreserve DBI DataDumperConcise DataPage ModuleFind PathClass SQLAbstract ScopeGuard SubName namespaceclean ];
    meta = {
      homepage = http://www.dbix-class.org/;
      description = "Extensible and flexible object <-> relational mapper";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassCandy = buildPerlPackage rec {
    name = "DBIx-Class-Candy-0.005003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "b8a229a7b15f559095d4561cf8220460128541ba7fc3545ed35869923d46565c";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ DBIxClass LinguaENInflect SubExporter ];
    meta = {
      homepage = https://github.com/frioux/DBIx-Class-Candy;
      description = "Sugar for your favorite ORM, DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassCursorCached = buildPerlPackage {
    name = "DBIx-Class-Cursor-Cached-1.001004";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARCANEZ/DBIx-Class-Cursor-Cached-1.001004.tar.gz;
      sha256 = "09b2jahn2x12qm4f7qm1jzsxbz7qn1czp6a3fnl5l2i3l4r5421p";
    };
    buildInputs = [ CacheCache DBDSQLite ];
    propagatedBuildInputs = [ CarpClan DBIxClass ];
    meta = {
      description = "Cursor class with built-in caching support";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassHTMLWidget = buildPerlPackage rec {
    name = "DBIx-Class-HTMLWidget-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/${name}.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [DBIxClass HTMLWidget];
  };

  DBIxClassHelpers = buildPerlPackage rec {
    name = "DBIx-Class-Helpers-2.033004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "14bc7adda3b30867311717faa11a4534bceda3061229dc2533647c1906d8784c";
    };
    buildInputs = [ DBDSQLite DateTimeFormatSQLite TestDeep TestFatal TestRoo aliased ];
    propagatedBuildInputs = [ CarpClan DBIxClassCandy DBIxIntrospector SafeIsa TextBrew ];
    meta = {
      homepage = https://github.com/frioux/DBIx-Class-Helpers;
      description = "Simplify the common case stuff for DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassIntrospectableM2M = buildPerlPackage rec {
    name = "DBIx-Class-IntrospectableM2M-0.001002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "c6baafb4241693fdb34b29ebd906993add364bf31aafa4462f3e062204cc87f0";
    };
    propagatedBuildInputs = [ DBIxClass ];
    meta = {
      description = "Introspect many-to-many relationships";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassSchemaLoader = buildPerlPackage rec {
    name = "DBIx-Class-Schema-Loader-0.07049";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "e869cdde1378cfebccf229b0cde58d2746dc6080b75f56d072aa5f1fce76a764";
    };
    buildInputs = [ DBDSQLite TestDeep TestDifferences TestException TestWarn ];
    propagatedBuildInputs = [ CarpClan ClassUnload DBIxClass DataDump StringToIdentifierEN curry ];
    meta = {
      description = "Create a DBIx::Class::Schema based on a database";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxConnector = buildPerlModule rec {
    name = "DBIx-Connector-0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "57c08d2c1951486cb95cfb83f518f462a3dbf20d353f3eee4f46af44fa19c359";
    };
    buildInputs = [ TestMockModule ];
    propagatedBuildInputs = [ DBI ];
    meta = {
      homepage = http://search.cpan.org/dist/DBIx-Connector/;
      description = "Fast, safe DBI connection and transaction management";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  DBIxDBSchema = buildPerlPackage {
    name = "DBIx-DBSchema-0.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IV/IVAN/DBIx-DBSchema-0.45.tar.gz;
      sha256 = "7a2a978fb6d9feaa3e4b109c71c963b26a008a2d130c5876ecf24c5a72338a1d";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Unknown";
      license = "unknown";
    };
  };

  DBIxHTMLViewLATEST = buildPerlPackage {
    name = "DBIx-HTMLView-LATEST";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAKANARDO/DBIx-HTMLView-LATEST.tar.gz;
      sha256 = "b1af44cba329a8f583d174c5e82a7a2e91fe4f3a35cc38cbf028449578114dfa";
    };
    doCheck = false;
  };

  DBIxSearchBuilder = buildPerlPackage {
    name = "DBIx-SearchBuilder-1.67";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BP/BPS/DBIx-SearchBuilder-1.67.tar.gz;
      sha256 = "453179c22a61af573e502c8396f3f28daea03dfdc162094b90f9b3c331d563da";
    };
    buildInputs = [ DBDSQLite ];
    propagatedBuildInputs = [ CacheSimpleTimedExpiry ClassAccessor ClassReturnValue Clone DBIxDBSchema Want capitalization ];
    meta = {
      description = "Encapsulate SQL queries and rows in simple perl objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxSimple = buildPerlPackage {
    name = "DBIx-Simple-1.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JU/JUERD/DBIx-Simple-1.37.tar.gz;
      sha256 = "46d311aa2ce08907401c56119658426dbb044c5a40de73d9a7b79bf50390cae3";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Very complete easy-to-use OO interface to DBI";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DBIxIntrospector = buildPerlPackage rec {
    name = "DBIx-Introspector-0.001005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "0fp6h71xv4pgb8l815rs6ad4camzhjqf64s1sf7zmhchqqn4vacn";
    };

    propagatedBuildInputs = [ DBI Moo ];
    buildInputs = [ DBDSQLite TestFatal TestRoo ];
  };

  DevelCycle = buildPerlPackage {
    name = "Devel-Cycle-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LD/LDS/Devel-Cycle-1.12.tar.gz;
      sha256 = "1hhb77kz3dys8yaik452j22cm3510zald2mpvfyv5clqv326aczx";
    };
    meta = {
      description = "Find memory cycles in objects";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelDeclare = buildPerlPackage rec {
    name = "Devel-Declare-0.006019";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "ac719dc289cbf53fbb3b090ccd3a55a9d207f24e09480423c96f7185af131808";
    };
    buildInputs = [ ExtUtilsDepends TestRequires ];
    propagatedBuildInputs = [ BHooksEndOfScope BHooksOPCheck SubName ];
    meta = {
      description = "Adding keywords to perl, in perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  DevelFindPerl = buildPerlPackage rec {
    name = "Devel-FindPerl-0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "0ns95dsgmr8s0f1dfwd1cyv32vmd22w0vs51ppnnzp5zyi499581";
    };
    meta = {
      description = "Find the path to your perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelGlobalDestruction = buildPerlPackage rec {
    name = "Devel-GlobalDestruction-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "1aslj6myylsvzr0vpqry1cmmvzbmpbdcl4v9zrl18ccik7rabf1l";
    };
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      homepage = http://search.cpan.org/dist/Devel-GlobalDestruction;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelGlobalPhase = buildPerlPackage rec {
     name = "Devel-GlobalPhase-0.003003";
     src = fetchurl {
       url = mirror://cpan/authors/id/H/HA/HAARG/Devel-GlobalPhase-0.003003.tar.gz;
       sha256 = "1x9jzy3l7gwikj57swzl94qsq03j9na9h1m69azzs7d7ghph58wd";
     };
     meta = {
       description = "Detect perl's global phase on older perls.";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  DevelHide = buildPerlPackage rec {
    name = "Devel-Hide-0.0009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "1phnzbw58v6551nhv6sg86m72nx9w5j4msh1hg4jvkakkq5w9pki";
    };
  };

  DevelNYTProf = buildPerlPackage rec {
    name = "Devel-NYTProf-6.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/${name}.tar.gz";
      sha256 = "b2a9f8b49afb9be8d087ddb50ef77a53f3796481b37eb5a965e1d4055445db1c";
    };
    propagatedBuildInputs = [ FileWhich JSONMaybeXS ];
    meta = {
      homepage = https://github.com/timbunce/devel-nytprof;
      description = "Powerful fast feature-rich Perl source code profiler";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestDifferences ];
  };

  DevelOverloadInfo = buildPerlPackage rec {
     name = "Devel-OverloadInfo-0.005";
     src = fetchurl {
       url = mirror://cpan/authors/id/I/IL/ILMARI/Devel-OverloadInfo-0.005.tar.gz;
       sha256 = "1rx6g8pyhi7lx6z130b7vlf8syzrq92w9ky8mpw4d6bwlkzy5zcb";
     };
     propagatedBuildInputs = [ MROCompat PackageStash SubIdentify ];
     buildInputs = [ TestFatal ];
     meta = {
       description = "introspect overloaded operators";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  DevelPartialDump = buildPerlPackage {
    name = "Devel-PartialDump-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Devel-PartialDump-0.20.tar.gz;
      sha256 = "01yrsdpn9ns9iwwc92bhjn2605b7ys7i3198gjb935lsllzgzw5f";
    };
    propagatedBuildInputs = [ ClassTiny SubExporter namespaceclean ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ TestSimple13 TestWarnings ];
  };

  DevelStackTrace = buildPerlPackage {
    name = "Devel-StackTrace-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.03.tar.gz;
      sha256 = "7618cd4ebe24e254c17085f4b418784ab503cb4cb3baf8f48a7be894e59ba848";
    };
    meta = {
      homepage = https://metacpan.org/release/Devel-StackTrace;
      description = "An object representing a stack trace";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage {
    name = "Devel-StackTrace-AsHTML-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.15.tar.gz;
      sha256 = "0iri5nb2lb76qv5l9z0vjpfrq5j2fyclkd64kh020bvy37idp0v2";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "Displays stack trace in HTML";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSymdump = buildPerlPackage rec {
    name = "Devel-Symdump-2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "826f81a107f5592a2516766ed43beb47e10cc83edc9ea48090b02a36040776c0";
    };
    meta = {
      description = "Dump symbol names or the symbol table";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Digest = buildPerlPackage {
    name = "Digest-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-1.17.tar.gz;
      sha256 = "2f6a54459fc7f37c0669d548bb224b695eb8d2ddc089aa5547645ce1f5fd86f7";
    };
    meta = {
      description = "Modules that calculate message digests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestCRC = buildPerlPackage rec {
    name = "Digest-CRC-0.22.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLIMAUL/${name}.tar.gz";
      sha256 = "112b50f7fbc6f6baf5d4584ee97f542ced6c9ec03a3147f7902c84b8b26778cb";
    };
    meta = {
      description = "Module that calculates CRC sums of all sorts";
      license = stdenv.lib.licenses.publicDomain;
    };
  };

  DigestHMAC = buildPerlPackage {
    name = "Digest-HMAC-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz;
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestHMAC_SHA1 = buildPerlPackage {
    name = "Digest-HMAC_SHA1-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz;
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DigestJHash = buildPerlPackage rec {
    name = "Digest-JHash-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "c746cf0a861a004090263cd54d7728d0c7595a0cf90cbbfd8409b396ee3b0063";
    };
    meta = {
      description = "Perl extension for 32 bit Jenkins Hashing Algorithm";
      license = stdenv.lib.licenses.artistic2;
      maintainers = [ maintainers.rycee ];
    };
  };

  DigestMD4 = buildPerlPackage rec {
    name = "Digest-MD4-1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/${name}.tar.gz";
      sha256 = "19ma1hmvgiznq95ngzvm6v4dfxc9zmi69k8iyfcg6w14lfxi0lb6";
    };
  };

  DigestMD5 = buildPerlPackage {
    name = "Digest-MD5-2.55";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-MD5-2.55.tar.gz;
      sha256 = "03b198a2d14425d951e5e50a885d3818c3162c8fe4c21e18d7798a9a179d0e3c";
    };
    meta = {
      description = "Perl interface to the MD-5 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestMD5File = buildPerlPackage {
    name = "Digest-MD5-File-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMUEY/Digest-MD5-File-0.08.tar.gz;
      sha256 = "060jzf45dlwysw5wsm7av1wvpl06xgk415kwwpvv89r6wda3md5d";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Perl extension for getting MD5 sums for files and urls";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DigestPerlMD5 = buildPerlPackage rec {
    name = "Digest-Perl-MD5-1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DELTA/${name}.tar.gz";
      sha256 = "7100cba1710f45fb0e907d8b1a7bd8caef35c64acd31d7f225aff5affeecd9b1";
    };
    meta = {
      description = "Perl Implementation of Rivest's MD5 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestSHA = null;

  DigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz;
      sha256 = "1k23p5pjk42vvzg8xcn4iwdii47i0qm4awdzgbmz08bl331dmhb8";
    };
    meta = {
      description = "Perl interface to the SHA-1 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistCheckConflicts = buildPerlPackage rec {
    name = "Dist-CheckConflicts-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "1i7dr9jpdiy2nijl2p4q5zg2q2s9ckbj2hs4kmnnckf9hsb4p17a";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Declare version conflicts for your dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZilla = buildPerlPackage {
    name = "Dist-Zilla-4.300039";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-4.300039.tar.gz;
      sha256 = "10cighwsqp53kbk2gwlnl9m18sbs7ijr2v37vwca9qxbscy2yr21";
    };
    buildInputs = [ FileShareDirInstall SoftwareLicense TestFatal TestFileShareDir TestScript ];
    propagatedBuildInputs = [ AppCmd CPANUploader ClassLoad ConfigINI ConfigMVP ConfigMVPReaderINI DataSection DateTime FileCopyRecursive FileFindRule FileHomeDir FileShareDir FileShareDirInstall Filepushd HashMergeSimple JSON ListAllUtils ListMoreUtils LogDispatchouli Moose MooseAutobox MooseXLazyRequire MooseXRoleParameterized MooseXSetOnce MooseXTypes MooseXTypesPathClass MooseXTypesPerl PPI ParamsUtil PathClass PerlPrereqScanner PerlVersion PodEventual SoftwareLicense StringFormatter StringRewritePrefix SubExporter SubExporterForMethods TermReadKey TestDeep TextGlob TextTemplate TryTiny YAMLTiny autobox namespaceautoclean CPANMetaRequirements ];
    meta = {
      homepage = http://dzil.org/;
      description = "Distribution builder; installer not included!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  DistZillaPluginBundleTestingMania = buildPerlPackage {
    name = "Dist-Zilla-PluginBundle-TestingMania-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-PluginBundle-TestingMania-0.21.tar.gz;
      sha256 = "1cbq7v799bf93iqp19v1ln6bcf6gvmc0qw3gf4bq445wsm7w62wy";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox perl ];
    propagatedBuildInputs = [ DistZilla DistZillaPluginMojibakeTests DistZillaPluginNoTabsTests DistZillaPluginTestCPANChanges DistZillaPluginTestCPANMetaJSON DistZillaPluginTestCompile DistZillaPluginTestDistManifest DistZillaPluginTestEOL DistZillaPluginTestKwalitee DistZillaPluginTestMinimumVersion DistZillaPluginTestPerlCritic DistZillaPluginTestPodLinkCheck DistZillaPluginTestPortability DistZillaPluginTestSynopsis DistZillaPluginTestUnusedVars DistZillaPluginTestVersion JSONPP ListMoreUtils Moose PodCoverageTrustPod TestCPANMeta TestPerlCritic TestVersion namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-PluginBundle-TestingMania/;
      description = "Test your dist with every testing plugin conceivable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginCheckChangeLog = buildPerlPackage {
    name = "Dist-Zilla-Plugin-CheckChangeLog-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FA/FAYLAND/Dist-Zilla-Plugin-CheckChangeLog-0.01.tar.gz;
      sha256 = "153dbe5ff8cb3c060901e003237a0515d7b9b5cc870eebfd417a6c91e28edec2";
    };
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Dist::Zilla with Changes check";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginMojibakeTests = buildPerlPackage {
    name = "Dist-Zilla-Plugin-MojibakeTests-0.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Dist-Zilla-Plugin-MojibakeTests-0.5.tar.gz;
      sha256 = "0630acc9bcb415feba49b55a1b70da6e49a740673b4a483fc8058d03c6a21676";
    };
    propagatedBuildInputs = [ DistZilla Moose TestMojibake UnicodeCheckUTF8 ];
    meta = {
      homepage = https://github.com/creaktive/Dist-Zilla-Plugin-MojibakeTests;
      description = "Release tests for source encoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginNoTabsTests = buildPerlPackage {
    name = "Dist-Zilla-Plugin-NoTabsTests-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Dist-Zilla-Plugin-NoTabsTests-0.01.tar.gz;
      sha256 = "fd4ed380de4fc2bad61db377cc50ab26b567e53b3a1efd0b8d8baab80256ef9e";
    };
    propagatedBuildInputs = [ DistZilla Moose TestNoTabs namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-NoTabsTests;
      description = "Release tests making sure hard tabs aren't used";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginPodWeaver = buildPerlPackage {
    name = "Dist-Zilla-Plugin-PodWeaver-3.102000";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-Plugin-PodWeaver-3.102000.tar.gz;
      sha256 = "0xayy50fgfc7wlsnygz28ka2ax9pmr0rn845i8d6p40amrkzzlml";
    };
    buildInputs = [ FileFindRule ];
    propagatedBuildInputs = [ DistZilla ListMoreUtils Moose PPI PodElementalPerlMunger PodWeaver namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Dist-Zilla-Plugin-PodWeaver;
      description = "Weave your Pod together from configuration and Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeAnyFromPod = buildPerlPackage {
    name = "Dist-Zilla-Plugin-ReadmeAnyFromPod-0.131500";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeAnyFromPod-0.131500.tar.gz;
      sha256 = "4d02ce5f185e0d9061019c1925a410931d0c1848db7e5ba5f8e676f04634b06e";
    };
    buildInputs = [ DistZilla TestMost ];
    propagatedBuildInputs = [ DistZilla FileSlurp IOstringy Moose MooseAutobox MooseXHasSugar PodMarkdown ];
    meta = {
      homepage = https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeAnyFromPod;
      description = "Automatically convert POD to a README in any format for Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeMarkdownFromPod = buildPerlPackage {
    name = "Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.120120";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.120120.tar.gz;
      sha256 = "5a3346daab4e2bba850ee4a7898467da9f80bc93cc10d2d625f9880a46092160";
    };
    buildInputs = [ DistZilla TestMost ];
    propagatedBuildInputs = [ DistZillaPluginReadmeAnyFromPod Moose ];
    meta = {
      homepage = https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeMarkdownFromPod;
      description = "Automatically convert POD to a README.mkdn for Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANChanges = buildPerlPackage rec {
    name = "Dist-Zilla-Plugin-Test-CPAN-Changes-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/${name}.tar.gz";
      sha256 = "215b3a5c3c58c8bab0ea27130441bbdaec737eecc00f0670937f608bdbf64806";
    };
    buildInputs = [ CPANChanges DistZilla ];
    propagatedBuildInputs = [ CPANChanges DataSection DistZilla Moose ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-CPAN-Changes/;
      description = "Release tests for your changelog";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANMetaJSON = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.003.tar.gz;
      sha256 = "c76b9f5745f4626969bb9c60e1330ebd0d8b197f8dd33f9a6e6fce63877b4883";
    };
    buildInputs = [ DistZilla ];
    propagatedBuildInputs = [ DistZilla Moose MooseAutobox ];
    meta = {
      homepage = http://p3rl.org/Dist::Zilla::Plugin::Test::CPAN::Meta::JSON;
      description = "Release tests for your META.json";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCompile = buildPerlPackage rec {
    name = "Dist-Zilla-Plugin-Test-Compile-2.054";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "363fc251785a36a0b2028fda3b38d71d30c7048b09145362bbfac13fc41eab7e";
    };
    buildInputs = [ CPANMetaCheck DistZilla Filepushd ModuleBuildTiny PerlPrereqScanner TestDeep TestMinimumVersion TestWarnings self."if" ];
    propagatedBuildInputs = [ DataSection DistZilla Moose PathTiny SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/Dist-Zilla-Plugin-Test-Compile;
      description = "Common tests to check syntax of your modules, only using core modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestDistManifest = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-DistManifest-2.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-DistManifest-2.000004.tar.gz;
      sha256 = "a832d9d04f85e9dd09f30af67c5d636efe79847ec3790939de081ee5e412fb68";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestDistManifest ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-DistManifest/;
      description = "Release tests for the manifest";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestEOL = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-EOL-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Dist-Zilla-Plugin-Test-EOL-0.10.tar.gz;
      sha256 = "1sl7zvjzpwf7wl188a3j13k1qcb63hawx82iy6r3dx2gns8nc0nw";
    };
    buildInputs = [ DistZilla TestScript ];
    propagatedBuildInputs = [ DistZilla Moose TestEOL namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-EOL/;
      description = "Author tests making sure correct line endings are used";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DistZillaPluginTestKwalitee = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Kwalitee-2.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Kwalitee-2.06.tar.gz;
      sha256 = "1723beb96d4048fd4fb0fea2ed36c0c6f3ea4648ce7f93d4cb73e5d49e274bf6";
    };
    buildInputs = [ CaptureTiny DistZilla PathClass perl ];
    propagatedBuildInputs = [ DataSection DistZilla Moose SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-Kwalitee;
      description = "Release tests for kwalitee";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestMinimumVersion = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-MinimumVersion-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-MinimumVersion-2.000005.tar.gz;
      sha256 = "988c71a3158e94e7a0b23f346f19af4a0ed67e101a2653c3185c5ae49981132b";
    };
    buildInputs = [ DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestMinimumVersion ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-MinimumVersion/;
      description = "Release tests for minimum required versions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPerlCritic = buildPerlModule {
    name = "Dist-Zilla-Plugin-Test-Perl-Critic-2.112410";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JQ/JQUELIN/Dist-Zilla-Plugin-Test-Perl-Critic-2.112410.tar.gz;
      sha256 = "3ce59ce3ef6cf56d7de0debb33c26f899492d9742c8b82073e257787fd85630f";
    };
    buildInputs = [ DistZilla MooseAutobox ];
    propagatedBuildInputs = [ DataSection DistZilla Moose namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Perl-Critic/;
      description = "Tests to check your code against best practices";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPodLinkCheck = buildPerlPackage rec {
    name = "Dist-Zilla-Plugin-Test-Pod-LinkCheck-1.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/${name}.tar.gz";
      sha256 = "26f3b257d5037aeec8335910cfdaf76fc8612f38f5d3134f46cd433e116947b0";
    };
#    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ DistZilla Moose TestPodLinkCheck ];
    meta = {
      homepage = https://github.com/rwstauner/Dist-Zilla-Plugin-Test-Pod-LinkCheck;
      description = "Add release tests for POD links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPortability = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Portability-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Portability-2.000005.tar.gz;
      sha256 = "b32d0a4b1d78ba76fabedd299c1a11efed05c3ce9752d7da6babe06d3515242b";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestPortabilityFiles ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-Portability/;
      description = "Release tests for portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestSynopsis = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Synopsis-2.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Synopsis-2.000004.tar.gz;
      sha256 = "d073de3206c5e588f60f55e4be64fab4c2595f5bc3013cd91307993691598d59";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestSynopsis ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-Synopsis/;
      description = "Release tests for synopses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestUnusedVars = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-UnusedVars-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-UnusedVars-2.000005.tar.gz;
      sha256 = "37ec462dc82f45cfd9d6d92ee59b8fd215a9a14b18d179b05912baee77359804";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestVars namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-UnusedVars/;
      description = "Release tests for unused variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestVersion = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Version-0.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Dist-Zilla-Plugin-Test-Version-0.002004.tar.gz;
      sha256 = "4ae5055071e07442223d07d818e9484430368b59c15966b90b18c8abc06f8e36";
    };
    buildInputs = [ DistZilla TestNoTabs TestScript ];
    propagatedBuildInputs = [ DistZilla Moose TestVersion namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Version/;
      description = "Release Test::Version tests";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  EmailAbstract = buildPerlPackage rec {
    name = "Email-Abstract-3.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "fc7169acb6c43df7f005e7ef6ad08ee8ca6eb6796b5d1604593c997337cc8240";
    };
    propagatedBuildInputs = [ EmailSimple MROCompat ModulePluggable ];
    meta = {
      homepage = https://github.com/rjbs/Email-Abstract;
      description = "Unified interface to mail representations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailAddress = buildPerlPackage {
    name = "Email-Address-1.909";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.909.tar.gz;
      sha256 = "0l7x6sl06j9ffgfz5f9vgms2b5axd4cgp5fj03ivb3kia4km6b3g";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "RFC 2822 Address Parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailAddressList = buildPerlPackage {
    name = "Email-Address-List-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Email-Address-List-0.05.tar.gz;
      sha256 = "705c23fc2163c2347ba0aea998450259f7b10577a368c6d310bd4e98b427a033";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ EmailAddress ];
    meta = {
      description = "RFC close address list parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailAddressXS = buildPerlPackage rec {
     name = "Email-Address-XS-1.03";
     src = fetchurl {
       url = mirror://cpan/authors/id/P/PA/PALI/Email-Address-XS-1.03.tar.gz;
       sha256 = "1knf1i9rr20bpzscbvaqsqjgw51pnnga4zlnkgsvw7jpqh4cyj6i";
     };
     meta = {
       description = "Parse and format RFC 2822 email addresses and groups";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  EmailDateFormat = buildPerlPackage rec {
    name = "Email-Date-Format-1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "579c617e303b9d874411c7b61b46b59d36f815718625074ae6832e7bb9db5104";
    };
    meta = {
      homepage = https://github.com/rjbs/Email-Date-Format;
      description = "Produce RFC 2822 date strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailReply = buildPerlPackage rec {
    name = "Email-Reply-1.204";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Reply-1.204.tar.gz;
      sha256 = "ba4fd80ac5017d6d132e0358c786b0ecd1c7adcbeee5c19fb3da2964791a56f0";
    };
    propagatedBuildInputs = [ EmailAbstract EmailAddress EmailMIME ];
    meta = {
      homepage = "http://search.cpan.org/~rjbs/${name}";
      description = "Reply to an email message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMessageID = buildPerlPackage {
    name = "Email-MessageID-1.406";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MessageID-1.406.tar.gz;
      sha256 = "1f22sdnfq169qw1l0lg7y74pmiam7j9v95bggjnf3q4mygdmshpc";
    };
    meta = {
      description = "Generate world unique message-ids";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  EmailMIME = buildPerlPackage rec {
    name = "Email-MIME-1.946";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "68ee79023165d77bec99a2e12ef89ad4e12501e6c321f6822053dc4f411c337c";
    };
    propagatedBuildInputs = [ EmailAddressXS EmailMIMEContentType EmailMIMEEncodings EmailMessageID EmailSimple MIMETypes ModuleRuntime ];
    meta = {
      homepage = https://github.com/rjbs/Email-MIME;
      description = "Easy MIME message handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  EmailMIMEAttachmentStripper = buildPerlPackage rec {
    name = "Email-MIME-Attachment-Stripper-1.317";
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ EmailAbstract EmailMIME ];

    src = fetchurl {
        url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-Attachment-Stripper-1.317.tar.gz;
        sha256 = "dcb98b09dc3e8f757ec3882a4234548108bb2d12e3cfadf95a26cef381a9e789";
    };
    meta = {
        homepage = "http://search.cpan.org/dist/${name}";
        description = "Strip the attachments from an email";
        license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMIMEContentType = buildPerlPackage rec {
    name = "Email-MIME-ContentType-1.022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "9abb7280b0da62a855ae5528b14deb94341a84e721af0a7e5a2adc3534ec5310";
    };
    meta = {
      homepage = https://github.com/rjbs/Email-MIME-ContentType;
      description = "Parse a MIME Content-Type Header";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
    propagatedBuildInputs = [ Encode ];
  };

  EmailMIMEEncodings = buildPerlPackage rec {
    name = "Email-MIME-Encodings-1.315";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4c71045507b31ec853dd60152b40e33ba3741779c0f49bb143b50cf8d243ab5c";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      homepage = https://github.com/rjbs/Email-MIME-Encodings;
      description = "A unified interface to MIME encoding and decoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  EmailMIMEModifier = buildPerlPackage rec {
    doCheck = false; # tests are broken, it seems
    name = "Email-MIME-Modifier-1.444";
    src = fetchurl {
      url = "http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4521cf361527cd9b5e8b0db3d2e6c9588c52de6a8997e1daf5c21ed1eb7a4ba2";
    };
    propagatedBuildInputs = [ EmailMIME EmailMIMEContentType ];
    meta = {
      homepage = "http://search.cpan.org/~rjbs/${name}";
      description = "Modify Email::MIME Objects Easily";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailSend = buildPerlPackage rec {
    name = "Email-Send-2.201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4bbec933558d7cc9b8152bad86dd313de277a21a89b4ea83d84e61587e95dbc6";
    };
    propagatedBuildInputs = [ EmailAbstract EmailAddress ReturnValue ];
    meta = {
      homepage = https://github.com/rjbs/Email-Send;
      description = "Simply Sending Email";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
    buildInputs = [ MIMETools MailTools ];
  };

  EmailOutlookMessage = buildPerlModule rec {
    name = "Email-Outlook-Message-${version}";
    version = "0.919";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MV/MVZ/${name}.tar.gz";
      sha256 = "0fb1gymqa8nlj540dmbb1rhs2b0ln3y9ippbgj0miswcw92iaayb";
    };
    propagatedBuildInputs = [ EmailMIME EmailSender IOAll IOString OLEStorage_Lite ];
    meta = with stdenv.lib; {
      homepage = http://www.matijs.net/software/msgconv/;
      description = "A .MSG to mbox converter";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  EmailSender = buildPerlPackage rec {
    name = "Email-Sender-1.300031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "c412372938510283d8c850127895e09c2b670f892e1c3992fd54c0c1a9064f14";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ EmailAbstract EmailAddress MooXTypesMooseLike ScalarListUtils SubExporter Throwable TryTiny libnet ];
    meta = {
      homepage = https://github.com/rjbs/Email-Sender;
      description = "A library for sending email";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailSimple = buildPerlPackage rec {
    name = "Email-Simple-2.214";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "b2f02b37441ea60efbddebbd675017d26bb767e9a4de3e0fc30b5410a1416b92";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      homepage = https://github.com/rjbs/Email-Simple;
      description = "Simple parsing of RFC2822 message format and headers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailValid = buildPerlPackage rec {
    name = "Email-Valid-1.202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "18hkmhddzbd23s6ak64d4j6q8ijykjyp5nxbr2hfcq1acsdhh8fh";
    };
    propagatedBuildInputs = [ IOCaptureOutput MailTools NetDNS NetDomainTLD ];
    doCheck = false;
  };

  EmailValidLoose = buildPerlPackage rec {
    name = "Email-Valid-Loose-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "e718e76eddee240251c999e139c8cbe6f2cc80192da5af875cbd12fa8ab93a59";
    };
    propagatedBuildInputs = [ EmailValid ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  Encode = buildPerlPackage rec {
    name = "Encode-2.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/${name}.tar.gz";
      sha256 = "044d2fc743bdf5ce4509a0e717a7adb31d488dafae63fde794f57a9f47b2ecb7";
    };
    meta = {
      description = "Character encodings in Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeDetect = buildPerlModule rec {
    name = "Encode-Detect-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JG/JGMYERS/${name}.tar.gz";
      sha256 = "834d893aa7db6ce3f158afbd0e432d6ed15a276e0940db0a74be13fd9c4bbbf1";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    meta = {
      description = "An Encode::Encoding subclass that detects the encoding of data";
      license = stdenv.lib.licenses.free;
    };
  };


  EncodeEUCJPASCII = buildPerlPackage {
    name = "Encode-EUCJPASCII-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz;
      sha256 = "f998d34d55fd9c82cf910786a0448d1edfa60bf68e2c2306724ca67c629de861";
    };
    outputs = [ "out" ];
    meta = {
      description = "EucJP-ascii - An eucJP-open mapping";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeHanExtra = buildPerlPackage {
    name = "Encode-HanExtra-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Encode-HanExtra-0.23.tar.gz;
      sha256 = "1fd4b06cada70858003af153f94c863b3b95f2e3d03ba18d0451a81d51db443a";
    };
    meta = {
      description = "Extra sets of Chinese encodings";
      license = stdenv.lib.licenses.mit;
    };
  };

  EncodeJIS2K = buildPerlPackage {
    name = "Encode-JIS2K-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.03.tar.gz;
      sha256 = "1ec84d72db39deb4dad6fca95acfcc21033f45a24d347c20f9a1a696896c35cc";
    };
    outputs = [ "out" ];
    meta = {
    };
  };

  EncodeLocale = buildPerlPackage rec {
    name = "Encode-Locale-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz;
      sha256 = "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1";
    };
    preCheck = if stdenv.isCygwin then ''
      sed -i"" -e "s@plan tests => 13@plan tests => 10@" t/env.t
      sed -i"" -e "s@ok(env(\"\\\x@#ok(env(\"\\\x@" t/env.t
      sed -i"" -e "s@ok(\$ENV{\"\\\x@#ok(\$ENV{\"\\\x@" t/env.t
    '' else null;
    meta = {
      description = "Determine the locale encoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  enum = buildPerlPackage rec {
    name = "enum-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "d2f36b5015f1e35f640159867b60bf5d5cd66b56cd5e42d33f531be68e5eee35";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Env = buildPerlPackage {
    name = "Env-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Env-1.04.tar.gz;
      sha256 = "d94a3d412df246afdc31a2199cbd8ae915167a3f4684f7b7014ce1200251ebb0";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Env;
      description = "Perl module that imports environment variables as scalars or arrays";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EnvPath = buildPerlPackage {
    name = "Env-Path-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSB/Env-Path-0.19.tar.gz;
      sha256 = "1qhmj15a66h90pjl2dgnxsb9jj3b1r5mpvnr87cafcl8g69z0jr4";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Error = buildPerlModule rec {
    name = "Error-0.17025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1bzgzmf1v4md02vadm46b4j4ilqxrcrfasvbzymhrznlsd54g7vc";
    };
  };

  EV = buildPerlPackage rec {
    name = "EV-4.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "2ae7f8734e2e4945510252152c3bea4be35f4aa58aad3db0504c38844b08a991";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ commonsense ];
    meta = {
      license = stdenv.lib.licenses.gpl1Plus;
    };
  };

  EvalClosure = buildPerlPackage {
    name = "Eval-Closure-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz;
      sha256 = "1bcc47r6zm3hfr6ccsrs72kgwxm3wkk07mgnpsaxi67cypr482ga";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Safely and cleanly create closures via string eval";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExceptionBase = buildPerlModule rec {
    name = "Exception-Base-0.2501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/${name}.tar.gz";
      sha256 = "5723dd78f4ac0b4d262a05ea46af663ea00d8096b2e9c0a43515c210760e1e75";
    };
    buildInputs = [ TestUnitLite ];
    meta = {
      description = "Lightweight exceptions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
    };
  };

  ExceptionClass = buildPerlPackage rec {
    name = "Exception-Class-1.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "03gf4cdgrjnljgrlxkvbh2cahsyzn0zsh2zcli7b1lrqn7wgpwrk";
    };
    propagatedBuildInputs = [ ClassDataInheritable DevelStackTrace ];
  };

  ExceptionDied = buildPerlModule {
    name = "Exception-Died-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Died-0.06.tar.gz;
      sha256 = "1dcajw2m3x5m76fpi3fvy9fjkmfrd171pnx087i5fkgx5ay41i1m";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase constantboolean ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExceptionWarning = buildPerlModule {
    name = "Exception-Warning-0.0401";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Warning-0.0401.tar.gz;
      sha256 = "1a6k3sbhkxmz00wrmhv70f9kxjf7fklp1y6mnprfvcdmrsk9qdkv";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExporterDeclare = buildPerlModule {
    name = "Exporter-Declare-0.114";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Exporter-Declare-0.114.tar.gz;
      sha256 = "4bd70d6ca76f6f6ba7e4c618d4ac93b8593a58f1233ccbe18b10f5f204f1d4e4";
    };
    buildInputs = [ FennecLite TestException ];
    propagatedBuildInputs = [ MetaBuilder aliased ];
    meta = {
      homepage = http://open-exodus.net/projects/Exporter-Declare;
      description = "Exporting done right";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExporterLite = buildPerlPackage {
    name = "Exporter-Lite-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz;
      sha256 = "1hns15imih8z2h6zv3m1wwmv9fiysacsb52y94v6zf2cmw4kjny0";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterTiny = buildPerlPackage {
    name = "Exporter-Tiny-1.000000";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.000000.tar.gz;
      sha256 = "ffdd77d57de099e8f64dd942ef12a00a3f4313c2531f342339eeed2d366ad078";
    };
    meta = {
      homepage = https://metacpan.org/release/Exporter-Tiny;
      description = "An exporter with the features of Sub::Exporter but only core dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsCommand = buildPerlPackage {
    name = "ExtUtils-Command-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Command-1.20.tar.gz;
      sha256 = "740cccc93ba851aae803695b7a5b65ccbaa78bf4e96aa2e54f3f632c87a98c98";
    };
    meta = {
      homepage = http://search.cpan.org/dist/ExtUtils-Command;
      description = "Utilities to replace common UNIX commands in Makefiles etc";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Expect = buildPerlPackage {
    name = "Expect-1.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JACOBY/Expect-1.35.tar.gz;
      sha256 = "09d92761421decd495853103379165a99efbf452c720f30277602cf23679fd06";
    };
    propagatedBuildInputs = [ IOTty ];
    meta = {
      description = "Automate interactions with command line programs that expose a text terminal interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Exporter = buildPerlPackage {
    name = "Exporter-5.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Exporter-5.72.tar.gz;
      sha256 = "cd13b7a0e91e8505a0ce4b25f40fab2c92bb28a99ef0d03da1001d95a32f0291";
    };
    meta = {
      description = "Implements default import method for modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsCBuilder = buildPerlPackage rec {
    name = "ExtUtils-CBuilder-0.280230";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMBS/ExtUtils-CBuilder-0.280230.tar.gz;
      sha256 = "1mcwvic01x0flcz3jsny5j8j5zz96r63qjwq75hs42cpf3by3ahx";
    };
  };

  ExtUtilsCChecker = buildPerlModule rec {
    name = "ExtUtils-CChecker-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/${name}.tar.gz";
      sha256 = "50bfe76870fc1510f56bae4fa2dce0165d9ac4af4e7320d6b8fda14dfea4be0b";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Configure-time utilities for using C headers,";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsConfig = buildPerlPackage {
    name = "ExtUtils-Config-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz;
      sha256 = "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c";
    };
    meta = {
      description = "A wrapper for perl's configuration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsConstant = buildPerlPackage {
    name = "ExtUtils-Constant-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NW/NWCLARK/ExtUtils-Constant-0.24.tar.gz;
      sha256 = "aa9e8c0b564576195a7508374f4a80b97fe3cf4a4c13efe4c949ece3e76b217d";
    };
  };

  ExtUtilsCppGuess = buildPerlPackage rec {
    name = "ExtUtils-CppGuess-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETJ/ExtUtils-CppGuess-0.12.tar.gz;
      sha256 = "0sqq8vadch633cx7w7i47fca49pxzyh82n5kwxdgvsg32mdppi1i";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    propagatedBuildInputs = [ CaptureTiny ];
    buildInputs = [ ModuleBuild ];
  };

  ExtUtilsDepends = buildPerlPackage {
    name = "ExtUtils-Depends-0.405";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.405.tar.gz;
      sha256 = "0b4ab9qmcihsfs2ajhn5qzg7nhazr68v3r0zvb7076smswd41mla";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExtUtilsHelpers = buildPerlPackage {
    name = "ExtUtils-Helpers-0.026";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz;
      sha256 = "05ilqcj1rg5izr09dsqmy5di4fvq6ph4k0chxks7qmd4j1kip46y";
    };
    meta = {
      description = "Various portability utilities for module builders";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstall = buildPerlPackage {
    name = "ExtUtils-Install-2.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Install-2.14.tar.gz;
      sha256 = "35412305cbae979aac3b6e2c70cb301ae461979a1d848a8a043f74518eb96aea";
    };
    meta = {
      homepage = https://metacpan.org/release/ExtUtils-Install;
      description = "Install files from here to there";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstallPaths = buildPerlPackage {
    name = "ExtUtils-InstallPaths-0.011";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.011.tar.gz;
      sha256 = "0z06y0fhx9hy9x01abb7s2xdbqrh9x4ps7avmlf4bwfwih2gl2bn";
    };
    propagatedBuildInputs = [ ExtUtilsConfig ];
    meta = {
      description = "Build.PL install path logic made easy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsLibBuilder = buildPerlModule rec {
    name = "ExtUtils-LibBuilder-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/${name}.tar.gz";
      sha256 = "1lmmfcjxvsvhn4f3v2lyylgr8dzcf5j7mnd1pkq3jc75dph724f5";
    };
    perlPreHook = "export LD=$CC";
    meta = {
      description = "A tool to build C libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsMakeMaker = buildPerlPackage {
    name = "ExtUtils-MakeMaker-7.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.34.tar.gz;
      sha256 = "95f1eb44de480d00b28d031b574ec868f7aeeee199eb5abe5666f6bcbbf68480";
    };
    meta = {
      homepage = https://metacpan.org/release/ExtUtils-MakeMaker;
      description = "Create a module Makefile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsMakeMakerCPANfile = buildPerlPackage rec {
     name = "ExtUtils-MakeMaker-CPANfile-0.08";
     src = fetchurl {
       url = mirror://cpan/authors/id/I/IS/ISHIGAKI/ExtUtils-MakeMaker-CPANfile-0.08.tar.gz;
       sha256 = "0yg2z4six807lraqh8ncsq6l62vj7zi0a38ha9nvmhd6lbipmsql";
     };
     propagatedBuildInputs = [ ModuleCPANfile ];
     meta = {
       description = "cpanfile support for EUMM";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  ExtUtilsManifest = buildPerlPackage rec {
    name = "ExtUtils-Manifest-1.70";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/ExtUtils-Manifest-1.70.tar.gz;
      sha256 = "159bypwl8xpq1yi39prr49hl7x2xww5aj97nv169c8xja0h0dzzf";
    };
  };

  ExtUtilsParseXS = buildPerlPackage rec {
    name = "ExtUtils-ParseXS-3.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "077fqiyabydm8j34wxzxwxskyidh8nmwq9gskaxai8kq298z1pj1";
    };
  };

  ExtUtilsPkgConfig = buildPerlPackage rec {
    name = "ExtUtils-PkgConfig-1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "bbeaced995d7d8d10cfc51a3a5a66da41ceb2bc04fedcab50e10e6300e801c6e";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net;
      description = "Simplistic interface to pkg-config";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  # From CPAN[1]:
  #   This module exists merely as a compatibility wrapper around
  #   ExtUtils::Typemaps. In a nutshell, ExtUtils::Typemap was renamed to
  #   ExtUtils::Typemaps because the Typemap directory in lib/ could collide with
  #   the typemap file on case-insensitive file systems.
  #
  #   The ExtUtils::Typemaps module is part of the ExtUtils::ParseXS distribution
  #   and ships with the standard library of perl starting with perl version
  #   5.16.
  #
  # [1] http://search.cpan.org/~smueller/ExtUtils-Typemap-1.00/lib/ExtUtils/Typemap.pm:
  ExtUtilsTypemap = buildPerlPackage rec {
    name = "ExtUtils-Typemap-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-Typemap-1.00.tar.gz;
      sha256 = "1iqz0xlscg655gnwb2h1wrjj70llblps1zznl29qn1mv5mvibc5i";
    };
  };

  ExtUtilsTypemapsDefault = buildPerlModule rec {
    name = "ExtUtils-Typemaps-Default-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-Typemaps-Default-1.05.tar.gz;
      sha256 = "1phmha0ks95kvzl00r1kgnd5hvg7qb1q9jmzjmw01p5zgs1zbyix";
    };
  };

  ExtUtilsXSBuilder = buildPerlPackage {
    name = "ExtUtils-XSBuilder-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRICHTER/ExtUtils-XSBuilder-0.28.tar.gz;
      sha256 = "8cced386e3d544c5ec2deb3aed055b72ebcfc2ea9a6c807da87c4245272fe80a";
    };
    propagatedBuildInputs = [ ParseRecDescent TieIxHash ];
  };

  ExtUtilsXSpp = buildPerlModule rec {
    name = "ExtUtils-XSpp-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-XSpp-0.18.tar.gz;
      sha256 = "1zx84f93lkymqz7qa4d63gzlnhnkxm5i3gvsrwkvvqr9cxjasxli";
    };
    buildInputs = [ TestBase TestDifferences ];
  };

  FatalException = buildPerlModule {
    name = "Fatal-Exception-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Fatal-Exception-0.05.tar.gz;
      sha256 = "0kzfwc44vpxla3j637kfmnwmv57g6x4899ijqb4ljamk7whms298";
    };
    buildInputs = [ ExceptionWarning TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionDied ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FCGI = buildPerlPackage rec {
    name = "FCGI-0.78";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/FCGI-0.78.tar.gz;
      sha256 = "1cxavhzg4gyw4gl9kirpbdimjr8gk1rjc3pqs3xrnh1gjybld5xa";
    };
  };

  FCGIProcManager = buildPerlPackage {
    name = "FCGI-ProcManager-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARODLAND/FCGI-ProcManager-0.28.tar.gz;
      sha256 = "e1c958c042427a175e051e0008f2025e8ec80613d3c7750597bf8e529b04420e";
    };
    meta = {
      description = "A perl-based FastCGI process manager";
      license = "unknown";
    };
  };

  FennecLite = buildPerlModule {
    name = "Fennec-Lite-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Fennec-Lite-0.004.tar.gz;
      sha256 = "dce28e3932762c2ff92aa52d90405c06e898e81cb7b164ccae8966ae77f1dcab";
    };
    meta = {
      homepage = http://open-exodus.net/projects/Fennec-Lite;
      description = "Minimalist Fennec, the commonly used bits";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileChangeNotify = buildPerlPackage {
    name = "File-ChangeNotify-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/File-ChangeNotify-0.28.tar.gz;
      sha256 = "e00fe809d481131a08dca26e851cf0ffce8d9e9d03d58c58f15aa62e28aa2f05";
    };
    buildInputs = [ TestException TestRequires TestWithoutModule ];
    propagatedBuildInputs = [ ClassLoad ModulePluggable Moo TypeTiny namespaceautoclean ];
    meta = with stdenv.lib; {
      description = "Watch for changes to files, cross-platform style";
      license = licenses.artistic2;
    };
  };

  Filechdir = buildPerlPackage rec {
    name = "File-chdir-0.1010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "009b8p2fzj4nhl03fpkhrn0rsh7myxqbrf69iqpzd86p1gs23hgg";
    };
  };

  FileBaseDir = buildPerlModule rec {
    version = "0.08";
    name = "File-BaseDir-${version}";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KI/KIMRYAN/File-BaseDir-0.08.tar.gz;
      sha256 = "c065fcd3e2f22ae769937bcc971b91f80294d5009fac140bfba83bf7d35305e3";
    };
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    propagatedBuildInputs = [ IPCSystemSimple ];
    buildInputs = [ FileWhich ];
  };

  FileBOM = buildPerlModule rec {
    name = "File-BOM-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTLAW/${name}.tar.gz";
      sha256 = "431c8b39397fd5ad5b1a1100d3647a06e9f94304d46db44ffc0a0e5c5c06a1c1";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Readonly ];
    meta = {
      description = "Utilities for handling Byte Order Marks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCheckTree = buildPerlPackage {
    name = "File-CheckTree-4.42";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/File-CheckTree-4.42.tar.gz;
      sha256 = "66fb417f8ff8a5e5b7ea25606156e70e204861c59fa8c3831925b4dd3f155f8a";
    };
    meta = {
      homepage = http://search.cpan.org/dist/File-CheckTree;
      description = "Run many filetest checks on a tree";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCopyRecursive = buildPerlPackage rec {
    name = "File-Copy-Recursive-0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/${name}.tar.gz";
      sha256 = "18amrqvdjlb4hc7mblbwb63q96ql1rnlb5saknsvrxqfjcxr5f78";
    };
    propagatedBuildInputs = [ PathTiny ];
    buildInputs = [ TestDeep TestException TestFile TestWarn ];
  };

  FileDesktopEntry = buildPerlPackage rec {
    version = "0.04";
    name = "File-DesktopEntry-${version}";
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "d7f80d8bd303651a43dc1810c73740d38a0d2b158fb33cd3b6ca4d3a566da7cb";
    };
    propagatedBuildInputs = [ FileBaseDir ];
  };

  FileFindIterator = buildPerlPackage {
    name = "File-Find-Iterator-0.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TE/TEXMEC/File-Find-Iterator-0.4.tar.gz;
      sha256 = "a2b87ab9756a2e5bb674adbd39937663ed20c28c716bf5a1095a3ca44d54ab2c";
    };
    propagatedBuildInputs = [ ClassIterator ];
    meta = {
    };
  };

  FileFindObject = buildPerlModule rec {
    name = "File-Find-Object-0.3.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-v0.3.2.tar.gz;
      sha256 = "7c467b6b7752bff46b7b8b84c9aabeac45bbfdab1e2224108a2e2170adb9f2b7";
    };
    propagatedBuildInputs = [ ClassXSAccessor ];
    meta = {
      description = "An object oriented File::Find replacement";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  FileFindObjectRule = buildPerlModule rec {
    name = "File-Find-Object-Rule-0.0306";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "2ce55766b25fb8799d37b95bca61e8a71d8a437e28541e1cd06b7eb89f7739d1";
    };
    propagatedBuildInputs = [ FileFindObject NumberCompare TextGlob ];
    meta = {
      homepage = http://www.shlomifish.org/open-source/projects/File-Find-Object/;
      description = "Alternative interface to File::Find::Object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFindRule = buildPerlPackage rec {
    name = "File-Find-Rule-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "1znachnhmi1w5pdqx8dzgfa892jb7x8ivrdy4pzjj7zb6g61cvvy";
    };
    propagatedBuildInputs = [ NumberCompare TextGlob ];
  };

  FileFindRulePerl = buildPerlPackage {
    name = "File-Find-Rule-Perl-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/File-Find-Rule-Perl-1.15.tar.gz;
      sha256 = "9a48433f86e08ce18e03526e2982de52162eb909d19735460f07eefcaf463ea6";
    };
    propagatedBuildInputs = [ FileFindRule ParamsUtil ];
    meta = {
      description = "Common rules for searching for Perl things";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFinder = buildPerlPackage rec {
    name = "File-Finder-0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ME/MERLYN/${name}.tar.gz";
      sha256 = "2ecbc19ac67a9e635c872a807a8d3eaaff5babc054f15a191d47cdfc5f176a74";
    };
    propagatedBuildInputs = [ TextGlob ];
    meta = {
      license = stdenv.lib.licenses.free; # Same as Perl
    };
  };

  FileFnMatch = buildPerlPackage rec {
    name = "File-FnMatch-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJP/File-FnMatch-0.02.tar.gz";
      sha256 = "05p9m7kpmjv8bmmbs5chb5fqyshcgmskbbzq5c9qpskbx2w5894n";
    };
    meta = {
      maintainers = [ maintainers.limeytexan ];
      description = "simple filename and pathname matching";
      license = stdenv.lib.licenses.free; # Same as Perl
    };
  };

  FileHandleUnget = buildPerlPackage rec {
    name = "FileHandle-Unget-0.1628";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/${name}.tar.gz";
      sha256 = "9ef4eb765ddfdc35b350905d8dd0a1e12139eabc586652811bfab41972100fdf";
    };
    buildInputs = [ FileSlurp URI ];
    meta = {
      homepage = https://github.com/coppit/filehandle-unget/;
      description = "FileHandle which supports multi-byte unget";
      license = stdenv.lib.licenses.gpl2;
      maintainers = with maintainers; [ romildo ];
    };
  };

  FileHomeDir = buildPerlPackage {
    name = "File-HomeDir-1.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RE/REHSACK/File-HomeDir-1.002.tar.gz;
      sha256 = "eb4c0c85775138460cd4013d8117232f08e88381c95c6a93b3d11e969185c274";
    };
    propagatedBuildInputs = [ FileWhich ];
    meta = {
      description = "Find your home and other directories on any platform";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    preCheck = "export HOME=$TMPDIR";
    doCheck = !stdenv.isDarwin;
  };

  FileKeePass = buildPerlPackage rec {
    name = "File-KeePass-2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7";
    };
    propagatedBuildInputs = [ CryptRijndael ];
  };

  Filelchown = buildPerlModule rec {
    name = "File-lchown-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/${name}.tar.gz";
      sha256 = "a02fbf285406a8a4d9399284f032f2d55c56975154c2e1674bd109837b8096ec";
    };
    buildInputs = [ ExtUtilsCChecker ];
    meta = {
      description = "Modify attributes of symlinks without dereferencing them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileLibMagic = buildPerlPackage rec {
    name = "File-LibMagic-1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "c8a695fac1454f52e18e2e1b624c0647cf117326014023dda69fa3e1a5f33d60";
    };
    buildInputs = [ pkgs.file TestFatal ];
    makeMakerFlags = "--lib=${pkgs.file}/lib";
    preCheck = ''
      substituteInPlace t/oo-api.t \
        --replace "/usr/share/file/magic.mgc" "${pkgs.file}/share/misc/magic.mgc"
    '';
    meta = {
      homepage = https://metacpan.org/release/File::LibMagic;
      description = "Determine MIME types of data or files using libmagic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FileListing = buildPerlPackage rec {
    name = "File-Listing-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/File-Listing-6.04.tar.gz;
      sha256 = "1xcwjlnxaiwwpn41a5yi6nz95ywh3szq5chdxiwj36kqsvy5000y";
    };
    propagatedBuildInputs = [ HTTPDate ];
  };

  FileMimeInfo = buildPerlPackage rec {
    name = "File-MimeInfo-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MICHIELB/File-MimeInfo-0.28.tar.gz;
      sha256 = "1ipbh63bkh1r2gy5g7q4bzhki8j29mm1jkhbv60p9vwsdys5s91a";
    };
    doCheck = false; # Failed test 'desktop file is the right one'
    buildInputs = [ FileBaseDir ];
  };

  FileMMagic = buildPerlPackage rec {
    name = "File-MMagic-1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KN/KNOK/${name}.tar.gz";
      sha256 = "cf0c1b1eb29705c02d97c2913648009c0be42ce93ec24b36c696bf2d4f5ebd7e";
    };
    meta = {
      description = "Guess file type from contents";
      license = stdenv.lib.licenses.free; # Some form of BSD4/Apache mix.
    };
  };

  FileModified = buildPerlPackage rec {
    name = "File-Modified-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "6b50b1aab6ec6998a017f6403c2735b3bc1e1cf46187bd134d7eb6df3fc45144";
    };
    meta = {
      homepage = https://github.com/neilbowers/File-Modified;
      description = "Checks intelligently if files have changed";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileNext = buildPerlPackage rec {
    name = "File-Next-1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0nfp84p63a5xm6iwlckh3f6cy9bdpjw5fazplskhnb8k5ifg4rb9";
    };
  };

  FileNFSLock = buildPerlPackage {
    name = "File-NFSLock-1.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBB/File-NFSLock-1.27.tar.gz;
      sha256 = "0hhh3cmbby98b1xh64dvj31wqcr9hsk1zqrq3ci8fjd4xb7xch8g";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FilePath = buildPerlPackage rec {
    name = "File-Path-2.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JK/JKEENAN/File-Path-2.15.tar.gz;
      sha256 = "1570f3c1cdf93c50f65c2072e8f20ee121550771dfb7f6e563f503a2a7050744";
    };
    meta = {
      description = "Create or remove directory trees";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filepushd = buildPerlPackage {
    name = "File-pushd-1.014";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/File-pushd-1.014.tar.gz;
      sha256 = "b5ab37ffe3acbec53efb7c77b4423a2c79afa30a48298e751b9ebee3fdc6340b";
    };
    meta = {
      homepage = https://metacpan.org/release/File-pushd;
      description = "Change directory temporarily for a limited scope";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileReadBackwards = buildPerlPackage rec {
    name = "File-ReadBackwards-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UR/URI/${name}.tar.gz";
      sha256 = "82b261af87507cc3e7e66899c457104ebc8d1c09fb85c53f67c1f90f70f18d6e";
    };
    meta = {
      description = "Read a file backwards by lines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FileRemove = buildPerlPackage rec {
    name = "File-Remove-1.57";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/File-Remove-1.57.tar.gz;
      sha256 = "1b814lw181kkqh6c1n4p2zlzzsq6ic5pfpr831nphf2w2rhcvgmk";
    };
  };

  FileShare = buildPerlPackage {
    name = "File-Share-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IN/INGY/File-Share-0.25.tar.gz;
      sha256 = "0w3h800qqcf1sn79h84zngnn788rg2jx4jjb70l44f6419p2b7cf";
    };
    propagatedBuildInputs = [ FileShareDir ];
    meta = {
      homepage = https://github.com/ingydotnet/file-share-pm/tree;
      description = "Extend File::ShareDir to Local Libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileShareDir = buildPerlPackage {
    name = "File-ShareDir-1.104";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RE/REHSACK/File-ShareDir-1.104.tar.gz;
      sha256 = "1bqwhk3qfg60bkpi5b83bh93sng8jx20i3ka5sixc0prrppjidh7";
    };
    propagatedBuildInputs = [ ClassInspector ];
    meta = {
      description = "Locate per-dist and per-module shared files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileShareDirInstall = buildPerlModule {
    name = "File-ShareDir-Install-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/File-ShareDir-Install-0.11.tar.gz;
      sha256 = "1j0cw1aq9fdv9kl1a6fnfa4zihsvmcqzy9sb0xk0i9pyx5r8ggrj";
    };
    meta = {
      description = "Install shared files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  FilesysNotifySimple = buildPerlPackage {
    name = "Filesys-Notify-Simple-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Filesys-Notify-Simple-0.13.tar.gz;
      sha256 = "18jv96k1pf8wqf4vn2ahs7dv44lc9cyqj0bja9z17qici3dx7qxd";
    };
    meta = {
      description = "Simple and dumb file system watcher";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestSharedFork ];
  };

  FileTemp = null;

  FileType = buildPerlModule {
    name = "File-Type-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PM/PMISON/File-Type-0.22.tar.gz;
      sha256 = "0hfkaafp6wb0nw19x47wc6wc9mwlw8s2rxiii3ylvzapxxgxjp6k";
    };
    meta = {
      description = "File::Type uses magic numbers (typically at the start of a file) to determine the MIME type of that file.";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
  };

  FileSlurp = buildPerlPackage {
    name = "File-Slurp-9999.19";
    # WARNING: check on next update if deprecation warning is gone
    patches = [ ../development/perl-modules/File-Slurp/silence-deprecation.patch ];
    src = fetchurl {
      url = mirror://cpan/authors/id/U/UR/URI/File-Slurp-9999.19.tar.gz;
      sha256 = "0hrn4nipwx40d6ji8ssgr5nw986z9iqq8cn0kdpbszh9jplynaff";
    };
    meta = {
      description = "Simple and Efficient Reading/Writing/Modifying of Complete Files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
  };

  FileSlurper = buildPerlPackage rec {
    name = "File-Slurper-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "4efb2ea416b110a1bda6f8133549cc6ea3676402e3caf7529fce0313250aa578";
    };
    buildInputs = [ TestWarnings ];
    meta = {
      description = "A simple, sane and efficient module to slurp a file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileSlurpTiny = buildPerlPackage rec {
    name = "File-Slurp-Tiny-0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "452995beeabf0e923e65fdc627a725dbb12c9e10c00d8018c16d10ba62757f1e";
    };
    meta = {
      description = "A simple, sane and efficient file slurper [DISCOURAGED]";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileUtil = buildPerlModule rec {
    name = "File-Util-4.161950";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOMMY/${name}.tar.gz";
      sha256 = "88507b19da580d595b5c25fe6ba75bbd6096b4359e389ead067a216f766c20ee";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      homepage = https://github.com/tommybutler/file-util/wiki;
      description = "Easy, versatile, portable file handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FileWhich = buildPerlPackage rec {
    name = "File-Which-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "e8a8ffcf96868c6879e82645db4ff9ef00c2d8a286fed21971e7280f52cf0dd4";
    };
    meta = {
      homepage = http://perl.wdlabs.com/File-Which;
      description = "Perl implementation of the which utility as an API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filter = buildPerlPackage {
    name = "Filter-1.58";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Filter-1.58.tar.gz;
      sha256 = "6de91cb4cbfe08d0ccffbca39aed57f9237be602b8183f13fd163fc8cb657f3d";
    };
    meta = {
      description = "Source Filters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilterSimple = buildPerlPackage {
    name = "Filter-Simple-0.94";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Filter-Simple-0.94.tar.gz;
      sha256 = "1lkrgsqaxf595ha1y29gxqqf4kf8cpm5yzr4gg7zngbq1nb0pz6g";
    };
    meta = {
      description = "Simplified source filtering";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FinanceQuote = buildPerlPackage rec {
    name = "Finance-Quote-1.47";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EC/ECOCODE/${name}.tar.gz";
      sha256 = "0gzbq85738f299jaw4nj3ljnka380j2y6yspmyl71rgfypqjvbr7";
    };
    propagatedBuildInputs = [ CGI DateTime HTMLTableExtract JSON LWPProtocolHttps ];
    meta = with stdenv.lib; {
      homepage = http://finance-quote.sourceforge.net/;
      description = "Get stock and mutual fund quotes from various exchanges";
      license = licenses.gpl2;
    };
  };

  FontAFM = buildPerlPackage rec {
    name = "Font-AFM-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1";
    };
  };

  FontTTF = buildPerlPackage rec {
    name = "Font-TTF-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BH/BHALLISSY/${name}.tar.gz";
      sha256 = "4b697d444259759ea02d2c442c9bffe5ffe14c9214084a01f743693a944cc293";
    };
    meta = {
      description = "TTF font support for Perl";
      license = stdenv.lib.licenses.artistic2;
    };
    buildInputs = [ IOString ];
  };

  ForksSuper = buildPerlPackage {
    name = "Forks-Super-0.93";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MO/MOB/Forks-Super-0.93.tar.gz;
      sha256 = "1blkhi3kpkqv6dlnbxz5r9j9lbr58vag3aa2c9yqpkqk59hivbgg";
    };
    doCheck = false;
    meta = {
      description = "Extensions and convenience methods to manage background processes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
    propagatedBuildInputs = [ URI ];
  };

  FormValidatorSimple = buildPerlPackage rec {
    name = "FormValidator-Simple-0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LY/LYOKATO/${name}.tar.gz";
      sha256 = "fc3a63dc54b962d74586070176adaf5be869f09b561bb30f5fd32ef531792666";
    };
    propagatedBuildInputs = [ ClassAccessor ClassDataAccessor DateCalc DateTimeFormatStrptime EmailValidLoose ListMoreUtils TieIxHash UNIVERSALrequire YAML ];
    meta = {
      description = "Validation with simple chains of constraints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
    buildInputs = [ CGI ];
  };

  FreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.5001";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.5001.tar.gz;
      sha256 = "0h8gakd6b9770n2xhld1hhqghdar3hrq2js4mgiwxy86j4r0hpiw";
    };
    doCheck = false;
  };

  GamesSolitaireVerify = buildPerlModule {
    name = "Games-Solitaire-Verify-0.1701";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Games-Solitaire-Verify-0.1701.tar.gz;
      sha256 = "71383f9c44a344aa92eca6ad999103b05809f19b3e078cf01651f2298bc435c1";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ ClassXSAccessor ExceptionClass ListMoreUtils ];
    meta = {
      description = "Verify solutions for solitaire games";
      license = stdenv.lib.licenses.mit;
    };
  };

  GD = buildPerlPackage rec {
    name = "GD-2.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "1ampz82kf0ixybncfgpvq2bp9nq5sjsmmw4c8srsv0g5jpz02pfh";
    };

    buildInputs = [ pkgs.gd pkgs.libjpeg pkgs.zlib pkgs.freetype pkgs.libpng pkgs.fontconfig pkgs.xorg.libXpm ];

    # Patch needed to get arguments past the first GetOptions call
    # and to specify libfontconfig search path.
    # Patch has been sent upstream.
    patches = [ ../development/perl-modules/gd-options-passthrough-and-fontconfig.patch ];

    # tests fail
    doCheck = false;

    makeMakerFlags = "--lib_png_path=${pkgs.libpng.out} --lib_jpeg_path=${pkgs.libjpeg.out} --lib_zlib_path=${pkgs.zlib.out} --lib_ft_path=${pkgs.freetype.out} --lib_fontconfig_path=${pkgs.fontconfig.lib} --lib_xpm_path=${pkgs.xorg.libXpm.out}";
  };

  GDGraph = buildPerlPackage rec {
    name = "GDGraph-1.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RUZ/GDGraph-1.54.tar.gz;
      sha256 = "0kzsdc07ycxjainmz0dnsclb15w2j1y7g8b5mcb7vhannq85qvxr";
    };
    propagatedBuildInputs = [ GDText ];
    buildInputs = [ CaptureTiny TestException ];
    meta = {
      description = "Graph Plotting Module for Perl 5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GDSecurityImage = buildPerlModule {
    name = "GD-SecurityImage-1.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BU/BURAK/GD-SecurityImage-1.73.tar.gz;
      sha256 = "1kaxs67rfd4w46lxgcg3pa05a596l0h1k8n4zk2gwrrar4022wpx";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Security image (captcha) generator";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GDText = buildPerlPackage rec {
    name = "GDTextUtil-0.86";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MV/MVERB/GDTextUtil-0.86.tar.gz;
      sha256 = "1g0nc7fz4d672ag7brlrrcz7ibm98x49qs75bq9z957ybkwcnvl8";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Text utilities for use with GD";
    };
  };

  GeoIP = buildPerlPackage rec {
    name = "Geo-IP-1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/${name}.tar.gz";
      sha256 = "1fka8fr7fw6sh3xa9glhs1zjg3s2gfkhi7n7da1l2m2wblqj0c0n";
    };
    makeMakerFlags = "LIBS=-L${pkgs.geoip}/lib INC=-I${pkgs.geoip}/include";
    doCheck = false; # seems to access the network
  };

  GetoptLong = buildPerlPackage rec {
    name = "Getopt-Long-2.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/${name}.tar.gz";
      sha256 = "0rsb7ri8210xv09mnxykw5asbcqivd0v38x0z4jkis3k5gdim210";
    };
  };

  GetoptLongDescriptive = buildPerlPackage rec {
    name = "Getopt-Long-Descriptive-0.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "9ad4b98f294aa0515cc3150a1ae878d39e470762b78d8bd9df055eba9dea2846";
    };
    buildInputs = [ CPANMetaCheck TestFatal TestWarnings ];
    propagatedBuildInputs = [ ParamsValidate SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/Getopt-Long-Descriptive;
      description = "Getopt::Long, but simpler and more powerful";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GetoptTabular = buildPerlPackage rec {
    name = "Getopt-Tabular-0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GW/GWARD/${name}.tar.gz";
      sha256 = "0xskl9lcj07sdfx5dkma5wvhhgf5xlsq0khgh8kk34dm6dv0dpwv";
    };
  };

  GitPurePerl = buildPerlPackage rec {
    name = "Git-PurePerl-0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BROQ/${name}.tar.gz";
      sha256 = "987c74366cc4c37ee084050f985fa254359c89c12507f5b8bfc6607de538d5a8";
    };
    buildInputs = [ Testutf8 ];
    propagatedBuildInputs = [ ArchiveExtract ConfigGitLike DataStreamBulk DateTime FileFindRule IODigest MooseXStrictConstructor MooseXTypesPathClass ];
    doCheck = false;
    meta = {
      description = "A Pure Perl interface to Git repositories";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Glib = buildPerlPackage rec {
    name = "Glib-1.326";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0prn9kkdpwjq9qmzqashbhk3pq4gvlrmvm3b10xf1dhc48406382";
    };
    buildInputs = [ pkgs.glib ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl wrappers for the GLib utility and Object libraries";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig ];
  };

  Gnome2 = buildPerlPackage rec {
    name = "Gnome2-1.047";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "ccc85c5dc3c14f915ed1a186d238681d83fef3d17eed1c20001499ff56b6390c";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gnome2Canvas Gnome2VFS Gtk2 ];
    propagatedBuildInputs = [ pkgs.gnome2.libgnomeui ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net;
      description = "Perl interface to the 2.x series of the GNOME libraries";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Gnome2Canvas = buildPerlPackage rec {
    name = "Gnome2-Canvas-1.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/${name}.tar.gz";
      sha256 = "47a34204cd5f3a0ef5c8b9e1c9c96f41740edab7e9abf1d0560fa8666ba1916e";
    };
    buildInputs = [ pkgs.gnome2.libgnomecanvas ];
    meta = {
      license = stdenv.lib.licenses.lgpl2Plus;
    };
    propagatedBuildInputs = [ Gtk2 Pango ];
  };

  Gnome2VFS = buildPerlPackage rec {
    name = "Gnome2-VFS-1.083";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "eca974669df4e7f21b4fcedb96c8a328422369c68b8c2cd99b9ce9cc5d7a7979";
    };
    propagatedBuildInputs = [ pkgs.gnome2.gnome_vfs Glib ];
    meta = {
      description = "Perl interface to the 2.x series of the GNOME VFS library";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Gnome2Wnck = buildPerlPackage rec {
    name = "Gnome2-Wnck-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/${name}.tar.gz";
      sha256 = "604a8ece88ac29f132d59b0caac27657ec31371c1606a4698a2160e88ac586e5";
    };
    buildInputs = [ pkgs.libwnck pkgs.glib pkgs.gtk2 ];
    propagatedBuildInputs = [ Gtk2 Pango ];
    meta = {
      description = "Perl interface to the Window Navigator Construction Kit";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  GnuPG = buildPerlPackage {
    name = "GnuPG-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YA/YANICK/GnuPG-0.19.tar.gz;
      sha256 = "af53f2d3f63297e046676eae14a76296afdd2910e09723b6b113708622b7989b";
    };
    buildInputs = [ pkgs.gnupg1orig ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  GnuPGInterface = buildPerlPackage rec {
    name = "GnuPG-Interface-0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/${name}.tar.gz";
      sha256 = "247a9f5a88bb6745281c00d0f7d5d94e8599a92396849fd9571356dda047fd35";
    };
    buildInputs = [ pkgs.which pkgs.gnupg1compat ];
    propagatedBuildInputs = [ MooXHandlesVia MooXlate ];
    doCheck = false;
    meta = {
      description = "Supply object methods for interacting with GnuPG";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GoferTransporthttp = buildPerlPackage {
    name = "GoferTransport-http-1.017";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/GoferTransport-http-1.017.tar.gz;
      sha256 = "f73effe3ea7afa1907ce8977c87387abb0d4404f85a724ae2637b29a73154a9b";
    };
    propagatedBuildInputs = [ mod_perl2 DBI HTTPMessage LWP URI ];
    doCheck = false; # no make target 'test'
    meta = {
      description = "HTTP transport for DBI stateless proxy driver DBD::Gofer";
    };
  };

  GooCanvas = buildPerlPackage rec {
    name = "Goo-Canvas-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YE/YEWENBIN/${name}.tar.gz";
      sha256 = "0c588c507eed5e62d12ed1cc1e491c6ff3a1f59c4fb3d435e14214b37ab39251";
    };
    propagatedBuildInputs = [ pkgs.goocanvas pkgs.gtk2 Gtk2 Pango ];
    meta = {
      description = "Perl interface to the GooCanvas";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GoogleProtocolBuffers = buildPerlPackage rec {
    name = "Google-ProtocolBuffers-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/protobuf/${name}.tar.gz";
      sha256 = "0wad56n12h9yhnrq1m1z3jna1ch3mg3mqj41wkfi49ws1g34k15k";
    };
    propagatedBuildInputs = [ ClassAccessor ParseRecDescent ];
    patches =
      [ ../development/perl-modules/Google-ProtocolBuffers-multiline-comments.patch ];
    meta = {
      description = "Simple interface to Google Protocol Buffers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Graph = buildPerlPackage rec {
    name = "Graph-0.9704";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/${name}.tar.gz";
      sha256 = "099a1gca0wj5zs0cffncjqp2mjrdlk9i6325ks89ml72gfq8wpij";
    };
  };

  GraphViz = buildPerlPackage rec {
    name = "GraphViz-2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "1bgm4a8kan53r30qiknr4kasvhar1khf7vq064l1inzfrp2glpnr";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz TestPod ];
    propagatedBuildInputs = [ FileWhich IPCRun ParseRecDescent XMLTwig XMLXPath ];

    meta = with stdenv.lib; {
      description = "Perl interface to the GraphViz graphing tool";
      license = licenses.artistic2;
      maintainers = [ ];
    };
  };

  grepmail = buildPerlPackage rec {
    name = "grepmail-5.3104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/${name}.tar.gz";
      sha256 = "7969e569ec54b2f569a5af56ac4d884c630ad850974658219b0b6953e97b5d3d";
    };
    buildInputs = [ FileSlurp URI ];
    propagatedBuildInputs = [ MailMboxMessageParser TimeDate ];
    outputs = [ "out" ];
    meta = {
      homepage = https://github.com/coppit/grepmail;
      description = "Search mailboxes for mail matching a regular expression";
      license = stdenv.lib.licenses.gpl2;
      maintainers = with maintainers; [ romildo ];
    };
  };

  GrowlGNTP = buildPerlModule rec {
    name = "Growl-GNTP-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTN/Growl-GNTP-0.21.tar.gz;
      sha256 = "0gq8ypam6ifp8f3s2mf5d6sw53m7h3ki1zfahh2p41kl8a77yy98";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CryptCBC DataUUID ];
  };

  GSSAPI = buildPerlPackage rec {
    name = "GSSAPI-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGROLMS/${name}.tar.gz";
      sha256 = "1mkhwxjjlhr58pd770i9gnf7zy7jj092iv6jfbnb8bvnc5xjr3vx";
    };
    buildInputs = [ TestPod ];
    propagatedBuildInputs = [ pkgs.krb5Full.dev ];
    meta = {
      maintainers = [ maintainers.limeytexan ];
      description = "Perl extension providing access to the GSSAPIv2 library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    makeMakerFlags = "--gssapiimpl ${pkgs.krb5Full.dev}";
  };

  Gtk2 = buildPerlPackage rec {
    name = "Gtk2-1.24992";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1044rj3wbfmgaif2jb0k28m2aczli6ai2n5yvn6pr7zjyw16kvd2";
    };
    buildInputs = [ pkgs.gtk2 Cairo ExtUtilsDepends ExtUtilsPkgConfig Glib Pango ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl interface to the 2.x series of the Gimp Toolkit library";
      license = stdenv.lib.licenses.lgpl21Plus;
      platforms   = stdenv.lib.platforms.linux;
    };
  };

  Gtk2GladeXML = buildPerlPackage rec {
    name = "Gtk2-GladeXML-1.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/${name}.tar.gz";
      sha256 = "50240a2bddbda807c8f8070de941823b7bf3d288a13be6d0d6563320b42c445a";
    };
    propagatedBuildInputs = [ pkgs.gnome2.libglade pkgs.gtk2 Gtk2 Pango ];
    meta = {
      homepage = https://metacpan.org/pod/Gtk2::GladeXML;
      description = "Create user interfaces directly from Glade XML files";
      license = stdenv.lib.licenses.lgpl2Plus;
    };
  };

  Gtk2TrayIcon = buildPerlPackage rec {
    name = "Gtk2-TrayIcon-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORUP/${name}.tar.gz";
      sha256 = "cbb7632b75d7f41554dfe8ee9063dbfd1d8522291077c65d0d82e9ceb5e94ae2";
    };
    propagatedBuildInputs = [ pkgs.gtk2 Gtk2 Pango ];
    meta = {
      license = stdenv.lib.licenses.gpl2;
    };
  };

  Gtk2AppIndicator = buildPerlPackage rec {
    name = "Gtk2-AppIndicator-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/${name}.tar.gz";
      sha256 = "a25cb071e214fb89b4450aa4605031eae89b7961e149b0d6e8f491c19c14a90a";
    };
    propagatedBuildInputs = [ pkgs.libappindicator-gtk2 pkgs.libdbusmenu-gtk2 pkgs.gtk2 pkgs.pkgconfig Gtk2 ];
    # Tests fail due to no display:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    doCheck = false;
    meta = {
      description = "Perl extension for libappindicator";
      license = stdenv.lib.licenses.artistic1;
    };
  };

  Gtk2ImageView = buildPerlPackage rec {
    name = "Gtk2-ImageView-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RATCLIFFE/${name}.tar.gz";
      sha256 = "087186c3693acf196451cf59cc8b7f5cf9a7b05abe20d32dcbcba0822953fb80";
    };
    buildInputs = [ pkgs.gtkimageview pkgs.gtk2 ];
    propagatedBuildInputs = [ Gtk2 Pango ];
    # Tests fail due to no display server:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    #   t/animview.t ...........
    doCheck = false;
    meta = {
      description = "Perl bindings for the GtkImageView widget";
      license = stdenv.lib.licenses.free;
    };
  };

  Gtk2Unique = buildPerlPackage rec {
    name = "Gtk2-Unique-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/${name}.tar.gz";
      sha256 = "ae8dfb0f6844ddaa2ce7b5b44553419490c8e83c24fd35c431406a58f6be0f4f";
    };
    propagatedBuildInputs = [ pkgs.libunique pkgs.gtk2 Gtk2 Pango ];
    meta = {
      description = "Use single instance applications";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Guard = buildPerlPackage rec {
    name = "Guard-1.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "34c4ddf91fc93d1090d86da14df706d175b1610c67372c01e12ce9555d4dd1dc";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HashFlatten = buildPerlPackage rec {
    name = "Hash-Flatten-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBC/Hash-Flatten-1.19.tar.gz;
      sha256 = "162b9qgkr19f97w4pic6igyk3zd0sbnrhl3s8530fikciffw9ikh";
    };
    buildInputs = [ TestAssertions ];
    propagatedBuildInputs = [ LogTrace ];
  };

  HashMerge = buildPerlPackage rec {
    name = "Hash-Merge-0.300";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "0h3wfnpv5d4d3f9xzmwkchay6251nhzngdv3f6xia56mj4hxabs0";
    };
    propagatedBuildInputs = [ CloneChoose ];
    meta = {
      description = "Merges arbitrarily deep hashes into a single hash";
    };
    buildInputs = [ Clone ClonePP ];
  };

  HashMergeSimple = buildPerlPackage {
    name = "Hash-Merge-Simple-0.051";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROKR/Hash-Merge-Simple-0.051.tar.gz;
      sha256 = "1c56327873d2f04d5722777f044863d968910466997740d55a754071c6287b73";
    };
    buildInputs = [ TestDeep TestDifferences TestException TestMost TestWarn ];
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Recursively merge two or more hashes, simply";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashMoreUtils = buildPerlModule rec {
    name = "Hash-MoreUtils-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "5e9c8458457eb18315a5669e3bef68488cd5ed8c2220011ac7429ff983288ab1";
    };
    meta = {
      description = "Provide the stuff missing in Hash::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  HashMultiValue = buildPerlPackage {
    name = "Hash-MultiValue-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARISTOTLE/Hash-MultiValue-0.16.tar.gz;
      sha256 = "1x3k7h542xnigz0b8vsfiq580p5r325wi5b8mxppiqk8mbvis636";
    };
    meta = {
      description = "Store multiple values per key";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashUtilFieldHashCompat = buildPerlPackage {
    name = "Hash-Util-FieldHash-Compat-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Hash-Util-FieldHash-Compat-0.11.tar.gz;
      sha256 = "06vlygjyk7rkkw0di3252mma141w801qn3xk40aa2yskbfklcbk4";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HeapFibonacci = buildPerlPackage {
    name = "Heap-0.80";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JM/JMM/Heap-0.80.tar.gz;
      sha256 = "1plv2djbyhvkdcw2ic54rdqb745cwksxckgzvw7ssxiir7rjknnc";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HookLexWrap = buildPerlPackage rec {
    name = "Hook-LexWrap-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "b60bdc5f98f94f9294b06adef82b1d996da192d5f183f9f434b610fd1137ec2d";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      homepage = https://github.com/chorny/Hook-LexWrap;
      description = "Lexically scoped subroutine wrappers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLClean = buildPerlPackage rec {
    name = "HTML-Clean-0.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LI/LINDNER/${name}.tar.gz";
      sha256 = "1h0dzxx034hpshxlpsxhxh051d1p79cjgp4q5kg68kgx7aian85c";
    };
    meta = {
      description = "Cleans up HTML code for web browsers, not humans";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLElementExtended = buildPerlPackage {
    name = "HTML-Element-Extended-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSISK/HTML-Element-Extended-1.18.tar.gz;
      sha256 = "f3ef1af108f27fef15ebec66479f251ce08aa49bd00b0462c9c80c86b4b6b32b";
    };
    propagatedBuildInputs = [ HTMLTree ];
  };

  HTMLEscape = buildPerlModule rec {
    name = "HTML-Escape-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "b1cbac4157ad8dedac6914e1628855e05b8dc885a4007d2e4df8177c6a9b70fb";
    };
    buildInputs = [ ModuleBuildPluggablePPPort TestRequires ];
    meta = {
      homepage = https://github.com/tokuhirom/HTML-Escape;
      description = "Extremely fast HTML escaping";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFromANSI = buildPerlPackage {
    name = "HTML-FromANSI-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/HTML-FromANSI-2.03.tar.gz;
      sha256 = "21776345ed701b2c04c7b09380af943f9984cc7f99624087aea45db5fc09c359";
    };
    propagatedBuildInputs = [ HTMLParser TermVT102Boundless ];
    meta = {
    };
  };

  HTMLForm = buildPerlPackage {
    name = "HTML-Form-6.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Form-6.03.tar.gz;
      sha256 = "0dpwr7yz6hjc3bcqgcbdzjjk9l58ycdjmbam9nfcmm85y2a1vh38";
    };
    propagatedBuildInputs = [ HTMLParser HTTPMessage ];
    meta = {
      description = "Class that represents an HTML form element";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatter = buildPerlPackage {
    name = "HTML-Formatter-2.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NI/NIGELM/HTML-Formatter-2.16.tar.gz;
      sha256 = "cb0a0dd8aa5e8ba9ca214ce451bf4df33aa09c13e907e8d3082ddafeb30151cc";
    };
    buildInputs = [ FileSlurper TestWarnings ];
    propagatedBuildInputs = [ FontAFM HTMLTree ];
    meta = {
      homepage = https://metacpan.org/release/HTML-Formatter;
      description = "Base class for HTML formatters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatTextWithLinks = buildPerlModule {
    name = "HTML-FormatText-WithLinks-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STRUAN/HTML-FormatText-WithLinks-0.15.tar.gz;
      sha256 = "7fcc1ab79eb58fb97d43e5bdd14e21791a250a204998918c62d6a171131833b1";
    };
    propagatedBuildInputs = [ HTMLFormatter URI ];
    meta = {
      description = "HTML to text conversion with links as footnotes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatTextWithLinksAndTables = buildPerlPackage {
    name = "HTML-FormatText-WithLinks-AndTables-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DALEEVANS/HTML-FormatText-WithLinks-AndTables-0.07.tar.gz;
      sha256 = "809ee2f11705706b33c54312b5c7bee674838f2beaaedaf8cb945e702aae39b6";
    };
    propagatedBuildInputs = [ HTMLFormatTextWithLinks ];
    meta = {
      description = "Converts HTML to Text with tables intact";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-2.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "0fvilng85wc65pna898x7mp4hx73mhahl7j2s10gj76avmxdizsw";
    };
    buildInputs = [ FileShareDirInstall TestAggregate TestException ];
    propagatedBuildInputs = [ CGI Clone ConfigAny DataVisitor DateTime
      DateTimeFormatBuilder DateTimeFormatNatural DateTimeFormatStrptime
      DateTimeLocale EmailValid FileShareDir HTMLScrubber HTMLTokeParserSimple
      HTTPMessage HashFlatten ListMoreUtils ModulePluggable Moose MooseXAliases
      NumberFormat PathClass Readonly RegexpCommon TaskWeaken YAMLLibYAML ];
    meta = {
      description = "HTML Form Creation, Rendering and Validation Framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormHandler = buildPerlPackage {
    name = "HTML-FormHandler-0.40057";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GS/GSHANK/HTML-FormHandler-0.40057.tar.gz;
      sha256 = "1hn9shhbsi4pdp396ia2hky3i0imnxgwvhy57gp0jjhy5qyvafvm";
    };
    # a single test is failing on perl 5.20
    doCheck = false;
    buildInputs = [ FileShareDirInstall PadWalker TestDifferences TestException TestMemoryCycle ];
    propagatedBuildInputs = [ ClassLoad DataClone DateTime DateTimeFormatStrptime EmailValid FileShareDir HTMLTree JSON ListAllUtils Moose MooseXGetopt MooseXTypes MooseXTypesCommon MooseXTypesLoadableClass SubExporter SubName TryTiny aliased namespaceautoclean ];
    meta = {
      description = "HTML forms using Moose";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMason = buildPerlPackage {
    name = "HTML-Mason-1.58";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/HTML-Mason-1.58.tar.gz;
      sha256 = "81dc9b199f0f3b3473c97ba0ebee4b9535cd633d4e9c1ca3818615dc03dff948";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ CGI CacheCache ClassContainer ExceptionClass LogAny ];
    meta = {
      homepage = https://metacpan.org/release/HTML-Mason;
      description = "High-performance, dynamic web site authoring system";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMasonPSGIHandler = buildPerlPackage {
    name = "HTML-Mason-PSGIHandler-0.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RUZ/HTML-Mason-PSGIHandler-0.53.tar.gz;
      sha256 = "eafd7c7655dfa8261df3446b931a283d30306877b83ac4671c49cff74ea7f00b";
    };
    buildInputs = [ Plack ];
    propagatedBuildInputs = [ CGIPSGI HTMLMason ];
    meta = {
      homepage = http://search.cpan.org/dist/HTML-Mason-PSGIHandler/;
      description = "PSGI handler for HTML::Mason";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLParser = buildPerlPackage rec {
    name = "HTML-Parser-3.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "12v05ywlnsi9lc17z32k9jxx3sj1viy7y1wpl7n4az76v7hwfa7c";
    };
    propagatedBuildInputs = [ HTMLTagset ];
    meta = {
      description = "HTML parser class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTagCloud = buildPerlModule rec {
    name = "HTML-TagCloud-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBERTSD/${name}.tar.gz";
      sha256 = "05bhnrwwlwd6cj3cn91zw5r99xddvy142bznid26p1pg5m3rk029";
    };
    meta = {
      description = "Generate An HTML Tag Cloud";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLQuoted = buildPerlPackage {
    name = "HTML-Quoted-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-Quoted-0.04.tar.gz;
      sha256 = "8b41f313fdc1812f02f6f6c37d58f212c84fdcf7827f7fd4b030907f39dc650c";
    };
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Extract structure of quoted HTML mail message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLRewriteAttributes = buildPerlPackage {
    name = "HTML-RewriteAttributes-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-RewriteAttributes-0.05.tar.gz;
      sha256 = "1808ec7cdf40d2708575fe6155a88f103b17fec77973a5831c2f24c250e7a58c";
    };
    propagatedBuildInputs = [ HTMLParser URI ];
    meta = {
      description = "Concise attribute rewriting";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLSelectorXPath = buildPerlPackage {
    name = "HTML-Selector-XPath-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/HTML-Selector-XPath-0.23.tar.gz;
      sha256 = "0vvvdrccypwv3qpf9hq5h2b6k0p5qrmz60p2swjh009dvr601h7j";
    };
    buildInputs = [ TestBase ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HTMLScrubber = buildPerlPackage rec {
    name = "HTML-Scrubber-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/${name}.tar.gz";
      sha256 = "0xb5zj67y2sjid9bs3yfm81rgi91fmn38wy1ryngssw6vd92ijh2";
    };
    propagatedBuildInputs = [ HTMLParser ];
  };

  HTMLTableExtract = buildPerlPackage rec {
    name = "HTML-TableExtract-2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSISK/${name}.tar.gz";
      sha256 = "01jimmss3q68a89696wmclvqwb2ybz6xgabpnbp6mm6jcni82z8a";
    };
    propagatedBuildInputs = [ HTMLElementExtended ];
  };

  HTMLTagset = buildPerlPackage rec {
    name = "HTML-Tagset-3.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz;
      sha256 = "1qh8249wgr4v9vgghq77zh1d2zs176bir223a8gh3k9nksn7vcdd";
    };
  };

  HTMLTemplate = buildPerlPackage rec {
    name = "HTML-Template-2.97";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMTREGAR/HTML-Template-2.97.tar.gz;
      sha256 = "17qjw8swj2q4b1ic285pndgrkmvpsqw0j68nhqzpk1daydhsyiv5";
    };
    propagatedBuildInputs = [ CGI ];
    buildInputs = [ TestPod ];
  };

  HTMLTidy = buildPerlPackage rec {
    name = "HTML-Tidy-1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1iyp2fd6j75cn1xvcwl2lxr8qpjxssy2360cyqn6g3kzd1fzdyxw";
    };

    patchPhase = ''
      sed -i "s#/usr/include/tidyp#${pkgs.tidyp}/include/tidyp#" Makefile.PL
      sed -i "s#/usr/lib#${pkgs.tidyp}/lib#" Makefile.PL
    '';
    buildInputs = [ TestException ];
  };

  HTMLTiny = buildPerlPackage rec {
    name = "HTML-Tiny-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "d7cdc9d5985e2e44ceba10b756acf1e0d3a1b3ee3b516e5b54adb850fe79fda3";
    };
    meta = {
      description = "Lightweight, dependency free HTML/XML generation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTokeParserSimple = buildPerlModule rec {
    name = "HTML-TokeParser-Simple-3.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "17aa1v62sp8ycxcicwhankmj4brs6nnfclk9z7mf1rird1f164gd";
    };
    propagatedBuildInputs = [ HTMLParser SubOverride ];
  };

  HTMLTree = buildPerlModule {
    name = "HTML-Tree-5.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/HTML-Tree-5.07.tar.gz;
      sha256 = "1gyvm4qlwm9y6hczkpnrdfl303ggbybr0nqxdjw09hii8yw4sdzh";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Work with HTML in a DOM-like tree structure";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTreeBuilderXPath = buildPerlPackage {
    name = "HTML-TreeBuilder-XPath-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/HTML-TreeBuilder-XPath-0.14.tar.gz;
      sha256 = "1wx4i1scng20n405fp3a4vrwvvq9bvbmg977wnd5j2ja8jrbvsr5";
    };
    propagatedBuildInputs = [ HTMLTree XMLXPathEngine ];
    meta = {
      description = "Add XPath support to HTML::TreeBuilder";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HTMLWidget = buildPerlPackage {
    name = "HTML-Widget-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz;
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    doCheck = false;
    propagatedBuildInputs = [
      TestNoWarnings ClassAccessor ClassAccessorChained
      ClassDataAccessor ModulePluggableFast HTMLTree
      HTMLScrubber EmailValid DateCalc
    ];
  };

  HTTPBody = buildPerlPackage rec {
    name = "HTTP-Body-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GE/GETTY/${name}.tar.gz";
      sha256 = "fc0d2c585b3bd1532d92609965d589e0c87cd380e7cca42fb9ad0a1311227297";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP Body Parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPCookies = buildPerlPackage {
    name = "HTTP-Cookies-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Cookies-6.04.tar.gz;
      sha256 = "1m0kxcirbvbkrm2c59p1bkbvzlcdymg8fdpa7wlxijlx0xwz1iqc";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP cookie jars";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDaemon = buildPerlPackage {
    name = "HTTP-Daemon-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Daemon-6.01.tar.gz;
      sha256 = "1hmd2isrkilf0q0nkxms1q64kikjmcw9imbvrjgky6kh89vqdza3";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "A simple http server class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDate = buildPerlPackage {
    name = "HTTP-Date-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Date-6.02.tar.gz;
      sha256 = "0cz357kafhhzw7w59iyi0wvhw7rlh5g1lh38230ckw7rl0fr9fg8";
    };
    meta = {
      description = "Date conversion routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPEntityParser = buildPerlModule rec {
     name = "HTTP-Entity-Parser-0.21";
     src = fetchurl {
       url = mirror://cpan/authors/id/K/KA/KAZEBURO/HTTP-Entity-Parser-0.21.tar.gz;
       sha256 = "1n7qhyscllialds5jsk1k8x2vmfbjvisa3342as5x15hpm13wkf1";
     };
     propagatedBuildInputs = [ HTTPMultiPartParser HashMultiValue JSONMaybeXS StreamBuffered WWWFormUrlEncoded ];
     buildInputs = [ HTTPMessage ModuleBuildTiny ];
     meta = {
       description = "PSGI compliant HTTP Entity Parser";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/kazeburo/HTTP-Entity-Parser";
     };
  };

  HTTPDAV = buildPerlPackage rec {
    name = "HTTP-DAV-0.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COSIMO/HTTP-DAV-0.48.tar.gz;
      sha256 = "1fnw3wd9zrkxq54jqgi4iw48ndysgy73glva4129s8243pn05a86";
    };
    meta = {
      description = "WebDAV client library.";
    };
    propagatedBuildInputs = [ XMLDOM ];
  };

  HTTPHeaderParserXS = buildPerlPackage rec {
    name = "HTTP-HeaderParser-XS-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/${name}.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
  };

  HTTPHeadersFast = buildPerlModule rec {
    name = "HTTP-Headers-Fast-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "5e68ed8e3e67531e1d43c6a2cdfd0ee2daddf2e5b94c1a2648f3a6500a6f12d5";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ HTTPDate ];
    meta = {
      homepage = https://github.com/tokuhirom/HTTP-Headers-Fast;
      description = "Faster implementation of HTTP::Headers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPLite = buildPerlPackage rec {
    name = "HTTP-Lite-2.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "0z77nflj8zdcfg70kc93glq5kmd6qxn2nf7h70x4xhfg25wkvr1q";
    };
    buildInputs = [ CGI ];
  };

  HTTPMessage = buildPerlPackage rec {
    name = "HTTP-Message-6.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/${name}.tar.gz";
      sha256 = "46790ae127946d5cfea5a1e05c1b9f4a045a7c5094fe81f086bbf3341290ebd0";
    };
    buildInputs = [ TryTiny ];
    propagatedBuildInputs = [ EncodeLocale HTTPDate IOHTML LWPMediaTypes URI ];
    meta = {
      homepage = https://github.com/libwww-perl/HTTP-Message;
      description = "HTTP style message (base class)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPMultiPartParser = buildPerlPackage rec {
     name = "HTTP-MultiPartParser-0.02";
     src = fetchurl {
       url = mirror://cpan/authors/id/C/CH/CHANSEN/HTTP-MultiPartParser-0.02.tar.gz;
       sha256 = "04hbs0b1lzv2c8dqfcc9qjm5akh25fn40903is36zlalkwaxmpay";
     };
     buildInputs = [ TestDeep ];
     meta = {
       description = "HTTP MultiPart Parser";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  HTTPNegotiate = buildPerlPackage {
    name = "HTTP-Negotiate-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz;
      sha256 = "05p053vjs5g91v5cmjnny7a3xzddz5k7vnjw81wfh01ilqg9qwhw";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "Choose a variant to serve";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPParserXS = buildPerlPackage rec {
    name = "HTTP-Parser-XS-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/${name}.tar.gz";
      sha256 = "02d84xq1mm53c7jl33qyb7v5w4372vydp74z6qj0vc96wcrnhkkr";
    };
  };

  HTTPProxy = buildPerlPackage rec {
    name = "HTTP-Proxy-0.304";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/${name}.tar.gz";
      sha256 = "b05290534ec73625c21a0565fc35170890dab163843d95331c292c23f504c69d";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A pure Perl HTTP proxy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    # tests fail because they require network access
    doCheck = false;
  };

  HTTPRequestAsCGI = buildPerlPackage rec {
    name = "HTTP-Request-AsCGI-1.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/HTTP-Request-AsCGI-1.2.tar.gz;
      sha256 = "1smwmiarwcgq7vjdblnb6ldi2x1s5sk5p15p7xvm5byiqq3znnwl";
    };
    propagatedBuildInputs = [ ClassAccessor HTTPMessage ];
  };

  HTTPResponseEncoding = buildPerlPackage {
    name = "HTTP-Response-Encoding-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/HTTP-Response-Encoding-0.06.tar.gz;
      sha256 = "1am8lis8107s5npca1xgazdy5sknknzcqyhdmc220s4a4f77n5hh";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "Adds encoding() to HTTP::Response";
    };
    buildInputs = [ LWP ];
  };

  HTTPServerSimple = buildPerlPackage {
    name = "HTTP-Server-Simple-0.52";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BP/BPS/HTTP-Server-Simple-0.52.tar.gz;
      sha256 = "0k6bg7k6mjixfzxdkkdrhqvaqmdhjszx0zsk8g0bimiby6j9z4yq";
    };
    doCheck = false;
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ CGI ];
  };

  HTTPServerSimpleAuthen = buildPerlPackage rec {
    name = "HTTP-Server-Simple-Authen-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "2dddc8ab9dc8986980151e4ba836a6bbf091f45cf195be1768ebdb4a993ed59b";
    };
    propagatedBuildInputs = [ AuthenSimple HTTPServerSimple ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimpleMason = buildPerlPackage {
    name = "HTTP-Server-Simple-Mason-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-Mason-0.14.tar.gz;
      sha256 = "b7a49d8e6e55bff0b1f0278d951685466b143243b6f9e59e071f5472ca2a025a";
    };
    propagatedBuildInputs = [ HTMLMason HTTPServerSimple HookLexWrap ];
    meta = {
      description = "A simple mason server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimplePSGI = buildPerlPackage rec {
     name = "HTTP-Server-Simple-PSGI-0.16";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MI/MIYAGAWA/HTTP-Server-Simple-PSGI-0.16.tar.gz;
       sha256 = "1fhx2glycd66m4l4m1gja81ixq8nh4r5g9wjhhkrffq4af2cnz2z";
     };
     propagatedBuildInputs = [ HTTPServerSimple ];
     meta = {
       description = "PSGI handler for HTTP::Server::Simple";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/miyagawa/HTTP-Server-Simple-PSGI";
     };
  };

  I18NCollate = buildPerlPackage {
    name = "I18N-Collate-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/I18N-Collate-1.02.tar.gz;
      sha256 = "9174506bc903eda89690394e3f45558ab7e013114227896d8569d6164648fe37";
    };
    meta = {
      homepage = http://search.cpan.org/dist/I18N-Collate;
      description = "Compare 8-bit scalar data according to the current locale";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  "if" = null;

  # For backwards compatibility.
  if_ = self."if";

  ImageInfo = buildPerlPackage rec {
    name = "Image-Info-1.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/${name}.tar.gz";
      sha256 = "c546d27414686660dbc3cd8501537128c5285a8db0faf742c2dc12b9a29ba3db";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "Extract meta information from image files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImageScale = buildPerlPackage rec {
    name = "Image-Scale-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "f09c5f0663b87738365ac2819e186b909abeb9ed85d83bc15ee76872c947cdf8";
    };
    buildInputs = [ pkgs.libpng pkgs.libjpeg TestNoWarnings ];
    propagatedBuildInputs = [ pkgs.zlib ];
    makeMakerFlags = "--with-jpeg-includes=${pkgs.libjpeg.dev}/include --with-jpeg-libs=${pkgs.libjpeg.out}/lib --with-png-includes=${pkgs.libpng.dev}/include --with-png-libs=${pkgs.libpng.out}/lib";
    meta = {
      description = "Fast, high-quality fixed-point image resizing";
      license = stdenv.lib.licenses.gpl2Plus;
    };
  };

  ImageSize = buildPerlPackage rec {
    name = "Image-Size-3.300";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJRAY/${name}.tar.gz";
      sha256 = "0sq2kwdph55h4adx50fmy86brjkkv8grsw33xrhf1k9icpwb3jak";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "Read the dimensions of an image in several popular formats";
      license = with stdenv.lib.licenses; [ artistic1 lgpl21Plus ];
    };
  };

  IMAPClient = buildPerlPackage {
    name = "IMAP-Client-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CONTEB/IMAP-Client-0.13.tar.gz;
      sha256 = "15fa4hpw2rqg2iadyz10rnv99hns78wph5qlh3257a3mbfjjyyla";
    };
    doCheck = false; # nondeterministic
  };

  Importer = buildPerlPackage rec {
    name = "Importer-0.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "0745138c487d74033d0cbeb36f06595036dc7e688f1a5dbec9cc2fa799e13946";
    };
    meta = {
      description = "Alternative but compatible interface to modules that export symbols";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ImportInto = buildPerlPackage {
    name = "Import-Into-1.002005";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Import-Into-1.002005.tar.gz;
      sha256 = "0rq5kz7c270q33jq6hnrv3xgkvajsc62ilqq7fs40av6zfipg7mx";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Import packages into other packages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IO = buildPerlPackage {
    name = "IO-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/IO-1.25.tar.gz;
      sha256 = "89790db8b9281235dc995c1a85d532042ff68a90e1504abd39d463f05623e7b5";
    };
    doCheck = false;
    meta = {
      description = "Perl core IO modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOAll = buildPerlPackage {
    name = "IO-All-0.87";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/IO-All-0.87.tar.gz;
      sha256 = "0nsd9knlbd7if2v6zwj4q978axq0w5hk8ymp61z14a821hjivqjl";
    };
    meta = {
      homepage = https://github.com/ingydotnet/io-all-pm/tree;
      description = "IO::All of it to Graham and Damian!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  IOCapture = buildPerlPackage rec {
    name = "IO-Capture-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REYNOLDS/${name}.tar.gz";
      sha256 = "c2c15a254ca74fb8c57d25d7b6cbcaff77a3b4fb5695423f1f80bb423abffea9";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOCaptureOutput = buildPerlPackage rec {
    name = "IO-CaptureOutput-1.1104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "fcc732fcb438f97a72b30e8c7796484bef2562e374553b207028e2fbf73f8330";
    };
    meta = {
      homepage = https://github.com/dagolden/IO-CaptureOutput;
      description = "Capture STDOUT and STDERR from Perl code, subprocesses or XS";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOCompress = buildPerlPackage rec {
    name = "IO-Compress-2.074";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "b4bd68ce895a6578e5be96ade36449461becc328cc7ab900ae4e362380f097f2";
    };
    propagatedBuildInputs = [ CompressRawBzip2 CompressRawZlib ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "IO Interface to compressed data files/buffers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
    # Same as CompressRawZlib
    doCheck = false && !stdenv.isDarwin;
  };

  IODigest = buildPerlPackage {
    name = "IO-Digest-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.11.tar.gz;
      sha256 = "14kz7z4xw179aya3116wxac29l4y2wmwrba087lya4v2gxdgiz4g";
    };
    propagatedBuildInputs = [ PerlIOviadynamic ];
  };

  IOHTML = buildPerlPackage {
    name = "IO-HTML-1.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/IO-HTML-1.001.tar.gz;
      sha256 = "ea78d2d743794adc028bc9589538eb867174b4e165d7d8b5f63486e6b828e7e0";
    };
    meta = {
      description = "Open an HTML file with automatic charset detection";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  IOHandleUtil = buildPerlPackage rec {
     name = "IO-Handle-Util-0.01";
     src = fetchurl {
       url = mirror://cpan/authors/id/N/NU/NUFFIN/IO-Handle-Util-0.01.tar.gz;
       sha256 = "1g7746gh3y9a9df3xb3l504czgwrrzr7lp87j7jwm2mklarrig6k";
     };
     propagatedBuildInputs = [ IOString SubExporter asa ];
     meta = {
     };
  };

  IOInteractive = buildPerlPackage {
    name = "IO-Interactive-1.022";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/IO-Interactive-1.022.tar.gz;
      sha256 = "0ed53b8ae93ae877e98e0d89b7b429e29ccd1ee4c28e952c4ea9aa73d01febdc";
    };
    meta = {
      description = "Utilities for interactive I/O";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOLockedFile = buildPerlPackage rec {
    name = "IO-LockedFile-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RANI/IO-LockedFile-0.23.tar.gz;
      sha256 = "1dgq8zfkaszisdb5hz8jgcl0xc3qpv7bbv562l31xgpiddm7xnxi";
    };
  };

  IOMultiplex = buildPerlPackage {
    name = "IO-Multiplex-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBB/IO-Multiplex-1.16.tar.gz;
      sha256 = "74d22c44b5ad2e7190e2786e8a17d74bbf4cef89b4d1157ba33598b5a2720dad";
    };
  };

  IOPager = buildPerlPackage rec {
    version = "0.39";
    name = "IO-Pager-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-${version}.tgz";
      sha256 = "0ksldcw0hydfy9k70i6q6fm1wgbc54kx0lbwlkrszsbd7q72dlfg";
    };
    propagatedBuildInputs = [ pkgs.more FileWhich ]; # `more` used in tests
  };

  IOPrompt = buildPerlModule {
    name = "IO-Prompt-0.997004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/IO-Prompt-0.997004.tar.gz;
      sha256 = "f17bb305ee6ac8b5b203e6d826eb940c4f3f6d6f4bfe719c3b3a225f46f58615";
    };
    propagatedBuildInputs = [ TermReadKey Want ];
    doCheck = false; # needs access to /dev/tty
    meta = {
      description = "Interactively prompt for user input";
    };
  };

  IOSocketIP = buildPerlModule {
    name = "IO-Socket-IP-0.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/IO-Socket-IP-0.39.tar.gz;
      sha256 = "11950da7636cb786efd3bfb5891da4c820975276bce43175214391e5c32b7b96";
    };
    meta = {
      description = "Family-neutral IP socket supporting both IPv4 and IPv6";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSocketInet6 = buildPerlPackage rec {
    name = "IO-Socket-INET6-2.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1fqypz6qa5rw2d5y2zq7f49frwra0aln13nhq5gi514j2zx21q45";
    };
    propagatedBuildInputs = [Socket6];
    doCheck = false;
  };

  IOSocketSSL = buildPerlPackage rec {
    name = "IO-Socket-SSL-2.056";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SULLR/${name}.tar.gz";
      sha256 = "91451ecc28b243a78b438f0a42db24c4b60a86f088879b38e40bdbd697818259";
    };
    propagatedBuildInputs = [ NetSSLeay ];
    # Fix path to default certificate store.
    postPatch = ''
      substituteInPlace lib/IO/Socket/SSL.pm \
        --replace "\$openssldir/cert.pem" "/etc/ssl/certs/ca-certificates.crt"
    '';
    meta = {
      homepage = https://github.com/noxxi/p5-io-socket-ssl;
      description = "Nearly transparent SSL encapsulation for IO::Socket::INET";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false; # tries to connect to facebook.com etc.
  };

  IOSocketTimeout = buildPerlModule rec {
    name = "IO-Socket-Timeout-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/${name}.tar.gz";
      sha256 = "edf915d6cc66bee43503aa6dc2b373366f38eaff701582183dad10cb8adf2972";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork TestTCP ];
    propagatedBuildInputs = [ PerlIOviaTimeout ];
    meta = {
      description = "IO::Socket with read/write timeout";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  IOString = buildPerlPackage rec {
    name = "IO-String-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0";
    };
  };

  IOstringy = pkgs.perlPackages.IOStringy;

  IOStringy = buildPerlPackage rec {
    name = "IO-stringy-2.111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSKOLL/${name}.tar.gz";
      sha256 = "178rpx0ym5l2m9mdmpnr92ziscvchm541w94fd7ygi6311kgsrwc";
    };
  };

  IOTee = buildPerlPackage rec {
    name = "IO-Tee-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/IO-Tee-0.65.tar.gz;
      sha256 = "04hc94fk6qlazrarcznw2d8wiqw289js4za0czw65296kc8csgf6";
    };
  };

  IOTieCombine = buildPerlPackage {
    name = "IO-TieCombine-1.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/IO-TieCombine-1.005.tar.gz;
      sha256 = "1bv9ampayf4bvyxg4ivy18l8k79jvq55x6gl68b2fg8b62w4sba0";
    };
    meta = {
      homepage = https://github.com/rjbs/io-tiecombine;
      description = "Produce tied (and other) separate but combined variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  IOTty = buildPerlPackage rec {
    name = "IO-Tty-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "0399anjy3bc0w8xzsc3qx5vcyqryc9gc52lc7wh7i49hsdq8gvx2";
    };
  };

  IPCountry = buildPerlPackage rec {
    name = "IP-Country-2.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWETTERS/${name}.tar.gz";
      sha256 = "88db833a5ab22ed06cb53d6f205725e3b5371b254596053738885e91fa105f75";
    };
    propagatedBuildInputs = [ GeographyCountries ];
    meta = {
      description = "Fast lookup of country codes from IP addresses";
      license = stdenv.lib.licenses.mit;
    };
  };

  GeographyCountries = buildPerlPackage rec {
    name = "Geography-Countries-2009041301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/${name}.tar.gz";
      sha256 = "48c42e40e8281ba7c981743a854c48e6def2d51eb0925ea6c96e25c74497f20f";
    };
    meta = {
      description = "2-letter, 3-letter, and numerical codes for countries";
      license = stdenv.lib.licenses.mit;
    };
  };


  IPCRun = buildPerlPackage {
    name = "IPC-Run-0.98";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/IPC-Run-0.98.tar.gz;
      sha256 = "018r6jb8h0danyd3g8k03ziaf4w2d31qi9x876gn21js8l232spl";
    };
    doCheck = false; /* attempts a network connection to localhost */
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "System() and background procs w/ piping, redirs, ptys (Unix, Win32)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
    propagatedBuildInputs = [ IOTty ];
    buildInputs = [ Readonly ];
  };

  IPCRun3 = buildPerlPackage rec {
    name = "IPC-Run3-0.048";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0r9m8q78bg7yycpixd7738jm40yz71p2q7inm766kzsw3g6c709x";
    };
  };

  IPCShareLite = buildPerlPackage rec {
    name = "IPC-ShareLite-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/IPC-ShareLite-0.17.tar.gz;
      sha256 = "1gz7dbwxrzbzdsjv11kb49jlf9q6lci2va6is0hnavd93nwhdm0l";
    };
  };

  IPCSystemSimple = buildPerlPackage {
    name = "IPC-System-Simple-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PJ/PJF/IPC-System-Simple-1.25.tar.gz;
      sha256 = "f1b6aa1dfab886e8e4ea825f46a1cbb26038ef3e727fef5d84444aa8035a4d3b";
    };
    meta = {
      description = "Run commands simply, with detailed diagnostics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCSysV = buildPerlPackage {
    name = "IPC-SysV-2.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHX/IPC-SysV-2.07.tar.gz;
      sha256 = "d01a367af771d35e3b11a21366ad6405f8d28e8cbca4c0cf08ab78bf157d052d";
    };
    meta = {
      description = "System V IPC constants and system calls";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImageExifTool = buildPerlPackage rec {
    name = "Image-ExifTool-${version}";
    version = "10.80";

    src = fetchurl {
      url = "https://www.sno.phy.queensu.ca/~phil/exiftool/${name}.tar.gz";
      sha256 = "14rwr5wk2snqv4yva6fax1gfsdv88941n237m0wyzn3n0xh9dy5w";
    };

    meta = with stdenv.lib; {
      description = "ExifTool, a tool to read, write and edit EXIF meta information";
      homepage = https://www.sno.phy.queensu.ca/~phil/exiftool/;

      longDescription = ''
        ExifTool is a platform-independent Perl library plus a command-line
        application for reading, writing and editing meta information in
        image, audio and video files.  ExifTool supports many different types
        of metadata including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC
        Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well as the maker
        notes of many digital cameras by Canon, Casio, FujiFilm, HP,
        JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Nikon,
        Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Ricoh, Sanyo,
        Sigma/Foveon and Sony.
      '';

      license = with licenses; [ gpl1Plus /* or */ artistic2 ];

      maintainers = [ maintainers.kiloreux ];
      platforms = platforms.unix;
    };
  };

  Inline = buildPerlPackage rec {
    name = "Inline-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "7e2bd984b1ebd43e336b937896463f2c6cb682c956cbd2c311a464363d2ccef6";
    };
    buildInputs = [ TestWarn ];
    meta = {
      homepage = https://github.com/ingydotnet/inline-pm;
      description = "Write Perl Subroutines in Other Programming Languages";
      longDescription = ''
        The Inline module allows you to put source code from other
        programming languages directly "inline" in a Perl script or
        module. The code is automatically compiled as needed, and then loaded
        for immediate access from Perl.
      '';
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  InlineC = buildPerlPackage rec {
    name = "Inline-C-0.78";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/${name}.tar.gz";
      sha256 = "9a7804d85c01a386073d2176582b0262b6374c5c0341049da3ef84c6f53efbc7";
    };
    buildInputs = [ FileCopyRecursive FileShareDirInstall TestWarn YAMLLibYAML ];
    propagatedBuildInputs = [ Inline ParseRecDescent Pegex ];
    postPatch = ''
      # this test will fail with chroot builds
      rm -f t/08taint.t
      rm -f t/28autowrap.t
    '';
    meta = {
      homepage = https://github.com/ingydotnet/inline-c-pm;
      description = "C Language Support for Inline";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  InlineJava = buildPerlPackage rec {
    name = "Inline-Java-0.53";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PATL/${name}.tar.gz";
      sha256 = "1d9hq09nv3l6m015ws08b3gbfp8daxryqr7p0yi0xhqr44j9qcj8";
    };

    propagatedBuildInputs = [ Inline ];

    makeMakerFlags = "J2SDK=${pkgs.jdk}";

    # FIXME: Apparently tests want to access the network.
    doCheck = false;

    meta = {
      description = "Inline::Java -- Write Perl classes in Java";

      longDescription = ''
        The Inline::Java module allows you to put Java source code directly
        "inline" in a Perl script or module.  A Java compiler is launched and
        the Java code is compiled.  Then Perl asks the Java classes what
        public methods have been defined.  These classes and methods are
        available to the Perl program as if they had been written in Perl.
      '';

      license = stdenv.lib.licenses.artistic2;

      maintainers = [ ];
    };
  };

  IPCSignal = buildPerlPackage rec {
    name = "IPC-Signal-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "1l3g0zrcwf2whwjhbpwdcridb7c77mydwxvfykqg1h6hqb4gj8bw";
    };
  };

  JavaScriptMinifierXS = buildPerlModule rec {
    name = "JavaScript-Minifier-XS-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GT/GTERMARS/JavaScript-Minifier-XS-0.11.tar.gz;
      sha256 = "1vlyhckpjbrg2v4dy9szsxxl0q44n0y1xl763mg2y2ym9g5144hm";
    };
    meta = {
      description = "XS based JavaScript minifier";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  JSON = buildPerlPackage {
    name = "JSON-2.90";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz;
      sha256 = "127yppvr17qik9pkd1vy901hs4l13kg6rhp76jdgcyask35v7nsd";
    };
    preConfigure = ''
      cp lib/JSON/backportPP.pm{,orig}
      echo "1;" > lib/JSON/backportPP.pm
    '';
    postConfigure = ''
      cp lib/JSON/backportPP.pm{orig,}
    '';
    meta = {
      description = "JSON (JavaScript Object Notation) encoder/decoder";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  JSONAny = buildPerlPackage {
    name = "JSON-Any-1.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/JSON-Any-1.39.tar.gz;
      sha256 = "1hspg6khjb38syn59cysnapc1q77qgavfym3fqr6l2kiydf7ajdf";
    };
    meta = {
      description = "Wrapper Class for the various JSON classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestFatal TestRequires TestWarnings TestWithoutModule ];
  };

  JSONMaybeXS = buildPerlPackage rec {
    name = "JSON-MaybeXS-1.003010";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/JSON-MaybeXS-1.003010.tar.gz;
      sha256 = "0hs504x5zsa2vl6r7b3rvbygsak1ly24m1lg636bqp3x7jirmb30";
    };
    meta = {
      description = "Use L<Cpanel::JSON::XS> with a fallback to L<JSON::XS> and L<JSON::PP>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPP = buildPerlPackage rec {
    name = "JSON-PP-2.97001";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISHIGAKI/JSON-PP-2.97001.tar.gz;
      sha256 = "1d1731yqv2py039qxcr0j9r4jb8m9kq387pj1q6gxawbfwvlmxb7";
    };
    meta = {
      description = "JSON::XS compatible pure-Perl module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPPCompat5006 = buildPerlPackage {
    name = "JSON-PP-Compat5006-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-Compat5006-1.09.tar.gz;
      sha256 = "197030df52635f9bbe25af10742eea5bd74971473118c11311fcabcb62e3716a";
    };
    meta = {
      description = "Helper module in using JSON::PP in Perl 5.6";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

 JSONWebToken = buildPerlModule rec {
    name = "JSON-WebToken-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/${name}.tar.gz";
      sha256 = "77c182a98528f1714d82afc548d5b3b4dc93e67069128bb9b9413f24cf07248b";
    };
    buildInputs = [ TestMockGuard TestRequires ];
    propagatedBuildInputs = [ JSON ];
    meta = {
      homepage = https://github.com/xaicron/p5-JSON-WebToken;
      description = "JSON Web Token (JWT) implementation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONXS = buildPerlPackage {
    name = "JSON-XS-3.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-3.04.tar.gz;
      sha256 = "0b3w14zqjxnm93jjfzjqz8pkxp3a2l9242y7zxxhnvzav1mq7n35";
    };
    propagatedBuildInputs = [ TypesSerialiser ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
    buildInputs = [ CanaryStability ];
  };

  JSONXSVersionOneAndTwo = buildPerlPackage rec {
    name = "JSON-XS-VersionOneAndTwo-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "e6092c4d961fae777acf7fe99fb3cd6e5b710fec85765a6b90417480e4c94a34";
    };
    propagatedBuildInputs = [ JSONXS ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Later = buildPerlPackage rec {
    version = "0.21";
    name = "Object-Realize-Later-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1nfqssld7pcdw9sj4mkfnh75w51wl14i1h7npj9fld4fri09cywg";
    };
  };

  lib_ = buildPerlPackage {
    name = "lib-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/lib-0.63.tar.gz;
      sha256 = "72f63db9220098e834d7a38231626bd0c9b802c1ec54a628e2df35f3818e5a00";
    };
    meta = {
      description = "Manipulate @INC at compile time";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libapreq2 = buildPerlPackage {
    name = "libapreq2-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISAAC/libapreq2-2.13.tar.gz;
      sha256 = "5731e6833b32d88e4a5c690e45ddf20fcf969ce3da666c5627d775e92da0cf6e";
    };
    outputs = [ "out" ];
    buildInputs = [ pkgs.apacheHttpd pkgs.apr pkgs.aprutil ApacheTest ExtUtilsXSBuilder ];
    propagatedBuildInputs = [ mod_perl2 ];
    makeMakerFlags = "--with-apache2-src=${pkgs.apacheHttpd.dev} --with-apache2-apxs=${pkgs.apacheHttpd.dev}/bin/apxs --with-apache2-httpd=${pkgs.apacheHttpd.out}/bin/httpd --with-apr-config=${pkgs.apr.dev}/bin/apr-1-config --with-apu-config=${pkgs.aprutil.dev}/bin/apu-1-config";
    preConfigure = ''
      # override broken prereq check
      substituteInPlace configure --replace "prereq_check=\"\$PERL \$PERL_OPTS build/version_check.pl\"" "prereq_check=\"echo\""
      '';
    preBuild = ''
      substituteInPlace apreq2-config --replace "dirname" "${pkgs.coreutils}/bin/dirname"
      '';
    installPhase = ''
      mkdir $out
      make install DESTDIR=$out
      cp -r $out/${pkgs.apacheHttpd.dev}/. $out/.
      cp -r $out/$out/. $out/.
      rm -r $out/nix
      '';
    doCheck = false; # test would need to start apache httpd
    meta = {
      license = stdenv.lib.licenses.asl20;
    };
  };

  libintlperl = pkgs.perlPackages.libintl_perl;

  libintl_perl = buildPerlPackage rec {
    name = "libintl-perl-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GU/GUIDO/libintl-perl-1.29.tar.gz;
      sha256 = "1cgvrgh4axd8jlr6497ndgphgvgnqc1axd306460hskdvc85z4vq";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  libnet = buildPerlPackage {
    name = "libnet-3.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/libnet-3.11.tar.gz;
      sha256 = "1lsj3a2vbryh85mbb6yddyb2zjv5vs88fdj5x3v7fp2ndr6ixarg";
    };
    meta = {
      description = "Collection of network protocol modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libxml_perl = buildPerlPackage rec {
    name = "libxml-perl-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/${name}.tar.gz";
      sha256 = "1jy9af0ljyzj7wakqli0437zb2vrbplqj4xhab7bfj2xgfdhawa5";
    };
    propagatedBuildInputs = [ XMLParser ];
  };

  LinguaENFindNumber = buildPerlPackage {
    name = "Lingua-EN-FindNumber-1.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Lingua-EN-FindNumber-1.32.tar.gz;
      sha256 = "1d176d1c863fb9844bd19d2c2a4e68a0ed73da158f724a89405b90db7e8dbd04";
    };
    propagatedBuildInputs = [ LinguaENWords2Nums ];
    meta = {
      homepage = https://github.com/neilbowers/Lingua-EN-FindNumber;
      description = "Locate (written) numbers in English text";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflect = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-1.903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/${name}.tar.gz";
      sha256 = "fcef4b67b04cc39e427b2d70e7c5b24195edd0ed88dd705a08ecd5cd830b0d49";
    };
    meta = {
      description = "Convert singular to plural. Select 'a' or 'an'";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflectNumber = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Number-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "66fb33838512746f5c597e80264fea66643f7f26570ec2f9205b6135ad67acbf";
    };
    propagatedBuildInputs = [ LinguaENInflect ];
    meta = {
      homepage = https://github.com/neilbowers/Lingua-EN-Inflect-Number;
      description = "Force number of words to singular or plural";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflectPhrase = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Phrase-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "55058911a99f1755de3eb449a99ffbeb92d88c01ff5dc60511a24679050ddea8";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ LinguaENInflectNumber LinguaENNumberIsOrdinal LinguaENTagger ];
    meta = {
      homepage = https://metacpan.org/release/Lingua-EN-Inflect-Phrase;
      description = "Inflect short English Phrases";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENNumberIsOrdinal = buildPerlPackage {
    name = "Lingua-EN-Number-IsOrdinal-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Number-IsOrdinal-0.05.tar.gz;
      sha256 = "28d5695400c0f4e2bd209793cb74f6da2b9257356aacb2947c603425e09618d6";
    };
    buildInputs = [ TestFatal TryTiny ];
    propagatedBuildInputs = [ LinguaENFindNumber ];
    meta = {
      homepage = https://metacpan.org/release/Lingua-EN-Number-IsOrdinal;
      description = "Detect if English number is ordinal or cardinal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENTagger = buildPerlPackage {
    name = "Lingua-EN-Tagger-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AC/ACOBURN/Lingua-EN-Tagger-0.28.tar.gz;
      sha256 = "1rm223d871s150dgnhbar71w56bim950cp45f0904w6px5fifcqa";
    };
    propagatedBuildInputs = [ HTMLParser LinguaStem MemoizeExpireLRU ];
    meta = {
      description = "Part-of-speech tagger for English natural language processing";
      license = stdenv.lib.licenses.gpl3;
    };
  };

  LinguaENWords2Nums = buildPerlPackage {
    name = "Lingua-EN-Words2Nums-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOEY/Lingua-EN-Words2Nums-0.18.tar.gz;
      sha256 = "686556797cd2a4eaa066f19bbf03ab25c06278292c9ead2f187dfd9031ea1d85";
    };
    meta = {
      description = "Convert English text to numbers";
      license = "unknown";
    };
  };

  LinguaPTStemmer = buildPerlPackage rec {
     name = "Lingua-PT-Stemmer-0.02";
     src = fetchurl {
       url = mirror://cpan/authors/id/N/NE/NEILB/Lingua-PT-Stemmer-0.02.tar.gz;
       sha256 = "17c48sfbgwd2ivlgf59sr6jdhwa3aim8750f8pyzz7xpi8gz0var";
     };
     meta = {
       description = "Portuguese language stemming";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/neilb/Lingua-PT-Stemmer";
     };
  };

  LinguaStem = buildPerlModule rec {
    name = "Lingua-Stem-0.84";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SN/SNOWHARE/Lingua-Stem-0.84.tar.gz;
      sha256 = "12avh2mnnc7llmmshrr5bgb473fvydxnlqrqbl2815mf2dp4pxcg";
    };
    doCheck = false;
    propagatedBuildInputs = [ LinguaPTStemmer LinguaStemFr LinguaStemIt LinguaStemRu LinguaStemSnowballDa SnowballNorwegian SnowballSwedish TextGerman ];
  };

  LinguaStemFr = buildPerlPackage rec {
     name = "Lingua-Stem-Fr-0.02";
     src = fetchurl {
       url = mirror://cpan/authors/id/S/SD/SDP/Lingua-Stem-Fr-0.02.tar.gz;
       sha256 = "0vyrspwzaqjxm5mqshf4wvwa3938mkajd1918d9ii2l9m2rn8kwx";
     };
     meta = {
     };
  };

  LinguaStemIt = buildPerlPackage rec {
     name = "Lingua-Stem-It-0.02";
     src = fetchurl {
       url = mirror://cpan/authors/id/A/AC/ACALPINI/Lingua-Stem-It-0.02.tar.gz;
       sha256 = "1207r183s5hlh4mfwa6p46vzm0dhvrs2dnss5s41a0gyfkxp7riq";
     };
     meta = {
     };
  };

  LinguaStemRu = buildPerlPackage rec {
     name = "Lingua-Stem-Ru-0.04";
     src = fetchurl {
       url = mirror://cpan/authors/id/N/NE/NEILB/Lingua-Stem-Ru-0.04.tar.gz;
       sha256 = "0a2jmdz7jn32qj5hyiw5kbv8fvlpmws8i00a6xcbkzb48yvwww0j";
     };
     meta = {
       description = "Porter's stemming algorithm for Russian (KOI8-R only)";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/neilb/Lingua-Stem-Ru";
     };
  };

  LinguaStemSnowballDa = buildPerlPackage rec {
     name = "Lingua-Stem-Snowball-Da-1.01";
     src = fetchurl {
       url = mirror://cpan/authors/id/C/CI/CINE/Lingua-Stem-Snowball-Da-1.01.tar.gz;
       sha256 = "0mm0m7glm1s6i9f6a78jslw6wh573208arxhq93yriqmw17bwf9f";
     };
     meta = {
     };
  };

  LinguaTranslit = buildPerlPackage rec {
    name = "Lingua-Translit-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALINKE/${name}.tar.gz";
      sha256 = "113f91d8fc2c630437153a49fb7a52b023af8f6278ed96c070b1f60824b8eae1";
    };
    doCheck = false;
  };

  LinuxDistribution = buildPerlModule {
    name = "Linux-Distribution-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Linux-Distribution-0.23.tar.gz;
      sha256 = "603e27da607b3e872a669d7a66d75982f0969153eab2d4b20c341347b4ebda5f";
    };
    # The tests fail if the distro it's built on isn't in the supported list.
    # This includes NixOS.
    doCheck = false;
    meta = {
      description = "Perl extension to detect on which Linux distribution we are running";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinuxInotify2 = buildPerlPackage rec {
    name = "Linux-Inotify2-1.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/Linux-Inotify2-1.22.tar.gz;
      sha256 = "1l916p8xak6c51x4x1vrzd8wpi55bld74wf0p5w5m4vr80zjb7dw";
    };
    propagatedBuildInputs = [ commonsense ];
  };

  ListAllUtils = buildPerlPackage {
    name = "List-AllUtils-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/List-AllUtils-0.14.tar.gz;
      sha256 = "e45aa65927ae1975a000cc2fed14274627fa5e2bd09bab826a5f2c41d17ef6cd";
    };
    propagatedBuildInputs = [ ListSomeUtils ListUtilsBy ScalarListUtils ];
    meta = {
      description = "Combines List::Util and List::MoreUtils in one bite-sized package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ListBinarySearch = pkgs.buildPerlPackage {
    name = "List-BinarySearch-0.20";
    src = pkgs.fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVIDO/List-BinarySearch-0.20.tar.gz;
      sha256 = "1piyl65m38bwqaap13wkgs033wiwb6m5zmr5va86ya4696cir7wd";
    };
  };

  ListMoreUtils = buildPerlPackage rec {
    name = "List-MoreUtils-0.428";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "713e0945d5f16e62d81d5f3da2b6a7b14a4ce439f6d3a7de74df1fd166476cc2";
    };
    propagatedBuildInputs = [ ExporterTiny ListMoreUtilsXS ];
    meta = {
      homepage = https://metacpan.org/release/List-MoreUtils;
      description = "Provide the stuff missing in List::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestLeakTrace ];
  };

  ListMoreUtilsXS = buildPerlPackage rec {
     name = "List-MoreUtils-XS-0.428";
     src = fetchurl {
       url = mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.428.tar.gz;
       sha256 = "0bfndmnkqaaf3gffprak143bzplxd69c368jxgr7rzlx88hyd7wx";
     };
     propagatedBuildInputs = [ XSLoader ];
     meta = {
       description = "Provide the stuff missing in List::Util in XS";
       license = with stdenv.lib.licenses; [ asl20 ];
       homepage = "https://metacpan.org/release/List-MoreUtils-XS";
     };
  };

  ListSomeUtils = buildPerlPackage rec {
    name = "List-SomeUtils-0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "eaa7d99ce86380c0389876474c8eb84acc0a6bfeef1b0fc23a292592de6f89f7";
    };
    buildInputs = [ TestLeakTrace ];
    propagatedBuildInputs = [ ModuleImplementation ];
    meta = {
      homepage = https://metacpan.org/release/List-SomeUtils;
      description = "Provide the stuff missing in List::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListUtilsBy = buildPerlModule rec {
    name = "List-UtilsBy-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/List-UtilsBy-0.11.tar.gz;
      sha256 = "0nkpylkqccxanr8wc7j9wg6jdrizybjjd6p8q3jbh7f29cxz9pgs";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LocaleCodes = buildPerlPackage {
    name = "Locale-Codes-3.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Locale-Codes-3.56.tar.gz;
      sha256 = "d82f3340ecb7f8700493df0273dede0c049fbc44c2fe1e811fc6c5a79b79ae79";
    };
    meta = {
      description = "A distribution of modules to handle locale codes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleGettext = buildPerlPackage {
    name = "gettext-1.07";
    buildInputs = [ pkgs.gettext ];
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz;
      sha256 = "05cwqjxxary11di03gg3fm6j9lbvg1dr2wpr311c1rwp8salg7ch";
    };
    LANG="C";
  };

  LocaleMaketext = buildPerlPackage {
    name = "Locale-Maketext-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Locale-Maketext-1.28.tar.gz;
      sha256 = "1sgpcnh9kqdnsizpwxzsyfv44id7gxsgkd9bmnhmj4g8hfs9712p";
    };
  };

  LocaleMaketextFuzzy = buildPerlPackage {
    name = "Locale-Maketext-Fuzzy-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Fuzzy-0.11.tar.gz;
      sha256 = "3785171ceb78cc7671319a3a6d8ced9b190e097dfcd9b2a9ebc804cd1a282f96";
    };
    meta = {
      description = "Maketext from already interpolated strings";
      license = "unrestricted";
    };
  };

  LocaleMaketextLexicon = buildPerlPackage {
    name = "Locale-Maketext-Lexicon-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DRTECH/Locale-Maketext-Lexicon-1.00.tar.gz;
      sha256 = "b73f6b04a58d3f0e38ebf2115a4c1532f1a4eef6fac5c6a2a449e4e14c1ddc7c";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Locale-Maketext-Lexicon;
      description = "Use other catalog formats in Maketext";
      license = "mit";
    };
  };

  LocaleMaketextSimple = buildPerlPackage {
    name = "Locale-Maketext-Simple-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Locale-Maketext-Simple-0.21.tar.gz;
      sha256 = "1ad9vh45j8c32nzkbjipinawyg1pnjckwlhsjqcqs47vyi8zy2dh";
    };
  };

  LocaleMsgfmt = buildPerlPackage {
    name = "Locale-Msgfmt-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AZ/AZAWAWI/Locale-Msgfmt-0.15.tar.gz;
      sha256 = "c3276831cbeecf58be02081bcc180bd348daa35da21a7737b7b038a59f643ab4";
    };
    meta = {
      description = "Compile .po files to .mo files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocalePO = buildPerlPackage {
    name = "Locale-PO-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COSIMO/Locale-PO-0.27.tar.gz;
      sha256 = "3c994a4b63e6e4e836c6f79a93f51921cab77c90c9753fe0f8b5429220d516b9";
    };
    propagatedBuildInputs = [ FileSlurp ];
    meta = {
      description = "Perl module for manipulating .po entries from GNU gettext";
      license = "unknown";
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  locallib = buildPerlPackage rec {
    name = "local-lib-2.000024";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "01cav7m6qc1x96wna1viiw6n212f94ks7cik4vj1a1lasixr36rf";
    };
    meta = {
      description = "Create and use a local lib/ for perl modules with PERL5LIB";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ ModuleBuild ];
  };

  LockFileSimple = buildPerlPackage rec {
    name = "LockFile-Simple-0.208";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/lockfile-simple/LockFile-Simple-0.208.tar.gz";
      sha256 = "18pk5a030dsg1h6wd8c47wl8pzrpyh9zi9h2c9gs9855nab7iis5";
    };
  };

  LogAny = buildPerlPackage rec {
    name = "Log-Any-1.705";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PR/PREACTION/${name}.tar.gz";
      sha256 = "85c7c5189a8bfc2ffb6f879b4cd04dd77f94bc5abc3800b4330f42f43fb9a696";
    };
    # Syslog test fails.
    preCheck = "rm t/syslog.t";
    meta = {
      homepage = https://github.com/preaction/Log-Any;
      description = "Bringing loggers and listeners together";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  LogContextual = buildPerlPackage rec {
    name = "Log-Contextual-0.008001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "b93cbcfbb8796d51c836e3b00243cda5630808c152c14eee5f20ca09c9451993";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DataDumperConcise ExporterDeclare Moo ];
    meta = {
      homepage = https://github.com/frioux/Log-Contextual;
      description = "Simple logging interface with a contextual log";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogDispatch = buildPerlPackage {
    name = "Log-Dispatch-2.67";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Log-Dispatch-2.67.tar.gz;
      sha256 = "017ks3i0k005dqz7fz53w7x35csqqlr4vfb95c0ijdablajs4kd9";
    };
    propagatedBuildInputs = [ DevelGlobalDestruction ParamsValidationCompiler Specio namespaceautoclean ];
    meta = {
      description = "Dispatches messages to one or more outputs";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ IPCRun3 TestFatal TestNeeds ];
  };

  LogHandler = buildPerlModule rec {
    name = "Log-Handler-0.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BL/BLOONIX/${name}.tar.gz";
      sha256 = "45bf540ab2138ed3ff93afc205b0516dc75755b86acdcc5e75c41347833c293d";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Log messages to several outputs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  LogMessage = buildPerlPackage {
    name = "Log-Message-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-0.08.tar.gz;
      sha256 = "bd697dd62aaf26d118e9f0a0813429deb1c544e4501559879b61fcbdfe99fe46";
    };
    meta = {
      description = "Powerful and flexible message logging mechanism";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogTrace = buildPerlPackage rec {
    name = "Log-Trace-1.070";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBC/Log-Trace-1.070.tar.gz;
      sha256 = "1qrnxn9b05cqyw1286djllnj8wzys10754glxx6z5hihxxc85jwy";
    };
  };

  MCE = buildPerlPackage rec {
     name = "MCE-1.835";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MA/MARIOROY/MCE-1.835.tar.gz;
       sha256 = "1dxs7gvj97vr1ns74k3inix1i80d8b2j942crnapdx9j90j6cqvi";
     };
     meta = {
       description = "Many-Core Engine for Perl providing parallel processing capabilities";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/marioroy/mce-perl";
     };
  };

  LogLog4perl = buildPerlPackage rec {
    name = "Log-Log4perl-1.49";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/${name}.tar.gz";
      sha256 = "b739187f519146cb6bebcfc427c64b1f4138b35c5f4c96f46a21ed4a43872e16";
    };
    meta = {
      homepage = https://mschilli.github.io/log4perl/;
      description = "Log4j implementation for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  # For backwards compatibility.
  Log4Perl = self.LogLog4perl;

  LogDispatchArray = buildPerlPackage {
    name = "Log-Dispatch-Array-1.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatch-Array-1.003.tar.gz;
      sha256 = "0dvzp0gsh17jqg02460ndchyapr1haahndq1p9v6mwkv5wf9680c";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ LogDispatch ];
    meta = {
      homepage = https://github.com/rjbs/log-dispatch-array;
      description = "Log events to an array (reference)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogDispatchouli = buildPerlPackage rec {
    name = "Log-Dispatchouli-2.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "7f2a1a1854fd1e4ed02883bc21f5395f4244a266b661276b438d1bdd50bdacf7";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ LogDispatchArray StringFlogger SubExporterGlobExporter ];
    meta = {
      homepage = https://github.com/rjbs/Log-Dispatchouli;
      description = "A simple wrapper around Log::Dispatch";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogLogLite = buildPerlPackage rec {
    name = "Log-LogLite-0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RANI/${name}.tar.gz";
      sha256 = "0sqsa4750wvhw4cjmxpxqg30i1jjcddadccflisrdb23qn5zn285";
    };
    propagatedBuildInputs = [ IOLockedFile ];
    meta = {
      description = "Helps us create simple logs for our application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWP = buildPerlPackage rec {
    name = "libwww-perl-6.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OA/OALDERS/libwww-perl-6.33.tar.gz;
      sha256 = "97417386f11f007ae129fe155b82fd8969473ce396a971a664c8ae6850c69b99";
    };
    propagatedBuildInputs = [ FileListing HTMLParser HTTPCookies HTTPDaemon HTTPNegotiate NetHTTP TryTiny WWWRobotRules ];
    meta = with stdenv.lib; {
      description = "The World-Wide Web library for Perl";
      license = with licenses; [ artistic1 gpl1Plus ];
      platforms = platforms.unix;
    };
    buildInputs = [ TestFatal TestRequiresInternet ];
  };

  LWPAuthenOAuth = buildPerlPackage rec {
    name = "LWP-Authen-OAuth-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMBRODY/${name}.tar.gz";
      sha256 = "e78e0bd7de8002cfb4760073258d555ef55b2c27c07a94b3d8a2166a17fd96bc";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Generate signed OAuth requests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPMediaTypes = buildPerlPackage {
    name = "LWP-MediaTypes-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/LWP-MediaTypes-6.02.tar.gz;
      sha256 = "0xmnblp962qy02akah30sji8bxrqcyqlff2w95l199ghql60ny8q";
    };
    meta = {
      description = "Guess media type for a file or a URL";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolconnect = pkgs.perlPackages.LWPProtocolConnect;

  LWPProtocolConnect = buildPerlPackage {
    name = "LWP-Protocol-connect-6.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BE/BENNING/LWP-Protocol-connect-6.09.tar.gz;
      sha256 = "9f252394775e23aa42c3176611e5930638ab528d5190110b4731aa5b0bf35a15";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ LWPProtocolHttps ];
    meta = {
      description = "Provides HTTP/CONNECT proxy support for LWP::UserAgent";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolhttps = pkgs.perlPackages.LWPProtocolHttps;

  LWPProtocolHttps = buildPerlPackage rec {
    name = "LWP-Protocol-https-6.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.07.tar.gz;
      sha256 = "1rxrpwylfw1afah0nk96kgkwjbl2p1a7lwx50iipg8c4rx3cjb2j";
    };
    patches = [ ../development/perl-modules/lwp-protocol-https-cert-file.patch ];
    propagatedBuildInputs = [ IOSocketSSL LWP MozillaCA ];
    doCheck = false; # tries to connect to https://www.apache.org/.
    meta = {
      description = "Provide https support for LWP::UserAgent";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
    buildInputs = [ TestRequiresInternet ];
  };

  LWPProtocolhttp10 = buildPerlPackage rec {
     name = "LWP-Protocol-http10-6.03";
     src = fetchurl {
       url = mirror://cpan/authors/id/G/GA/GAAS/LWP-Protocol-http10-6.03.tar.gz;
       sha256 = "1lxq40qfwfai9ryhzhsdnycc4189c8kfl43rf7qq34fmz48skzzk";
     };
     propagatedBuildInputs = [ LWP ];
     meta = {
       description = "Legacy HTTP/1.0 support for LWP";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  LWPUserAgent = LWP;

  LWPUserAgentDetermined = buildPerlPackage {
    name = "LWP-UserAgent-Determined-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/LWP-UserAgent-Determined-1.07.tar.gz;
      sha256 = "06d8d50e8cd3692a11cb4fb44a2f84e5476a98f0e2e6a4a0dfce9f67e55ddb53";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A virtual browser that retries errors";
      license = "unknown";
    };
  };

  LWPUserAgentMockable = buildPerlModule {
    name = "LWP-UserAgent-Mockable-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJEMMESON/LWP-UserAgent-Mockable-1.18.tar.gz;
      sha256 = "0923ahl22c0gdzrihj7dqnrawia9hmcl462asf4ry8d5wd84z1i5";
    };
    propagatedBuildInputs = [ HookLexWrap LWP SafeIsa ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    # Tests require network connectivity
    # https://rt.cpan.org/Public/Bug/Display.html?id=63966 is the bug upstream,
    # which doesn't look like it will get fixed anytime soon.
    doCheck = false;
    buildInputs = [ ModuleBuildTiny TestRequiresInternet ];
  };

  LWPxParanoidAgent = buildPerlPackage rec {
    name = "LWPx-ParanoidAgent-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/lwp/${name}.tar.gz";
      sha256 = "0gfhw3jbs25yya2dryv8xvyn9myngcfcmsybj7gkq62fnznil16c";
    };
    doCheck = false; # 3 tests fail, probably because they try to connect to the network
    propagatedBuildInputs = [ LWP NetDNS ];
  };

  maatkit = import ../development/perl-modules/maatkit {
    inherit fetchurl buildPerlPackage stdenv DBDmysql;
  };

  MacPasteboard = buildPerlPackage rec {
    name = "Mac-Pasteboard-0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/${name}.tar.gz";
      sha256 = "85b1d5e9630973b997c3c1634e2df964d6a8d6cb57d9abe1f7093385cf26cf54";
    };
    meta = with stdenv.lib; {
      description = "Manipulate Mac OS X pasteboards";
      license = with licenses; [ artistic1 gpl1Plus ];
      platforms = platforms.darwin;
    };
    buildInputs = [ pkgs.darwin.apple_sdk.frameworks.ApplicationServices ];
  };

  MailMaildir = buildPerlPackage rec {
    version = "1.0.0";
    name = "Mail-Maildir-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEROALTI/Mail-Maildir-100/${name}.tar.bz2";
      sha256 = "1krkqfps6q3ifrhi9450l5gm9199qyfcm6vidllr0dv65kdaqpj4";
    };
  };

  MailBox = buildPerlPackage rec {
    version = "3.005";
    name = "Mail-Box-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "103v5jiv5mlckss1yardjvil506sx60f3g2ph2kgx9x6sy1sd93m";
    };

    doCheck = false;

    propagatedBuildInputs = [ DevelGlobalDestruction FileRemove Later MailTransport ];
  };

  MailMboxMessageParser = buildPerlPackage rec {
    name = "Mail-Mbox-MessageParser-1.5105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/${name}.tar.gz";
      sha256 = "641edd8b7ab74de671ab4931311413c1bd037a1c3eaa0a0c97451cd7b104f2d8";
    };
    buildInputs = [ FileSlurp TextDiff URI ];
    propagatedBuildInputs = [ FileHandleUnget ];
    meta = {
      homepage = https://github.com/coppit/mail-mbox-messageparser;
      description = "A fast and simple mbox folder reader";
      license = stdenv.lib.licenses.gpl2;
      maintainers = with maintainers; [ romildo ];
    };
  };

  MailMessage = buildPerlPackage rec {
     name = "Mail-Message-3.006";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MA/MARKOV/Mail-Message-3.006.tar.gz;
       sha256 = "08bdf06bmxdqbslk3k9av542pjhyw9wx10j79fxz0dwpalimc6zi";
     };
     propagatedBuildInputs = [ IOStringy MIMETypes MailTools URI UserIdentity ];
     meta = {
       description = "Processing MIME messages";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  MailDKIM = buildPerlPackage rec {
    name = "Mail-DKIM-0.52";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-DKIM-0.52.tar.gz;
      sha256 = "1dbczg7vyvvm12d9gbiqd9a24qg4254cz7bh7yf3p27i58hhpbwy";
    };
    propagatedBuildInputs = [ CryptOpenSSLRSA MailTools NetDNSResolverMock YAMLLibYAML ];
    doCheck = false; # tries to access the domain name system
    buildInputs = [ TestRequiresInternet ];
  };

  MailIMAPClient = buildPerlPackage {
    name = "Mail-IMAPClient-3.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.39.tar.gz;
      sha256 = "18sf8fd093qxvflscysm6pv6mj9cmm19zrnfic297jjvgnsgshdm";
    };
    propagatedBuildInputs = [ ParseRecDescent ];
  };

  MailPOP3Client = buildPerlPackage rec {
    name = "Mail-POP3Client-2.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SD/SDOWD/${name}.tar.gz";
      sha256 = "1142d6247a93cb86b23ed8835553bb2d227ff8213ee2743e4155bb93f47acb59";
    };
    meta = {
      description = "Perl 5 module to talk to a POP3 (RFC1939) server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailRFC822Address = buildPerlPackage {
    name = "Mail-RFC822-Address-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PD/PDWARREN/Mail-RFC822-Address-0.3.tar.gz;
      sha256 = "351ef4104ecb675ecae69008243fae8243d1a7e53c681eeb759e7b781684c8a7";
    };
  };

  MailSendmail = buildPerlPackage rec {
    name = "Mail-Sendmail-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Mail-Sendmail-0.80.tar.gz";
      sha256 = "1r38qbkj7jwj8cqy1rnqzkk81psxi08b1aiq392817f3bk5ri2jv";
    };
    # The test suite simply loads the module and attempts to send an email to
    # the module's author, the latter of which is a) more of an integration
    # test, b) impossible to verify, and c) won't work from a sandbox. Replace
    # it in its entirety with the following simple smoke test.
    checkPhase = ''
      perl -I blib/lib -MMail::Sendmail -e 'print "1..1\nok 1\n"'
    '';
    meta = {
      maintainers = [ maintainers.limeytexan ];
      description = "Simple platform independent mailer";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailSPF = buildPerlPackage rec {
    name = "Mail-SPF-v2.9.0";
    #src = /root/nixops/Mail-SPF-v2.9.0;
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMEHNLE/mail-spf/${name}.tar.gz";
      sha256 = "61cb5915f1c7acc7a931ffc1bfc1291bdfac555e2a46eb2391b995ea9ecb6162";
    };
    # remove this patch patches = [ ../development/perl-modules/Mail-SPF.patch ];

    buildInputs = [ ModuleBuild NetDNSResolverProgrammable ];
    propagatedBuildInputs = [ Error NetAddrIP NetDNS URI ];

    buildPhase = "perl Build.PL --install_base=$out --install_path=\"sbin=$out/bin\" --install_path=\"lib=$out/lib/perl5/site_perl\"; ./Build build ";

    doCheck = false; # The main test performs network access
    meta = {
      description = "An object-oriented implementation of Sender Policy Framework";
      license = stdenv.lib.licenses.bsd3;
    };
  };


  MailTools = buildPerlPackage rec {
    name = "MailTools-2.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "15iizg2x1w7ca0r8rn3wwhp7w160ljvf55prspljwd6cm7vhcmpm";
    };
    propagatedBuildInputs = [ TimeDate ];
    meta = {
      description = "Various e-mail related modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MailTransport = buildPerlPackage rec {
     name = "Mail-Transport-3.002";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MA/MARKOV/Mail-Transport-3.002.tar.gz;
       sha256 = "0wm4j9w15nsvjxi9x22fn2rnljbffd88v27p0z0305bfg35gh4kg";
     };
     propagatedBuildInputs = [ MailMessage ];
     meta = {
       description = "Email message exchange";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  MathLibm = buildPerlPackage rec {
    name = "Math-Libm-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSLEWART/Math-Libm-1.00.tar.gz;
      sha256 = "0xn2a950mzzs5q1c4q98ckysn9dz20x7r35g02zvk35chgr0klxz";
    };
  };

  MathCalcUnits = buildPerlPackage rec {
    name = "Math-Calc-Units-1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SF/SFINK/${name}.tar.gz";
      sha256 = "13wgbxv2fmigdj0vf7nwkq1y2q07jgfj8wdrpqkywfxv4zdwzqv1";
    };
    meta = {
      description = "Human-readable unit-aware calculator";
      license = with stdenv.lib.licenses; [ artistic1 gpl2 ];
    };
  };

  MathBigInt = buildPerlPackage rec {
    name = "Math-BigInt-1.999811";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "d4bfa5ad0127b6360ad29971da6fa08bcfb56a471d55db3c7419d05f8a947b8d";
    };
    meta = {
      description = "Arbitrary size integer/float math package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathBigIntGMP = buildPerlPackage rec {
    name = "Math-BigInt-GMP-1.6004";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "1wiklyxxpf02c01flymyjqh46lhi0qhkvf14icni8grjgpfjjqi3";
    };
    buildInputs = [ pkgs.gmp ];
    doCheck = false;
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    propagatedBuildInputs = [ MathBigInt ];
  };

  MathBigIntLite = buildPerlPackage rec {
     name = "Math-BigInt-Lite-0.17";
     src = fetchurl {
       url = mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-Lite-0.17.tar.gz;
       sha256 = "1pii36cykpja9al6bdnsxn2w0la674qagqcff6lhk9yx6xakycpk";
     };
     propagatedBuildInputs = [ MathBigInt ];
     meta = {
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  MathBigRat = buildPerlPackage rec {
    name = "Math-BigRat-0.2613";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "b893dfe2caf27b233a3678abc39176e706a9b518e8937bc496e46e125e960e22";
    };
    propagatedBuildInputs = [ MathBigInt ];
    meta = {
      description = "Arbitrary big rational numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathClipper = buildPerlModule rec {
    name = "Math-Clipper-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Math-Clipper-1.23.tar.gz;
      sha256 = "0i9wzvig7ayijc9nvh5x5rryk1jrcj1hcvfmlcj449rnnxx24dav";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    buildInputs = [ ExtUtilsCppGuess ExtUtilsTypemapsDefault ExtUtilsXSpp ModuleBuildWithXSpp TestDeep ];
  };

  MathComplex = buildPerlPackage {
    name = "Math-Complex-1.59";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Math-Complex-1.59.tar.gz;
      sha256 = "f35eb4987512c51d2c47294a008ede210d8dd759b90b887d04847c69b42dd6d1";
    };
  };

  MathConvexHullMonotoneChain = buildPerlPackage rec {
    name = "Math-ConvexHull-MonotoneChain-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Math-ConvexHull-MonotoneChain-0.01.tar.gz;
      sha256 = "1xcl7cz62ydddji9qzs4xsfxss484jqjlj4iixa4aci611cw92r8";
    };
  };

  MathGeometryVoronoi = buildPerlPackage rec {
    name = "Math-Geometry-Voronoi-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMTREGAR/Math-Geometry-Voronoi-1.3.tar.gz;
      sha256 = "0b206k2q5cznld45cjhgm0as0clc9hk135ds8qafbkl3k175w1vj";
    };
    propagatedBuildInputs = [ ClassAccessor ParamsValidate ];
  };

  MathPlanePath = buildPerlPackage rec {
    name = "Math-PlanePath-126";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "014gr79gg992paas6v1glciyycqp2hg7pg4y03kgfbxz1slc6zhq";
    };
    propagatedBuildInputs = [ MathLibm constant-defer ];
    buildInputs = [ DataFloat MathBigIntLite ];
  };

  MathRandomISAAC = buildPerlPackage {
    name = "Math-Random-ISAAC-1.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JAWNSY/Math-Random-ISAAC-1.004.tar.gz;
      sha256 = "0z1b3xbb3xz71h25fg6jgsccra7migq7s0vawx2rfzi0pwpz0wr7";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      homepage = http://search.cpan.org/dist/Math-Random-ISAAC;
      description = "Perl interface to the ISAAC PRNG algorithm";
      license = with stdenv.lib.licenses; [ publicDomain mit artistic2 gpl3 ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRandomMTAuto = buildPerlPackage {
    name = "Math-Random-MT-Auto-6.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Math-Random-MT-Auto-6.22.tar.gz;
      sha256 = "07zha5zjxyvqwnycb1vzk4hk2m46n9yc5lrbvhkc22595dsyjahz";
    };
    propagatedBuildInputs = [ ObjectInsideOut ];
    meta = {
      description = "Auto-seeded Mersenne Twister PRNGs";
      license = "unrestricted";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRandomSecure = buildPerlPackage {
    name = "Math-Random-Secure-0.080001";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Math-Random-Secure-0.080001.tar.gz;
      sha256 = "0dgbf4ncll4kmgkyb9fsaxn0vf2smc9dmwqzgh3259zc2zla995z";
    };
    buildInputs = [ ListMoreUtils TestSharedFork TestWarn ];
    propagatedBuildInputs = [ CryptRandomSource MathRandomISAAC ];
    meta = {
      description = "Cryptographically-secure, cross-platform replacement for rand()";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRound = buildPerlPackage rec {
    name = "Math-Round-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GROMMEL/Math-Round-0.07.tar.gz;
      sha256 = "09wkvqj4hfq9y0fimri967rmhnq90dc2wf20lhlmqjp5hsd359vk";
    };
  };

  MathVecStat = buildPerlPackage rec {
    name = "Math-VecStat-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AS/ASPINELLI/Math-VecStat-0.08.tar.gz;
      sha256 = "03bdcl9pn2bc9b50c50nhnr7m9wafylnb3v21zlch98h9c78x6j0";
    };
  };

  Memoize = buildPerlPackage {
    name = "Memoize-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Memoize-1.03.tgz;
      sha256 = "5239cc5f644a50b0de9ffeaa51fa9991eb06ecb1bf4678873e3ab89af9c0daf3";
    };
  };

  MemoizeExpireLRU = buildPerlPackage rec {
     name = "Memoize-ExpireLRU-0.56";
     src = fetchurl {
       url = mirror://cpan/authors/id/N/NE/NEILB/Memoize-ExpireLRU-0.56.tar.gz;
       sha256 = "1xnp3jqabl4il5kfadlqimbxhzsbm7gpwrgw0m5s5fdsrc0n70zf";
     };
     meta = {
       description = "Expiry plug-in for Memoize that adds LRU cache expiration";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/neilb/Memoize-ExpireLRU";
     };
  };

  MetaBuilder = buildPerlModule {
    name = "Meta-Builder-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Meta-Builder-0.003.tar.gz;
      sha256 = "e7ac289b88d1662e87708d716877ac66a1a8414660996fe58c1db96d834a5375";
    };
    buildInputs = [ FennecLite TestException ];
    meta = {
      description = "Tools for creating Meta objects to track custom metrics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MethodSignaturesSimple = buildPerlPackage {
    name = "Method-Signatures-Simple-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RH/RHESA/Method-Signatures-Simple-1.07.tar.gz;
      sha256 = "1p6sf6iyyn73pc89mfr65bzxvbw1ibcsp4j10iv8ik3p353pvkf8";
    };
    propagatedBuildInputs = [ DevelDeclare ];
    meta = {
      description = "Basic method declarations with signatures, without source filters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MHonArc = buildPerlPackage rec {
    name = "MHonArc-2.6.18";

    src = fetchurl {
      url    = "http://dcssrv1.oit.uci.edu/indiv/ehood/release/MHonArc/tar/${name}.tar.gz";
      sha256 = "1xmf26dfwr8achprc3n1pxgl0mkiyr6pf25wq3dqgzqkghrrsxa2";
    };
    propagatedBuildInputs = [ ];

    installTargets = "install";

    meta = with stdenv.lib; {
      homepage    = http://dcssrv1.oit.uci.edu/indiv/ehood/mhonarch.html;
      description = "A mail-to-HTML converter";
      maintainers = with maintainers; [ lovek323 ];
      license     = licenses.gpl2;
      platforms   = platforms.unix;
    };
  };

  MIMEBase64 = buildPerlPackage rec {
    name = "MIME-Base64-3.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1f8y78dskf91p4xym73n9lqbj15av5vxpsivm7nr7jx9lrk3b1kz";
    };
  };

  MIMECharset = buildPerlPackage {
    name = "MIME-Charset-1.012.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/MIME-Charset-1.012.2.tar.gz;
      sha256 = "878c779c0256c591666bd06c0cde4c0d7820eeeb98fd1183082aee9a1e7b1d13";
    };
    meta = {
      description = "Charset Information for MIME";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  mimeConstruct = buildPerlPackage rec {
    name = "mime-construct-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "00wk9950i9q6qwp1vdq9xdddgk54lqd0bhcq2hnijh8xnmhvpmsc";
    };
    outputs = [ "out" ];
    buildInputs = [ ProcWaitStat ];
  };

  MIMELite = buildPerlPackage rec {
    name = "MIME-Lite-3.030";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "8f39901bc580bc3dce69e10415305e4435ff90264c63d29f707b4566460be962";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      description = "Low-calorie MIME generator (DEPRECATED)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MIMEtools = MIMETools;

  MIMETools = buildPerlPackage rec {
    name = "MIME-tools-5.509";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSKOLL/MIME-tools-5.509.tar.gz;
      sha256 = "0wv9rzx5j1wjm01c3dg48qk9wlbm6iyf91j536idk09xj869ymv4";
    };
    propagatedBuildInputs = [ MailTools ];
    buildInputs = [ TestDeep ];
    meta = {
      description = "class for parsed-and-decoded MIME message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MIMETypes = buildPerlPackage rec {
    name = "MIME-Types-2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1y3vnxk4wv4a00lxcp39hw9650cdl455d3y7nv42rqmvaxikghwr";
    };
    meta = {
      description = "Definition of MIME types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MixinLinewise = buildPerlPackage rec {
    name = "Mixin-Linewise-0.108";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "7df20678474c0973930a472b0c55e3f8e85b7790b68ab18ef618f9c453c8aef2";
    };
    propagatedBuildInputs = [ PerlIOutf8_strict SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/mixin-linewise;
      description = "Write your linewise code for handles; this does the rest";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MockConfig = buildPerlPackage rec {
     name = "Mock-Config-0.03";
     src = fetchurl {
       url = mirror://cpan/authors/id/R/RU/RURBAN/Mock-Config-0.03.tar.gz;
       sha256 = "06q0xkg5cwdwafzmb9rkaa305ddv7vli9gpm6n9jnkyaaxbk9f55";
     };
     meta = {
       description = "temporarily set Config or XSConfig values";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus artistic2 ];
     };
  };

  ModernPerl = buildPerlModule {
    name = "Modern-Perl-1.20170117";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Modern-Perl-1.20170117.tar.gz;
      sha256 = "5df2a83461163212db22b9c3353606a1a123616820fe50675041c34f004b3628";
    };
    meta = {
      homepage = https://github.com/chromatic/Modern-Perl;
      description = "Enable all of the features of Modern Perl with one import";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuild = buildPerlPackage rec {
    name = "Module-Build-0.4224";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "10n7ggpmicwq1n503pg7kiwslda0bz48azzjvc7vb9s4hbbibjm6";
    };
    meta = {
      description = "Build and install Perl modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildDeprecated = buildPerlModule {
    name = "Module-Build-Deprecated-0.4210";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Deprecated-0.4210.tar.gz;
      sha256 = "be089313fc238ee2183473aca8c86b55fb3cf44797312cbe9b892d6362621703";
    };
    doCheck = false;
    meta = {
      description = "A collection of modules removed from Module-Build";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildPluggable = buildPerlModule rec {
    name = "Module-Build-Pluggable-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "e5bb2acb117792c984628812acb0fec376cb970caee8ede57535e04d762b0e40";
    };
    propagatedBuildInputs = [ ClassAccessorLite ClassMethodModifiers DataOptList ];
    meta = {
      homepage = https://github.com/tokuhirom/Module-Build-Pluggable;
      description = "Module::Build meets plugins";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestSharedFork ];
  };

  ModuleBuildPluggablePPPort = buildPerlModule rec {
    name = "Module-Build-Pluggable-PPPort-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "44084ba3d8815f343bd391585ac5d8339a4807ce5c0dd84c98db8f310b64c0ea";
    };
    buildInputs = [ TestRequires TestSharedFork ];
    propagatedBuildInputs = [ ModuleBuildPluggable ];
    meta = {
      description = "Generate ppport.h";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildTiny = buildPerlModule {
    name = "Module-Build-Tiny-0.039";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz;
      sha256 = "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c";
    };
    buildInputs = [ FileShareDir ];
    propagatedBuildInputs = [ ExtUtilsHelpers ExtUtilsInstallPaths ];
    meta = {
      description = "A tiny replacement for Module::Build";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildWithXSpp = buildPerlModule rec {
    name = "Module-Build-WithXSpp-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "0d39fjg9c0n820bk3fb50vvlwhdny4hdl69xmlyzql5xzp4cicsk";
    };
    propagatedBuildInputs = [ ExtUtilsCppGuess ExtUtilsXSpp ];
  };

  ModuleBuildXSUtil = buildPerlModule rec {
    name = "Module-Build-XSUtil-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIDEAKIO/${name}.tar.gz";
      sha256 = "1vjl77iwbwr2xhdlyqva3hhma9r1fgr2rappwsimwqjmybdrfd6b";
    };
    buildInputs = [ CaptureTiny CwdGuard FileCopyRecursive ];
    meta = {
      description = "A Module::Build class for building XS modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ DevelCheckCompiler ];
  };

  ModuleCPANTSAnalyse = buildPerlPackage rec {
     name = "Module-CPANTS-Analyse-0.96";
     src = fetchurl {
       url = mirror://cpan/authors/id/I/IS/ISHIGAKI/Module-CPANTS-Analyse-0.96.tar.gz;
       sha256 = "1c38fnbx9w1s841am1i5h33lcqr9bwc9bni21n907nmyp41wr297";
     };
     propagatedBuildInputs = [ ArchiveAnyLite ArrayDiff CPANDistnameInfo FileFindObject IOCapture JSONMaybeXS ModuleExtractUse ModulePluggable SetScalar SoftwareLicenseCCpack ];
     buildInputs = [ ExtUtilsMakeMakerCPANfile TestFailWarnings ];
     meta = {
       description = "Generate Kwalitee ratings for a distribution";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "http://cpants.cpanauthors.org";
     };
  };

  ModuleCPANfile = buildPerlPackage rec {
     name = "Module-CPANfile-1.1002";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Module-CPANfile-1.1002.tar.gz;
       sha256 = "1z9wsps70h7ypaxmwq8l8wp0dg4kqrxmaqgzbh2fq8jw9idw55dz";
     };
     meta = {
       description = "Parse cpanfile";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/miyagawa/cpanfile";
     };
  };

  ModuleCoreList = buildPerlPackage {
    name = "Module-CoreList-5.20180221";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Module-CoreList-5.20180221.tar.gz;
      sha256 = "12gad19gxvrv19938f6hs2i2fanq2s1dx3l1yy8nh0nvc2mwggzl";
    };
    meta = {
      homepage = http://dev.perl.org/;
      description = "What modules shipped with versions of perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleExtractUse = buildPerlModule rec {
     name = "Module-ExtractUse-0.342";
     src = fetchurl {
       url = mirror://cpan/authors/id/D/DO/DOMM/Module-ExtractUse-0.342.tar.gz;
       sha256 = "06z6iz4zc1rdm3w3zkddgv832rghlpvb4r494vdz65pphr65saax";
     };
     propagatedBuildInputs = [ ParseRecDescent PodStrip ];
     buildInputs = [ TestDeep TestNoWarnings ];
     meta = {
       description = "Find out what modules are used";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  ModuleFind = buildPerlPackage {
    name = "Module-Find-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.13.tar.gz;
      sha256 = "0s45y5lvd9k89g7lds83c0bn1p29c13hfsbrd7x64jfaf8h8cisa";
    };
    meta = {
      description = "Find and use installed modules in a (sub)category";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleImplementation = let version = "0.09"; in buildPerlPackage {
    name = "Module-Implementation-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Module-Implementation-${version}.tar.gz";
      sha256 = "0vfngw4dbryihqhi7g9ks360hyw8wnpy3hpkzyg0q4y2y091lpy1";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleRuntime TryTiny ];
    meta = {
      inherit version;
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Loads one of several alternate underlying implementations for a module";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ModuleInfo = buildPerlPackage rec {
    name = "Module-Info-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Module-Info-0.37.tar.gz;
      sha256 = "0j143hqxgdkdpj5qssppq72gjr0n73c4f7is6wgrrcchjx905a4f";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    meta = {
      description = "Information about Perl modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ BUtils ];
  };

  ModuleInstall = let version = "1.19"; in buildPerlPackage {
    name = "Module-Install-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Install-${version}.tar.gz";
      sha256 = "06q12cm97yh4p7qbm0a2p96996ii6ss59qy57z0f7f9svy6sflqs";
    };
    propagatedBuildInputs = [ FileRemove ModuleBuild ModuleScanDeps YAMLTiny ];
    meta = {
      description = "Standalone, extensible Perl module installer";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstallAuthorRequires = buildPerlPackage {
    name = "Module-Install-AuthorRequires-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Module-Install-AuthorRequires-0.02.tar.gz;
      sha256 = "1v2ciw75dj5y8lh10d1vrhwmjx266gpqavr8m21jlpblgm9j2qyc";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Declare author-only dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleInstallAuthorTests = buildPerlPackage {
    name = "Module-Install-AuthorTests-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Module-Install-AuthorTests-0.002.tar.gz;
      sha256 = "121dyggy38316xss06v1zkwx4b59gl7b00c5q99xyzimwqnp49a0";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Designate tests only run by module authors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleLoadConditional = buildPerlPackage rec {
     name = "Module-Load-Conditional-0.68";
     src = fetchurl {
       url = mirror://cpan/authors/id/B/BI/BINGOS/Module-Load-Conditional-0.68.tar.gz;
       sha256 = "1zcq0s7q9bvk9wdv9ijfyddh3b8ck4n3w87rcx31lbsav5fba9vn";
     };
     meta = {
       description = "Looking up module information / loading at runtime";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  ModuleManifest = buildPerlPackage {
    name = "Module-Manifest-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Module-Manifest-1.09.tar.gz;
      sha256 = "a395f80ff15ea0e66fd6c453844b6787ed4a875a3cd8df9f7e29280250bd539b";
    };
    buildInputs = [ TestException TestWarn ];
    propagatedBuildInputs = [ ParamsUtil ];
    meta = {
      description = "Parse and examine a Perl distribution MANIFEST file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleMetadata = buildPerlPackage rec {
    name = "Module-Metadata-1.000033";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Module-Metadata-1.000033.tar.gz;
      sha256 = "13pzydb22693l33rfx6drwbhjxj04q80ds4m2nn2sbmm95wwr5mw";
    };
  };

  ModulePath = buildPerlPackage rec {
    name = "Module-Path-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "b33179ce4dd73dfcde7d46808804b9ffbb11db0245fe455a7d001747562feaca";
    };
    buildInputs = [ DevelFindPerl ];
    meta = {
      homepage = https://github.com/neilbowers/Module-Path;
      description = "Get the full path to a locally installed module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggable = buildPerlPackage rec {
    name = "Module-Pluggable-5.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIMONW/${name}.tar.gz";
      sha256 = "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
    meta = {
      description = "Automatically give your module the ability to have plugins";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ AppFatPacker ];
  };

  ModulePluggableFast = buildPerlPackage {
    name = "Module-Pluggable-Fast-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Module-Pluggable-Fast-0.19.tar.gz;
      sha256 = "0pq758wlasmh77xyd2xh75m5b2x14s8pnsv63g5356gib1q5gj08";
    };
    propagatedBuildInputs = [ UNIVERSALrequire ];
  };

  ModuleRefresh = buildPerlPackage {
    name = "Module-Refresh-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Module-Refresh-0.17.tar.gz;
      sha256 = "6b30a6ceddc6512ab4490c16372ecf309a259f2ca147d622e478ac54e08511c3";
    };
    buildInputs = [ PathClass ];
    meta = {
      description = "Refresh %INC files when updated on disk";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntime = buildPerlModule {
    name = "Module-Runtime-0.016";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz;
      sha256 = "097hy2czwkxlppri32m599ph0xfvfsbf0a5y23a4fdc38v32wc38";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Runtime module handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntimeConflicts = buildPerlPackage {
    name = "Module-Runtime-Conflicts-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Module-Runtime-Conflicts-0.003.tar.gz;
      sha256 = "707cdc75038c70fe91779b888ac050f128565d3967ba96680e1b1c7cc9733875";
    };
    propagatedBuildInputs = [ DistCheckConflicts ];
    meta = {
      homepage = https://github.com/karenetheridge/Module-Runtime-Conflicts;
      description = "Provide information on conflicts for Module::Runtime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleScanDeps = let version = "1.24"; in buildPerlPackage {
    name = "Module-ScanDeps-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSCHUPP/Module-ScanDeps-${version}.tar.gz";
      sha256 = "0s6cj90ckhy351gql52ksh4ms1x8piv26iadl09fcpzkx7j0srw9";
    };
    buildInputs = [ TestRequires ];
    meta = {
      inherit version;
      description = "Recursively scan Perl code for dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleSignature = buildPerlPackage {
    name = "Module-Signature-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Module-Signature-0.81.tar.gz;
      sha256 = "7df547ceb8e45d40f75e481a868f389aaed5641c2cf4e133146ccea4b8facec6";
    };
    buildInputs = [ IPCRun ];
    meta = {
      description = "Module signature file manipulation";
      license = stdenv.lib.licenses.cc0;
    };
  };

  ModuleUtil = buildPerlModule {
    name = "Module-Util-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTLAW/Module-Util-1.09.tar.gz;
      sha256 = "6cfbcb6a45064446ec8aa0ee1a7dddc420b54469303344187aef84d2c7f3e2c6";
    };
    meta = {
      description = "Module name tools and transformations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleVersions = buildPerlPackage {
    name = "Module-Versions-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THW/Module-Versions-0.02.zip;
      sha256 = "0g7qs6vqg91xpwg1cdy91m3kh9m1zbkzyz1qsy453b572xdscf0d";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleVersionsReport = buildPerlPackage {
    name = "Module-Versions-Report-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Module-Versions-Report-1.06.tar.gz;
      sha256 = "a3261d0d84b17678d8c4fd55eb0f892f5144d81ca53ea9a38d75d1a00ad9796a";
    };
    meta = {
      description = "Report versions of all modules in memory";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  mod_perl2 = buildPerlPackage {
    name = "mod_perl-2.0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/mod_perl-2.0.10.tar.gz;
      sha256 = "0r1bhzwl5gr0202r6448943hjxsickzn55kdmb7dzad39vnq7kyi";
    };
    makeMakerFlags = "MP_AP_DESTDIR=$out";
    buildInputs = [ pkgs.apacheHttpd ];
    doCheck = false; # would try to start Apache HTTP server
    meta = {
      description = "Embed a Perl interpreter in the Apache HTTP server";
      license = stdenv.lib.licenses.asl20;
    };
  };
  Mojolicious = buildPerlPackage rec {
    name = "Mojolicious-7.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/${name}.tar.gz";
      sha256 = "25d8ab46fd7c340abcbbe740f690c197df6ff40a9c3dddf907629211bf3ad905";
    };
    meta = {
      homepage = http://mojolicious.org;
      description = "Real-time web framework";
      license = with stdenv.lib.licenses; [ artistic2 ];
    };
  };

  MojoIOLoopForkCall = buildPerlModule rec {
    name = "Mojo-IOLoop-ForkCall-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/${name}.tar.gz";
      sha256 = "a436b71c7d1450f79b9810f4f46e24f5ffe1e1428da473d4315673e08e4dec62";
    };
    propagatedBuildInputs = [ IOPipely Mojolicious ];
    meta = {
      description = "Run blocking functions asynchronously by forking";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MonitoringPlugin = buildPerlPackage rec {
    name = "Monitoring-Plugin-0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIERLEIN/${name}.tar.gz";
      sha256 = "030cw86j8712z8rn66k935gbilb5rcj3lnk4n53vh1b2phrszvjw";
    };
    propagatedBuildInputs = [ ClassAccessor ConfigTiny MathCalcUnits ParamsValidate ];
    meta = {
      description = ''
        A family of perl modules to streamline writing Naemon,
        Nagios, Icinga or Shinken (and compatible) plugins
      '';
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOPipely = buildPerlPackage rec {
    name = "IO-Pipely-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/${name}.tar.gz";
      sha256 = "e33b6cf5cb2b46ee308513f51e623987a50a89901e81bf19701dce35179f2e74";
    };
    meta = {
      homepage = http://search.cpan.org/dist/IO-Pipely/;
      description = "Portably create pipe() or pipe-like handles";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moo = buildPerlPackage rec {
    name = "Moo-2.003004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "f8bbb625f8e963eabe05cff9048fdd72bdd26777404ff2c40bc690f558be91e1";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers DevelGlobalDestruction ModuleRuntime RoleTiny SubQuote ];
    meta = {
      description = "Minimalist Object Orientation (with Moose compatibility)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  Moose = buildPerlPackage {
    name = "Moose-2.2010";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Moose-2.2010.tar.gz;
      sha256 = "af0905b69f18c27de1177c9bc7778ee495d4ec91be1f223e8ca8333af4de08c5";
    };
    buildInputs = [ CPANMetaCheck TestCleanNamespaces TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoadXS DevelGlobalDestruction DevelOverloadInfo DevelStackTrace EvalClosure ModuleRuntimeConflicts PackageDeprecationManager PackageStashXS ScalarListUtils SubExporter ];
    preConfigure = ''
      export LD=$CC
    '';
    meta = {
      homepage = http://moose.perl.org/;
      description = "A postmodern object system for Perl 5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.eelco ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooXHandlesVia = buildPerlPackage rec {
    name = "MooX-HandlesVia-0.001008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTP/${name}.tar.gz";
      sha256 = "b0946f23b3537763b8a96b8a83afcdaa64fce4b45235e98064845729acccfe8c";
    };
    buildInputs = [ MooXTypesMooseLike TestException TestFatal ];
    propagatedBuildInputs = [ DataPerl Moo ];
    meta = {
      description = "NativeTrait-like behavior for Moo";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXTypesMooseLike = buildPerlPackage rec {
    name = "MooX-Types-MooseLike-0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/${name}.tar.gz";
      sha256 = "1d6jg9x3p7gm2r0xmbcag374a44gf5pcga2swvxhlhzakfm80dqx";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    buildInputs = [ Moo TestFatal ];
  };

  MooXTypesMooseLikeNumeric = buildPerlPackage rec {
    name = "MooX-Types-MooseLike-Numeric-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/${name}.tar.gz";
      sha256 = "16adeb617b963d010179922c2e4e8762df77c75232e17320b459868c4970c44b";
    };
    buildInputs = [ Moo TestFatal ];
    propagatedBuildInputs = [ MooXTypesMooseLike ];
    meta = {
      description = "Moo types for numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseAutobox = buildPerlModule {
    name = "Moose-Autobox-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Moose-Autobox-0.16.tar.gz;
      sha256 = "0mbhd0p7gf6qdhaylldl0ahq59zghs0vd5n1iqcbfkj8ryj1sh4j";
    };
    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ ListMoreUtils Moose SyntaxKeywordJunction autobox namespaceautoclean ];
    meta = {
      description = "Autoboxed wrappers for Native Perl datatypes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXABC = buildPerlPackage {
    name = "MooseX-ABC-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-ABC-0.06.tar.gz;
      sha256 = "1sky0dpi22wrymmkjmqba4k966zn7vrbpx918wn2nmg48swyrgjf";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = https://metacpan.org/release/MooseX-ABC;
      description = "Abstract base classes for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXAliases = buildPerlPackage rec {
    name = "MooseX-Aliases-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0j07zqczjfmng3md6nkha7560i786d0cp3gdmrx49hr64jbhz1f4";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAppCmd = buildPerlModule rec {
    name = "MooseX-App-Cmd-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "2e3bbf7283a4bee72d91d26eb204436030992bbe55cbd35ec33a546f16f973ff";
    };
    buildInputs = [ ModuleBuildTiny MooseXConfigFromFile TestOutput YAML ];
    propagatedBuildInputs = [ AppCmd MooseXGetopt MooseXNonMoose ];
    meta = {
      homepage = https://github.com/moose/MooseX-App-Cmd;
      description = "Mashes up MooseX::Getopt and App::Cmd";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  MooX = buildPerlPackage rec {
    name = "MooX-0.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GE/GETTY/${name}.tar.gz";
      sha256 = "2ff91a656e78aae0aca42293829d7a7e5acb9bf22b0401635b2ab6c870de32d5";
    };
    propagatedBuildInputs = [ DataOptList ImportInto Moo ];
    meta = {
      homepage = https://github.com/Getty/p5-moox;
      description = "Using Moo and MooX:: packages the most lazy way";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXlate = buildPerlPackage {
    name = "MooX-late-0.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/MooX-late-0.015.tar.gz;
      sha256 = "175326af3076fa8698669f289fad1322724978cddaf40ea04e600fcd7f6afbbf";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moo TypeTiny ];
    meta = {
      homepage = https://metacpan.org/release/MooX-late;
      description = "Easily translate Moose code to Moo";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXSimpleConfig = buildPerlPackage {
    name = "MouseX-SimpleConfig-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJGARDNER/MouseX-SimpleConfig-0.11.tar.gz;
      sha256 = "257f384091d33d340373a6153947039c698dc449d1ef989335644fc3d2da0069";
    };
    propagatedBuildInputs = [ ConfigAny MouseXConfigFromFile ];
    meta = {
      description = "A Mouse role for setting attributes from a simple configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestUseAllModules = buildPerlPackage {
    name = "Test-UseAllModules-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISHIGAKI/Test-UseAllModules-0.17.tar.gz;
      sha256 = "a71f2fe8b96ab8bfc2760aa1d3135ea049a5b20dcb105457b769a1195c7a2509";
    };
    meta = {
      description = "Do use_ok() for all the MANIFESTed modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypesPathClass = buildPerlPackage {
    name = "MouseX-Types-Path-Class-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MASAKI/MouseX-Types-Path-Class-0.07.tar.gz;
      sha256 = "228d4b4f3f0ed9547278691d0b7c5fe53d90874a69df709a49703c6af87c09de";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ MouseXTypes PathClass ];
    meta = {
      description = "A Path::Class type library for Mouse";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypes = buildPerlPackage {
    name = "MouseX-Types-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/MouseX-Types-0.06.tar.gz;
      sha256 = "77288441fdadd15beeec9a0813ece8aec1542f1d8ceaaec14755b3f316fbcf8b";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyMoose ];
    meta = {
      description = "Organize your Mouse types in libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXConfigFromFile = buildPerlPackage {
    name = "MouseX-ConfigFromFile-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MASAKI/MouseX-ConfigFromFile-0.05.tar.gz;
      sha256 = "921b31cb13fc1f982a602f8e23815b7add23a224257e43790e287504ce879534";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ MouseXTypesPathClass ];
    meta = {
      description = "An abstract Mouse role for setting attributes from a configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXGetOpt = self.MouseXGetopt;

  MouseXGetopt = buildPerlModule rec {
    name = "MouseX-Getopt-0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "a6221043e7be3217ce56d2a6425a413d9cd28e2f52053995a6ceb118e8e963bc";
    };
    buildInputs = [ ModuleBuildTiny MouseXConfigFromFile MouseXSimpleConfig TestException TestWarn ];
    propagatedBuildInputs = [ GetoptLongDescriptive Mouse ];
    meta = {
      homepage = https://github.com/gfx/mousex-getopt;
      description = "A Mouse role for processing command line options";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MooseXAttributeChained = buildPerlModule rec {
    name = "MooseX-Attribute-Chained-1.0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOMHUKINS/MooseX-Attribute-Chained-1.0.3.tar.gz;
      sha256 = "0kjydmkxh8hpkbbmsgd5wrkhgq7w69lgfg6lx4s5g2xpqfkqmqz7";
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAttributeHelpers = buildPerlPackage {
    name = "MooseX-AttributeHelpers-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-AttributeHelpers-0.23.tar.gz;
      sha256 = "3f63f60d94d840a309d9137f78605e15f07c977fd15a4f4b55bd47b65ed52be1";
    };
    patches = [ ../development/perl-modules/MooseXAttributeHelpers-perl-5.20.patch ];
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Extend your attribute interfaces (deprecated)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXClone = buildPerlModule {
    name = "MooseX-Clone-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Clone-0.06.tar.gz;
      sha256 = "19wd74dihybnz1lbbsqn0clwxzb6y0aa0i25a8zhajz7p5fq5myb";
    };
    propagatedBuildInputs = [ DataVisitor HashUtilFieldHashCompat namespaceautoclean ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  MooseXConfigFromFile = buildPerlModule rec {
    name = "MooseX-ConfigFromFile-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "9ad343cd9f86d714be9b54b9c68a443d8acc6501b6ad6b15e9ca0130b2e96f08";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestFatal TestRequires TestWithoutModule ];
    propagatedBuildInputs = [ MooseXTypesPathTiny ];
    meta = {
      homepage = https://github.com/moose/MooseX-ConfigFromFile;
      description = "An abstract Moose role for setting attributes from a configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  MooseXDaemonize = buildPerlModule rec {
    name = "MooseX-Daemonize-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "111f391221d00f8b09cdcc6c806ab114324cf7f529d12f627fb97d054da42225";
    };
    buildInputs = [ DevelCheckOS ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ MooseXGetopt MooseXTypesPathClass ];
    meta = {
      homepage = https://github.com/moose/MooseX-Daemonize;
      description = "Role for daemonizing your Moose based application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXEmulateClassAccessorFast = buildPerlPackage {
    name = "MooseX-Emulate-Class-Accessor-Fast-0.00903";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/MooseX-Emulate-Class-Accessor-Fast-0.00903.tar.gz;
      sha256 = "1lkn1h4sxr1483jicsgsgzclbfw63g2i2c3m4v4j9ar75yrb0kh8";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose namespaceclean ];
    meta = {
      description = "Emulate Class::Accessor::Fast behavior using Moose attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXGetopt = buildPerlModule rec {
    name = "MooseX-Getopt-0.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "de18f8ea0a5650cbbdebecb8f4c028f5f951fc5698332f7b8e20c7874902c259";
    };
    buildInputs = [ ModuleBuildTiny MooseXStrictConstructor PathTiny TestDeep TestFatal TestRequires TestTrap TestWarnings ];
    propagatedBuildInputs = [ GetoptLongDescriptive MooseXRoleParameterized ];
    meta = {
      homepage = https://github.com/moose/MooseX-Getopt;
      description = "A Moose role for processing command line options";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MooseXHasOptions = buildPerlPackage {
    name = "MooseX-Has-Options-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PS/PSHANGOV/MooseX-Has-Options-0.003.tar.gz;
      sha256 = "07c21cf8ed500b272020ff8da19f194728bb414e0012a2f0cc54ef2ef6222a68";
    };
    buildInputs = [ Moose TestDeep TestDifferences TestException TestMost TestWarn namespaceautoclean ];
    propagatedBuildInputs = [ ClassLoad ListMoreUtils StringRewritePrefix ];
    meta = {
      homepage = https://github.com/pshangov/moosex-has-options;
      description = "Succinct options for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXHasSugar = buildPerlPackage {
    name = "MooseX-Has-Sugar-1.000006";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/MooseX-Has-Sugar-1.000006.tar.gz;
      sha256 = "efeed3ddb3a8ea18f416d485f3c2b0427145d267e63368c651d488eaa8c28d09";
    };
    buildInputs = [ TestFatal namespaceclean ];
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      homepage = https://github.com/kentfredric/MooseX-Has-Sugar;
      description = "Sugar Syntax for moose 'has' fields";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXLazyRequire = buildPerlModule {
    name = "MooseX-LazyRequire-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-LazyRequire-0.11.tar.gz;
      sha256 = "ef620c1e019daf9cf3f23a943d25a94c91e93ab312bcd63be2e9740ec0b94288";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ Moose aliased namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-lazyrequire;
      description = "Required attributes which fail only when trying to use them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXMarkAsMethods = buildPerlPackage {
    name = "MooseX-MarkAsMethods-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSRCHBOY/MooseX-MarkAsMethods-0.15.tar.gz;
      sha256 = "1y3yxwcjjajm66pvca54cv9fax7a6dy36xqr92x7vzyhfqrw3v69";
    };
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/MooseX-MarkAsMethods/;
      description = "Mark overload code symbols as methods";
      license = stdenv.lib.licenses.lgpl21;
    };
  };

  MooseXMethodAttributes = buildPerlPackage {
    name = "MooseX-MethodAttributes-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-MethodAttributes-0.31.tar.gz;
      sha256 = "1whd10w7bm3dwaj7gpgw40bci9vvb2zmxs4349ifji91hvinwqck";
    };
    buildInputs = [ MooseXRoleParameterized TestFatal TestRequires ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-methodattributes;
      description = "Code attribute introspection";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXNonMoose = buildPerlPackage {
    name = "MooseX-NonMoose-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-NonMoose-0.26.tar.gz;
      sha256 = "0zdaiphc45s5xj0ax5mkijf5d8v6w6yccb3zplgj6f30y7n55gnb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
    meta = {
      description = "Easy subclassing of non-Moose classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXOneArgNew = buildPerlPackage {
    name = "MooseX-OneArgNew-0.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-OneArgNew-0.005.tar.gz;
      sha256 = "0gqhqdkwsnxmni0xv43iplplgp6g55khdwc5117j9i569r3wykvy";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized ];
    meta = {
      homepage = https://github.com/rjbs/moosex-oneargnew;
      description = "Teach ->new to accept single, non-hashref arguments";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRelatedClassRoles = buildPerlPackage rec {
    name = "MooseX-RelatedClassRoles-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HD/HDP/MooseX-RelatedClassRoles-0.004.tar.gz;
      sha256 = "17vynkf6m5d039qkr4in1c9lflr8hnwp1fgzdwhj4q6jglipmnrh";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized ];
  };

  MooseXParamsValidate = buildPerlPackage {
    name = "MooseX-Params-Validate-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-Params-Validate-0.21.tar.gz;
      sha256 = "1n9ry6gnskkp9ir6s7d5jirn3mh14ydgpmwqz6wcp6d9md358ac8";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DevelCaller Moose ParamsValidate ];
    meta = {
      description = "An extension of Params::Validate using Moose's types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleParameterized = buildPerlModule {
    name = "MooseX-Role-Parameterized-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-Parameterized-1.10.tar.gz;
      sha256 = "0plx25n80mv9qwhix52z79md0qil616nbcryk2f4216kghpw2ij8";
    };
    buildInputs = [ CPANMetaCheck ModuleBuildTiny MooseXRoleWithOverloading TestFatal TestRequires ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      homepage = https://github.com/sartak/MooseX-Role-Parameterized/tree;
      description = "Roles with composition parameters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleWithOverloading = buildPerlPackage rec {
    name = "MooseX-Role-WithOverloading-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0rb8k0dp1a55bm2pr6r0vsi5msvjl1dslfidxp1gj80j7zbrbc4j";
    };
    propagatedBuildInputs = [ Moose aliased namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/MooseX-Role-WithOverloading;
      description = "Roles which support overloading";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRunnable = buildPerlModule rec {
    name = "MooseX-Runnable-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "40d8fd1b5524ae965965a1f144d7a0a0c850594c524402b2319b24d5c4af1199";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple13 TestTableDriven ];
    propagatedBuildInputs = [ ListSomeUtils MooseXTypesPathTiny ];
    meta = {
      homepage = https://github.com/moose/MooseX-Runnable;
      description = "Tag a class as a runnable application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  MooseXSemiAffordanceAccessor = buildPerlPackage rec {
    name = "MooseX-SemiAffordanceAccessor-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-SemiAffordanceAccessor-0.10.tar.gz;
      sha256 = "1mdil9ckgmgr78z59p8wfa35ixn5855ndzx14y01dvfxpiv5gf55";
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSetOnce = buildPerlPackage rec {
    name = "MooseX-SetOnce-0.200002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-SetOnce-0.200002.tar.gz;
      sha256 = "0ndnl8dj7nh8lvckl6r3jw31d0dmq30qf2pqkgcz0lykzjvhdvfb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSingleton = buildPerlModule rec {
    name = "MooseX-Singleton-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Singleton-0.30.tar.gz;
      sha256 = "0hb5s1chsgbx2nlb0f112mdh2v1zwww8f4i3gvfvcghx3grv5135";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestRequires TestWarnings ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXStrictConstructor = buildPerlPackage {
    name = "MooseX-StrictConstructor-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-StrictConstructor-0.21.tar.gz;
      sha256 = "c72a5ae9583706ccdec71d401dcb3054013a7536b750df1436613d858ea2920d";
    };
    buildInputs = [ Moo TestFatal TestNeeds ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Make your object constructors blow up on unknown attributes";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  MooseXTraits = buildPerlModule rec {
    name = "MooseX-Traits-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "74afe0c4faf4e3b97c57f289437caa60becca34cd5821f489dd4cc9da4fbe29a";
    };
    buildInputs = [ ModuleBuildTiny MooseXRoleParameterized TestFatal TestRequires TestSimple13 ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Traits;
      description = "Automatically apply roles at object creation time";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTraitsPluggable = buildPerlPackage rec {
    name = "MooseX-Traits-Pluggable-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1jjqmcidy4kdgp5yffqqwxrsab62mbhbpvnzdy1rpwnb1savg5mb";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ListMoreUtils Moose namespaceautoclean ];
  };

  MooseXTypes = buildPerlModule rec {
    name = "MooseX-Types-0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "9cd87b3492cbf0be9d2df9317b2adf9fc30663770e69906654bea3f41b17cb08";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestRequires ];
    propagatedBuildInputs = [ CarpClan Moose SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types;
      description = "Organise your Moose types in libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MooseXTypesCommon = buildPerlModule rec {
    name = "MooseX-Types-Common-0.001014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "ef93718b6d2f240d50b5c3acb1a74b4c2a191869651470001a82be1f35d0ef0f";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestWarnings ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-Common;
      description = "A library of commonly used type constraints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesDateTime = buildPerlModule rec {
    name = "MooseX-Types-DateTime-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "b89fa26636f6a17eaa3868b4514340472b68bbdc2161a1d79a22a1bf5b1d39c6";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple13 ];
    propagatedBuildInputs = [ DateTime MooseXTypes ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-DateTime;
      description = "DateTime related constraints and coercions for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesDateTimeMoreCoercions = buildPerlPackage rec {
    name = "MooseX-Types-DateTime-MoreCoercions-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "21bb3a597719888edb6ceaa132418d5cf92ecb92a50cce37b94259a55e0e3796";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple ];
    propagatedBuildInputs = [ DateTime DateTimeXEasy Moose MooseXTypes MooseXTypesDateTime TimeDurationParse namespaceclean self."if" ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-DateTime-MoreCoercions;
      description = "Extensions to MooseX::Types::DateTime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesLoadableClass = buildPerlModule {
    name = "MooseX-Types-LoadableClass-0.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-LoadableClass-0.015.tar.gz;
      sha256 = "e037d3778253dcf92946435715bada0e6449c0a2808fa3ff32a965064d5a3bf4";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
      homepage = https://github.com/moose/MooseX-Types-LoadableClass;
      description = "ClassName type constraint with coercion to load the class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesPathClass = buildPerlModule {
    name = "MooseX-Types-Path-Class-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Class-0.09.tar.gz;
      sha256 = "0zpgwzxj6d9k2lbg6v6zd1bcbzjz2h336rm816krbblq6ssvm177";
    };
    propagatedBuildInputs = [ MooseXTypes PathClass ];
    meta = {
      description = "A Path::Class type library for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ ModuleBuildTiny TestNeeds ];
  };

  MooseXTypesPathTiny = buildPerlModule {
    name = "MooseX-Types-Path-Tiny-0.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Tiny-0.012.tar.gz;
      sha256 = "19eede02dd654e70f73e34cd7af0063765173bcaefeeff1bdbe21318ecfd9158";
    };
    buildInputs = [ Filepushd ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ MooseXGetopt MooseXTypesStringlike PathTiny ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-types-path-tiny;
      description = "Path::Tiny types and coercions for Moose";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesPerl = buildPerlPackage {
    name = "MooseX-Types-Perl-0.101343";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-Types-Perl-0.101343.tar.gz;
      sha256 = "0nijy676q27bvjb8swxrb1j4lq2xq8jbqkaxs1l9q81k7jpvx17h";
    };
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      description = "Moose types that check against Perl syntax";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesStringlike = buildPerlPackage {
    name = "MooseX-Types-Stringlike-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/MooseX-Types-Stringlike-0.003.tar.gz;
      sha256 = "06fgamdiz0n7cgghb8ycjd5mcidj8w769zs2gws6z6jjbkn4kqrf";
    };
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      homepage = https://github.com/dagolden/moosex-types-stringlike;
      description = "Moose type constraints for strings or string-like objects";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesStructured = buildPerlModule {
    name = "MooseX-Types-Structured-0.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Structured-0.36.tar.gz;
      sha256 = "0mrxc00sid7526c6brrnjr6288468sszic3wazij71v3z59bdka3";
    };
    buildInputs = [ DateTime ModuleBuildTiny MooseXTypesDateTime TestFatal TestNeeds ];
    propagatedBuildInputs = [ DevelPartialDump MooseXTypes ];
    meta = {
      homepage = https://metacpan.org/release/MooseX-Types-Structured;
      description = "MooseX::Types::Structured - Structured Type Constraints for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesURI = buildPerlModule rec {
    name = "MooseX-Types-URI-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "d310d20fa361fe2dff758236df87949cc7bf98e5cf3a7c79115365eccde6ccc1";
    };
    buildInputs = [ ModuleBuildTiny TestSimple13 ];
    propagatedBuildInputs = [ MooseXTypesPathClass URIFromHash ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-URI;
      description = "URI related types and coercions for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  Mouse = buildPerlModule rec {
    name = "Mouse-2.5.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SK/SKAJI/Mouse-v2.5.2.tar.gz;
      sha256 = "17nr2432cfw7q2qxiz8pv7lw91dszgvn4ln77gpv2m77kjh5ilbs";
    };
    buildInputs = [ DevelPPPort ModuleBuildXSUtil TestException TestFatal TestLeakTrace TestOutput TestRequires TryTiny self.version ];
    NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isi686 "-fno-stack-protector";
    hardeningDisable = stdenv.lib.optional stdenv.isi686 "stackprotector";
  };

  MouseXNativeTraits = buildPerlPackage rec {
    name = "MouseX-NativeTraits-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "0pnbchkxfz9fwa8sniyjqp0mz75b3k2fafq9r09znbbh51dbz9gq";
    };
    buildInputs = [ AnyMoose TestFatal ];
    propagatedBuildInputs = [ Mouse ];
    meta = {
      description = "Extend attribute interfaces for Mouse";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MozillaCA = buildPerlPackage rec {
    name = "Mozilla-CA-20180117";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABH/${name}.tar.gz";
      sha256 = "f2cc9fbe119f756313f321e0d9f1fac0859f8f154ac9d75b1a264c1afdf4e406";
    };
    meta = {
      description = "Mozilla's CA cert bundle in PEM format";
      license = stdenv.lib.licenses.mpl20;
    };
  };

  MozillaLdap = buildPerlPackage rec {
    name = "Mozilla-Ldap-${version}";
    version = "1.5.3";
    USE_OPENLDAP = 1;
    LDAPSDKDIR = pkgs.openldap.dev;
    LDAPSDKLIBDIR = "${pkgs.openldap.out}/lib";
    src = fetchurl {
      url = "https://ftp.mozilla.org/pub/directory/perldap/releases/${version}/src/perl-mozldap-${version}.tar.gz";
      sha256 = "0s0albdw0zvg3w37s7is7gddr4mqwicjxxsy400n1p96l7ipnw4x";
    };
    meta = {
      description = "Mozilla's ldap client library";
      license = with stdenv.lib.licenses; [ mpl20 lgpl21Plus gpl2Plus ];
    };
  };

  MROCompat = buildPerlPackage {
    name = "MRO-Compat-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/MRO-Compat-0.13.tar.gz;
      sha256 = "1y547lr6zccf7919vx01v22zsajy528psanhg5aqschrrin3nb4a";
    };
    meta = {
      description = "Mro::* interface compatibility for Perls < 5.9.5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MusicBrainzDiscID = buildPerlModule rec {
    name = "MusicBrainz-DiscID-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NJ/NJH/${name}.tar.gz";
      sha256 = "0fjph2q3yp0aa87gckv3391s47m13wbyylj7jb7vqx7hv0pzj0jh";
    };
    # Build.PL in this package uses which to find pkg-config -- make it use path instead
    patchPhase = ''sed -ie 's/`which pkg-config`/"pkg-config"/' Build.PL'';
    doCheck = false; # The main test performs network access
    nativeBuildInputs = [ pkgs.pkgconfig ];
    #buildInputs = [ TestMore TestPod ];
    propagatedBuildInputs = [ pkgs.libdiscid ];
  };

  MusicBrainz = buildPerlModule rec {
    name = "WebService-MusicBrainz-1.0.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BF/BFAIST/${name}.tar.gz";
      sha256 = "182z3xjajk6s7k5xm3kssjy3hqx2qbnq4f8864hma098ryy2ph3a";
    };
    propagatedBuildInputs = [ Mojolicious ];
    doCheck = false; # Test performs network access.
  };

  namespaceautoclean = buildPerlPackage rec {
    name = "namespace-autoclean-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "cd410a1681add521a28805da2e138d44f0d542407b50999252a147e553c26c39";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ SubIdentify namespaceclean ];
    meta = {
      homepage = https://github.com/moose/namespace-autoclean;
      description = "Keep imports out of your namespace";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  namespaceclean = buildPerlPackage rec {
    name = "namespace-clean-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      homepage = http://search.cpan.org/dist/namespace-clean;
      description = "Keep imports and functions out of your namespace";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  # Deprecated.
  NamespaceAutoclean = self.namespaceautoclean;

  # Deprecated.
  NamespaceClean = self.namespaceclean;

  NetIdent = buildPerlPackage rec {
    name = "Net-Ident-1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "5f5f1142185a67b87406a3fb31f221564f61838a70ef4c07284a66c55e82ad05";
    };
    meta = {
      homepage = http://wiki.github.com/toddr/Net-Ident/;
      description = "Lookup the username on the remote end of a TCP/IP connection";
      license = stdenv.lib.licenses.mit;
    };
  };

  NetAddrIP = buildPerlPackage rec {
    name = "NetAddr-IP-4.079";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKER/${name}.tar.gz";
      sha256 = "ec5a82dfb7028bcd28bb3d569f95d87dd4166cc19867f2184ed3a59f6d6ca0e7";
    };
    meta = {
      description = "Manages IPv4 and IPv6 addresses and subnets";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
    doCheck = false;
  };

  NetAmazonAWSSign = buildPerlPackage {
    name = "Net-Amazon-AWSSign-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NA/NATON/Net-Amazon-AWSSign-0.12.tar.gz;
      sha256 = "0gpdjz5095hd3y1xhnbv45m6q2shw0c9r7spj1jvb8hy7dmhq10x";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Perl extension to create signatures for AWS requests";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetAmazonEC2 = buildPerlPackage rec {
    name = "Net-Amazon-EC2-0.14-stanaka-bc66577e13";
    src = fetchFromGitHub {
      owner = "stanaka";
      repo = "net-amazon-ec2";
      rev = "bc66577e1312e828e252937d95f9f5f637af6a0b";
      sha256 = "0x7kac27vp60a0qmvf6zpr2ds7245hncpn2y1qbacmdp092x212k";
    };
    buildInputs = [ pkgs.unzip ];
    patches =
      [ # In DescribeInstance requests, say "InstanceId.1" instead of
        # "InstanceId", as required by the Amazon spec.  EC2 tolerates
        # "InstanceId", but Nova doesn't.
        ../development/perl-modules/net-amazon-ec2-nova-compat.patch
        # Support DescribeInstancesV6.
        ../development/perl-modules/net-amazon-ec2-ipv6.patch
      ];
    propagatedBuildInputs =
      [ DigestHMAC LWP LWPProtocolHttps Moose URI ParamsValidate XMLSimple ];
    doCheck = false; # wants to create actual EC2 instances (for $$$)
  };

  NetAmazonMechanicalTurk = buildPerlModule rec {
    name = "Net-Amazon-MechanicalTurk-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MT/MTURK/${name}.tar.gz";
      sha256 = "13hgggfchhp4m3l2rn3d1v6g6ccwmwf9xiyc9izv5570930mw2cd";
    };
    patches =
      [ ../development/perl-modules/net-amazon-mechanicalturk.patch ];
    propagatedBuildInputs = [ DigestHMAC LWPProtocolHttps XMLParser ];
    doCheck = false;
  };

  NetAmazonS3 = buildPerlPackage rec {
    name = "Net-Amazon-S3-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCONOVER/${name}.tar.gz";
      sha256 = "efb73dd9a96078742cb8564f7b58f5abe5168277342c7634961d63b4ef278848";
    };
    buildInputs = [ LWP TestException ];
    propagatedBuildInputs = [ DataStreamBulk DateTimeFormatHTTP DigestHMAC DigestMD5File FileFindRule HTTPDate HTTPMessage LWPUserAgentDetermined MIMETypes Moose MooseXStrictConstructor MooseXTypesDateTimeMoreCoercions PathClass RegexpCommon TermEncoding TermProgressBarSimple URI VMEC2SecurityCredentialCache XMLLibXML ];
    meta = {
      homepage = http://search.cpan.org/dist/Net-Amazon-S3/;
      description = "Use the Amazon S3 - Simple Storage Service";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAmazonS3Policy = buildPerlModule {
    name = "Net-Amazon-S3-Policy-0.1.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/POLETTIX/Net-Amazon-S3-Policy-0.1.6.tar.gz;
      sha256 = "056rhq6vsdpwi2grbmxj8341qjrz0258civpnhs78j37129nxcfj";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Manage Amazon S3 policies for HTTP POST forms";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetAMQP = buildPerlModule {
    name = "Net-AMQP-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHIPS/Net-AMQP-0.06.tar.gz;
      sha256 = "0b2ba7de2cd7ddd5fe102a2e2ae7aeba21eaab1078bf3bfd3c5a722937256380";
    };
    doCheck = false; # failures on 32bit
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable XMLLibXML ];
    meta = {
      description = "Advanced Message Queue Protocol (de)serialization and representation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetCIDR = buildPerlPackage {
    name = "Net-CIDR-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSAM/Net-CIDR-0.18.tar.gz;
      sha256 = "c3df7ea8d42b2d8ec328c187329c5f8c4db6a2470873f61e3d0dd91430ef1427";
    };
    meta = {
      description = "Manipulate IPv4/IPv6 netblocks in CIDR notation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  NetCIDRLite = buildPerlPackage rec {
    name = "Net-CIDR-Lite-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOUGW/${name}.tar.gz";
      sha256 = "cfa125e8a2aef9259bc3a44e07cbdfb7894b64d22e7c0cee92aee2f5c7915093";
    };
    meta = {
      description = "Perl extension for merging IPv4 or IPv6 CIDR addresses";
      license = "unknown";
    };
  };

  NetCoverArtArchive = buildPerlPackage {
    name = "Net-CoverArtArchive-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Net-CoverArtArchive-1.02.tar.gz;
      sha256 = "1lfx8lrjgb3s11fcm243jp5sghngd9svkgmg7xmssmj34q4f49ap";
    };
    buildInputs = [ FileFindRule ];
    propagatedBuildInputs = [ JSONAny LWP Moose namespaceautoclean ];
    meta = {
      homepage = https://github.com/metabrainz/CoverArtArchive;
      description = "Query the coverartarchive.org";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetDBus = buildPerlPackage rec {
    name = "Net-DBus-1.1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBERR/${name}.tar.gz";
      sha256 = "8391696db9e96c374b72984c0bad9c7d1c9f3b4efe68f9ddf429a77548e0e269";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ pkgs.pkgconfig pkgs.dbus XMLTwig ];
    meta = {
      homepage = http://www.freedesktop.org/wiki/Software/dbus;
      description = "Extension for the DBus bindings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDNS = buildPerlPackage rec {
    name = "Net-DNS-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NL/NLNETLABS/${name}.tar.gz";
      sha256 = "1ad46ba6438b846a94b4f50d53ecfda55f504a17e11b94effb087ff9329e61d0";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    makeMakerFlags = "--noonline-tests";
    meta = {
      description = "Perl Interface to the Domain Name System";
      license = stdenv.lib.licenses.mit;
    };
  };

  NetDNSResolverMock = buildPerlPackage rec {
     name = "Net-DNS-Resolver-Mock-1.20171219";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MB/MBRADSHAW/Net-DNS-Resolver-Mock-1.20171219.tar.gz;
       sha256 = "0m3rxpkv1b9121srvbqkrgzg4m8mnydiydqv34in1i1ixwrl6jn9";
     };
     propagatedBuildInputs = [ NetDNS ];
     meta = {
       description = "Mock a DNS Resolver object for testing";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  NetDomainTLD = buildPerlPackage rec {
    name = "Net-Domain-TLD-1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXP/${name}.tar.gz";
      sha256 = "4c37f811184d68ac4179d48c10ea31922dd5fca2c1bffcdcd95c5a2a3b4002ee";
    };
    meta = {
      description = "Work with TLD names";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  NetHTTP = buildPerlPackage rec {
    name = "Net-HTTP-6.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/${name}.tar.gz";
      sha256 = "1e8624b1618dc6f7f605f5545643ebb9b833930f4d7485d4124aa2f2f26d1611";
    };
    propagatedBuildInputs = [ URI ];
    __darwinAllowLocalNetworking = true;
    meta = {
      homepage = https://github.com/libwww-perl/Net-HTTP;
      description = "Low-level HTTP connection (client)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  NetIDNEncode = buildPerlModule {
    name = "Net-IDN-Encode-2.400";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFAERBER/Net-IDN-Encode-2.400.tar.gz;
      sha256 = "0a9knav5f9kjldrkxx1k47ivd3p23zkmi8aqgyhnxidhgasz1dlq";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Internationalizing Domain Names in Applications (IDNA)";
    };
  };

  NetIMAPClient = buildPerlPackage rec {
    name = "Net-IMAP-Client-0.9505";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GANGLION/${name}.tar.gz";
      sha256 = "d3f6a608b85e09a8080a67a9933837aae6f2cd0e8ee39df3380123dc5e3de912";
    };
    propagatedBuildInputs = [ IOSocketSSL ListMoreUtils ];
    meta = {
      description = "Not so simple IMAP client library";
    };
  };

  NetIP = buildPerlPackage {
    name = "Net-IP-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.26.tar.gz;
      sha256 = "0ffn2xqqbkfi7v303sp5dwgbv36jah3vg8r4nxhxfiv60vric3q4";
    };
    meta = {
      description = "Perl extension for manipulating IPv4/IPv6 addresses";
    };
  };

  NetLDAP = perlldap;

  NetOAuth = buildPerlModule {
    name = "Net-OAuth-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KG/KGRENNAN/Net-OAuth-0.28.tar.gz;
      sha256 = "0k4h4a5048h7qgyx25ih64x0l4airx8a6d9gjq08wmxcl2fk3z3v";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable DigestHMAC DigestSHA1 LWP ];
    meta = {
      description = "An implementation of the OAuth protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetPatricia = buildPerlPackage rec {
    name = "Net-Patricia-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRUBER/${name}.tar.gz";
      sha256 = "70835a926e1c5a8d0324c72fffee82eeb7ec6c141dee04fd446820b64f71c552";
    };
    propagatedBuildInputs = [ NetCIDRLite Socket6 ];
    meta = {
      license = "unknown";
    };
  };

  NetPing = buildPerlPackage {
    name = "Net-Ping-2.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Net-Ping-2.66.tar.gz;
      sha256 = "a477b29e543695343513e65f3aff885a353ecebb612741e79f0bad5622e4b9e4";
    };
    meta = {
      description = "Check a remote host for reachability";
    };
  };

  NetDNSResolverProgrammable = buildPerlPackage rec {
    name = "Net-DNS-Resolver-Programmable-0.009";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BIGPRESH/Net-DNS-Resolver-Programmable-0.009.tar.gz;
      sha256 = "8080a2ab776629585911af1179bdb7c4dc2bebfd4b5efd77b11d1dac62454bf8";
    };
    propagatedBuildInputs = [ NetDNS ];
    meta = {
      description = "Programmable DNS resolver class for offline emulation of DNS";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  NetServer = buildPerlPackage {
    name = "Net-Server-2.009";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RH/RHANDOM/Net-Server-2.009.tar.gz;
      sha256 = "0gw1k9gcw7habbkxvsfa2gz34brlbwcidk6khgsf1qjm0dbccrw2";
    };
    doCheck = false; # seems to hang waiting for connections
    meta = {
      description = "Extensible, general Perl server engine";
    };
  };

  NetSMTP = libnet;

  NetSMTPSSL = buildPerlPackage {
    name = "Net-SMTP-SSL-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Net-SMTP-SSL-1.04.tar.gz;
      sha256 = "001a6dcfahf7kkyirqkc8jd4fh4fkal7n7vm9c4dblqrvmdc8abv";
    };
    propagatedBuildInputs = [ IOSocketSSL ];
  };

  NetSMTPTLS = buildPerlPackage {
    name = "Net-SMTP-TLS-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AW/AWESTHOLM/Net-SMTP-TLS-0.12.tar.gz;
      sha256 = "19g48kabj22v66jbf69q78xplhi7r1y2kdbddfwh4xy3g9k75rzg";
    };
    propagatedBuildInputs = [ DigestHMAC IOSocketSSL ];
  };

  NetSMTPTLSButMaintained = buildPerlPackage {
    name = "Net-SMTP-TLS-ButMaintained-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FA/FAYLAND/Net-SMTP-TLS-ButMaintained-0.24.tar.gz;
      sha256 = "0vi5cv7f9i96hgp3q3jpxzn1ysn802kh5xc304f8b7apf67w15bb";
    };
    propagatedBuildInputs = [ DigestHMAC IOSocketSSL ];
  };

  NetSNMP = buildPerlModule rec {
    name = "Net-SNMP-6.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DT/DTOWN/Net-SNMP-v6.0.1.tar.gz";
      sha256 = "0hdpn1cw52x8cw24m9ayzpf4rwarm0khygn1sv3wvwxkrg0pphql";
    };
    doCheck = false; # The test suite fails, see https://rt.cpan.org/Public/Bug/Display.html?id=85799
  };

  NetSSLeay = buildPerlPackage rec {
    name = "Net-SSLeay-1.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/${name}.tar.gz";
      sha256 = "1j5h4ycm8538397l204d2d5fkm9595aj174pj7bkpbhwzfwqi0cx";
    };
    buildInputs = [ pkgs.openssl ];
    doCheck = false; # Test performs network access.
    preConfigure = ''
      mkdir openssl
      ln -s ${pkgs.openssl.out}/lib openssl
      ln -s ${pkgs.openssl.bin}/bin openssl
      ln -s ${pkgs.openssl.dev}/include openssl
      export OPENSSL_PREFIX=$(realpath openssl)
    '';
    meta = {
      description = "Perl extension for using OpenSSL";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  NetStatsd = buildPerlPackage {
    name = "Net-Statsd-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COSIMO/Net-Statsd-0.12.tar.gz;
      sha256 = "63e453603da165bc6d1c4ca0b55eda3d2204f040c59304a47782c5aa7886565c";
    };
    meta = {
      description = "Sends statistics to the stats daemon over UDP";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetTelnet = buildPerlPackage {
    name = "Net-Telnet-3.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JR/JROGERS/Net-Telnet-3.04.tar.gz;
      sha256 = "e64d567a4e16295ecba949368e7a6b8b5ae2a16b3ad682121d9b007dc5d2a37a";
    };
    meta = {
      description = "Interact with TELNET port or other TCP ports";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetTwitterLite = buildPerlModule {
    name = "Net-Twitter-Lite-0.12008";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.12008.tar.gz;
      sha256 = "13j69a6nqq8mh5b4qk021db55rkfnk1ppwk0rpg68b1z58gvxsmj";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ JSON LWPProtocolHttps ];
    doCheck = false;
    meta = {
      homepage = https://github.com/semifor/Net-Twitter-Lite;
      description = "A perl interface to the Twitter API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberCompare = buildPerlPackage rec {
    name = "Number-Compare-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "09q8i0mxvr7q9vajwlgawsi0hlpc119gnhq4hc933d03x0vkfac3";
    };
  };

  NumberFormat = buildPerlPackage rec {
    name = "Number-Format-1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WRW/${name}.tar.gz";
      sha256 = "82d659cb16461764fd44d11a9ce9e6a4f5e8767dc1069eb03467c6e55de257f3";
    };
    meta = {
      description = "Perl extension for formatting numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberMisc = buildPerlModule rec {
     name = "Number-Misc-1.2";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MI/MIKO/Number-Misc-1.2.tar.gz;
       sha256 = "1n4ivj4ydplanwbxn3jbsfyfcl91ngn2d0addzqrq1hac26bdfbp";
     };
     meta = {
       description = "Number::Misc - handy utilities for numbers";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  NTLM = buildPerlPackage rec {
    name = "NTLM-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NB/NBEBOUT/${name}.tar.gz";
      sha256 = "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.pSub ];
    };
  };

  ObjectAccessor = buildPerlPackage {
    name = "Object-Accessor-0.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Object-Accessor-0.48.tar.gz;
      sha256 = "76cb824a27b6b4e560409fcf6fd5b3bfbbd38b72f1f3d37ed0b54bd9c0baeade";
    };
    meta = {
      description = "Per object accessors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectInsideOut = buildPerlModule {
    name = "Object-InsideOut-4.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Object-InsideOut-4.04.tar.gz;
      sha256 = "01pncagr3k7yj0rn22xap08s17nw2p2ffcg6j00gs9fg4jv9pfmj";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    meta = {
      description = "Comprehensive inside-out object support module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.07.tar.gz;
      sha256 = "0c8l7195bjvx0v6zmkgdnxvwg7yj2zq8hi7xd25a3iikd12dc4f6";
    };
    meta = {
      description = "Generate cryptographic signatures for objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  # For backwards compatibility. Please use OLEStorage_Lite instead.
  OLEStorageLight = OLEStorage_Lite;

  OLEStorage_Lite = buildPerlPackage rec {
    name = "OLE-Storage_Lite-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "179cxwqxb0f9dpx8954nvwjmggxxi5ndnang41yav1dx6mf0abp7";
    };
    meta = {
      description = "Read and write OLE storage files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Opcodes = buildPerlPackage {
    name = "Opcodes-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Opcodes-0.14.tar.gz;
      sha256 = "7f7365447e4d1c5b87b43091448f0488e67c9f036b26c022a5409cd73d343893";
    };
    meta = {
      description = "More Opcodes information from opnames.h and opcode.h";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  OpenGL = buildPerlPackage rec {
    name = "OpenGL-0.70";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHM/${name}.tar.gz";
      sha256 = "1q3lz168q081iwl9jg21fbzhp9la79gav9mv6nmh2jab83s2l3mj";
    };

    # FIXME: try with libGL + libGLU instead of libGLU_combined
    buildInputs = with pkgs; [ pkgs.libGLU_combined pkgs.libGLU pkgs.freeglut pkgs.xorg.libX11 pkgs.xorg.libXi pkgs.xorg.libXmu pkgs.xorg.libXext pkgs.xdummy ];

    patches = [ ../development/perl-modules/perl-opengl.patch ];

    configurePhase = ''
      substituteInPlace Makefile.PL \
        --replace "@@libpaths@@" '${stdenv.lib.concatStringsSep "\n" (map (f: "-L${f}/lib") buildInputs)}'

      cp -v ${../development/perl-modules/perl-opengl-gl-extensions.txt} utils/glversion.txt

      perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags
    '';

    doCheck = false;
  };

  NetOpenIDCommon = buildPerlPackage rec {
    name = "Net-OpenID-Common-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "1jdbkp18ka2m4akjp9b0dbw2lqnzgwpq435cnh6hwwa79bbrfkmb";
    };
    propagatedBuildInputs = [ CryptDHGMP XMLSimple ];
  };

  NetOpenIDConsumer = buildPerlPackage rec {
    name = "Net-OpenID-Consumer-1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "0f2g6sczvbpyjmy14pabmrj0d48hlsndqswrvmqk1161wxpkh70f";
    };
    propagatedBuildInputs = [ JSON NetOpenIDCommon ];
    buildInputs = [ CGI ];
  };

  NetOpenSSH = buildPerlPackage rec {
    name = "Net-OpenSSH-0.77";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/${name}.tar.gz";
      sha256 = "16e965c6ed3dfe0f1288a6ba932d0e8d5c7846ce86de05c0dbd64259df2a2477";
    };
    meta = {
      description = "Perl SSH client package implemented on top of OpenSSH";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageConstants = buildPerlPackage {
    name = "Package-Constants-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Package-Constants-0.06.tar.gz;
      sha256 = "0b58be78706ccc4e4bd9bbad41767470427fd7b2cfad749489de101f85bc5df5";
    };
    meta = {
      description = "List constants defined in a package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageDeprecationManager = buildPerlPackage rec {
    name = "Package-DeprecationManager-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1d743ada482b5c9871d894966e87d4c20edc96931bb949fb2638b000ddd6684b";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ PackageStash ParamsUtil SubInstall SubName ];
    meta = {
      homepage = https://metacpan.org/release/Package-DeprecationManager;
      description = "Manage deprecation warnings for your distribution";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  PatchReader = buildPerlPackage rec {
    name = "PatchReader-0.9.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TM/TMANNERM/PatchReader-0.9.6.tar.gz;
      sha256 = "b8de37460347bb5474dc01916ccb31dd2fe0cd92242c4a32d730e8eb087c323c";
    };
    meta = {
      homepage = "http://search.cpan.org/~tmannerm/${name}";
      description = "Utilities to read and manipulate patches and CVS";
      license = with stdenv.lib.licenses; [ artistic1 ];
    };
  };

  PackageStash = buildPerlPackage {
    name = "Package-Stash-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-0.37.tar.gz;
      sha256 = "06ab05388f9130cd377c0e1d3e3bafeed6ef6a1e22104571a9e1d7bfac787b2c";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleImplementation ];
    meta = {
      homepage = https://metacpan.org/release/Package-Stash;
      description = "Routines for manipulating stashes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageStashXS = buildPerlPackage {
    name = "Package-Stash-XS-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-XS-0.28.tar.gz;
      sha256 = "11nl69n8i56p91pd0ia44ip0vpv2cxwpbfakrv01vvv8az1cbn13";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      homepage = https://metacpan.org/release/Package-Stash-XS;
      description = "Faster and more correct implementation of the Package::Stash API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Pango = buildPerlPackage rec {
    name = "Pango-1.227";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0wdcidnfnb6nm79fzfs39ivawj3x8m98a147fmcxgv1zvwia9c1l";
    };
    buildInputs = [ pkgs.pango ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Layout and render international text";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  ParallelForkManager = buildPerlPackage rec {
    name = "Parallel-ForkManager-1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/${name}.tar.gz";
      sha256 = "f1de2e9875eeb77d65f80338905dedd522f3913822502982f805aa71cde5a472";
    };
    buildInputs = [ TestWarn ];
    meta = {
      homepage = https://github.com/dluxhu/perl-parallel-forkmanager;
      description = "A simple parallel processing fork manager";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ParallelPrefork = buildPerlPackage {
    name = "Parallel-Prefork-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Parallel-Prefork-0.18.tar.gz;
      sha256 = "f1c1f48f1ae147a58bc88f9cb2f570d6bb15ea4c0d589abd4c3084ddc961596e";
    };
    buildInputs = [ TestRequires TestSharedFork ];
    propagatedBuildInputs = [ ClassAccessorLite ListMoreUtils ProcWait3 ScopeGuard SignalMask ];
    meta = {
      description = "A simple prefork server framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsClassify = buildPerlModule rec {
    name = "Params-Classify-0.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Params-Classify-0.015.tar.gz;
      sha256 = "052r198xyrsv8wz21gijdigz2cgnidsa37nvyfzdiz4rv1fc33ir";
    };
  };

  ParamsUtil = buildPerlPackage {
    name = "Params-Util-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Params-Util-1.07.tar.gz;
      sha256 = "0v67sx93yhn7xa0nh9mnbf8mixf54czk6wzrjsp6dzzr5hzyrw9h";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Simple, compact and correct param-checking functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsValidate = buildPerlModule rec {
    name = "Params-Validate-1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "49a68dfb430bea028042479111d19068e08095e5a467e320b7ab7bde3d729733";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleImplementation ];
    perlPreHook = "export LD=$CC";
    meta = {
      homepage = https://metacpan.org/release/Params-Validate;
      description = "Validate method/function parameters";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ParamsValidationCompiler = buildPerlPackage rec {
     name = "Params-ValidationCompiler-0.27";
     src = fetchurl {
       url = mirror://cpan/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.27.tar.gz;
       sha256 = "1cpr188c2xm0kkmdir6slcsgv7v6ibqff4lax8s0whwx6ml9kaah";
     };
     propagatedBuildInputs = [ EvalClosure ExceptionClass ];
     buildInputs = [ Specio Test2PluginNoWarnings Test2Suite TestSimple13 TestWithoutModule ];
     meta = {
       description = "Build an optimized subroutine parameter validator once, use it forever";
       license = with stdenv.lib.licenses; [ artistic2 ];
       homepage = "http://metacpan.org/release/Params-ValidationCompiler";
     };
  };

  PARDist = buildPerlPackage {
    name = "PAR-Dist-0.49";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSCHUPP/PAR-Dist-0.49.tar.gz;
      sha256 = "078ycyn8pw3rba4k3qwcqrqfcym5c1pivymwa0bvs9sab45j4iwy";
    };
    meta = {
      description = "Create and manipulate PAR distributions";
    };
  };

  Parent = buildPerlPackage {
    name = "parent-0.236";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.236.tar.gz;
      sha256 = "0yhjps1fprifhvzdwwl09bp1ngyqx85rvyn96j34papn0jypx0rd";
    };
  };

  ParseCPANMeta = buildPerlPackage {
    name = "Parse-CPAN-Meta-1.4414";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Parse-CPAN-Meta-1.4414.tar.gz;
      sha256 = "cd7608154dfb72c9e110f012befe6b75d78448cb3e761716b60aa7545e16ca1b";
    };
    propagatedBuildInputs = [ CPANMetaYAML JSONPP ];
    meta = {
      homepage = https://github.com/Perl-Toolchain-Gang/Parse-CPAN-Meta;
      description = "Parse META.yml and META.json CPAN metadata files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseDebControl = buildPerlPackage rec {
    name = "Parse-DebControl-2.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYBONCI/${name}.tar.gz";
      sha256 = "0ad78qri4sg9agghqdm83xsjgks94yvffs23kppy7mqjy8gwwjxn";
    };
    propagatedBuildInputs = [ IOStringy LWP ];
    meta = with stdenv.lib; {
      homepage = http://search.cpan.org/~jaybonci/Parse-DebControl;
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseRecDescent = buildPerlModule rec {
    name = "Parse-RecDescent-1.967015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JT/JTBRAUN/${name}.tar.gz";
      sha256 = "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37";
    };
    meta = {
      description = "Generate Recursive-Descent Parsers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseSyslog = buildPerlPackage {
    name = "Parse-Syslog-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSCHWEI/Parse-Syslog-1.10.tar.gz;
      sha256 = "659a2145441ef36d9835decaf83da308fcd03f49138cb3d90928e8bfc9f139d9";
    };
  };

  PathClass = buildPerlModule {
    name = "Path-Class-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.37.tar.gz;
      sha256 = "1kj8q8dmd8jci94w5arav59nkp0pkxrkliz4n8n6yf02hsa82iv5";
    };
    meta = {
      description = "Cross-platform path specification manipulation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PathTiny = buildPerlPackage {
    name = "Path-Tiny-0.104";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.104.tar.gz;
      sha256 = "c69f1dcfeb4aa004086deb9bc14c7d79f45798b947f1efbd634a3442e267aaef";
    };
    meta = {
      homepage = https://metacpan.org/release/Path-Tiny;
      description = "File path utility";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    preConfigure =
      ''
        substituteInPlace lib/Path/Tiny.pm --replace 'use File::Spec 3.40' \
          'use File::Spec 3.39'
      '';
    # This appears to be currently failing tests, though I don't know why.
    # -- ocharles
    doCheck = false;
  };

  PathTools = buildPerlPackage {
    name = "PathTools-3.47";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/PathTools-3.47.tar.gz;
      sha256 = "caa8d4b45372b8cb0ef0f6f696efa3a60b0fd394b115cad39a7fbb8f6bd38026";
    };
  };

  pcscperl = buildPerlPackage {
    name = "pcsc-perl-1.4.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WH/WHOM/pcsc-perl-1.4.14.tar.bz2";
      sha256 = "17f6i16jv6ci6459vh6y3sz94vgcvykjjszcl4xsykryakjvf8i7";
    };
    buildInputs = [ pkgs.pcsclite ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    NIX_CFLAGS_LINK = "-L${pkgs.pcsclite}/lib -lpcsclite";
    # tests fail; look unfinished
    doCheck = false;
    meta = {
      homepage = http://ludovic.rousseau.free.fr/softwares/pcsc-perl/;
      description = "Communicate with a smart card using PC/SC";
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = with maintainers; [ abbradar ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  PDFAPI2 = buildPerlPackage rec {
    name = "PDF-API2-2.033";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SS/SSIMMS/${name}.tar.gz";
      sha256 = "9c0866ec1a3053f73afaca5f5cdbe6925903b4ce606f4bf4ac317731a69d27a0";
    };
    buildInputs = [ TestException TestMemoryCycle ];
    propagatedBuildInputs = [ FontTTF ];
    meta = {
      description = "Facilitates the creation and modification of PDF files";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Pegex = buildPerlPackage rec {
    name = "Pegex-0.64";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "27e00264bdafb9c2109212b9654542032617fecf7b7814915d2bdac198f067cd";
    };
    buildInputs = [ FileShareDirInstall YAMLLibYAML ];
    meta = {
      homepage = https://github.com/ingydotnet/pegex-pm;
      description = "Acmeist PEG Parser Framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Perl5lib = buildPerlPackage rec {
    name = "perl5lib-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/${name}.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
  };

  Perlosnames = buildPerlPackage rec {
    name = "Perl-osnames-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/${name}.tar.gz";
      sha256 = "fb22a1ed59dc2311f7f1ffca5685d90c0600020467f624f57b4dd3dba5bc659b";
    };
    meta = {
      homepage = https://metacpan.org/release/Perl-osnames;
      description = "List possible $^O ($OSNAME) values, with description";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlCritic = buildPerlModule rec {
    name = "Perl-Critic-1.130";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0662e8f02dd78e39ee9d5b01bdf5376a7cc70ce2b0edc9ca015be35e6cb61df6";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ BKeywords ConfigTiny EmailAddress FileHomeDir ModulePluggable PPIxRegexp PPIxUtilities PerlTidy PodSpell StringFormat ];
    meta = {
      homepage = http://perlcritic.com;
      description = "Critique Perl source code for best-practices";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOeol = buildPerlPackage rec {
    name = "PerlIO-eol-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1fayp27vcmypqyzcd4003036h3g5zy6jk1ia25frdca58pzcpk6f";
    };
  };

  PerlIOutf8_strict = buildPerlPackage rec {
    name = "PerlIO-utf8_strict-0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "83a33f2fe046cb3ad6afc80790635a423e2c7c6854afacc6998cd46951cc81cb";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Fast and correct UTF-8 IO";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOviadynamic = buildPerlPackage {
    name = "PerlIO-via-dynamic-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/PerlIO-via-dynamic-0.14.tar.gz;
      sha256 = "0jbb3xpbqzmr625blvnjszd69l3cwxzi7bhmkj5x48dgv3s7mkca";
    };
  };

  PerlIOviaQuotedPrint = buildPerlPackage {
    name = "PerlIO-via-QuotedPrint-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/PerlIO-via-QuotedPrint-0.08.tar.gz;
      sha256 = "9b999a54134816de5217f7a8cac69fa5d89ab32dc589fcd5c9e84902f608cb9c";
    };
    meta = {
      description = "PerlIO Layer for quoted-printable encoding";
    };
  };

  PerlIOviasymlink = buildPerlPackage {
    name = "PerlIO-via-symlink-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz;
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };

    buildInputs = [ ModuleInstall ];

    postPatch = ''
      # remove outdated inc::Module::Install included with module
      # causes build failure for perl5.18+
      rm -r  inc
    '';
  };

  PerlIOviaTimeout = buildPerlModule rec {
    name = "PerlIO-via-Timeout-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/${name}.tar.gz";
      sha256 = "9278f9ef668850d913d98fa4c0d7e7d667cff3503391f4a4eae73a246f2e7916";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork TestTCP ];
    meta = {
      description = "A PerlIO layer that adds read & write timeout to a handle";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  perlldap = buildPerlPackage rec {
    name = "perl-ldap-0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARSCHAP/${name}.tar.gz";
      sha256 = "5f57dd261dc16ebf942a272ddafe69526598df71151a51916edc37a4f2f23834";
    };
    buildInputs = [ TextSoundex ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      homepage = http://ldap.perl.org/;
      description = "LDAP client library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.limeytexan ];
    };
  };

  PerlMagick = buildPerlPackage rec {
    name = "PerlMagick-6.89-1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JC/JCRISTY/${name}.tar.gz";
      sha256 = "0n9afy1z5bhf9phrbahnkwhgcmijn8jggpbzwrivw1zhliliiy68";
    };
    buildInputs = [ pkgs.imagemagick ];
    preConfigure =
      ''
        sed -i -e 's|my \$INC_magick = .*|my $INC_magick = "-I${pkgs.imagemagick.dev}/include/ImageMagick";|' Makefile.PL
      '';
    doCheck = false;
  };

  PerlOSType = buildPerlPackage rec {
    name = "Perl-OSType-1.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "1ch36kfjwm229xicb9k7b9fhisy58ihdr16vm8iwniymnna4kvg7";
    };
  };

  PerlTidy = buildPerlPackage rec {
    name = "Perl-Tidy-20180220";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHANCOCK/${name}.tar.gz";
      sha256 = "e9973ce28b7518108c1e68fa767c6566822480e739df275375a0dfcc9c2b3370";
    };
    meta = {
      description = "Indent and reformat perl scripts";
      license = stdenv.lib.licenses.gpl2Plus;
    };
  };

  PHPSerialization = buildPerlPackage {
    name = "PHP-Serialization-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/PHP-Serialization-0.34.tar.gz;
      sha256 = "0yphqsgg7zrar2ywk2j2fnjxmi9rq32yf0p5ln8m9fmfx4kd84mr";
    };
    meta = {
      description = "Simple flexible means of converting the output of PHP's serialize() into the equivalent Perl memory structure, and vice versa";
      license = "unknown";
    };
  };

  PkgConfig = buildPerlPackage rec {
    name = "PkgConfig-0.19026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "5cb6e934d29dd93e04c2fa779f4b7e51361edaf56957b47a232017a4bb7e922c";
    };
    meta = {
      homepage = https://metacpan.org/pod/PkgConfig;
      description = "Pure-Perl Core-Only replacement for pkg-config";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.limeytexan ];
    };
  };

  Plack = buildPerlPackage rec {
    name = "Plack-1.0047";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "322c93f5acc0a0f0e11fd4a76188f978bdc14338a9f1df3ae535227017046561";
    };
    buildInputs = [ AuthenSimplePasswd CGIEmulatePSGI FileShareDirInstall HTTPRequestAsCGI HTTPServerSimplePSGI IOHandleUtil LWP LWPProtocolhttp10 LogDispatchArray MIMETypes TestMockTimeHiRes TestRequires TestSharedFork TestTCP ];
    propagatedBuildInputs = [ ApacheLogFormatCompiler CookieBaker DevelStackTraceAsHTML FileShareDir FilesysNotifySimple HTTPEntityParser HTTPHeadersFast HTTPMessage TryTiny ];
    meta = {
      homepage = https://github.com/plack/Plack;
      description = "Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareDebug = buildPerlModule rec {
    name = "Plack-Middleware-Debug-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "e1e4ff6e9b246fe67547ebac8a3e83d4ae77873f889d1f63411c21c8c6bf96d5";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ ClassMethodModifiers DataDump FileShareDir Plack TextMicroTemplate ];
    meta = {
      homepage = https://github.com/miyagawa/Plack-Middleware-Debug;
      description = "Display information about the current request/response";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareFixMissingBodyInRedirect = buildPerlPackage rec {
    name = "Plack-Middleware-FixMissingBodyInRedirect-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SW/SWEETKID/${name}.tar.gz";
      sha256 = "6c22d069f5a57ac206d4659b28b8869bb9270640bb955efddd451dcc58cdb391";
    };
    propagatedBuildInputs = [ HTMLParser Plack ];
    meta = {
      homepage = https://github.com/Sweet-kid/Plack-Middleware-FixMissingBodyInRedirect;
      description = "Plack::Middleware which sets body for redirect response, if it's not already set";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareMethodOverride = buildPerlPackage rec {
    name = "Plack-Middleware-MethodOverride-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "2b4a6e67006f97a2b4cf7980900f6a8ababb1cf97d6597319f9897ada3c555bc";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Override REST methods to Plack apps via POST";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareRemoveRedundantBody = buildPerlPackage {
    name = "Plack-Middleware-RemoveRedundantBody-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SW/SWEETKID/Plack-Middleware-RemoveRedundantBody-0.07.tar.gz;
      sha256 = "64b841d5d74b4c4a595b85749d69297f4f5f5c0829a6e99e0099f05dd69be3c3";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      homepage = https://github.com/Sweet-kid/Plack-Middleware-RemoveRedundantBody;
      description = "Plack::Middleware which sets removes body for HTTP response if it's not required";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareReverseProxy = buildPerlPackage {
    name = "Plack-Middleware-ReverseProxy-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-ReverseProxy-0.15.tar.gz;
      sha256 = "1zmsccdy6wr5hxzj07r1nsmaymyibk87p95z0wzknjw10lwmqs9f";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Supports app to run as a reverse proxy backend";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackTestExternalServer = buildPerlPackage rec {
    name = "Plack-Test-ExternalServer-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "5baf5c57fe0c06412deec9c5abe7952ab8a04f8c47b4bbd8e9e9982268903ed0";
    };
    buildInputs = [ Plack TestSharedFork TestTCP ];
    propagatedBuildInputs = [ LWP ];
    meta = {
      homepage = https://github.com/perl-catalyst/Plack-Test-ExternalServer;
      description = "Run HTTP tests on external live servers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Po4a = buildPerlPackage rec {
    name = "po4a-0.47";
    src = fetchurl {
      url = "https://alioth.debian.org/frs/download.php/file/4142/po4a-0.47.tar.gz";
      sha256 = "5010e1b7df1115cbd475f46587fc05fefc97301f9bba0c2f15106005ca017507";
    };
    nativeBuildInputs = [ pkgs.docbook_xml_xslt pkgs.docbook_xsl pkgs.docbook_xsl_ns ];
    propagatedBuildInputs = [ TextWrapI18N LocaleGettext TermReadKey SGMLSpm ModuleBuild UnicodeLineBreak ModuleBuild ];
    buildInputs = [ pkgs.gettext pkgs.libxslt pkgs.glibcLocales pkgs.docbook_xml_dtd_412 pkgs.docbook_sgml_dtd_41 pkgs.texlive.combined.scheme-basic pkgs.jade ];
    LC_ALL="en_US.UTF-8";
    SGML_CATALOG_FILES = "${pkgs.docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml";
    preConfigure = ''
      touch Makefile.PL
      export PERL_MB_OPT="--install_base=$out --prefix=$out"
      substituteInPlace Po4aBuilder.pm --replace "\$self->install_sets(\$self->installdirs)->{'bindoc'}" "'$out/share/man/man1'"
    '';
    buildPhase = "perl Build.PL --install_base=$out; ./Build build";
    installPhase = "./Build install";
    checkPhase = ''
      export SGML_CATALOG_FILES=${pkgs.docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat
      ./Build test
    '';
    meta = {
      homepage = https://po4a.alioth.debian.org/;
      description = "tools for helping translation of documentation";
      license = with stdenv.lib.licenses; [ gpl2 ];
    };
  };

  POE = buildPerlPackage rec {
    name = "POE-1.367";
    patches = [
      ../development/perl-modules/perl-POE-1.367-pod_linkcheck.patch
      ../development/perl-modules/perl-POE-1.367-pod_no404s.patch
    ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/POE-1.367.tar.gz";
      sha256 = "0b9s7yxaa2lgzyi56brgygycfjk7lz33d1ddvc1wvwwvm45p4wmp";
    };
    # N.B. removing TestPodLinkCheck from buildInputs because tests requiring
    # this module don't disable themselves when "run_network_tests" is
    # not present (see below).
    propagatedBuildInputs = [ pkgs.cacert IOPipely IOTty POETestLoops ];
    meta = {
      maintainers = [ maintainers.limeytexan ];
      description = "Portable multitasking and networking framework for any event loop";
      license = stdenv.lib.licenses.artistic2;
    };
    preCheck = ''
      set -x

      : Makefile.PL touches the following file as a "marker" to indicate
      : it should perform tests which use the network. Delete this file
      : for sandbox builds.
      rm -f run_network_tests

      : Certs are required if not running in a sandbox.
      export SSL_CERT_FILE=${pkgs.cacert.out}/etc/ssl/certs/ca-bundle.crt

      : The following flag enables extra tests not normally performed.
      export RELEASE_TESTING=1

      set +x
    '';
  };

  POETestLoops = buildPerlPackage rec {
    name = "POE-Test-Loops-1.360";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/${name}.tar.gz";
      sha256 = "0yx4wsljfmdzsiv0ni98x6lw975cm82ahngbwqvzv60wx5pwkl5y";
    };
    meta = {
      maintainers = [ maintainers.limeytexan ];
      description = "Reusable tests for POE::Loop authors";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  PPI = buildPerlPackage rec {
    name = "PPI-1.236";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHALDU/${name}.tar.gz";
      sha256 = "c6674b349c0b7d9a6d668e789a5e5215477d88ed4c8203aa69a2a50085308aec";
    };
    buildInputs = [ ClassInspector FileRemove TestDeep TestObject TestSubCalls ];
    propagatedBuildInputs = [ Clone IOString ListMoreUtils ParamsUtil TaskWeaken ];

    # Remove test that fails due to unexpected shebang after
    # patchShebang.
    preCheck = "rm t/03_document.t";

    meta = {
      homepage = https://github.com/adamkennedy/PPI;
      description = "Parse, Analyze and Manipulate Perl (without perl)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxRegexp = buildPerlModule rec {
    name = "PPIx-Regexp-0.056";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/${name}.tar.gz";
      sha256 = "37992de526a368d120506e8c6c0498266e4de81942658cf0af1db89b12302f15";
    };
    propagatedBuildInputs = [ PPI ];
    meta = {
      description = "Parse regular expressions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxUtilities = buildPerlModule {
    name = "PPIx-Utilities-1.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EL/ELLIOTJS/PPIx-Utilities-1.001000.tar.gz;
      sha256 = "03a483386fd6a2c808f09778d44db06b02c3140fb24ba4bf12f851f46d3bcb9b";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ExceptionClass PPI Readonly ];
    meta = {
      description = "Extensions to L<PPI|PPI>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcBackground = buildPerlPackage rec {
    name = "Proc-Background-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BZ/BZAJAC/${name}.tar.gz";
      sha256 = "1ce0dd78c0bb8393a2431b385a27b99fcc623a41ebec57b3cc09cc38cdb708ee";
    };
    meta = {
    };
  };

  ProcProcessTable = buildPerlPackage {
    name = "Proc-ProcessTable-0.55";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JW/JWB/Proc-ProcessTable-0.55.tar.gz;
      sha256 = "3b9660d940a0c016c5e48108fa9dbf9f30492b505aa0a26d22b09554f05714f5";
    };
    meta = {
      description = "Perl extension to access the unix process table";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcFind = buildPerlPackage rec {
    name = "Proc-Find-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/${name}.tar.gz";
      sha256 = "07d715c2b8644dc6d5b5a36ffcd2f02da017bf86a00027387aa47c53e2347a81";
    };
    buildInputs = [ Perlosnames ];
    propagatedBuildInputs = [ ProcProcessTable ];
    meta = {
      homepage = https://metacpan.org/release/Proc-Find;
      description = "Find processes by name, PID, or some other attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcSafeExec = buildPerlPackage {
    name = "Proc-SafeExec-1.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BILBO/Proc-SafeExec-1.5.tar.gz;
      sha256 = "1b4d0908bcac563d34a7e5be61c5da3eee98e4a6c7fa68c2670cc5844b5a2d78";
    };
  };

  ProcSimple = buildPerlPackage rec {
    name = "Proc-Simple-1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/${name}.tar.gz";
      sha256 = "4c8f0a924b19ad78a13da73fe0fb306d32a7b9d10a332c523087fc83a209a8c4";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcWait3 = buildPerlPackage {
    name = "Proc-Wait3-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CT/CTILMES/Proc-Wait3-0.05.tar.gz;
      sha256 = "1a907f5db6933dc2939bbfeffe19eeae7ed39ef1b97a2bc9b723f2f25f81caf3";
    };
    meta = {
      description = "Perl extension for wait3 system call";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcWaitStat = buildPerlPackage rec {
    name = "Proc-WaitStat-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROSCH/Proc-WaitStat-1.00.tar.gz;
      sha256 = "1g3l8jzx06x4l4p0x7fyn4wvg6plfzl420irwwb9v447wzsn6xfh";
    };
    propagatedBuildInputs = [ IPCSignal ];
  };

  ProtocolWebSocket = buildPerlModule rec {
    name = "Protocol-WebSocket-0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VT/VTI/${name}.tar.gz";
      sha256 = "1w0l9j1bnmw82jfhrx5yfw4hbl0bpcwmrl5laa1gz06mkzkdpa6z";
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  ProtocolHTTP2 = buildPerlModule rec {
    name = "Protocol-HTTP2-1.08";

    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CR/CRUX/${name}.tar.gz";
      sha256 = "06y1djgzbn340hixav85728dvp8mj2mx2qf5fzkqxh145g5q860g";
    };
    buildInputs = [ AnyEvent ModuleBuildTiny NetSSLeay TestLeakTrace TestSharedFork TestTCP ];
  };

  PSGI = buildPerlPackage rec {
    name = "PSGI-1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0iqzxs8fv63510knm3zr3jr3ky4x7diwd7y24mlshzci81kl8v55";
    };
  };

  PadWalker = buildPerlPackage rec {
    name = "PadWalker-2.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/${name}.tar.gz";
      sha256 = "2a6c44fb600861e54568e74081a8d1f121f0060076069ceab34b1ae89d6588cf";
    };
  };

  Perl6Junction = buildPerlPackage rec {
    name = "Perl6-Junction-1.60000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "0r3in9pyrm6wfrhcvxbq5w1617x8x5537lxj9hdzks4pa7l7a8yh";
    };
  };

  PerlMinimumVersion = buildPerlPackage rec {
    name = "Perl-MinimumVersion-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "478b5824791b87fc74c94a892180682bd06ad2cdf34034b1a4b859273927802a";
    };
    buildInputs = [ TestScript ];
    propagatedBuildInputs = [ FileFindRulePerl PerlCritic ];
    meta = {
      homepage = https://github.com/neilbowers/Perl-MinimumVersion;
      description = "Find a minimum required version of perl for Perl code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlPrereqScanner = buildPerlPackage rec {
    name = "Perl-PrereqScanner-1.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "280a1c4710390865fb9f310a861a34720b28b4cbe50609c841af5cf2d3a2bced";
    };
    propagatedBuildInputs = [ GetoptLongDescriptive ModulePath Moose PPI StringRewritePrefix namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Perl-PrereqScanner;
      description = "A tool to scan your Perl code for its prerequisites";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlVersion = buildPerlPackage rec {
    name = "Perl-Version-1.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "1887414d1c8689d864c840114101e043e99d7dd5b9cca69369a60e821e3ad0f7";
    };
    propagatedBuildInputs = [ FileSlurpTiny ];
    meta = {
      description = "Parse and manipulate Perl version strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodChecker = buildPerlPackage {
    name = "Pod-Checker-1.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Checker-1.73.tar.gz;
      sha256 = "7dee443b03d80d0735ec50b6d1caf0209c51ab0a97d64050cfc10e1555cb9305";
    };
  };

  PodCoverage = buildPerlPackage rec {
    name = "Pod-Coverage-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "01xifj83dv492lxixijmg6va02rf3ydlxly0a9slmx22r6qa1drh";
    };
    propagatedBuildInputs = [ DevelSymdump ];
  };

  PodCoverageTrustPod = buildPerlPackage {
    name = "Pod-Coverage-TrustPod-0.100005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Coverage-TrustPod-0.100005.tar.gz;
      sha256 = "08bk6lfimr2pwi6c92xg5cw1cxmi5fqhls3yasqzpjnd4if86s3c";
    };
    propagatedBuildInputs = [ PodCoverage PodEventual ];
    meta = {
      homepage = https://github.com/rjbs/pod-coverage-trustpod;
      description = "Allow a module's pod to contain Pod::Coverage hints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElemental = buildPerlPackage rec {
    name = "Pod-Elemental-0.103004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "43625cde7241fb174ad9c7eb45387fba410dc141d7de2323855eeab3590072c9";
    };
    buildInputs = [ TestDeep TestDifferences ];
    propagatedBuildInputs = [ MooseXTypes PodEventual StringRewritePrefix StringTruncate ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Elemental;
      description = "Work with nestable Pod elements";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElementalPerlMunger = buildPerlPackage rec {
    name = "Pod-Elemental-PerlMunger-0.200006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "09fd3b5d53119437a01dced66b42eafdcd53895b3c32a2b0f781f36fda0f665b";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ PPI PodElemental ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Elemental-PerlMunger;
      description = "A thing that takes a string of Perl and rewrites its documentation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodEscapes = let version = "1.07"; in buildPerlPackage {
    name = "Pod-Escapes-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Pod-Escapes-${version}.tar.gz";
      sha256 = "0213lmbbw3vy50ahlp2lqmmnkwhrizyl1y87i4jgnla9k0kwixyv";
    };
  };

  PodEventual = buildPerlPackage {
    name = "Pod-Eventual-0.094001";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Eventual-0.094001.tar.gz;
      sha256 = "be9fb8910b108e5d1a66f002b659ad22576e88d779b703dff9d15122c3f80834";
    };
    propagatedBuildInputs = [ MixinLinewise ];
    meta = {
      description = "Read a POD document as a series of trivial events";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestDeep ];
  };

  PodParser = buildPerlPackage {
    name = "Pod-Parser-1.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz;
      sha256 = "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd";
    };
    meta = {
      description = "Modules for parsing/translating POD format documents";
      license = stdenv.lib.licenses.artistic1;
    };
  };

  PodPOM = buildPerlPackage rec {
    name = "Pod-POM-2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "1b50fba9bbdde3ead192beeba0eaddd0c614e3afb1743fa6fff805f57c56f7f4";
    };
    buildInputs = [ FileSlurper TestDifferences TextDiff ];
    meta = {
      homepage = https://github.com/neilb/Pod-POM;
      description = "POD Object Model";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodPOMViewTOC = buildPerlPackage rec {
    name = "Pod-POM-View-TOC-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "ccb42272c7503379cb1131394620ee50276d72844e0e80eb4b007a9d58f87623";
    };
    propagatedBuildInputs = [ PodPOM ];
    meta = {
      description = "Generate the TOC of a POD with Pod::POM";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodLaTeX = buildPerlModule rec {
    name = "Pod-LaTeX-0.61";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJENNESS/${name}.tar.gz";
      sha256 = "15a840ea1c8a76cd3c865fbbf2fec33b03615c0daa50f9c800c54e0cf0659d46";
    };
    meta = {
      homepage = https://github.com/timj/perl-Pod-LaTeX/tree/master;
      description = "Convert Pod data to formatted Latex";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  podlators = buildPerlPackage rec {
    name = "podlators-4.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RR/RRA/${name}.tar.gz";
      sha256 = "008b4j41ijrfyyq5nd3y7pqyww6rg49fjg2c6kmpnqrmgs347qqp";
    };
    meta = {
      description = "Convert POD data to various other formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  podlinkcheck = buildPerlPackage rec {
    name = "podlinkcheck-15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "4e3bebec1bf82dbf850a94ae26a253644cf5806ec41afc74e43e1710a37321db";
    };
    propagatedBuildInputs = [ FileFindIterator FileHomeDir IPCRun constant-defer libintl_perl ];
    meta = {
      homepage = http://user42.tuxfamily.org/podlinkcheck/index.html;
      description = "Check POD L<> link references";
      license = stdenv.lib.licenses.gpl3Plus;
    };
  };

  PodPerldoc = buildPerlPackage rec {
    name = "Pod-Perldoc-3.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MALLEN/${name}.tar.gz";
      sha256 = "0kf6xwdha8jl0nxv60r2v7xsfnvv6i3gy135xsl40g71p02ychfc";
    };
    meta = {
      description = "Look up Perl documentation in Pod format";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodPlainer = buildPerlPackage {
    name = "Pod-Plainer-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RM/RMBARKER/Pod-Plainer-1.04.tar.gz;
      sha256 = "1bbfbf7d1d4871e5a83bab2137e22d089078206815190eb1d5c1260a3499456f";
    };
    meta = {
      description = "Perl extension for converting Pod to old-style Pod";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodMarkdown = buildPerlPackage {
    name = "Pod-Markdown-3.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RW/RWSTAUNER/Pod-Markdown-3.005.tar.gz;
      sha256 = "00s3745kl4vbxqyi2lx149q5ghyfazc4fd00kcpl84bb87jfgdzq";
    };
    buildInputs = [ TestDifferences ];
    meta = {
      homepage = https://github.com/rwstauner/Pod-Markdown;
      description = "Convert POD to Markdown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodSimple = buildPerlPackage {
    name = "Pod-Simple-3.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KH/KHW/Pod-Simple-3.35.tar.gz;
      sha256 = "0gg11ibbc02l2aw0bsv4jx0jax8z0apgfy3p5csqnvhlsb6218cr";
    };
    propagatedBuildInputs = [ TextTabsWrap ];
  };

  PodSpell = buildPerlPackage rec {
    name = "Pod-Spell-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOLMEN/Pod-Spell-1.20.tar.gz;
      sha256 = "6383f7bfe22bc0d839a08057a0ce780698b046184aea935be4833d94986dd03c";
    };
    propagatedBuildInputs = [ ClassTiny FileShareDir LinguaENInflect PathTiny ];
    buildInputs = [ FileShareDirInstall TestDeep ];
  };

  PodStrip = buildPerlModule rec {
     name = "Pod-Strip-1.02";
     src = fetchurl {
       url = mirror://cpan/authors/id/D/DO/DOMM/Pod-Strip-1.02.tar.gz;
       sha256 = "1zsjfw2cjq1bd3ppl67fdvrx46vj9lina0c3cv9qgk5clzvaq3fq";
     };
     meta = {
       description = "Remove POD from Perl code";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  PodUsage = buildPerlPackage {
    name = "Pod-Usage-1.69";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Usage-1.69.tar.gz;
      sha256 = "1a920c067b3c905b72291a76efcdf1935ba5423ab0187b9a5a63cfc930965132";
    };
    propagatedBuildInputs = [ podlators ];
    meta = {
      description = "Pod::Usage extracts POD documentation and shows usage information";
    };
  };

  PodWeaver = buildPerlPackage rec {
    name = "Pod-Weaver-4.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "5af25b29a55783e495a9df5ef6293240e2c9ab02764613d79f1ed50b12dec5ae";
    };
    buildInputs = [ PPI SoftwareLicense TestDifferences ];
    propagatedBuildInputs = [ ConfigMVP ConfigMVPReaderINI DateTime ListMoreUtils LogDispatchouli MixinLinewise ModuleRuntime Moose ParamsUtil PodElemental StringFlogger StringFormatter StringRewritePrefix namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Weaver;
      description = "Weave together a Pod document from an outline";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ProbePerl = buildPerlPackage rec {
    name = "Probe-Perl-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/${name}.tar.gz";
      sha256 = "0c9wiaz0mqqknafr4jdr0g2gdzxnn539182z0icqaqvp5qgd5r6r";
    };
  };

  POSIXstrftimeCompiler = buildPerlModule rec {
    name = "POSIX-strftime-Compiler-0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "26582bdd78b254bcc1c56d0b770fa280e8b8f70957c84dc44572ba4cacb0ac11";
    };
    # We cannot change timezones on the fly.
    prePatch = "rm t/04_tzset.t";
    meta = {
      homepage = https://github.com/kazeburo/POSIX-strftime-Compiler;
      description = "GNU C library compatible strftime for loggers and servers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Razor2ClientAgent = buildPerlPackage rec {
    name = "Razor2-Client-Agent-2.84";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "d7c2ed7f347a673b1425e4da7656073d6c52847bc7403bf57e3a404b52f7e501";
    };
    propagatedBuildInputs = [ DigestSHA1 URI ];
    meta = {
      homepage = http://razor.sourceforge.net/;
      description = "Collaborative, content-based spam filtering network agent";
      license = stdenv.lib.licenses.mit;
    };
    doCheck = false;
  };


  Readonly = buildPerlModule rec {
    name = "Readonly-2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SANKO/${name}.tar.gz";
      sha256 = "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      homepage = https://github.com/sanko/readonly;
      description = "Facility for creating read-only scalars, arrays, hashes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ReadonlyXS = buildPerlPackage rec {
    name = "Readonly-XS-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "8ae5c4e85299e5c8bddd1b196f2eea38f00709e0dc0cb60454dc9114ae3fff0d";
    };
    propagatedBuildInputs = [ Readonly ];
  };

  Redis = buildPerlModule rec {
    name = "Redis-1.991";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/${name}.tar.gz";
      sha256 = "f7d1a934fa9360a26e480f896f97be0fd62807f9d9baca65a9aa8d007ff2acaa";
    };
    buildInputs = [ IOString ModuleBuildTiny PodCoverageTrustPod TestCPANMeta TestDeep TestFatal TestSharedFork TestTCP ];
    propagatedBuildInputs = [ IOSocketTimeout TryTiny ];
    meta = {
      homepage = https://github.com/PerlRedis/perl-redis;
      description = "Perl binding for Redis database";
      license = stdenv.lib.licenses.artistic2;
      maintainers = [ maintainers.rycee ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.38";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Regexp-Assemble-0.38.tgz;
      sha256 = "0hp4v8mghmpflq9l9fqrkjg4cw0d3ha2nrmnsnzwjwqvmvwyfsx0";
    };
  };

  RegexpCommon = buildPerlPackage {
    name = "Regexp-Common-2017060201";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz;
      sha256 = "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b";
    };
    meta = with stdenv.lib; {
      description = "Provide commonly requested regular expressions";
      license = licenses.mit;
    };
  };

  RegexpCommonnetCIDR = buildPerlPackage {
    name = "Regexp-Common-net-CIDR-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BP/BPS/Regexp-Common-net-CIDR-0.03.tar.gz;
      sha256 = "39606a57aab20d4f4468300f2ec3fa2ab557fcc9cb7880ec7c6e07d80162da33";
    };
    propagatedBuildInputs = [ RegexpCommon ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpCopy = buildPerlPackage rec {
    name = "Regexp-Copy-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDUNCAN/${name}.tar.gz";
      sha256 = "09c8xb43p1s6ala6g4274az51mf33phyjkp66dpvgkgbi1xfnawp";
    };
  };

  RegexpGrammars = buildPerlModule rec {
    name = "Regexp-Grammars-1.048";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/${name}.tar.gz";
      sha256 = "d7718d9bb0d4259eabf326838e3f841b440c4e959faf9615d9ad9c345f4a3d6f";
    };
    meta = {
      homepage = http://search.cpan.org/~dconway/Regexp-Grammars-1.045/lib/Regexp/Grammars.pm;
      description = "Add grammatical parsing features to Perl 5.10 regexes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpIPv6 = buildPerlPackage {
    name = "Regexp-IPv6-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SALVA/Regexp-IPv6-0.03.tar.gz;
      sha256 = "d542d17d75ce93631de8ba2156da0e0b58a755c409cd4a0d27a3873a26712ce2";
    };
    meta = {
      license = "unknown";
    };
  };

  RegexpParser = buildPerlPackage {
    name = "Regexp-Parser-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Regexp-Parser-0.22.tar.gz;
      sha256 = "d6d3c711657a380f1cb24d8b54a1cd20f725f7f54665189e9e67bb0b877109a3";
    };
    meta = {
      homepage = http://wiki.github.com/toddr/Regexp-Parser;
      description = "Base class for parsing regexes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RESTUtils = buildPerlModule {
    name = "REST-Utils-0.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JALDHAR/REST-Utils-0.6.tar.gz;
      sha256 = "1zdrf3315rp2b8r9dwwj5h93xky7i33iawf4hzszwcddhzflmsfl";
    };
    buildInputs = [ TestLongString TestWWWMechanize TestWWWMechanizeCGI ];
    meta = {
      homepage = http://jaldhar.github.com/REST-Utils;
      description = "Utility functions for REST applications";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RpcXML = buildPerlPackage {
    name = "RPC-XML-0.80";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.80.tar.gz;
      sha256 = "1xvy9hs7bqsjnk0663kf7zk2qjg0pzv96n6z2wlc2w5bgal7q3ga";
    };
    propagatedBuildInputs = [ XMLParser ];
    doCheck = false;
  };

  ReturnValue = buildPerlPackage {
    name = "Return-Value-1.666005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.666005.tar.gz;
      sha256 = "1b2hfmdl19zi1z3npzv9wf6dh1g0xd88i70b4233ds9icnln08lf";
    };
  };

  RoleBasic = buildPerlModule {
    name = "Role-Basic-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Role-Basic-0.13.tar.gz;
      sha256 = "38a0959ef9f193ff76e72c325a9e9211bc4868689bd0e2b005778f53f8b6f36a";
    };
    meta = {
      description = "Just roles. Nothing else";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleHasMessage = buildPerlPackage {
    name = "Role-HasMessage-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Role-HasMessage-0.006.tar.gz;
      sha256 = "1lylfvarjfy6wy34dfny3032pc6r33mjby5yzzhmxybg8zhdp9pn";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized StringErrf ];
    meta = {
      description = "A thing with a message method";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleIdentifiable = buildPerlPackage {
    name = "Role-Identifiable-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Role-Identifiable-0.007.tar.gz;
      sha256 = "1bbkj2wqpbfdw1cbm99vg9d94rvzba19m18xhnylaym0l78lc4sn";
    };
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "A thing with a list of tags";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleTiny = buildPerlPackage rec {
    name = "Role-Tiny-2.000006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "cc73418c904a0286ecd8915eac11f5be2a8d1e17ea9cb54c9116b0340cd3e382";
    };
    meta = {
      description = "Roles. Like a nouvelle cuisine portion size slice of Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  RSSParserLite = buildPerlPackage {
    name = "RSS-Parser-Lite-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TF/TFPBL/RSS-Parser-Lite-0.12.tar.gz;
      sha256 = "1fcmp4qp7q3xr2mw7clqqwph45icbvgfs2n41gp9zamim2y39p49";
    };
    propagatedBuildInputs = [ locallib ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    doCheck = false;
  };

  RTClientREST = buildPerlPackage {
    name = "RT-Client-REST-0.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMITRI/RT-Client-REST-0.51.tar.gz;
      sha256 = "6a9df61c7f209f634613a8824393932d2faf2497b1c580ed8e5dd7794a36ea7d";
    };
    buildInputs = [ CGI DateTime DateTimeFormatDateParse Error ExceptionClass HTTPCookies LWP ParamsValidate TestException ];
    meta = {
      description = "Talk to RT installation using REST protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Safe = buildPerlPackage {
    name = "Safe-2.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RG/RGARCIA/Safe-2.35.tar.gz;
      sha256 = "e5d09756580287d7dc183ddaf26e4b2467e6f75b52ad73decdbe62d0750979b1";
    };
  };

  SafeIsa = buildPerlPackage {
    name = "Safe-Isa-1.000008";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Safe-Isa-1.000008.tar.gz;
      sha256 = "08r74hwxq5b3bibnbwjr9anybg15l3zqdgcirpw1xm2qpvcxgdkx";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Call isa, can, does and DOES safely on things that may not be objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarListUtils = buildPerlPackage {
    name = "Scalar-List-Utils-1.50";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.50.tar.gz;
      sha256 = "06aab9c693380190e53be09be7daed20c5d6278f71956989c24cca7782013675";
    };
    meta = {
      description = "Common Scalar and List utility subroutines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarString = buildPerlModule rec {
    name = "Scalar-String-0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "f54a17c9b78713b02cc43adfadf60b49467e7634d31317e8b9e9e97c26d68b52";
    };
  };

  SCGI = buildPerlModule rec {
    name = "SCGI-0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPERCODE/${name}.tar.gz";
      sha256 = "196rj47mh4fq2vlnw595q391zja5v6qg7s3sy0vy8igfyid8rdsq";
    };
    preConfigure = "export HOME=$(mktemp -d)";
  };

  ScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.21.tar.gz;
      sha256 = "0y6jfzvxiz8h5yfz701shair0ilypq2mvimd7wn8wi2nbkm1p6wc";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeUpper = buildPerlPackage rec {
    name = "Scope-Upper-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "7f151582423850d814034404b1e23b5efb281b9dd656b9afe81c761ebb88bbb4";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Scope-Upper/;
      description = "Act on upper scopes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SearchDict = buildPerlPackage {
    name = "Search-Dict-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Search-Dict-1.07.tar.gz;
      sha256 = "b128cdae4712fe53e83a219ca65478a84c1b128a2c6c86933e47923cf19c6554";
    };
    meta = {
      description = "Look - search for key in dictionary file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SelfLoader = buildPerlPackage {
    name = "SelfLoader-1.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/SelfLoader-1.24.tar.gz;
      sha256 = "4c7cd20fd82aa10520ac14b05fa003f60c72bb4c95527bd12aec8bf3c4546098";
    };
    meta = {
      description = "Load functions only on demand";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ServerStarter = buildPerlModule rec {
    name = "Server-Starter-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/${name}.tar.gz";
      sha256 = "96a20d4a1f341655bd1b26df5795d57c5d7498d9bcf8ca9d0d6e2ed743608f78";
    };
    buildInputs = [ TestRequires TestSharedFork TestTCP ];
    meta = {
      homepage = https://github.com/kazuho/p5-Server-Starter;
      description = "A superdaemon for hot-deploying server programs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SetInfinite = buildPerlPackage {
    name = "Set-Infinite-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/Set-Infinite-0.65.tar.gz;
      sha256 = "07bc880734492de40b4a3a8b5a331762f64e69b4629029fd9a9d357b25b87e1f";
    };
    meta = {
      description = "Infinite Sets math";
    };
  };

  SetIntSpan = buildPerlPackage rec {
    name = "Set-IntSpan-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SW/SWMCD/Set-IntSpan-1.19.tar.gz;
      sha256 = "1l6znd40ylzvfwl02rlqzvakv602rmvwgm2xd768fpgc2fdm9dqi";
    };

    meta = {
      description = "Manages sets of integers";
    };
  };

  SetObject = buildPerlPackage rec {
    name = "Set-Object-1.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "5effcfeb104da334f413a20dee9cdc5e874246096c3b282190a5f44453401810";
    };
    meta = {
      description = "Unordered collections (sets) of Perl Objects";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  SetScalar = buildPerlPackage {
    name = "Set-Scalar-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz;
      sha256 = "07aiqkyi1p22drpcyrrmv7f8qq6fhrxh007achy2vryxyck1bp53";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  SGMLSpm = buildPerlPackage {
    name = "SGMLSpm-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz;
      sha256 = "1gdjf3mcz2bxir0l9iljxiz6qqqg3a9gg23y5wjg538w552r432m";
    };
  };

  SignalMask = buildPerlPackage {
    name = "Signal-Mask-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Signal-Mask-0.008.tar.gz;
      sha256 = "043d995b6b249d9ebc04c467db31bb7ddc2e55faa08e885bdb050b1f2336b73f";
    };
    propagatedBuildInputs = [ IPCSignal ];
    meta = {
      description = "Signal masks made easy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SnowballNorwegian = buildPerlModule rec {
     name = "Snowball-Norwegian-1.2";
     src = fetchurl {
       url = mirror://cpan/authors/id/A/AS/ASKSH/Snowball-Norwegian-1.2.tar.gz;
       sha256 = "0675v45bbsh7vr7kpf36xs2q79g02iq1kmfw22h20xdk4rzqvkqx";
     };
     meta = {
       description = "Porters stemming algorithm for norwegian.";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  SnowballSwedish = buildPerlModule rec {
     name = "Snowball-Swedish-1.2";
     src = fetchurl {
       url = mirror://cpan/authors/id/A/AS/ASKSH/Snowball-Swedish-1.2.tar.gz;
       sha256 = "0agwc12jk5kmabnpsplw3wf4ii5w1zb159cpin44x3srb0sr5apg";
     };
     meta = {
       description = "Porters stemming algorithm for swedish.";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  SOAPLite = buildPerlPackage {
    name = "SOAP-Lite-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz;
      sha256 = "1zhy06v72r95ih3lx5rlx0bvkq214ndmcmn97m5k2rkxxy4ybpp4";
    };
    propagatedBuildInputs = [ ClassInspector HTTPDaemon LWP TaskWeaken URI XMLParser ];
    meta = {
      description = "Perl's Web Services Toolkit";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Socket = buildPerlPackage {
    name = "Socket-2.027";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Socket-2.027.tar.gz;
      sha256 = "1a725fbqx6bjzjf63bgs5wvzd20kffz1f94pbmv1670p9m4i270l";
    };
    postPatch = ''
      # requires network access
      rm t/getnameinfo.t t/getaddrinfo.t
    '';
    meta = {
      homepage = https://metacpan.org/pod/Socket;
      description = "Networking constants and support functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Socket6 = buildPerlPackage rec {
    name = "Socket6-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UM/UMEMOTO/${name}.tar.gz";
      sha256 = "bfd49ab99f3197c99285fed4683c4edc06277c1e4453f593e694d7bff0974586";
    };
    setOutputFlags = false;
    buildInputs = [ pkgs.which ];
    meta = {
      description = "IPv6 related part of the C socket.h defines and structure manipulators";
      license = stdenv.lib.licenses.bsd3;
    };
  };

  SoftwareLicense = buildPerlPackage rec {
    name = "Software-License-0.103013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "2641d937390f43b08fa31c419713cd96a2f0bf160be04cab322631daf6810ff3";
    };
    buildInputs = [ TryTiny ];
    propagatedBuildInputs = [ DataSection TextTemplate ];
    meta = {
      homepage = https://github.com/rjbs/Software-License;
      description = "Packages that provide templated software licenses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SoftwareLicenseCCpack = buildPerlPackage rec {
     name = "Software-License-CCpack-1.11";
     src = fetchurl {
       url = mirror://cpan/authors/id/B/BB/BBYRD/Software-License-CCpack-1.11.tar.gz;
       sha256 = "1cakbn7am8mhalwas5h33l7c6avdqpg42z478p6rav11pim5qksr";
     };
     propagatedBuildInputs = [ SoftwareLicense ];
     buildInputs = [ TestCheckDeps ];
     meta = {
       description = "Software::License pack for Creative Commons' licenses";
       license = with stdenv.lib.licenses; [ lgpl3Plus ];
       homepage = "https://github.com/SineSwiper/Software-License-CCpack";
     };
  };

  SortKey = buildPerlPackage rec {
    name = "Sort-Key-1.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/${name}.tar.gz";
      sha256 = "1kqs10s2plj6c96srk0j8d7xj8dxk1704r7mck8rqk09mg7lqspd";
    };
    meta = {
      description = "Sort arrays by one or multiple calculated keys";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SortVersions = buildPerlPackage rec {
    name = "Sort-Versions-1.62";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Sort-Versions-1.62.tar.gz;
      sha256 = "1aifzm79ky03gi2lwxyx4mk6yky8x215j0kz4f0jbgkf803k6pxz";
    };
  };

  Specio = buildPerlPackage rec {
     name = "Specio-0.42";
     src = fetchurl {
       url = mirror://cpan/authors/id/D/DR/DROLSKY/Specio-0.42.tar.gz;
       sha256 = "1xjfa9g4vc6x3f0bzzbac8dwgpc4in4za1l1sp0y6ykdla9qna93";
     };
     propagatedBuildInputs = [ DevelStackTrace EvalClosure MROCompat ModuleRuntime RoleTiny SubQuote TryTiny ];
     buildInputs = [ TestFatal TestNeeds ];
     meta = {
       description = "Type constraints and coercions for Perl";
       license = with stdenv.lib.licenses; [ artistic2 ];
       homepage = "http://metacpan.org/release/Specio";
     };
  };

  Spiffy = buildPerlPackage rec {
    name = "Spiffy-0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "18qxshrjh0ibpzjm2314157mxlibh3smyg64nr4mq990hh564n4g";
    };
  };

  SpreadsheetParseExcel = buildPerlPackage rec {
    name = "Spreadsheet-ParseExcel-0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOUGW/${name}.tar.gz";
      sha256 = "6ec4cb429bd58d81640fe12116f435c46f51ff1040c68f09cc8b7681c1675bec";
    };
    propagatedBuildInputs = [ CryptRC4 DigestPerlMD5 IOStringy OLEStorage_Lite ];
    meta = {
      homepage = https://github.com/runrig/spreadsheet-parseexcel/;
      description = "Read information from an Excel file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SpreadsheetWriteExcel = buildPerlPackage rec {
    name = "Spreadsheet-WriteExcel-2.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "e356aad6866cf135731268ee0e979a197443c15a04878e9cf3e80d022ad6c07e";
    };
    propagatedBuildInputs = [ OLEStorage_Lite ParseRecDescent ];
    meta = {
      description = "Write to a cross platform Excel binary file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstract = buildPerlPackage rec {
    name = "SQL-Abstract-1.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "9f44afe031a0cc63a6ccabaa46ba7ec58ef4db940559cee7fbc2dfbbf37bccab";
    };
    buildInputs = [ TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ HashMerge MROCompat Moo ];
    meta = {
      description = "Generate SQL from Perl data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstractLimit = buildPerlModule rec {
    name = "SQL-Abstract-Limit-0.141";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVEBAIRD/${name}.tar.gz";
      sha256 = "1qqh89kz065mkgyg5pjcgbf8qcpzfk8vf1lgkbwynknadmv87zqg";
    };
    propagatedBuildInputs = [ DBI SQLAbstract ];
    buildInputs = [ TestDeep TestException ];
  };

  SQLSplitStatement = buildPerlPackage rec {
    name = "SQL-SplitStatement-1.00020";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EM/EMAZEP/SQL-SplitStatement-1.00020.tar.gz;
      sha256 = "0bqg45k4c9qkb2ypynlwhpvzsl4ssfagmsalys18s5c79ps30z7p";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassAccessor ListMoreUtils RegexpCommon SQLTokenizer ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  SQLTokenizer = buildPerlPackage rec {
    name = "SQL-Tokenizer-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IZ/IZUT/SQL-Tokenizer-0.24.tar.gz;
      sha256 = "1qa2dfbzdlr5qqdam9yn78z5w3al5r8577x06qan8wv58ay6ka7s";
    };
  };

  SQLTranslator = buildPerlPackage rec {
    name = "SQL-Translator-0.11024";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "5bde9d6f67850089ef35a9296d6f53e5ee8e991438366b71477f3f27c1581bb1";
    };
    buildInputs = [ JSON TestDifferences TestException XMLWriter YAML ];
    propagatedBuildInputs = [ CarpClan DBI FileShareDir Moo PackageVariant ParseRecDescent TryTiny ];
    meta = {
      description = "SQL DDL transformations and more";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  PackageVariant = buildPerlPackage {
    name = "Package-Variant-1.003002";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Package-Variant-1.003002.tar.gz;
      sha256 = "b2ed849d2f4cdd66467512daa3f143266d6df810c5fae9175b252c57bc1536dc";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ImportInto strictures ];
    meta = {
      description = "Parameterizable packages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SortNaturally = buildPerlPackage rec {
    name = "Sort-Naturally-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746";
    };
  };

  Starlet = buildPerlPackage {
    name = "Starlet-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Starlet-0.28.tar.gz;
      sha256 = "245f606cdc8acadbe12e7e56dfa0752a8e8daa9a094373394fc17a45f5dde850";
    };
    buildInputs = [ LWP TestTCP ];
    propagatedBuildInputs = [ ParallelPrefork Plack ServerStarter ];
    meta = {
      description = "A simple, high-performance PSGI/Plack HTTP server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Starman = let version = "0.4014"; in buildPerlModule {
    name = "Starman-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Starman-${version}.tar.gz";
      sha256 = "1sbb5rb3vs82rlh1fjkgkcmj5pj62b4y9si4ihh45sl9m8c2qxx5";
    };
    buildInputs = [ LWP ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ DataDump HTTPDate HTTPMessage HTTPParserXS NetServer Plack TestTCP ];
    doCheck = false; # binds to various TCP ports
    meta = {
      inherit version;
      homepage = https://github.com/miyagawa/Starman;
      description = "High-performance preforking PSGI/Plack web server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsBasic = buildPerlPackage {
    name = "Statistics-Basic-1.6611";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JETTERO/Statistics-Basic-1.6611.tar.gz;
      sha256 = "1ywl398z42hz9w1k0waf1caa6agz8jzsjlf4rzs1lgpx2mbcwmb8";
    };
    propagatedBuildInputs = [ NumberFormat ];
    meta = {
      license = "open_source";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StatisticsDescriptive = buildPerlModule {
    name = "Statistics-Descriptive-3.0612";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Statistics-Descriptive-3.0612.tar.gz;
      sha256 = "772413148e5e00efb32f277c4254aa78b9112490a896208dcd0025813afdbf7a";
    };
    meta = {
      #homepage = http://web-cpan.berlios.de/modules/Statistics-Descriptive/; # berlios shut down; I found no replacement
      description = "Module of basic descriptive statistical functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ ListMoreUtils ];
  };

  StatisticsDistributions = buildPerlPackage rec {
    name = "Statistics-Distributions-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKEK/Statistics-Distributions-1.02.tar.gz;
      sha256 = "1j1kswl98f4i9dn176f9aa3y9bissx2sscga5jm3gjl4pxm3k7zr";
    };
  };

  StatisticsTTest = buildPerlPackage rec {
    name = "Statistics-TTest-1.1.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YU/YUNFANG/Statistics-TTest-1.1.0.tar.gz;
      sha256 = "0rkifgzm4rappiy669dyi6lyxn2sdqaf0bl6gndlfa67b395kndj";
    };
    propagatedBuildInputs = [ StatisticsDescriptive StatisticsDistributions ];
  };

  Storable = buildPerlPackage {
    name = "Storable-2.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMS/Storable-2.51.tar.gz;
      sha256 = "a566b792112bbba21131ec1d7a2bf78170c648484895283ae53c7f0c3dc2f0be";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StreamBuffered = buildPerlPackage {
    name = "Stream-Buffered-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Stream-Buffered-0.03.tar.gz;
      sha256 = "0fs2n9zw6isfkha2kbqrvl9mwg572x1x0jlfaps0qsyynn846bcv";
    };
    meta = {
      homepage = http://plackperl.org;
      description = "Temporary buffer to save bytes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  strictures = buildPerlPackage rec {
    name = "strictures-2.000003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "08mgvf1d2651gsg3jgjfs13878ndqa4ji8vfsda9f7jjd84ymy17";
    };
    meta = {
      homepage = http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/strictures.git;
      description = "Turn on strict and make all warnings fatal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringApprox = buildPerlPackage rec {
    name = "String-Approx-3.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/${name}.tar.gz";
      sha256 = "43201e762d8699cb0ac2c0764a5454bdc2306c0771014d6c8fba821480631342";
    };
  };

  StringCamelCase = buildPerlPackage rec {
    name = "String-CamelCase-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HI/HIO/String-CamelCase-0.04.tar.gz;
      sha256 = "1a8i4yzv586svd0pbxls7642vvmyiwzh4x2xyij8gbnfxsydxhw9";
    };
  };

  StringCRC32 = buildPerlPackage rec {
      name = "String-CRC32-1.6";
      src = fetchurl {
        url = mirror://cpan/authors/id/L/LE/LEEJO/String-CRC32-1.6.tar.gz;
        sha256 = "0mf545w014f9rwp2020h17dn8kfp7q1zgwrsfv0rpn89c61in8bh";
      };
      meta = {
        maintainers = with maintainers; [ ];
        platforms   = stdenv.lib.platforms.unix;
      };
  };

  StringErrf = buildPerlPackage {
    name = "String-Errf-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Errf-0.008.tar.gz;
      sha256 = "1nyn9s52jgbffrsv0m7rhcx1awjj43n68bfjlap8frdc7mw6y4xf";
    };
    buildInputs = [ JSONMaybeXS TimeDate ];
    propagatedBuildInputs = [ StringFormatter ];
    meta = {
      description = "A simple sprintf-like dialect";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringEscape = buildPerlPackage rec {
    name = "String-Escape-2010.002";
    src = fetchurl {
        url = mirror://cpan/authors/id/E/EV/EVO/String-Escape-2010.002.tar.gz;
        sha256 = "12ls7f7847i4qcikkp3skwraqvjphjiv2zxfhl5d49326f5myr7x";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringFlogger = buildPerlPackage rec {
    name = "String-Flogger-1.101245";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "aa03c08e01f802a358c175c6093c02adf9688659a087a8ddefdc3e9cef72640b";
    };
    propagatedBuildInputs = [ JSONMaybeXS SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/String-Flogger;
      description = "String munging for loggers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringFormat = buildPerlPackage rec {
    name = "String-Format-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SREZIC/String-Format-1.18.tar.gz;
      sha256 = "0y77frxzjifd4sw0j19cc346ysas1mya84rdxaz279lyin7plhcy";
    };
  };

  StringFormatter = buildPerlPackage {
    name = "String-Formatter-0.102084";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Formatter-0.102084.tar.gz;
      sha256 = "0mlwm0rirv46gj4h072q8gdync5zxxsxy8p028gdyrhczl942dc3";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = with stdenv.lib; {
      description = "Build sprintf-like functions of your own";
      license = licenses.gpl2;
    };
  };

  StringMkPasswd = buildPerlPackage {
    name = "String-MkPasswd-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.05.tar.gz;
      sha256 = "15lvcc8c9hp6mg3jx02wd3b85aphn8yl5db62q3pam04c0sgh42k";
    };
  };

  StringRewritePrefix = buildPerlPackage {
    name = "String-RewritePrefix-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.007.tar.gz;
      sha256 = "18nxl1vgkcx0r7ifkmbl9fp73f8ihiqhqqf3vq6sj5b3cgawrfsw";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Rewrite strings based on a set of known prefixes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringShellQuote = buildPerlPackage {
    name = "String-ShellQuote-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz;
      sha256 = "0dfxhr6hxc2majkkrm0qbx3qcbykzpphbj2ms93dc86f7183c1p6";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;

      # http://cpansearch.perl.org/src/ROSCH/String-ShellQuote-1.04/README
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ShellCommand = buildPerlPackage {
    name = "Shell-Command-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Shell-Command-0.06.tar.gz;
      sha256 = "1lgc2rb3b5a4lxvbq0cbg08qk0n2i88srxbsz93bwi3razpxxr7k";
    };
  };

  StringToIdentifierEN = buildPerlPackage rec {
    name = "String-ToIdentifier-EN-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "12nw7h2yiybhdw0vnnpc7bif8ylhsn6kqf6s39dsrf9h54iq9yrs";
    };
    propagatedBuildInputs = [ LinguaENInflectPhrase TextUnidecode namespaceclean ];
  };

  StringTruncate = buildPerlPackage {
    name = "String-Truncate-1.100602";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Truncate-1.100602.tar.gz;
      sha256 = "0vjz4fd4cvcy12gk5bdha7z73ifmfpmk748khha94dhiq3pd98xa";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      description = "A module for when strings are too long to be displayed in";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringTT = buildPerlPackage {
    name = "String-TT-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/String-TT-0.03.tar.gz;
      sha256 = "1asjr79wqcl9wk96afxrm1yhpj8lk9bk8kyz78yi5ypr0h55yq7p";
    };
    buildInputs = [ TestException TestSimple13 TestTableDriven ];
    propagatedBuildInputs = [ PadWalker SubExporter TemplateToolkit ];
    meta = {
      description = "Use TT to interpolate lexical variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringUtil = let version = "1.26"; in buildPerlModule {
    name = "String-Util-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKO/String-Util-${version}.tar.gz";
      sha256 = "0bgs6fsc0gcj9qa1k98nwjp4xbkl3ckz71rz3qhmav0lgkrr96pl";
    };
    meta = {
      inherit version;
      description = "String::Util -- String processing utilities";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ NumberMisc ];
    buildInputs = [ TestToolbox ];
  };

  libfile-stripnondeterminism = buildPerlPackage rec {
    name = "libstrip-nondeterminism-${version}";
    version = "0.016";

    src = fetchurl {
      url = "http://http.debian.net/debian/pool/main/s/strip-nondeterminism/strip-nondeterminism_${version}.orig.tar.gz";
      sha256 = "1y9lfhxgwyysybing72n3hng2db5njpk2dbb80vskdz75r7ffqjp";
    };

    buildInputs = [ ArchiveZip_1_53 pkgs.file ];
  };


  strip-nondeterminism = buildPerlPackage rec {
    name = "strip-nondeterminism-${version}";
    version = "0.016";

    src = fetchurl {
      url = "http://http.debian.net/debian/pool/main/s/strip-nondeterminism/strip-nondeterminism_${version}.orig.tar.gz";
      sha256 = "1y9lfhxgwyysybing72n3hng2db5njpk2dbb80vskdz75r7ffqjp";
    };

    buildInputs = [ ArchiveZip_1_53 libfile-stripnondeterminism pkgs.file ];

    meta = with stdenv.lib; {
      description = "A Perl module for stripping bits of non-deterministic information";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ pSub ];
    };
  };

  SubExporter = buildPerlPackage {
    name = "Sub-Exporter-0.987";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-0.987.tar.gz;
      sha256 = "1ml3n1ck4ln9qjm2mcgkczj1jb5n1fkscz9c4x23v4db0glb4g2l";
    };
    propagatedBuildInputs = [ DataOptList ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterForMethods = buildPerlPackage rec {
    name = "Sub-Exporter-ForMethods-0.100052";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "421fbba4f6ffcf13c4335f2c20630d709e6fa659c07545d094dbc5a558ad3006";
    };
    buildInputs = [ namespaceautoclean ];
    propagatedBuildInputs = [ SubExporter SubName ];
    meta = {
      homepage = https://github.com/rjbs/Sub-Exporter-ForMethods;
      description = "Helper routines for using Sub::Exporter to build methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SubExporterGlobExporter = buildPerlPackage {
    name = "Sub-Exporter-GlobExporter-0.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-GlobExporter-0.005.tar.gz;
      sha256 = "0qvsvfvfyk69v2ygjnyd5sh3bgbzd6f7k7mgv0zws1yywvpmxi1g";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter-globexporter;
      description = "Export shared globs with Sub::Exporter collectors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterProgressive = buildPerlPackage {
    name = "Sub-Exporter-Progressive-0.001013";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz;
      sha256 = "0mn0x8mkh36rrsr58s1pk4srwxh2hbwss7sv630imnk49navfdfm";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Only use Sub::Exporter if you need it";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterUtil = let version = "0.987"; in buildPerlPackage {
    name = "Sub-Exporter-Util-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-${version}.tar.gz";
      sha256 = "1ml3n1ck4ln9qjm2mcgkczj1jb5n1fkscz9c4x23v4db0glb4g2l";
    };
    propagatedBuildInputs = [ DataOptList ParamsUtil SubInstall ];
    meta = {
      inherit version;
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f";
    };
    meta = {
      description = "Retrieve names of code references";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubInfo = buildPerlPackage rec {
    name = "Sub-Info-0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "ea3056d696bdeff21a99d340d5570887d39a8cc47bff23adfc82df6758cdd0ea";
    };
    buildInputs = [ TestSimple13 ];
    propagatedBuildInputs = [ Importer ];
    meta = {
      description = "Tool for inspecting subroutines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SubInstall = buildPerlPackage {
    name = "Sub-Install-0.928";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Install-0.928.tar.gz;
      sha256 = "03zgk1yh128gciyx3q77zxzxg9kf8yy2gm46gdxqi24mcykngrb1";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Install subroutines into packages easily";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubName = buildPerlPackage rec {
    name = "Sub-Name-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "bd32e9dee07047c10ae474c9f17d458b6e9885a6db69474c7a494ccc34c27117";
    };
    buildInputs = [ BC DevelCheckBin ];
    meta = {
      homepage = https://github.com/p5sagit/Sub-Name;
      description = "(Re)name a sub";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SubOverride = buildPerlPackage rec {
    name = "Sub-Override-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "1d955qn44brkcfif3gi0q2vvvqahny6rax0vr068x5i9yz0ng6lk";
    };
    buildInputs = [ TestFatal ];
  };

  SubQuote = buildPerlPackage rec {
    name = "Sub-Quote-2.005000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "44b145111bee7b0001818e77f7ce587153232dbc97351f4c5ed34522372b64ff";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Efficient generation of subroutines via string eval";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubUplevel = buildPerlPackage {
    name = "Sub-Uplevel-0.2800";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2800.tar.gz;
      sha256 = "14z2xjiw931wizcx3mblmby753jspvfm321d6chs907nh0xzdwxl";
    };
    meta = {
      homepage = https://github.com/dagolden/sub-uplevel;
      description = "Apparently run a function in a higher stack frame";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SVNSimple = buildPerlPackage rec {
    name = "SVN-Simple-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/${name}.tar.gz";
      sha256 = "1ysgi38zx236cxz539k6d6rw5z0vc70rrglsaf5fk6rnwilw2g6n";
    };
    propagatedBuildInputs = [ pkgs.subversionClient ];
  };

  Swim = buildPerlPackage rec {
    name = "Swim-0.1.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "ac747362afec12a0ba30ffdfff8765f80a124dff8ebcb238326fa627e07daae8";
    };
    buildInputs = [ FileShareDirInstall ];
    propagatedBuildInputs = [ HTMLEscape HashMerge IPCRun Pegex TextAutoformat YAMLLibYAML ];
    meta = {
      homepage = https://github.com/ingydotnet/swim-pm;
      description = "See What I Mean?!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Switch = buildPerlPackage rec {
    name = "Switch-2.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz";
      sha256 = "0xbdjdgzfj9zwa4j3ipr8bfk7bcici4hk89hq5d27rhg2isljd9i";
    };
    doCheck = false;                             # FIXME: 2/293 test failures
  };

  SymbolGlobalName = buildPerlPackage {
    name = "Symbol-Global-Name-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Symbol-Global-Name-0.05.tar.gz;
      sha256 = "0f7623e9d724760aa64040222da1d82f1188586791329261cc60dad1d60d6a92";
    };
    meta = {
      description = "Finds name and type of a global variable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SymbolUtil = buildPerlModule {
    name = "Symbol-Util-0.0203";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Symbol-Util-0.0203.tar.gz;
      sha256 = "0cnwwrd5d6i80f33s7n2ak90rh4s53ss7q57wndrpkpr4bfn3djm";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  syntax = buildPerlPackage {
    name = "syntax-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHAYLON/syntax-0.004.tar.gz;
      sha256 = "fe19b6da8a8f43a5aa2ee571441bc0e339fb156d0081c157a1a24e9812c7d365";
    };
    propagatedBuildInputs = [ DataOptList namespaceclean ];
    meta = {
      homepage = https://github.com/phaylon/syntax/wiki;
      description = "Activate syntax extensions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SyntaxKeywordJunction = buildPerlPackage rec {
    name = "Syntax-Keyword-Junction-0.003008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "8b4975f21b1992a7e6c2df5dcc92b254c61925595eddcdfaf0b1498717aa95ef";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ syntax ];
    meta = {
      homepage = https://github.com/frioux/Syntax-Keyword-Junction;
      description = "Perl6 style Junction operators in Perl5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysCPU = buildPerlPackage rec {
    name = "Sys-CPU-0.61";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MZ/MZSANFORD/${name}.tar.gz";
      sha256 = "1r6976bs86j7zp51m5vh42xlyah951jgdlkimv202413kjvqc2i5";
    };
    buildInputs = stdenv.lib.optional stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.Carbon;
  };

  SysHostnameLong = buildPerlPackage rec {
    name = "Sys-Hostname-Long-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTT/${name}.tar.gz";
      sha256 = "1jv5n8jv48c1p8svjsigyxndv1ygsq8wgwj9c7ypx1vaf3rns679";
    };
    doCheck = false; # no `hostname' in stdenv
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  SysSigAction = buildPerlPackage {
    name = "Sys-SigAction-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBAXTER/Sys-SigAction-0.23.tar.gz;
      sha256 = "c4ef6c9345534031fcbbe2adc347fc7194d47afc945e7a44fac7e9563095d353";
    };
    meta = {
      description = "Perl extension for Consistent Signal Handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysSyslog = buildPerlPackage rec {
    name = "Sys-Syslog-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAPER/${name}.tar.gz";
      sha256 = "fe28e47b70b77aaae754385fe1470d174289e7b6908efa247d2e52486516fbb7";
    };
    meta = {
      description = "Perl interface to the UNIX syslog(3) calls";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SysVirt = buildPerlPackage rec {
    version = "4.1.0";
    name = "Sys-Virt-${version}";
    src = assert version == pkgs.libvirt.version; pkgs.fetchgit {
      url = git://libvirt.org/libvirt-perl.git;
      rev = "v${version}";
      sha256 = "0m0snv6gqh97nh1c31qvbm4sdzp49vixn7w3r69h6a5r71sn78x4";
    };
    propagatedBuildInputs = [XMLXPath];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [TestPodCoverage TimeHiRes TestPod pkgs.libvirt];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  TAPParserSourceHandlerpgTAP = buildPerlModule rec {
    name = "TAP-Parser-SourceHandler-pgTAP-3.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "15q46y2hbp2ij5n9ir76lmspqj3n8gb0z9l5ipb5g7q90l160m4k";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Tap-Parser-Sourcehandler-pgTAP/;
      description = "Stream TAP from pgTAP test scripts";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  TaskCatalystTutorial = buildPerlPackage rec {
    name = "Task-Catalyst-Tutorial-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "75b1b2d96155647842587146cefd0de30943b85195e8e3eca51e0f0b8642d61e";
    };
    buildInputs = [TestPodCoverage];
    propagatedBuildInputs = [ CatalystAuthenticationStoreDBIxClass CatalystControllerHTMLFormFu CatalystDevel CatalystManual CatalystModelDBICSchema CatalystPluginAuthentication CatalystPluginAuthorizationACL CatalystPluginAuthorizationRoles CatalystPluginSession CatalystPluginSessionStateCookie CatalystPluginSessionStoreFastMmap CatalystPluginStackTrace CatalystRuntime CatalystViewTT DBIxClass ];
    meta = {
      description = "Everything you need to follow the Catalyst Tutorial";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TaskFreecellSolverTesting = buildPerlModule rec {
    name = "Task-FreecellSolver-Testing-v0.0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "ce8960c0250a9947ae5b4485e8a3e807bb2d87b1120096464b3d2247d2c194ff";
    };
    buildInputs = [ ModuleBuild perl ];
    propagatedBuildInputs = [ EnvPath FileWhich GamesSolitaireVerify Inline InlineC ListMoreUtils Moo MooX PathTiny StringShellQuote TaskTestRunAllPlugins TemplateToolkit TestDataSplit TestDifferences TestPerlTidy TestRunPluginTrimDisplayedFilenames TestRunValgrind TestTrailingSpace YAMLLibYAML ];
    meta = {
      homepage = https://metacpan.org/release/Task-FreecellSolver-Testing;
      description = "Install the CPAN dependencies of the Freecell Solver test suite";
      license = stdenv.lib.licenses.mit;
    };
  };

  TaskPlack = buildPerlModule rec {
    name = "Task-Plack-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0ajwkyr9nwn11afi6fz6kx4bi7a3p8awjsldmsakz3sl0s42pmbr";
    };
    propagatedBuildInputs = [ Plack PSGI ModuleBuildTiny ];
  };

  TaskTestRunAllPlugins = buildPerlModule rec {
    name = "Task-Test-Run-AllPlugins-0.0105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "fd43bd053aa884a5abca851f145a0e29898515dcbfc3512f18cd0d86d28eb0a9";
    };
    buildInputs = [ TestRun TestRunCmdLine TestRunPluginAlternateInterpreters TestRunPluginBreakOnFailure TestRunPluginColorFileVerdicts TestRunPluginColorSummary TestRunPluginTrimDisplayedFilenames ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Specifications for installing all the Test::Run";
      license = stdenv.lib.licenses.mit;
    };
  };

  TaskWeaken = buildPerlPackage {
    name = "Task-Weaken-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Task-Weaken-1.05.tar.gz;
      sha256 = "0p5ryr3421p5rqj6dk5dcvxsml5gl9skbn7gv4szk50fimrvzww5";
    };
    meta = {
      description = "Ensure that a platform has weaken support";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginAutoformat = buildPerlPackage {
    name = "Template-Plugin-Autoformat-2.77";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KARMAN/Template-Plugin-Autoformat-2.77.tar.gz;
      sha256 = "bddfb4919f0abb2a2be7a9665333e0d4e098032f0e383dbaf04c4d896c7486ed";
    };
    propagatedBuildInputs = [ TemplateToolkit TextAutoformat ];
    meta = {
      homepage = https://github.com/karpet/template-plugin-autoformat;
      description = "TT plugin for Text::Autoformat";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginClass = buildPerlPackage {
    name = "Template-Plugin-Class-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Template-Plugin-Class-0.14.tar.gz;
      sha256 = "1hq7jy6zg1iaslsyi05afz0i944y9jnv3nb4krkxjfmzwy5gw106";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplatePluginIOAll = buildPerlPackage {
    name = "Template-Plugin-IO-All-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XERN/Template-Plugin-IO-All-0.01.tar.gz;
      sha256 = "1f7445422a21932e09bbef935766e0af6b7cceb088e9d8e030cd7a84bcdc5ee4";
    };
    propagatedBuildInputs = [ IOAll TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ eelco ];
      description = "Perl Template Toolkit Plugin for IO::All";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginJavaScript = buildPerlPackage {
    name = "Template-Plugin-JavaScript-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Template-Plugin-JavaScript-0.02.tar.gz;
      sha256 = "1mqqqs0dhfr6bp1305j9ns05q4pq1n3f561l6p8848k5ml3dh87a";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplatePluginJSONEscape = buildPerlPackage {
    name = "Template-Plugin-JSON-Escape-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NA/NANTO/Template-Plugin-JSON-Escape-0.02.tar.gz;
      sha256 = "051a8b1d3bc601d58fc51e246067d36450cfe970278a0456e8ab61940f13cd86";
    };
    propagatedBuildInputs = [ JSON TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplateTimer = buildPerlPackage {
    name = "Template-Timer-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-1.00.tar.gz;
      sha256 = "1d3pbcx1kz73ncg8s8lx3ifwphz838qy0m40gdar7790cnrlqcdp";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Rudimentary profiling for Template Toolkit";
      license = with stdenv.lib.licenses; [ artistic2 gpl3 ];
    };
  };

  TemplateTiny = buildPerlPackage {
    name = "Template-Tiny-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Template-Tiny-1.12.tar.gz;
      sha256 = "073e062c630b51dfb725cd6485a329155cb72d5c596e8cb698eb67c4566f0a4a";
    };
    meta = {
      description = "Template Toolkit reimplemented in as little code as possible";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplateToolkit = buildPerlPackage rec {
    name = "Template-Toolkit-2.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-2.27.tar.gz;
      sha256 = "1p66y9mwj7nkc1bcwgp2xjw78l4x5bzhj0xghp2k80ad4q1s848k";
    };
    propagatedBuildInputs = [ AppConfig ];
    meta = {
      description = "Comprehensive template processing system";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ CGI TestLeakTrace ];
  };

   TemplateGD = buildPerlPackage rec {
    name = "Template-GD-2.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-GD-2.66.tar.gz;
      sha256 = "98523c8192f2e8184042e5a2e172bd767ac289dd2e480f35f680dce32160905b";
    };
    propagatedBuildInputs = [ GD TemplateToolkit ];
    meta = {
      description = "GD plugin(s) for the Template Toolkit";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermANSIColor = buildPerlPackage {
    name = "Term-ANSIColor-4.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RR/RRA/Term-ANSIColor-4.06.tar.gz;
      sha256 = "8161c7434b1984bde588d75f22c786c46cb6d35d264d58111db0b82537de4bad";
    };
    meta = {
      description = "Color output using ANSI escape sequences";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermCap = let version = "1.17"; in buildPerlPackage {
    name = "Term-Cap-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTOWE/Term-Cap-${version}.tar.gz";
      sha256 = "0qyicyk4aikw6w3fm8c4y6hd7ff70crkl6bf64qmiakbgxy9p6p7";
    };
    meta = {
      inherit version;
      description = "Perl termcap interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermEncoding = buildPerlPackage {
    name = "Term-Encoding-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Term-Encoding-0.02.tar.gz;
      sha256 = "f274e72346a0c0cfacfb53030ac1e38b57425512fc5bdc5cd9ef75ab0f26cfcc";
    };
    meta = {
      description = "Detect encoding of the current terminal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBar = buildPerlPackage rec {
    name = "Term-ProgressBar-2.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/${name}.tar.gz";
      sha256 = "66994f1a6ca94d8d92e3efac406142fb0d05033360c0acce2599862db9c30e44";
    };
    buildInputs = [ CaptureTiny TestException ];
    propagatedBuildInputs = [ ClassMethodMaker TermReadKey ];
    meta = {
      description = "Provide a progress meter on a standard terminal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarQuiet = buildPerlPackage {
    name = "Term-ProgressBar-Quiet-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Term-ProgressBar-Quiet-0.31.tar.gz;
      sha256 = "25675292f588bc29d32e710cf3667da9a2a1751e139801770a9fdb18cd2184a6";
    };
    propagatedBuildInputs = [ IOInteractive TermProgressBar ];
    meta = {
      description = "";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestMockObject ];
  };

  TermProgressBarSimple = buildPerlPackage {
    name = "Term-ProgressBar-Simple-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EV/EVDB/Term-ProgressBar-Simple-0.03.tar.gz;
      sha256 = "a20db3c67d5bdfd0c1fab392c6d1c26880a7ee843af602af4f9b53a7043579a6";
    };
    propagatedBuildInputs = [ TermProgressBarQuiet ];
    buildInputs = [ TestMockObject ];
  };

  TermReadKey = buildPerlPackage rec {
    name = "TermReadKey-${version}";
    version = "2.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTOWE/${name}.tar.gz";
      sha256 = "0hdj5mldpj3pyprd4hbbalfx9yjgi5p59gg2ixk9808f5v7q74sa";
    };
  };

  TermReadLineGnu = buildPerlPackage rec {
    name = "Term-ReadLine-Gnu-1.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAYASHI/${name}.tar.gz";
      sha256 = "575d32d4ab67cd656f314e8d0ee3d45d2491078f3b2421e520c4273e92eb9125";
    };
    buildInputs = [ pkgs.readline pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lreadline -lncursesw";

    # For some crazy reason Makefile.PL doesn't generate a Makefile if
    # AUTOMATED_TESTING is set.
    AUTOMATED_TESTING = false;

    # Makefile.PL looks for ncurses in Glibc's prefix.
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '$Config{libpth}' \
          "'${pkgs.ncurses.out}/lib'"
      '';

    # Tests don't work because they require /dev/tty.
    doCheck = false;

    meta = {
      homepage = https://sourceforge.net/projects/perl-trg/;
      description = "Perl extension for the GNU Readline/History Library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermReadLineTTYtter = buildPerlPackage rec {
    name = "Term-ReadLine-TTYtter-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz";
      sha256 = "14xcqhg1vrwgv65nd2z8xzn0wgb18i17pzkkh8m15cp1rqrk2dxc";
    };

    outputs = [ "out" ];

    meta = {
      description = "a modified version of T::RL::Perl with several new nonstandard features specific to TTYtter";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermShellUI = buildPerlPackage rec {
    name = "Term-ShellUI-0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRONSON/${name}.tar.gz";
      sha256 = "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb";
    };
  };

  TermSizeAny = buildPerlPackage {
    name = "Term-Size-Any-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Any-0.002.tar.gz;
      sha256 = "64fa5fdb1ae3a823134aaa95aec75354bc17bdd9ca12ba0a7ae34a7e51b3ded2";
    };
    propagatedBuildInputs = [ DevelHide TermSizePerl ];
    meta = {
      description = "Retrieve terminal size";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermSizePerl = buildPerlPackage {
    name = "Term-Size-Perl-0.031";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Perl-0.031.tar.gz;
      sha256 = "ae9a6746cb1b305ddc8f8d8ca46878552b9c1123628971e13a275183822f209e";
    };
    meta = {
      description = "Perl extension for retrieving terminal size (Perl version)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermTable = buildPerlPackage rec {
    name = "Term-Table-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "4db6118fbf862bd32a8402e1ee28ce2044d0e0887ef29b726e917ab4258a063a";
    };
    buildInputs = [ TestSimple13 ];
    propagatedBuildInputs = [ Importer ];
    meta = {
      description = "Format a header and rows into a table";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TermVT102 = buildPerlPackage {
    name = "Term-VT102-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AJ/AJWOOD/Term-VT102-0.91.tar.gz;
      sha256 = "f954e0310941d45c0fc3eb4a40f5d3a00d68119e277d303a1e6af11ded6fbd94";
    };
    meta = {
    };
  };

  TermVT102Boundless = buildPerlPackage {
    name = "Term-VT102-Boundless-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Term-VT102-Boundless-0.04.tar.gz;
      sha256 = "5bb88b5aecb44ebf56d3ac7240be80cd26def9dcf1ebeb4e77d9983dfc7a8f19";
    };
    propagatedBuildInputs = [ TermVT102 ];
    meta = {
      license = "unknown";
    };
  };

  TermAnimation = buildPerlPackage rec {
    name = "Term-Animation-2.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KB/KBAUCOM/${name}.tar.gz";
      sha256 = "7d5c3c2d4f9b657a8b1dce7f5e2cbbe02ada2e97c72f3a0304bf3c99d084b045";
    };
    propagatedBuildInputs = [ Curses ];
    meta = {
      description = "ASCII sprite animation framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Test = buildPerlPackage {
    name = "Test-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Test-1.26.tar.gz;
      sha256 = "f7701bd28e05e7f82fe9a181bbab38f53fa6aeae48d2a810da74d1b981d4f392";
    };
    meta = {
      description = "Provides a simple framework for writing test scripts";
    };
  };

  Test2PluginNoWarnings = buildPerlPackage rec {
     name = "Test2-Plugin-NoWarnings-0.06";
     src = fetchurl {
       url = mirror://cpan/authors/id/D/DR/DROLSKY/Test2-Plugin-NoWarnings-0.06.tar.gz;
       sha256 = "002qk6qsm0l6r2kaxywvc38w0yf0mlavgywq8li076pn6kcw3242";
     };
     propagatedBuildInputs = [ TestSimple13 ];
     buildInputs = [ IPCRun3 Test2Suite ];
     meta = {
       description = "Fail if tests warn";
       license = with stdenv.lib.licenses; [ artistic2 ];
       homepage = "http://metacpan.org/release/Test2-Plugin-NoWarnings";
     };
  };

  Test2Suite = buildPerlPackage rec {
    name = "Test2-Suite-0.000111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "4ca28df74c7c2f37fe63897c5041aee92fba4530544d0afc371e7d14a9b4d0ad";
    };
    propagatedBuildInputs = [ ModulePluggable ScopeGuard SubInfo TermTable TestSimple13 ];
    meta = {
      description = "Distribution with a rich set of tools built upon the Test2 framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestAbortable = buildPerlPackage rec {
     name = "Test-Abortable-0.002";
     src = fetchurl {
       url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Abortable-0.002.tar.gz;
       sha256 = "0v97y31j56f4mxw0vxyjbdprq4951h4wcdh4acnfm63np7wvg44p";
     };
     propagatedBuildInputs = [ SubExporter TestSimple13 ];
     buildInputs = [ TestNeeds ];
     meta = {
       description = "subtests that you can die your way out of ... but survive";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/rjbs/Test-Abortable";
     };
  };

  TestAssert = buildPerlModule {
    name = "Test-Assert-0.0504";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Assert-0.0504.tar.gz;
      sha256 = "194bzflmzc0cw5727kznbj1zwzj7gnj7nx1643zk2hshdjlnv8yg";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase constantboolean ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestAssertions = buildPerlPackage rec {
    name = "Test-Assertions-1.054";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBC/Test-Assertions-1.054.tar.gz;
      sha256 = "10026w4r3yv6k3vc6cby7d61mxddlqh0ls6z39c82f17awfy9p7w";
    };
    propagatedBuildInputs = [ LogTrace ];
  };

  TestAggregate = buildPerlModule rec {
    name = "Test-Aggregate-0.375";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/${name}.tar.gz";
      sha256 = "c6cc0abfd0d4fce85371acca93ec245381841d32b4caa2d6475e4bc8130427d1";
    };
    buildInputs = [ TestMost TestNoWarnings TestTrap ];
    meta = {
      description = "Aggregate C<*.t> tests to make them run faster";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  TestBase = buildPerlPackage rec {
    name = "Test-Base-0.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0fch1cvivnszbnwhpfmwv1rin04j5xkj1n1ylfmlxg6bm72qqdjj";
    };
    propagatedBuildInputs = [ Spiffy ];
    buildInputs = [ AlgorithmDiff TextDiff ];
  };

  TestCheckDeps = buildPerlPackage rec {
    name = "Test-CheckDeps-0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "1vjinlixxdx6gfcw8y1dw2rla8bfhi8nmgcqr3nffc7kqskcrz36";
    };
    propagatedBuildInputs = [ CPANMetaCheck ];
    meta = {
      description = "Check for presence of dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestClass = buildPerlPackage rec {
    name = "Test-Class-0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "099154ed8caf3ff97c71237fab952264ac1c03d9270737a56071cabe65991350";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ MROCompat ModuleRuntime TryTiny ];
    meta = {
      description = "Easily create test classes in an xUnit/JUnit style";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestCleanNamespaces = buildPerlPackage {
    name = "Test-CleanNamespaces-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-CleanNamespaces-0.22.tar.gz;
      sha256 = "862a221994dd413b2f350450f22c96f57cac78784b1aca1a8fc763fc5449aaca";
    };
    buildInputs = [ Filepushd Moo Mouse RoleTiny SubExporter TestDeep TestNeeds TestWarnings namespaceclean ];
    propagatedBuildInputs = [ PackageStash SubIdentify ];
    meta = {
      homepage = https://github.com/karenetheridge/Test-CleanNamespaces;
      description = "Check for uncleaned imports";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCommand = buildPerlModule {
    name = "Test-Command-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANBOO/Test-Command-0.11.tar.gz;
      sha256 = "0cwm3c4d49mdrbm6vgh78b3x8mk730l0zg8i7xb9z8bkx9pzr8r8";
    };
    meta = {
      homepage = https://github.com/danboo/perl-test-command;
      description = "Test routines for external commands ";
      license = with stdenv.lib.licenses; [ artistic1 gpl1 ];
    };
  };

  TestCompile = buildPerlModule rec {
    name = "Test-Compile-1.3.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EG/EGILES/Test-Compile-v1.3.0.tar.gz;
      sha256 = "77527e9477ac5260443c756367a7f7bc3d8f6c6ebbc561b0b2fb3f79303bad33";
    };
    propagatedBuildInputs = [ UNIVERSALrequire ];
    meta = {
      description = "Check whether Perl files compile correctly";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCPANMeta = buildPerlPackage {
    name = "Test-CPAN-Meta-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BA/BARBIE/Test-CPAN-Meta-0.25.tar.gz;
      sha256 = "f55b4f9cf6bc396d0fe8027267685cb2ac4affce897d0967a317fac6db5a8db5";
    };
    meta = {
      description = "Validate your CPAN META.yml files";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TestDataSplit = buildPerlModule rec {
    name = "Test-Data-Split-0.2.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "9ba0c27a9e23c5dd8ede7611a049180485acc512a63783e1d1843b6569db5ae7";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ IOAll ListMoreUtils MooX MooXlate ];
    meta = {
      description = "Split data-driven tests into several test scripts";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestDeep = buildPerlPackage {
    name = "Test-Deep-1.127";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-1.127.tar.gz;
      sha256 = "0s3jmyvkgk48piw46sxppx11nfsbzhmisb0y513iza8vqiczr35p";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  TestDir = buildPerlPackage {
    name = "Test-Dir-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MT/MTHURN/Test-Dir-1.16.tar.gz;
      sha256 = "7332b323913eb6a2684d094755196304b2f8606f70eaab913654ca91f273eac2";
    };
    meta = {
      description = "Test directory attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDifferences = buildPerlModule {
    name = "Test-Differences-0.64";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCANTRELL/Test-Differences-0.64.tar.gz;
      sha256 = "9f459dd9c2302a0a73e2f5528a0ce7d09d6766f073187ae2c69e603adf2eb276";
    };
    propagatedBuildInputs = [ CaptureTiny TextDiff ];
    meta = {
      description = "Test strings and data structures and show differences if not ok";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDistManifest = buildPerlModule {
    name = "Test-DistManifest-1.014";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-DistManifest-1.014.tar.gz;
      sha256 = "3d26c20df42628981cbfcfa5b1ca028c6ceadb344c1dcf97a25ad6a88b73d7c5";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ ModuleManifest ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-DistManifest;
      description = "Author test that validates a package MANIFEST";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestEOL = buildPerlPackage {
    name = "Test-EOL-2.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-EOL-2.00.tar.gz;
      sha256 = "0l3bxpsw0x7j9nclizcp53mnf9wny25dmg2iglfhzgnk0xfpwzwf";
    };
    meta = {
      homepage = https://metacpan.org/release/Test-EOL;
      description = "Check the correct line endings in your project";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestException = buildPerlPackage rec {
    name = "Test-Exception-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Test-Exception-0.43.tar.gz;
      sha256 = "0cxm7s4bg0xpxa6l6996a6iq3brr4j7p4hssnkc6dxv4fzq16sqm";
    };
    propagatedBuildInputs = [ SubUplevel ];
  };

  TestFailWarnings = buildPerlPackage {
    name = "Test-FailWarnings-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-FailWarnings-0.008.tar.gz;
      sha256 = "0vx9chcp5x8m0chq574p9fnfckh5gl94j7904rh9v17n568fyd6s";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      homepage = https://metacpan.org/release/Test-FailWarnings;
      description = "Add test failures if warnings are caught";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestFatal = buildPerlPackage rec {
    name = "Test-Fatal-0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "bcdcef5c7b2790a187ebca810b0a08221a63256062cfab3c3b98685d91d1cbb0";
    };
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Test-Fatal;
      description = "Incredibly simple helpers for testing code with exceptions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestFile = buildPerlPackage {
    name = "Test-File-1.443";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Test-File-1.443.tar.gz;
      sha256 = "61b4a6ab8f617c8c7b5975164cf619468dc304b6baaaea3527829286fa58bcd5";
    };
    buildInputs = [ Testutf8 ];
    meta = {
      description = "Check file attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFileContents = buildPerlModule {
    name = "Test-File-Contents-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-File-Contents-0.23.tar.gz;
      sha256 = "cd6fadfb910b34b4b53991ff231dad99929ca8850abec3ad0e2810c4bd7b1f3d";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-File-Contents/;
      description = "Test routines for examining the contents of files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFileShareDir = buildPerlPackage {
    name = "Test-File-ShareDir-1.001002";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/Test-File-ShareDir-1.001002.tar.gz;
      sha256 = "b33647cbb4b2f2fcfbde4f8bb4383d0ac95c2f89c4c5770eb691f1643a337aad";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassTiny FileCopyRecursive FileShareDir ScopeGuard ];
    meta = {
      homepage = https://github.com/kentfredric/Test-File-ShareDir;
      description = "Create a Fake ShareDir for your modules for testing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarness = buildPerlPackage {
    name = "Test-Harness-3.42";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz;
      sha256 = "0fd90d4efea82d6e262e6933759e85d27cbcfa4091b14bf4042ae20bab528e53";
    };
    doCheck = false; # makes assumptions about path to Perl
    meta = {
      homepage = http://testanything.org/;
      description = "Run Perl standard test scripts with statistics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarnessStraps = buildPerlModule {
    name = "Test-Harness-Straps-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Harness-Straps-0.30.tar.gz;
      sha256 = "8b00efaa35723c1a35c8c8f5fa46a99e4bc528dfa520352b54ac418ef6d1cfa8";
    };
    meta = {
      description = "Detailed analysis of test results";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHTTPServerSimple = buildPerlPackage {
    name = "Test-HTTP-Server-Simple-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Test-HTTP-Server-Simple-0.11.tar.gz;
      sha256 = "85c97ebd4deb805291b17277032da48807228f24f89b1ce2fb3c09f7a896bb78";
    };
    propagatedBuildInputs = [ HTTPServerSimple ];
    meta = {
      description = "Test::More functions for HTTP::Server::Simple";
    };
  };

  TestJSON = buildPerlModule {
    name = "Test-JSON-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-JSON-0.11.tar.gz;
      sha256 = "1cyp46w3q7dg89qkw31ik2h2a6mdx6pzdz2lmp8m0a61zjr8mh07";
    };
    propagatedBuildInputs = [ JSONAny ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ TestDifferences ];
  };

  TestKwalitee = buildPerlPackage rec {
     name = "Test-Kwalitee-1.27";
     src = fetchurl {
       url = mirror://cpan/authors/id/E/ET/ETHER/Test-Kwalitee-1.27.tar.gz;
       sha256 = "095kpj2011jk1mpnb07fs7yi190hmqh85mj662gx0dkpl9ic7a5w";
     };
     propagatedBuildInputs = [ ModuleCPANTSAnalyse ];
     buildInputs = [ CPANMetaCheck TestDeep TestWarnings ];
     meta = {
       description = "Test the Kwalitee of a distribution before you release it";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/karenetheridge/Test-Kwalitee";
     };
  };

  TestLeakTrace = buildPerlPackage rec {
    name = "Test-LeakTrace-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEEJO/Test-LeakTrace-0.16.tar.gz;
      sha256 = "00z4hcjra5nk700f3fgpy8fs036d7ry7glpn8g3wh7jzj7nrw22z";
    };
    meta = {
      description = "Traces memory leaks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RG/RGARCIA/Test-LongString-0.17.tar.gz;
      sha256 = "0kwp7rfr1i2amz4ckigkv13ah7jr30q6l5k4wk0vxl84myg39i5b";
    };
  };

  TestMemoryCycle = buildPerlPackage rec {
    name = "Test-Memory-Cycle-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "9d53ddfdc964cd8454cb0da4c695b6a3ae47b45839291c34cb9d8d1cfaab3202";
    };
    propagatedBuildInputs = [ DevelCycle PadWalker ];
    meta = {
      description = "Verifies code hasn't left circular references";
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.unix;
    };
  };

  TestMockClass = buildPerlModule {
    name = "Test-Mock-Class-0.0303";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Mock-Class-0.0303.tar.gz;
      sha256 = "00pkfqcz7b34q1mvx15k46sbxs22zcrvrbv15rnbn2na57z54bnd";
    };
    buildInputs = [ ClassInspector TestAssert TestUnitLite ];
    propagatedBuildInputs = [ FatalException Moose namespaceclean ];
    meta = with stdenv.lib; {
      description = "Simulating other classes";
      license = licenses.lgpl2Plus;
      maintainers = with maintainers; [ ];
      platforms   = platforms.unix;
    };
  };

  TestMockGuard = buildPerlModule rec {
    name = "Test-Mock-Guard-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/${name}.tar.gz";
      sha256 = "7f228a63f8d6ceb92aa784080a13e85073121b2835eca06d794f9709950dbd3d";
    };
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      homepage = https://github.com/zigorou/p5-test-mock-guard;
      description = "Simple mock test library using RAII";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockModule = buildPerlModule {
    name = "Test-MockModule-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFRANKS/Test-MockModule-0.13.tar.gz;
      sha256 = "0lwh6fvnc16r6d74vvh5h4b5a1spcslpjb3mcqbv23k01lm78wvl";
    };
    propagatedBuildInputs = [ SUPER ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  SUPER = buildPerlModule rec {
    name = "SUPER-1.20141117";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/${name}.tar.gz";
      sha256 = "1a620e7d60aee9b13b1b26a44694c43fdb2bba1755cfff435dae83c7d42cc0b2";
    };
    propagatedBuildInputs = [ SubIdentify ];
    meta = {
      description = "Control superclass method dispatch";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  TestMockObject = buildPerlPackage rec {
    name = "Test-MockObject-1.20161202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/${name}.tar.gz";
      sha256 = "14b225fff3645338697976dbbe2c39e44c1c93536855b78b3bbc6e9bfe94a0a2";
    };
    buildInputs = [ CGI TestException TestWarn ];
    propagatedBuildInputs = [ UNIVERSALcan UNIVERSALisa ];
    meta = {
      description = "Perl extension for emulating troublesome interfaces";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMoose = Moose;

  TestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "1vxv7y7jn71m8v8ag0z0dd0zadhxp264dppb40islcjl4g7r6x08";
    };
  };

  TestMockTimeHiRes = buildPerlModule rec {
     name = "Test-MockTime-HiRes-0.08";
     src = fetchurl {
       url = mirror://cpan/authors/id/T/TA/TARAO/Test-MockTime-HiRes-0.08.tar.gz;
       sha256 = "1hfykcjrls6ywgbd49w29c7apj3nq4wlyx7jzpd2glwmz2pgfjaz";
     };
     buildInputs = [ AnyEvent ModuleBuildTiny TestClass TestMockTime TestRequires ];
     meta = {
       description = "Replaces actual time with simulated high resolution time";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/tarao/perl5-Test-MockTime-HiRes";
     };
  };

  TestMojibake = buildPerlPackage {
    name = "Test-Mojibake-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Test-Mojibake-1.3.tar.gz;
      sha256 = "0cqvbwddgh0pfzmh989gkysi9apqj7dp7jkxfa428db9kgzpbzlg";
    };
    meta = {
      homepage = https://github.com/creaktive/Test-Mojibake;
      description = "Check your source for encoding misbehavior";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMore = TestSimple;

  TestMost = buildPerlPackage {
    name = "Test-Most-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-Most-0.35.tar.gz;
      sha256 = "0zv5dyzq55r28plffibcr7wd00abap0h2zh4s4p8snaiszsad5wq";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    meta = {
      description = "Most commonly needed test functions and features";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestDeep TestDifferences TestException TestSimple13 TestWarn ];
  };

  TestNeeds = buildPerlPackage rec {
    name = "Test-Needs-0.002005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "5a4f33983586edacdbe00a3b429a9834190140190dab28d0f873c394eb7df399";
    };
    meta = {
      description = "Skip tests when modules not available";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestNoTabs = buildPerlPackage {
    name = "Test-NoTabs-2.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-NoTabs-2.00.tar.gz;
      sha256 = "127kpl1va267qar2ia4c22xb96jby2jqnda3sj5pjgmxg8si26cg";
    };
    meta = {
      description = "Check the presence of tabs in your project";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestNoWarnings = buildPerlPackage {
    name = "Test-NoWarnings-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Test-NoWarnings-1.04.tar.gz;
      sha256 = "0v385ch0hzz9naqwdw2az3zdqi15gka76pmiwlgsy6diiijmg2k3";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Make sure you didn't emit any warnings while testing";
      license = stdenv.lib.licenses.lgpl21;
    };
  };

  TestObject = buildPerlPackage rec {
    name = "Test-Object-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-Object-0.08.tar.gz;
      sha256 = "65278964147837313f4108e55b59676e8a364d6edf01b3dc198aee894ab1d0bb";
    };
  };

  TestOutput = buildPerlPackage rec {
    name = "Test-Output-1.031";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Test-Output-1.031.tar.gz;
      sha256 = "193y1xjvgc1p9pdgdwps2127knvpz9wc1xh6gmr74y3ihmqz7f7q";
    };
    propagatedBuildInputs = [ CaptureTiny ];
  };

  TestPerlCritic = buildPerlModule rec {
    name = "Test-Perl-Critic-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-Perl-Critic-1.04.tar.gz;
      sha256 = "28f806b5412c7908b56cf1673084b8b44ce1cb54c9417d784d91428e1a04096e";
    };
    propagatedBuildInputs = [ MCE PerlCritic ];
  };

  TestPerlTidy = buildPerlPackage rec {
    name = "Test-PerlTidy-20130104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LA/LARRYL/${name}.tar.gz";
      sha256 = "3f15d9f3f4811e348594620312258d75095237925b491ada623fa73ac9d2b9c8";
    };
    propagatedBuildInputs = [ FileFinder FileSlurp PerlTidy TextDiff ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPod = buildPerlPackage rec {
    name = "Test-Pod-1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1yvy5mc4j3s2h4aizryvark2nm58g2c6zhw9mlx9wmsavz7d78f1";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod/;
      description = "Check for POD errors in files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodCoverage = buildPerlPackage rec {
    name = "Test-Pod-Coverage-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Test-Pod-Coverage-1.10.tar.gz;
      sha256 = "1m203mhgfilz7iqc8mxaw4lw02fz391mni3n25sfx7nryylwrja8";
    };
    propagatedBuildInputs = [ PodCoverage ];
  };

  TestPodLinkCheck = buildPerlModule rec {
    name = "Test-Pod-LinkCheck-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/${name}.tar.gz";
      sha256 = "2bfe771173c38b69eeb089504e3f76511b8e45e6a9e6dac3e616e400ea67bcf0";
    };
    buildInputs = [ ModuleBuildTiny TestPod ];
    propagatedBuildInputs = [ CaptureTiny Moose podlinkcheck ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod-LinkCheck/;
      description = "Tests POD for invalid links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodNo404s = buildPerlModule rec {
    name = "Test-Pod-No404s-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/Test-Pod-No404s-0.02.tar.gz";
      sha256 = "0ycfghsyl9f31kxdppjwx2g5iajrqh3fyywz0x7d8ayndw2hdihi";
    };
    propagatedBuildInputs = [ LWP URIFind ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod-No404s/;
      description = "Checks POD for any http 404 links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ ModuleBuildTiny TestPod ];
  };

  TestPortabilityFiles = buildPerlPackage {
    name = "Test-Portability-Files-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/Test-Portability-Files-0.09.tar.gz;
      sha256 = "16d31fa941af1a79faec0192e09880cb19225cde649c03d2e3ceda9b455a621c";
    };
    meta = {
      description = "Check file names portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequires = buildPerlPackage rec {
    name = "Test-Requires-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "1d9f481lj12cw1ciil46xq9nq16p6a90nm7yrsalpf8asn8s6s17";
    };
    meta = {
      description = "Checks to see if the module can be loaded";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequiresInternet = buildPerlPackage rec {
     name = "Test-RequiresInternet-0.05";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MA/MALLEN/Test-RequiresInternet-0.05.tar.gz;
       sha256 = "0gl33vpj9bb78pzyijp884b66sbw6jkh1ci0xki8rmf03hmb79xv";
     };
     meta = {
       description = "Easily test network connectivity";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://metacpan.org/dist/Test-RequiresInternet";
     };
  };

  TestRoo = buildPerlPackage rec {
    name = "Test-Roo-1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "1mnym49j1lj7gzylma5b6nr4vp75rmgz2v71904v01xmxhy9l4i1";
    };

    propagatedBuildInputs = [ Moo MooXTypesMooseLike SubInstall strictures ];
    buildInputs = [ CaptureTiny ];
  };

  TestRoutine = buildPerlPackage {
    name = "Test-Routine-0.025";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Routine-0.025.tar.gz;
      sha256 = "13gxczy0mx3rqnp55vc0j2d936qldrimmad87nmf4wrj0kd2lw92";
    };
    buildInputs = [ TestAbortable TestFatal ];
    propagatedBuildInputs = [ Moose TestSimple13 namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Test-Routine;
      description = "Composable units of assertion";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestRun = buildPerlModule rec {
    name = "Test-Run-0.0304";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "f3feaf9c4494c0b3a5294228cab27efe93653b7e0bbd7fbb99b94b65b247f323";
    };
    buildInputs = [ TestTrap ];
    propagatedBuildInputs = [ IPCSystemSimple ListMoreUtils MooseXStrictConstructor TextSprintfNamed UNIVERSALrequire ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Base class to run standard TAP scripts";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunCmdLine = buildPerlModule rec {
    name = "Test-Run-CmdLine-0.0131";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "cceeeecd3f4b2f1d2929f3ada351c1ade23a8ac73ef0486dc6e9605ebcdaef18";
    };
    buildInputs = [ TestRun TestTrap ];
    propagatedBuildInputs = [ MooseXGetopt UNIVERSALrequire YAMLLibYAML ];
    meta = {
      homepage = http://web-cpan.berlios.de/modules/Test-Run/;
      description = "Analyze tests from the command line using Test::Run";
      license = stdenv.lib.licenses.mit;
    };
   };

  TestRunPluginAlternateInterpreters = buildPerlModule rec {
    name = "Test-Run-Plugin-AlternateInterpreters-0.0124";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "eecb3830d350b5d7853322df4f3090af42ff17e9c31075f8d4f69856c968bff3";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Define different interpreters for different test scripts with Test::Run";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginBreakOnFailure = buildPerlModule rec {
    name = "Test-Run-Plugin-BreakOnFailure-0.0.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-BreakOnFailure-v0.0.5.tar.gz;
      sha256 = "e422eb64a2fa6ae59837312e37ab88d68b4945148eb436a3774faed5074f0430";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Stop processing the entire test suite";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginColorFileVerdicts = buildPerlModule rec {
    name = "Test-Run-Plugin-ColorFileVerdicts-0.0124";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0418f03abe241f5a3c2a2ab3dd2679d11eee42c9e1f5b5a6ea80d9e238374302";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap ];
    propagatedBuildInputs = [ Moose ];
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Make the file verdict ('ok', 'NOT OK')";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginColorSummary = buildPerlModule rec {
    name = "Test-Run-Plugin-ColorSummary-0.0202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "ea4fb6768c4f6645cedf87d9b7c6baf97364ebc6f4171e4dd5f68939fb2bdd3a";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap ];
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "A Test::Run plugin that";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginTrimDisplayedFilenames = buildPerlModule rec {
    name = "Test-Run-Plugin-TrimDisplayedFilenames-0.0125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "2255bc5cb6ab65ee4dfff3bcdf007fb74785ff3bb439a9cef5052c66d80424a5";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Trim the first components";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunValgrind = buildPerlModule rec {
    name = "Test-RunValgrind-0.2.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "70947565ad0be3e5d0cd9aca9e1fd0cb07c873e574310e92e8eca629ec6cd631";
    };
    buildInputs = [ TestTrap ];
    propagatedBuildInputs = [ PathTiny ];
    meta = {
      description = "Tests that an external program is valgrind-clean";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestScript = buildPerlPackage rec {
    name = "Test-Script-1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "1ca4mwcghgpdrpcg6xc0iwp3ga9c94qni9zf4hhqq8lpjwdyg89k";
    };

    buildInputs = [ Test2Suite ];

    propagatedBuildInputs = [ CaptureTiny ProbePerl TestSimple13 ];
  };

  TestSharedFork = buildPerlPackage rec {
    name = "Test-SharedFork-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "17y52j20k1bs9dgf4n6rhh9dn4cfxxbnfn2cfs7pb00fc5jyhci9";
    };
    buildInputs = [ TestRequires ];
    meta = {
      homepage = https://github.com/tokuhirom/Test-SharedFork;
      description = "Fork test";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSimple = null;

  TestSimple13 = buildPerlPackage rec {
    name = "Test-Simple-1.302135";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Test-Simple-1.302135.tar.gz;
      sha256 = "889b59d5fb5955b5d15dbef1020aa2e9a3ccafacc8717c16a939d7cfd619ab70";
    };
    meta = {
      description = "Basic utilities for writing tests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestSpec = buildPerlPackage rec {
    name = "Test-Spec-0.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AK/AKZHAN/Test-Spec-0.54.tar.gz;
      sha256 = "1lk5l69bm6yl1zxzz5v6mizzqfinpdhasmi4qjxr1vnwcl9cyc8a";
    };
    propagatedBuildInputs = [ DevelGlobalPhase PackageStash TieIxHash ];
    meta = {
      description = "Write tests in a declarative specification style";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestDeep TestTrap ];
  };

  TestSubCalls = buildPerlPackage rec {
    name = "Test-SubCalls-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-SubCalls-1.10.tar.gz;
      sha256 = "cbc1e9b35a05e71febc13e5ef547a31c8249899bb6011dbdc9d9ff366ddab6c2";
    };
    propagatedBuildInputs = [ HookLexWrap ];
  };

  TestSynopsis = buildPerlPackage rec {
    name = "Test-Synopsis-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZO/ZOFFIX/${name}.tar.gz";
      sha256 = "1cxxidhwf8j8n41d423ankvls2wdi7aw755csi3hcv3mj9k67mfi";
    };
    meta = {
      description = "Test your SYNOPSIS code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTableDriven = buildPerlPackage {
    name = "Test-TableDriven-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JR/JROCKWAY/Test-TableDriven-0.02.tar.gz;
      sha256 = "16l5n6sx3yqdir1rqq21d41znpwzbs8v34gqr93y051arypphn22";
    };
    meta = {
      description = "Write tests, not scripts that run them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestTCP = buildPerlPackage rec {
    name = "Test-TCP-2.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "14ahzklq3xgmwj58p9vdcfgpggrmh3nigq5mzqk4wakbb6fjs0fx";
    };
    meta = {
      description = "Testing TCP program";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestSharedFork ];
  };

  TestTester = buildPerlPackage {
    name = "Test-Tester-0.109";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.109.tar.gz;
      sha256 = "0m9n28z09kq455r5nydj1bnr85lvmbfpcbjdkjfbpmfb5xgciiyk";
    };
  };

  TestTime = buildPerlPackage rec {
    name = "Test-Time-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SATOH/${name}.tar.gz";
      sha256 = "abef8885a811440114bfe067edc32f08500fbfd624902f8c3a81fc224ac4b410";
    };
    meta = {
      description = "Overrides the time() and sleep() core functions for testing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestToolbox = buildPerlModule rec {
     name = "Test-Toolbox-0.4";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MI/MIKO/Test-Toolbox-0.4.tar.gz;
       sha256 = "1hxx9rhvncvn7wvzhzx4sk00w0xq2scgspfhhyqwjnm1yg3va820";
     };
     meta = {
       description = "Test::Toolbox - tools for testing";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  TestTrailingSpace = buildPerlModule rec {
    name = "Test-TrailingSpace-0.0301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "a28875747adb7a0e7d1ae8a4ffe71869e7ceb3a85d0cb30172959dada7de5970";
    };
    propagatedBuildInputs = [ FileFindObjectRule ];
    meta = {
      description = "Test for trailing space in source files";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestUnitLite = buildPerlModule {
    name = "Test-Unit-Lite-0.1202";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Unit-Lite-0.1202.tar.gz;
      sha256 = "1a5jym9hjcpdf0rwyn7gwrzsx4xqzwgzx59rgspqlqiif7p2a79m";
    };
    meta = {
      description = "Unit testing without external dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Testuseok = buildPerlPackage {
    name = "Test-use-ok-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Test-use-ok-0.11.tar.gz;
      sha256 = "8410438a2acf127bffcf1ab92205b747a615b487e80a48e8c3d0bb9fa0dbb2a8";
    };
    meta = {
      homepage = https://github.com/audreyt/Test-use-ok/tree;
      description = "Alternative to Test::More::use_ok";
      license = "unrestricted";
    };
  };

  TestWarn = buildPerlPackage {
    name = "Test-Warn-0.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BIGJ/Test-Warn-0.32.tar.gz;
      sha256 = "1lkkpx8gyfsxfkys1psp990xyy1zxf8rsqd44az57x4y3zkidi9g";
    };
    propagatedBuildInputs = [ SubUplevel ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Perl extension to test methods for warnings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWarnings = buildPerlPackage rec {
    name = "Test-Warnings-0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "ae2b68b1b5616704598ce07f5118efe42dc4605834453b7b2be14e26f9cc9a08";
    };
    buildInputs = [ CPANMetaCheck ];
    meta = {
      homepage = https://github.com/karenetheridge/Test-Warnings;
      description = "Test for warnings and the lack of them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestWithoutModule = buildPerlPackage {
    name = "Test-Without-Module-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/Test-Without-Module-0.20.tar.gz;
      sha256 = "8e9aeb7c32a6c6d0b8a93114db2a8c072721273a9d9a2dd4f9ca86cfd28aa524";
    };
    meta = {
      description = "Test fallback behaviour in absence of modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestWWWMechanize = buildPerlPackage {
    name = "Test-WWW-Mechanize-1.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-WWW-Mechanize-1.48.tar.gz;
      sha256 = "1d11fx9155d5v17d5w7q3kj37b01l8yj2yb0g6b0z1vh938rrlcr";
    };
    buildInputs = [ TestLongString ];
    propagatedBuildInputs = [ CarpAssertMore HTTPServerSimple WWWMechanize ];
    meta = {
      homepage = https://github.com/petdance/test-www-mechanize;
      description = "Testing-specific WWW::Mechanize subclass";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TestWWWMechanizeCatalyst = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-Catalyst-0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "0nhhfrrai3ndziz873vpa1j0vljjnib4wqafd6yyvkf58ad7v0lv";
    };
    doCheck = false; # listens on an external port
    propagatedBuildInputs = [ CatalystRuntime LWP Moose namespaceclean
      TestWWWMechanize WWWMechanize ];
    meta = {
      description = "Test::WWW::Mechanize for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWWWMechanizeCGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-CGI-0.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Test-WWW-Mechanize-CGI-0.1.tar.gz;
      sha256 = "0bwwdk0iai5dlvvfpja971qpgvmf6yq67iag4z4szl9v5sra0xm5";
    };
    propagatedBuildInputs = [ WWWMechanizeCGI ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ TestLongString TestWWWMechanize ];
  };

  TestWWWMechanizePSGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-PSGI-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Test-WWW-Mechanize-PSGI-0.35.tar.gz;
      sha256 = "1hih8s49zf38bisvhnhzrrj0zwyiivkrbs7nmmdqm1qqy27wv7pc";
    };
    buildInputs = [ TestPod CGI ];
    propagatedBuildInputs = [ Plack TestWWWMechanize TryTiny ];
    meta = {
      description = "Test PSGI programs using WWW::Mechanize";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestXPath = buildPerlModule {
    name = "Test-XPath-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-XPath-0.16.tar.gz;
      sha256 = "09s47d5jcrx35dz623gjiqn0qmjrv0wb54czr7h01wffw1w8akxi";
    };
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestYAML = buildPerlPackage rec {
    name = "Test-YAML-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0hxrfs7p9hqkhvv5nhk2hd3kh32smwng4nz47b8xf4iw2q1n2dr7";
    };
    buildInputs = [ TestBase ];
  };

  TextAbbrev = buildPerlPackage {
    name = "Text-Abbrev-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Text-Abbrev-1.02.tar.gz;
      sha256 = "9cfb8bea2d5806b72fa1a0e1a3367ce662262eaa2701c6a3143a2a8076917433";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Text-Abbrev;
      description = "Abbrev - create an abbreviation table from a list";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextAligner = buildPerlModule rec {
    name = "Text-Aligner-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1vry21jrh91l2pkajnrps83bnr1fn6zshbzi80mcrnggrn9iq776";
    };
    meta = {
      description = "Align text in columns";
    };
  };

  TextAspell = buildPerlPackage rec {
    name = "Text-Aspell-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANK/${name}.tar.gz";
      sha256 = "0r9g31rd55934mp6n45b96g934ck4qns8x9i7qckn9wfy44k5sib";
    };
    propagatedBuildInputs = [ pkgs.aspell ];
    ASPELL_CONF = "dict-dir ${pkgs.aspellDicts.en}/lib/aspell";
    NIX_CFLAGS_COMPILE = "-I${pkgs.aspell}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.aspell}/lib -laspell";
  };

  TextAutoformat = buildPerlPackage {
    name = "Text-Autoformat-1.74";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Text-Autoformat-1.74.tar.gz;
      sha256 = "07eb3c2b3515897340ca6e9377495bbe2e05ec80d7f3f146adab8e534a818d5e";
    };
    propagatedBuildInputs = [ TextReform ];
    meta = {
      homepage = https://github.com/neilbowers/Text-Autoformat;
      description = "Automatic text wrapping and reformatting";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBalanced = buildPerlPackage {
    name = "Text-Balanced-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/Text-Balanced-2.03.tar.gz;
      sha256 = "057753f8f0568b53921f66a60a89c30092b73329bcc61a2c43339ab70c9792c8";
    };
    meta = {
      description = "Extract delimited text sequences from strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBibTeX = buildPerlModule rec {
    name = "Text-BibTeX-0.85";
    buildInputs = [ CaptureTiny ConfigAutoConf ExtUtilsLibBuilder ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/${name}.tar.gz";
      sha256 = "036kxgbn1jf70pfm2lmjlzjwnhbkd888fp5lyvmkjpdd15gla18h";
    };
    perlPreHook = "export LD=$CC";
    perlPostHook = stdenv.lib.optionalString stdenv.isDarwin ''
      oldPath="$(pwd)/btparse/src/libbtparse.dylib"
      newPath="$out/lib/libbtparse.dylib"

      install_name_tool -id "$newPath" "$newPath"
      install_name_tool -change "$oldPath" "$newPath" "$out/bin/biblex"
      install_name_tool -change "$oldPath" "$newPath" "$out/bin/bibparse"
      install_name_tool -change "$oldPath" "$newPath" "$out/bin/dumpnames"
      install_name_tool -change "$oldPath" "$newPath" "$out/lib/perl5/site_perl/5.24.3/darwin-2level/auto/Text/BibTeX/BibTeX.bundle"
    '';
    meta = {
      description = "Interface to read and parse BibTeX files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ ScalarListUtils ];
  };

  TextBrew = buildPerlPackage rec {
    name = "Text-Brew-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCIVEY/${name}.tar.gz";
      sha256 = "0k7nxglbx5pxl693zrj1fsi094sf1a3vqsrn73inzz7r3j28a6xa";
    };
  };

  TextCharWidth = buildPerlPackage rec {
    name = "Text-CharWidth-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KU/KUBOTA/${name}.tar.gz";
      sha256 = "abded5f4fdd9338e89fd2f1d8271c44989dae5bf50aece41b6179d8e230704f8";
    };
  };

  TextCSV = buildPerlPackage rec {
    name = "Text-CSV-1.95";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISHIGAKI/Text-CSV-1.95.tar.gz;
      sha256 = "7e0a11d9c1129a55b68a26aa4b37c894279df255aa63ec8341d514ab848dbf61";
    };
    meta = {
      description = "Comma-separated values manipulator (using XS or PurePerl)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TextCSVEncoded = buildPerlPackage rec {
    name = "Text-CSV-Encoded-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZA/ZARQUON/${name}.tar.gz";
      sha256 = "1l5rwlmnpnhjszb200a94lwvkwslsvyxm24ycf37gm8dla1mk2i4";
    };
    propagatedBuildInputs = [ TextCSV ];
    meta = {
      description = "Encoding aware Text::CSV";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TextCSV_XS = buildPerlPackage rec {
    name = "Text-CSV_XS-1.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HM/HMBRAND/${name}.tgz";
      sha256 = "2b4f111e9486b230b02bfabbbf50c453f959d18ec17351a930e41f0959b358b7";
    };
    meta = {
      homepage = https://metacpan.org/pod/Text::CSV_XS;
      description = "Comma-Separated Values manipulation routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextDiff = buildPerlPackage rec {
    name = "Text-Diff-1.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "013g13prdghxvrp5754gyc7rmv1syyxrhs33yc5f0lrz3dxs1fp8";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Perform diffs on files and record sets";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextGerman = buildPerlPackage rec {
     name = "Text-German-0.06";
     src = fetchurl {
       url = mirror://cpan/authors/id/U/UL/ULPFR/Text-German-0.06.tar.gz;
       sha256 = "1p87pgap99lw0nv62i3ghvsi7yg90lhn8vsa3yqp75rd04clybcj";
     };
     meta = {
     };
  };

  TextGlob = buildPerlPackage rec {
    name = "Text-Glob-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz;
      sha256 = "11sj62fynfgwrlgkv5a051cq6yn0pagxqjsz27dxx8phsd4wv706";
    };
  };

  TextIconv = buildPerlPackage {
    name = "Text-Iconv-1.7";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz;
      sha256 = "5b80b7d5e709d34393bcba88971864a17b44a5bf0f9e4bcee383d029e7d2d5c3";
    };
  };

  TestInter = buildPerlPackage {
    name = "Test-Inter-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Test-Inter-1.07.tar.gz;
      sha256 = "c3b1e2c753b88a893e08ec2dd3d0f0b3eb513cdce7afa52780cb0e02b6c576ee";
    };
    meta = {
      description = "Framework for more readable interactive test scripts";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestManifest = buildPerlPackage {
    name = "Test-Manifest-2.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Test-Manifest-2.02.tar.gz;
      sha256 = "064783ceaf7dd569a5724d40900a3f9d92168ee4c613f7a3cb99a99aa8283396";
    };
    meta = {
      description = "Interact with a t/test_manifest file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMarkdown = buildPerlPackage rec {
    name = "Text-Markdown-1.000031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "06y79lla8adkqhrs41xdddqjs81dcrh266b50mfbg37bxkawd4f1";
    };
    buildInputs = [ ListMoreUtils TestDifferences TestException ];
  };

  TestMagpie = buildPerlPackage {
    name = "Test-Magpie-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVENL/Test-Magpie-0.11.tar.gz;
      sha256 = "1c4iy35yg3fa9mrc4phmpz46fkihl6yic6a13fpcxyd3xafd5zhm";
    };
    propagatedBuildInputs = [ MooseXTypesStructured SetObject UNIVERSALref aliased ];
    meta = {
      description = "Spy on objects to achieve test doubles (mock testing)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ TestFatal Throwable ];
  };

  TestMinimumVersion = buildPerlPackage rec {
    name = "Test-MinimumVersion-0.101082";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "3fba4e8fcf74806259aa639be7d90e70346ad0e0e4b8b619593490e378241970";
    };
    propagatedBuildInputs = [ PerlMinimumVersion ];
    meta = {
      homepage = https://github.com/rjbs/Test-MinimumVersion;
      description = "Does your code require newer perl than you think?";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMicroTemplate = buildPerlPackage {
    name = "Text-MicroTemplate-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Text-MicroTemplate-0.24.tar.gz;
      sha256 = "1j5ljx7hs4k29732nr5f2m4kssz4rqjw3kknsnhams2yydqix01j";
    };
    meta = {
      description = "Micro template engine with Perl5 language";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestNumberDelta = buildPerlPackage {
    name = "Test-Number-Delta-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Number-Delta-1.06.tar.gz;
      sha256 = "535430919e6fdf6ce55ff76e9892afccba3b7d4160db45f3ac43b0f92ffcd049";
    };
    meta = {
      homepage = https://github.com/dagolden/Test-Number-Delta;
      description = "Compare the difference between numbers against a given tolerance";
      license = "apache";
    };
  };

  TextPasswordPronounceable = buildPerlPackage {
    name = "Text-Password-Pronounceable-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/Text-Password-Pronounceable-0.30.tar.gz;
      sha256 = "c186a50256e0bedfafb17e7ce157e7c52f19503bb79e18ebf06255911f6ead1a";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextPDF = buildPerlPackage rec {
    name = "Text-PDF-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BH/BHALLISSY/Text-PDF-0.31.tar.gz;
      sha256 = "0s5cimfr4wwzgv15k30x83ncg1257jwsvmbmb86lp02rw5g537yz";
    };
  };

  TextQuoted = buildPerlPackage {
    name = "Text-Quoted-2.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Text-Quoted-2.09.tar.gz;
      sha256 = "446c3e8da7e65f7988cd36e9da1159614eb0b337d6c4c0dec8f6df7673b96c5f";
    };
    propagatedBuildInputs = [ TextAutoformat ];
    meta = {
      description = "Extract the structure of a quoted mail message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextRecordParser = buildPerlPackage rec {
    name = "Text-RecordParser-1.6.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCLARK/${name}.tar.gz";
      sha256 = "0nn33c058bl957v38xhqig4ld34lifl4arqiilhxky339i0q2fys";
    };

    # In a NixOS chroot build, the tests fail because the font configuration
    # at /etc/fonts/font.conf is not available.
    doCheck = false;

    propagatedBuildInputs = [ ClassAccessor IOStringy ListMoreUtils Readonly TextAutoformat ];
    buildInputs = [ TestException ];
  };

  TextReform = buildPerlModule {
    name = "Text-Reform-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Text-Reform-1.20.tar.gz;
      sha256 = "a8792dd8c1aac97001032337b36a356be96e2d74c4f039ef9a363b641db4ae61";
    };
    meta = {
      description = "Manual text wrapping and reformatting";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextRoman = buildPerlPackage rec {
    name = "Text-Roman-3.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Text-Roman-3.5.tar.gz;
      sha256 = "0sh47svzz0wm993ywfgpn0fvhajl2sj5hcnf5zxjz02in6ihhjnb";
    };
    meta = {
      description = "Allows conversion between Roman and Arabic algarisms";
      license = stdenv.lib.licenses.bsd3;
    };
  };

  TextSimpleTable = buildPerlPackage {
    name = "Text-SimpleTable-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Text-SimpleTable-2.04.tar.gz;
      sha256 = "14sjmdcy7s73sk740g3ccmzmwhwd52x5ay3bjmibjlql1cag70ld";
    };
    meta = {
      description = "Simple eyecandy ASCII tables";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TextSoundex = buildPerlPackage {
    name = "Text-Soundex-3.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Text-Soundex-3.05.tar.gz;
      sha256 = "f6dd55b4280b25dea978221839864382560074e1d6933395faee2510c2db60ed";
    };
  };

  TextSprintfNamed = buildPerlModule rec {
    name = "Text-Sprintf-Named-0.0402";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "951317fce8fa5dd08190ba760182bc71f2b4346fa21df55c76155e6353e2864f";
    };
    buildInputs = [ TestWarn ];
    meta = {
      description = "Sprintf-like function with named conversions";
      license = stdenv.lib.licenses.mit;
    };
  };

  TextTable = buildPerlModule rec {
    name = "Text-Table-1.133";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "04kh5x5inq183rdg221wlqaaqi1ipyj588mxsslik6nhc14f17nd";
    };
    propagatedBuildInputs = [ TextAligner ];
    meta = {
      homepage = http://www.shlomifish.org/open-source/projects/docmake/;
      description = "Organize Data in Tables";
      license = stdenv.lib.licenses.isc;
      platforms = stdenv.lib.platforms.linux;
    };
  };

  TextTabsWrap = buildPerlPackage {
    name = "Text-Tabs+Wrap-2013.0523";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MU/MUIR/modules/Text-Tabs+Wrap-2013.0523.tar.gz;
      sha256 = "b9cb056fffb737b9c12862099b952bf4ab4b1f599fd34935356ae57dab6f655f";
    };
    meta = {
      description = "Expand tabs and do simple line wrapping";
    };
  };

  TextTabularDisplay = buildPerlPackage rec {
    name = "Text-TabularDisplay-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "1s46s4pg5mpfllx3icf4vnqz9iadbbdbsr5p7pr6gdjnzbx902gb";
    };
  };

  TextTemplate = buildPerlPackage {
    name = "Text-Template-1.52";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHOUT/Text-Template-1.52.tar.gz;
      sha256 = "85da7a5e7eecf1871cda8bf3ce7b8ad0b5f75c6c5791f43a7d94373406859b6c";
    };
    meta = {
      description = "Unknown";
      license = "unknown";
    };
    buildInputs = [ TestWarnings ];
  };

  TestTrap = buildPerlModule rec {
    name = "Test-Trap-0.3.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EB/EBHANSSEN/Test-Trap-v0.3.3.tar.gz;
      sha256 = "1676gqjyk0zig3yyqv053y5j1pajp2af08ffmgx94n414whbhm5c";
    };
    propagatedBuildInputs = [ DataDump ];
    meta = {
      description = "Trap exit codes, exceptions, output, etc";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVars = buildPerlModule rec {
    name = "Test-Vars-0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0qr8q0ksr925ycwbsyxjwgz4p9r7a8vkxpn33vy23zbijwpa3xx7";
    };

    buildInputs = [ ModuleBuildTiny ];

    meta = {
      homepage = https://github.com/gfx/p5-Test-Vars;
      description = "Detects unused variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVersion = buildPerlPackage rec {
    name = "Test-Version-2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "eae8b758395d6b23d4ce3109b055663379b9970fb8f81e5803d145dbc5ccdbac";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ FileFindRulePerl ];
    meta = {
      homepage = https://metacpan.org/dist/Test-Version;
      description = "Check to see that version's in modules are sane";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TextTrim = buildPerlModule {
    name = "Text-Trim-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTLAW/Text-Trim-1.02.tar.gz;
      sha256 = "1bnwjl5n04w8nnrzrm75ljn4pijqbijr9csfkjcs79h4gwn9lwqw";
    };
    meta = {
      description = "Remove leading and/or trailing whitespace from strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextUnaccent = buildPerlPackage {
    name = "Text-Unaccent-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LD/LDACHARY/Text-Unaccent-1.08.tar.gz;
      sha256 = "0avk50kia78kxryh2whmaj5l18q2wvmkdyqyjsf6kwr4kgy6x3i7";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextUnidecode = buildPerlPackage rec {
    name = "Text-Unidecode-1.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz;
      sha256 = "1imii0p6wvhrxsr5z2zhazpx5vl4l4ybf1y2c5hy480xvi6z293c";
    };
  };

  Testutf8 = buildPerlPackage {
    name = "Test-utf8-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKF/Test-utf8-1.01.tar.gz;
      sha256 = "ef371b1769cd8d36d2d657e8321723d94c8f8d89e7fd7437c6648c5dc6711b7a";
    };
    meta = {
      homepage = https://github.com/2shortplanks/Test-utf8/tree;
      description = "Handy utf8 tests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextvFileasData = buildPerlPackage rec {
    name = "Text-vFile-asData-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "b291ab5e0f987c5172560a692234711a75e4596d83475f72d01278369532f82a";
    };
    propagatedBuildInputs = [ ClassAccessorChained ];
    meta = {
      description = "Parse vFile formatted files into data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextWikiFormat = buildPerlModule {
    name = "Text-WikiFormat-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Text-WikiFormat-0.81.tar.gz;
      sha256 = "0cxbgx879bsskmnhjzamgsa5862ddixyx4yr77lafmwimnaxjg74";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextWrapI18N = buildPerlPackage {
    name = "Text-WrapI18N-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KU/KUBOTA/Text-WrapI18N-0.06.tar.gz;
      sha256 = "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488";
    };
    propagatedBuildInputs = [ pkgs.glibc TextCharWidth ];
    preConfigure = ''
      substituteInPlace WrapI18N.pm --replace '/usr/bin/locale' '${pkgs.glibc.bin}/bin/locale'
    '';
    meta = {
      description = "Line wrapping module with support for multibyte, fullwidth, and combining characters and languages without whitespaces between words";
      license = with stdenv.lib.licenses; [ artistic1 gpl2 ];
      # bogus use of glibc, pretty sure, think this is what we have glibcLocales for?
      broken = stdenv.hostPlatform.libc != "glibc";
    };
  };

  TextWrapper = buildPerlPackage {
    name = "Text-Wrapper-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/Text-Wrapper-1.05.tar.gz;
      sha256 = "64268e15983a9df47e1d9199a491f394e89f542e54afb33f4b78f3f318e09ab9";
    };
    meta = {
      description = "Word wrap text by breaking long lines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ TestDifferences ];
  };

  threads = buildPerlPackage rec {
    name = "threads-2.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/${name}.tar.gz";
      sha256 = "047i22mdnf7fa0h9w5jhqrjbg561l5jxk8xqzwh6zbmwlac4qf98";
    };
    meta = {
      description = "Perl interpreter-based threads";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  threadsshared = buildPerlPackage rec {
    name = "threads-shared-1.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/${name}.tar.gz";
      sha256 = "04qbypzgp49sq1wq5kip0m95lffv0pc8xj2wplrdpyqz87y105xd";
    };
    meta = {
      description = "Perl extension for sharing data structures between threads";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ThreadQueue = buildPerlPackage rec {
    name = "Thread-Queue-3.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/${name}.tar.gz";
      sha256 = "0wpqdbdfa4mw8lpcaw1lp2d553gl65cl8mli1srj8wrg0kaxshhx";
    };
    meta = {
      description = "Thread-safe queues";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ThreadSemaphore = buildPerlPackage {
    name = "Thread-Semaphore-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Thread-Semaphore-2.13.tar.gz;
      sha256 = "e3fe2cc047575529c8ea4c168cef8fab2ec931729a1826ffca1ef63e7e45bc81";
    };
    meta = {
      description = "Thread-safe semaphores";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Throwable = buildPerlPackage rec {
    name = "Throwable-0.200013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "184gdcwxqwnkrx5md968v1ny70pq6blzpkihccm3bpdxnpgd11wr";
    };
    propagatedBuildInputs = [ DevelStackTrace Moo ];
    meta = {
      homepage = https://github.com/rjbs/Throwable;
      description = "A role for classes that can be thrown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TieCacheLRU = buildPerlPackage rec {
    name = "Tie-Cache-LRU-20150301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1bf740450d3a6d7c12b48c25f7da5964e44e7cc38b28572cfb76ff22464f4469";
    };
    propagatedBuildInputs = [ ClassVirtual enum ];
    meta = {
      description = "A Least-Recently Used cache";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieCacheLRUExpires = buildPerlPackage rec {
    name = "Tie-Cache-LRU-Expires-0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/${name}.tar.gz";
      sha256 = "b316d849acd25f24346d55a9950d281fee0746398767c601234122159573eb9a";
    };
    propagatedBuildInputs = [ TieCacheLRU ];
    meta = {
      license = stdenv.lib.licenses.artistic1;
    };
  };

  TieCycle = buildPerlPackage rec {
    name = "Tie-Cycle-1.225";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "0i9xq2qm50p2ih24265jndp2x8hfq7ap0d88nrlv5yaad4hxhc7k";
    };
    meta = {
      description = "Cycle through a list of values via a scalar";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieFile = buildPerlPackage {
    name = "Tie-File-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Tie-File-1.00.tar.gz;
      sha256 = "7ca9c8a957cf743d3a98d0eb5deb767b1e14b4f00bc9d03da83d466fcb76bd44";
    };
    meta = {
      description = "Access the lines of a disk file via a Perl array";
    };
  };

  TieIxHash = buildPerlModule {
    name = "Tie-IxHash-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz;
      sha256 = "0mmg9iyh42syal3z1p2pn9airq65yrkfs66cnqs9nz76jy60pfzs";
    };
    meta = {
      description = "Ordered associative arrays for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieHashIndexed = buildPerlPackage {
    name = "Tie-Hash-Indexed-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHX/Tie-Hash-Indexed-0.05.tar.gz;
      sha256 = "a8862a4763d58a8c785e34b8b18e5db4ce5c3e36b9b5cf565a3088584eab361e";
    };
    meta = {
      description = "Ordered hashes for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieRefHash = buildPerlPackage {
    name = "Tie-RefHash-1.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Tie-RefHash-1.39.tar.gz;
      sha256 = "b0b80ef571e7dadb726b8214f7352a932a8fa82af29072895aa1aadc89f48bec";
    };
  };

  TieRegexpHash = buildPerlPackage rec {
    name = "Tie-RegexpHash-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALTREUS/${name}.tar.gz";
      sha256 = "0c207850e77efb16618e0aa015507926a3425b34aad5aa6e3e40d83989a085a3";
    };
    meta = {
      license = stdenv.lib.licenses.artistic1;
    };
  };

  TieToObject = buildPerlPackage {
    name = "Tie-ToObject-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz;
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
  };

  TimeDate = buildPerlPackage {
    name = "TimeDate-2.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/TimeDate-2.30.tar.gz;
      sha256 = "11lf54akr9nbivqkjrhvkmfdgkbhw85sq0q4mak56n6bf542bgbm";
    };
  };

  TimeDuration = buildPerlPackage rec {
    name = "Time-Duration-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "1f5vkid4pl5iq3hal01hk1zjbbzrqpx4m1djawbp93l152shb0j5";
    };
    meta = {
      description = "Rounded or exact English expression of durations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeDurationParse = buildPerlPackage rec {
    name = "Time-Duration-Parse-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "0affdzhsiy7dr6dzj2p6m9lynmjh53k31bprfsfa21pz8551hjj1";
    };
    buildInputs = [ TimeDuration ];
    propagatedBuildInputs = [ ExporterLite ];
    meta = {
      description = "Parse string that represents time duration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeHiRes = buildPerlPackage rec {
    name = "Time-HiRes-1.9753";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHI/Time-HiRes-1.9753.tar.gz;
      sha256 = "05a9xhn8y0f679kg8n0n3ng4mk6sd7isihqbbhfh29nxkkwxbgqg";
    };
  };

  TimeLocal = buildPerlPackage {
    name = "Time-Local-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Time-Local-1.25.tar.gz;
      sha256 = "1ae9c51d777ac44a3ebc154dc625ba24d7c0cde6a8b6dba87b46d0777889fef2";
    };
    meta = {
      description = "Efficiently compute time from local and GMT time";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeParseDate = buildPerlPackage {
    name = "Time-ParseDate-2015.103";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MU/MUIR/modules/Time-ParseDate-2015.103.tar.gz;
      sha256 = "2c1a06235bf811813caac9eaa9daa71af758667cdf7b082cb59863220fcaeed1";
    };
    doCheck = false;
    meta = {
      description = "Parse and format time values";
      license = "unknown";
    };
  };

  Tk = buildPerlPackage rec {
    name = "Tk-804.034";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/${name}.tar.gz";
      sha256 = "fea6b144c723528a2206c8cd9175844032ee9c14ee37791f0f151e5e5b293fe2";
    };
    makeMakerFlags = "X11INC=${pkgs.xorg.libX11.dev}/include X11LIB=${pkgs.xorg.libX11.out}/lib";
    buildInputs = [ pkgs.xorg.libX11 pkgs.libpng ];
    doCheck = false;            # Expects working X11.
    meta = {
      homepage = https://metacpan.org/pod/distribution/Tk/Tk.pod;
      license = stdenv.lib.licenses.tcltk;
    };
  };

  TreeDAGNode = buildPerlPackage rec {
    name = "Tree-DAG_Node-1.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "016kr76azxzfcpxjkhqp2piyyl6529shjis20mc3g2snfabsd2qw";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "An N-ary tree";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    propagatedBuildInputs = [ FileSlurpTiny ];
  };

  TreeSimple = buildPerlPackage rec {
    name = "Tree-Simple-1.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "1alnwb6c7n4al91m9cyknvcyvdz521lh22dz1hyk4v7c50adffnv";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "A simple tree object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimpleVisitorFactory = buildPerlPackage {
    name = "Tree-Simple-VisitorFactory-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-Simple-VisitorFactory-0.15.tgz;
      sha256 = "06y2vazkl307k59hnkp9h5bp3p7711kgmp1qdhb2lgnfwzn84zin";
    };
    propagatedBuildInputs = [ TreeSimple ];
    buildInputs = [ TestException ];
  };

  TryTiny = buildPerlPackage {
    name = "Try-Tiny-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz;
      sha256 = "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b";
    };
    buildInputs = [ CPANMetaCheck CaptureTiny ];
    meta = {
      homepage = https://metacpan.org/release/Try-Tiny;
      description = "Minimal try/catch with proper preservation of $@";
      license = stdenv.lib.licenses.mit;
    };
  };

  TypeTiny = buildPerlPackage {
    name = "Type-Tiny-1.002001";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/Type-Tiny-1.002001.tar.gz;
      sha256 = "93c9eeaaf23016625126794af483bc626a149f7226f9a6ec1081ef896acc13dd";
    };
    propagatedBuildInputs = [ ExporterTiny ];
    meta = {
      homepage = https://metacpan.org/release/Type-Tiny;
      description = "Tiny, yet Moo(se)-compatible type constraint";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TypesSerialiser = buildPerlPackage rec {
     name = "Types-Serialiser-1.0";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.0.tar.gz;
       sha256 = "03bk0hm5ys8k7265dkap825ybn2zmzb1hl0kf1jdm8yq95w39lvs";
     };
     propagatedBuildInputs = [ commonsense ];
     meta = {
     };
  };

  UNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.20140328";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.20140328.tar.gz;
      sha256 = "522da9f274786fe2cba99bc77cc1c81d2161947903d7fad10bd62dfb7f11990f";
    };
    meta = {
      homepage = https://github.com/chromatic/UNIVERSAL-can;
      description = "Work around buggy code calling UNIVERSAL::can() as a function";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALisa = buildPerlPackage {
    name = "UNIVERSAL-isa-1.20171012";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/UNIVERSAL-isa-1.20171012.tar.gz;
      sha256 = "0avzv9j32aab6l0rd63n92v0pgliz1p4yabxxjfq275hdh1mcsfi";
    };
    meta = {
      homepage = https://github.com/chromatic/UNIVERSAL-isa;
      description = "Attempt to recover from people calling UNIVERSAL::isa as a function";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALref = buildPerlPackage rec {
     name = "UNIVERSAL-ref-0.14";
     src = fetchurl {
       url = mirror://cpan/authors/id/J/JJ/JJORE/UNIVERSAL-ref-0.14.tar.gz;
       sha256 = "1ar8dfj90nn52cb8c6yyj4bi6ya8hk2f2sl0a5q7pmchj321bn1m";
     };
     propagatedBuildInputs = [ BUtils ];
     meta = {
       description = "Turns ref() into a multimethod";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  UNIVERSALrequire = buildPerlPackage rec {
    name = "UNIVERSAL-require-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "b2a736a87967a143dab58c8a110501d5235bcdd2c8b2a3bfffcd3c0bd06b38ed";
    };
    meta = {
      description = "Require() modules from a variable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCaseFold = buildPerlModule rec {
    name = "Unicode-CaseFold-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/${name}.tar.gz";
      sha256 = "418a212808f9d0b8bb330ac905096d2dd364976753d4c71534dab9836a63194d";
    };
    meta = {
      homepage = https://metacpan.org/release/Unicode-CaseFold;
      description = "Unicode case-folding for case-insensitive lookups";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCheckUTF8 = buildPerlPackage {
    name = "Unicode-CheckUTF8-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRADFITZ/Unicode-CheckUTF8-1.03.tar.gz;
      sha256 = "97f84daf033eb9b49cd8fe31db221fef035a5c2ee1d757f3122c88cf9762414c";
    };
    meta = {
      license = "unknown";
    };
  };

  UnicodeCollate = buildPerlPackage rec {
    name = "Unicode-Collate-1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SADAHIRO/${name}.tar.gz";
      sha256 = "1dpvck4saah8hqb9c82i25yimy9x2hkr1k3a2f1ly0k0ifhbiyyx";
    };
    meta = {
      description = "Unicode Collation Algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeICUCollator = buildPerlPackage {
    name = "Unicode-ICU-Collator-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TONYC/Unicode-ICU-Collator-0.002.tar.gz;
      sha256 = "0gimwydam0mdgm6qjzzxny4gw8zda9kc2843kcl2xrpq7z7ww3f9";
    };
    meta = {
      description = "Wrapper around ICU collation services";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
      broken = true; # tests fail http://hydra.nixos.org/build/25141764/nixlog/1/raw
    };
    buildInputs = [ pkgs.icu ];
  };

  UnicodeLineBreak = buildPerlPackage rec {
    name = "Unicode-LineBreak-2018.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/${name}.tar.gz";
      sha256 = "1cbilpy7ypr26rjr6cmrbkxhsm1l6yx7s1p7lcf0l3vi7vzr4346";
    };
    propagatedBuildInputs = [ MIMECharset ];
    meta = {
      description = "UAX #14 Unicode Line Breaking Algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeNormalize = buildPerlPackage rec {
    name = "Unicode-Normalize-1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KH/KHW/${name}.tar.gz";
      sha256 = "00b33a75d3b356ade2e09391ea2d32fac881671c18b1eb26b9ca31273d5b046c";
    };
    meta = {
      description = "Unicode Normalization Forms";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeString = buildPerlPackage rec {
    name = "Unicode-String-2.09";
    patches = [
      ../development/perl-modules/Unicode-String-perl-5-22.patch
    ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1bgsaf3dgmlgyvi84r42ysc037mr5280amnypa4d98jfjpdvw5y8";
    };
  };

  UnixGetrusage = buildPerlPackage {
    name = "Unix-Getrusage-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TA/TAFFY/Unix-Getrusage-0.03.tar.gz;
      sha256 = "76cde1cee2453260b85abbddc27cdc9875f01d2457e176e03dcabf05fb444d12";
    };
  };

  URI = buildPerlPackage rec {
    name = "URI-1.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "cca7ab4a6f63f3ccaacae0f2e1337e8edf84137e73f18548ec7d659f23efe413";
    };
    buildInputs = [ TestNeeds ];
    meta = {
      homepage = https://github.com/libwww-perl/URI;
      description = "Uniform Resource Identifiers (absolute and relative)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIdb = buildPerlModule {
    name = "URI-db-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/URI-db-0.18.tar.gz;
      sha256 = "460a1d3b9a45779f56dbbeebc60612370b32771f3158c87da981857163b43e0b";
    };
    propagatedBuildInputs = [ URINested ];
    meta = {
      homepage = https://search.cpan.org/dist/URI-db/;
      description = "Database URIs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIFind = buildPerlModule rec {
    name = "URI-Find-20160806";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1mk3jv8x0mcq3ajrn9garnxd0jc7sw4pkwqi88r5apqvlljs84z2";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = http://search.cpan.org/dist/URI-Find;
      description = "Find URIs in arbitrary text";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIFromHash = buildPerlPackage {
    name = "URI-FromHash-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/URI-FromHash-0.05.tar.gz;
      sha256 = "1l3g5ygv83vn9y1zpwjdqq5cs4ip2q058q0gmpcf5wp9rsycbjm7";
    };
    propagatedBuildInputs = [ ParamsValidate URI ];
    meta = {
      description = "Build a URI from a set of named parameters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ TestFatal ];
  };

  UriGoogleChart = buildPerlPackage rec {
    name = "URI-GoogleChart-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "00hq5cpsk7sa04n0wg52qhpqf9i2849yyvw2zk83ayh1qqpc50js";
    };
    propagatedBuildInputs = [ URI ];
  };

  UserIdentity = buildPerlPackage rec {
     name = "User-Identity-0.99";
     src = fetchurl {
       url = mirror://cpan/authors/id/M/MA/MARKOV/User-Identity-0.99.tar.gz;
       sha256 = "0c2qwxgpqncm4ya3rb5zz2hgiwwf559j1b1a6llyarf9jy43hfzm";
     };
     meta = {
       description = "Collect information about a user";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  URIIMAP = buildPerlPackage {
    name = "URI-imap-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWEST/URI-imap-1.01.tar.gz;
      sha256 = "0bdv6mrdijcq46r3lmz801rscs63f8p9qqliy2safd6fds4rj55v";
    };
    propagatedBuildInputs = [ URI ];
  };

  URINested = buildPerlModule {
    name = "URI-Nested-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/URI-Nested-0.10.tar.gz;
      sha256 = "e1971339a65fbac63ab87142d4b59d3d259d51417753c77cb58ea31a8233efaf";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = https://metacpan.org/release/URI-Nested/;
      description = "Nested URIs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIws = buildPerlPackage rec {
    name = "URI-ws-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "6e6b0e4172acb6a53c222639c000608c2dd61d50848647482ac8600d50e541ef";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = http://perl.wdlabs.com/URI-ws/;
      description = "WebSocket support for URI package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UUIDTiny = buildPerlPackage rec {
    name = "UUID-Tiny-1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAUGUSTIN/${name}.tar.gz";
      sha256 = "6dcd92604d64e96cc6c188194ae16a9d3a46556224f77b6f3d1d1312b68f9a3d";
    };
    meta = {
      description = "Pure Perl UUID Support With Functional Interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  VariableMagic = buildPerlPackage rec {
    name = "Variable-Magic-0.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "3f9a18517e33f006a9c2fc4f43f01b54abfe6ff2eae7322424f31069296b615c";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Variable-Magic/;
      description = "Associate user-defined magic to variables from Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  version = buildPerlPackage rec {
    name = "version-0.9918";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JP/JPEACOCK/${name}.tar.gz";
      sha256 = "54175c7ead4e2259c2fb2b83440b821e4287842067227e48fb899b5cae52237b";
    };
    meta = {
      description = "Structured version objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  vidir = buildPerlPackage rec {
    name = "vidir-0.040";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WO/WOLDRICH/App-${name}-woldrich.tar.gz";
      sha256 = "0c97yx33pyhskbmwpqbwlkxr85awd6kg1baibvqkarhhvc8v7l0h";
    };
    # NB: This preInstall a workaround for a problem that is fixed in HEAD.
    preInstall = ''
      sed -i -e '/^use encoding/d' bin/vidir
    '';
    outputs = [ "out" ];
    meta = {
      maintainers = [ maintainers.chreekat ];
      homepage = "http://search.cpan.org/~woldrich/App-vidir/bin/vidir";
      description = "Edit a directory in $EDITOR";
      license = with stdenv.lib.licenses; [ gpl1 ];
    };
  };

  VMEC2 = buildPerlModule rec {
    name = "VM-EC2-1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "cc8002965e3a4919527a85a84100cfc3703165a449ade29e95f4e31889fbd9ad";
    };
    propagatedBuildInputs = [ AnyEventHTTP JSON StringApprox XMLSimple ];
    meta = {
      description = "Perl interface to Amazon EC2, Virtual Private Cloud, Elastic Load Balancing, Autoscaling, and Relational Database services";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  VMEC2SecurityCredentialCache = buildPerlPackage rec {
    name = "VM-EC2-Security-CredentialCache-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCONOVER/${name}.tar.gz";
      sha256 = "fc7e9c152ff2b721ccb221ac40089934775cf58366aedb5cc1693609f840937b";
    };
    propagatedBuildInputs = [ DateTimeFormatISO8601 VMEC2 ];
    meta = {
      homepage = http://search.cpan.org/dist/VM-EC2-Security-CredentialCache/;
      description = "Cache credentials respecting expiration time for IAM roles";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  W3CLinkChecker = buildPerlPackage rec {
    name = "W3C-LinkChecker-4.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/${name}.tar.gz";
      sha256 = "6239f61b20d91dce7b21e4d4f626ab93a8f1e2f207da5015590d508cf6c66a65";
    };
    outputs = [ "out" ];
    propagatedBuildInputs = [ CGI CSSDOM ConfigGeneral LWP NetIP TermReadKey ];
    meta = {
      homepage = http://validator.w3.org/checklink;
      description = "A tool to check links and anchors in Web pages or full Web sites";
      license = stdenv.lib.licenses.w3c;
    };
  };

  WWWCurl = buildPerlPackage rec {
    name = "WWW-Curl-4.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZBALINT/${name}.tar.gz";
      sha256 = "1fmp9aib1kaps9vhs4dwxn7b15kgnlz9f714bxvqsd1j1q8spzsj";
    };
    patches = [ ../development/perl-modules/WWW-Curl-4.17-Skip-preprocessor-symbol-only-CURL_STRICTER.patch ];
    buildInputs = [ pkgs.curl ];
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '"cpp"' '"gcc -E"'
        substituteInPlace Makefile.PL --replace '_LASTENTRY\z' '_LASTENTRY\z|CURL_DID_MEMORY_FUNC_TYPEDEFS\z'
      '';
    NIX_CFLAGS_COMPILE = "-DCURL_STRICTER";
    doCheck = false; # performs network access
  };

  WWWFormUrlEncoded = buildPerlModule rec {
     name = "WWW-Form-UrlEncoded-0.24";
     src = fetchurl {
       url = mirror://cpan/authors/id/K/KA/KAZEBURO/WWW-Form-UrlEncoded-0.24.tar.gz;
       sha256 = "04fh54zgmrlhrmdaqs2yrwqmqwk9hd737z7rnbbd438l36skn7vd";
     };
     buildInputs = [ JSON ];
     meta = {
       description = "parser and builder for application/x-www-form-urlencoded";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
       homepage = "https://github.com/kazeburo/WWW-Form-UrlEncoded";
     };
  };

  WWWMechanize = buildPerlPackage {
    name = "WWW-Mechanize-1.88";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OA/OALDERS/WWW-Mechanize-1.88.tar.gz;
      sha256 = "0yd8a1zsfpbv5wr79x3iqmik9gvcd10iam9dfrdan4dri9vpxn9n";
    };
    propagatedBuildInputs = [ HTMLForm HTMLTree LWP ];
    doCheck = false;
    meta = {
      homepage = https://github.com/bestpractical/www-mechanize;
      description = "Handy web browsing in a Perl object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    buildInputs = [ CGI HTTPServerSimple TestDeep TestFatal TestOutput TestWarnings ];
  };

  WWWMechanizeCGI = buildPerlPackage {
    name = "WWW-Mechanize-CGI-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/WWW-Mechanize-CGI-0.3.tar.gz;
      sha256 = "046jm18liq7rwkdawdh9520cnalkfrk26yqryp7xgw71y65lvq61";
    };
    propagatedBuildInputs = [ HTTPRequestAsCGI WWWMechanize ];
    preConfigure = ''
      substituteInPlace t/cgi-bin/script.cgi \
        --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'
    '';
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  WWWRobotRules = buildPerlPackage {
    name = "WWW-RobotRules-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz;
      sha256 = "07m50dp5n5jxv3m93i55qvnd67a6g7cvbvlik115kmc8lbkh5da6";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Database of robots.txt-derived permissions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WWWYoutubeViewer = buildPerlPackage rec {
    name = "WWW-YoutubeViewer-${version}";
    version = "3.3.0";

    src = fetchFromGitHub {
      owner  = "trizen";
      repo   = "youtube-viewer";
      rev    = "${version}";
      sha256 = "15xyrwv08fw8jmpydwzks26ipxnzliwddgyjcfqiaj0p7lwlhmx1";
    };

    propagatedBuildInputs = [
      LWP
      LWPProtocolHttps
      DataDump
      JSON
    ];

    meta = {
      description = "A lightweight application for searching and streaming videos from YouTube";
      homepage = https://github.com/trizen/youtube-viewer;
      maintainers = with maintainers; [ woffs ];
      license = with stdenv.lib.licenses; [ artistic2 ];
    };
  };

  Want = buildPerlPackage rec {
    name = "Want-0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/${name}.tar.gz";
      sha256 = "1xsjylbxxcbkjazqms49ipi94j1hd2ykdikk29cq7dscil5p9r5l";
    };
  };

  Workflow = buildPerlPackage rec {
    name = "Workflow-1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JONASBN/${name}.tar.gz";
      sha256 = "0d93wc9cgw862x9x5zmbx6l6326dhq8py25yqpw7nqym6yphisnc";
    };
    buildInputs = [ DBDMock ListMoreUtils TestException ];
    propagatedBuildInputs = [ ClassAccessor ClassFactory ClassObservable DBI
      DateTime DateTimeFormatStrptime ExceptionClass FileSlurp LogDispatch
      Log4Perl XMLSimple DataUUID ];
    meta = {
      homepage = https://github.com/jonasbn/perl-workflow;
      description = "Simple, flexible system to implement workflows";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Wx = buildPerlPackage rec {
    name = "Wx-0.9932";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "0w0vcpk8bmklh16c0z1vxgipnmvdw7cckcmay7k7cihgb99vdz8w";
    };
    propagatedBuildInputs = [ AlienWxWidgets ];
    # Testing requires an X server:
    #   Error: Unable to initialize GTK+, is DISPLAY set properly?"
    doCheck = false;
    buildInputs = [ ExtUtilsXSpp ];
  };

  WxGLCanvas = buildPerlPackage rec {
    name = "Wx-GLCanvas-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/${name}.tar.gz";
      sha256 = "1q4gvj4gdx4l8k4mkgiix24p9mdfy1miv7abidf0my3gy2gw5lka";
    };
    propagatedBuildInputs = [ pkgs.libGLU Wx ];
    doCheck = false;
  };

  X11IdleTime = buildPerlPackage rec {
    name = "X11-IdleTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWENDT/${name}.tar.gz";
      sha256 = "0j27cb9yy9ymni8cbiyxplbg086b8lv6b330nwqyx0briq3xrzfq";
    };
    buildInputs = [ pkgs.xorg.libXext pkgs.xorg.libXScrnSaver pkgs.xorg.libX11 ];
    propagatedBuildInputs = [ InlineC ];
    patchPhase = ''sed -ie 's,-L/usr/X11R6/lib/,-L${pkgs.xorg.libX11.out}/lib/ -L${pkgs.xorg.libXext.out}/lib/ -L${pkgs.xorg.libXScrnSaver}/lib/,' IdleTime.pm'';
    meta = {
      description = "Get the idle time of X11";
    };
  };

  X11Protocol = buildPerlPackage rec {
    name = "X11-Protocol-0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMCCAM/${name}.tar.gz";
      sha256 = "1dq89bh6fqv7l5mbffqcismcljpq5f869bx7g8lg698zgindv5ny";
    };
    buildInputs = [ pkgs.xlibsWrapper ];
    NIX_CFLAGS_LINK = "-lX11";
    doCheck = false; # requires an X server
  };

  X11GUITest = buildPerlPackage rec {
    name = "X11-GUITest-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTRONDLP/${name}.tar.gz";
      sha256 = "0jznws68skdzkhgkgcgjlj40qdyh9i75r7fw8bqzy406f19xxvnw";
    };
    buildInputs = [ pkgs.xlibsWrapper pkgs.xorg.libXtst pkgs.xorg.libXi ];
    NIX_CFLAGS_LINK = "-lX11 -lXext -lXtst";
    doCheck = false; # requires an X server
  };

  X11XCB = buildPerlPackage rec {
    name = "X11-XCB-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/${name}.tar.gz";
      sha256 = "12qyf98s5hbybmh0mblpz50c00i68srq73w5rw31m2dhclj8n96q";
    };
    AUTOMATED_TESTING = false;
    buildInputs = [ pkgs.xorg.libxcb pkgs.xorg.xcbproto pkgs.xorg.xcbutil pkgs.xorg.xcbutilwm ExtUtilsDepends ExtUtilsPkgConfig TestDeep TestException XSObjectMagic ];
    propagatedBuildInputs = [ DataDump MouseXNativeTraits XMLDescent XMLSimple ];
    NIX_CFLAGS_LINK = [ "-lxcb" "-lxcb-util" "-lxcb-xinerama" "-lxcb-icccm" ];
    doCheck = false; # requires an X server
    meta = {
      description = "XCB bindings for X";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDescent = buildPerlModule rec {
    name = "XML-Descent-1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "0l5xmw2hd95ypppz3lyvp4sn02ccsikzjwacli3ydxfdz1bbh4d7";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ XMLTokeParser ];
    meta = {
      description = "Recursive descent XML parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDOM = buildPerlPackage rec {
    name = "XML-DOM-1.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJMATHER/${name}.tar.gz";
      sha256 = "0phpkc4li43m2g44hdcvyxzy9pymqwlqhh5hwp2xc0cv8l5lp8lb";
    };
    propagatedBuildInputs = [ XMLRegExp libxml_perl ];
  };

  XMLFilterBufferText = buildPerlPackage {
    name = "XML-Filter-BufferText-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz;
      sha256 = "8fd2126d3beec554df852919f4739e689202cbba6a17506e9b66ea165841a75c";
    };
    doCheck = false;
  };

  XMLFilterXInclude = buildPerlPackage {
    name = "XML-Filter-XInclude-1.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Filter-XInclude-1.0.tar.gz;
      sha256 = "98746f3c1f6f049491fec203d455bb8f8c9c6e250f041904dda5d78e21187f93";
    };
    doCheck = false;
  };

  XMLGrove = buildPerlPackage rec {
    name = "XML-Grove-0.46alpha";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/${name}.tar.gz";
      sha256 = "05yis1ms7cgwjh57k57whrmalb3ha0bjr9hyvh7cnadcyiynvdpw";
    };
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ libxml_perl ];

    #patch from https://bugzilla.redhat.com/show_bug.cgi?id=226285
    patches = [ ../development/perl-modules/xml-grove-utf8.patch ];
    meta = {
      description = "Perl-style XML objects";
    };
  };

  XMLHandlerYAWriter = buildPerlPackage rec {
    name = "XML-Handler-YAWriter-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRAEHE/${name}.tar.gz";
      sha256 = "11d45a1sz862va9rry3p2m77pwvq3kpsvgwhc5ramh9mbszbnk77";
    };
    propagatedBuildInputs = [ libxml_perl ];
    meta = {
      description = "Yet another Perl SAX XML Writer";
    };
  };

  XMLLibXML = buildPerlPackage rec {
    name = "XML-LibXML-2.0132";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0xnl281hb590i287fxpl947f1s4zl9dnvc4ajvsqi89w23im453j";
    };
    SKIP_SAX_INSTALL = 1;
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ XMLSAX ];

    # https://rt.cpan.org/Public/Bug/Display.html?id=122958
    preCheck = ''
      rm t/32xpc_variables.t
    '';
  };

  XMLLibXMLSimple = buildPerlPackage {
    name = "XML-LibXML-Simple-0.99";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/XML-LibXML-Simple-0.99.tar.gz;
      sha256 = "14fe45c9fcb36c1cf14ac922da4439f1f83d451a5e70aa7177cb6edb705c9e44";
    };
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      description = "XML::LibXML based XML::Simple clone";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLLibXSLT = buildPerlPackage rec {
    name = "XML-LibXSLT-1.96";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0wyl8klgr65j8y8fzgwz9jlvfjwvxazna8j3dg9gksd2v973fpia";
    };
    buildInputs = [ pkgs.zlib pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [ XMLLibXML ];
  };

  XMLNamespaceSupport = buildPerlPackage {
    name = "XML-NamespaceSupport-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz;
      sha256 = "1vz5pbi4lm5fhq2slrs2hlp6bnk29863abgjlcx43l4dky2rbsa7";
    };
  };

  XMLParser = buildPerlPackage {
    name = "XML-Parser-2.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz;
      sha256 = "05ij0g6bfn27iaggxf8nl5rhlwx6f6p6xmdav6rjcly3x5zd1s8s";
    };
    patchPhase = if stdenv.isCygwin then ''
      sed -i"" -e "s@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. \$Config{_exe};@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. (\$^O eq 'cygwin' ? \"\" : \$Config{_exe});@" inc/Devel/CheckLib.pm
    '' else null;
    makeMakerFlags = "EXPATLIBPATH=${pkgs.expat.out}/lib EXPATINCPATH=${pkgs.expat.dev}/include";
    propagatedBuildInputs = [ LWP ];
  };

  XMLXPath = buildPerlPackage rec {
    name = "XML-XPath-1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/${name}.tar.gz";
      sha256 = "9e6ac67c2cead5f918a060b8b9ccdbdcaa6d610be8517bba42a96cd56748b512";
    };
    buildInputs = [ PathTiny ];
    propagatedBuildInputs = [ ScalarListUtils XMLParser ];
    meta = {
      description = "Modules for parsing and evaluating XPath statements";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  XMLXPathEngine = buildPerlPackage {
    name = "XML-XPathEngine-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-XPathEngine-0.14.tar.gz;
      sha256 = "0r72na14bmsxfd16s9nlza155amqww0k8wsa9x2a3sqbpp5ppznj";
    };
    meta = {
      description = "A re-usable XPath engine for DOM-like trees";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  XMLRegExp = buildPerlPackage {
    name = "XML-RegExp-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz;
      sha256 = "0m7wj00a2kik7wj0azhs1zagwazqh3hlz4255n75q21nc04r06fz";
    };
  };

  XMLRSS = buildPerlModule {
    name = "XML-RSS-1.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/XML-RSS-1.60.tar.gz;
      sha256 = "4b3359878bb1a2bc06dae7ed17b00143a2b89c814b8b12f6e2780f35b1528677";
    };
    propagatedBuildInputs = [ DateTimeFormatMail DateTimeFormatW3CDTF XMLParser ];
    meta = {
      homepage = http://perl-rss.sourceforge.net/;
      description = "Creates and updates RSS files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAX = buildPerlPackage {
    name = "XML-SAX-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-1.00.tar.gz;
      sha256 = "1qra9k3wszjxvsgbragl55z3qba4nri0ipmjaxfib4l6xxj6bsj5";
    };
    propagatedBuildInputs = [ XMLNamespaceSupport XMLSAXBase ];
    postInstall = ''
      perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"
      '';
  };

  XMLSAXBase = buildPerlPackage {
    name = "XML-SAX-Base-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz;
      sha256 = "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0";
    };
    meta = {
      description = "Base class for SAX Drivers and Filters";
      homepage = https://github.com/grantm/XML-SAX-Base;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAXExpat = buildPerlPackage rec {
     name = "XML-SAX-Expat-0.51";
     src = fetchurl {
       url = mirror://cpan/authors/id/B/BJ/BJOERN/XML-SAX-Expat-0.51.tar.gz;
       sha256 = "0gy8h2bvvvlxychwsb99ikdh5cqpk6sqc073jk2b4zffs09n40ac";
     };
     propagatedBuildInputs = [ XMLParser XMLSAX ];
     meta = {
       description = "SAX Driver for Expat";
       license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
     };
  };

  XMLSAXWriter = buildPerlPackage {
    name = "XML-SAX-Writer-0.57";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.57.tar.gz;
      sha256 = "3d61d07ef43b0126f5b4de4f415a256fa859fa88dc4fdabaad70b7be7c682cf0";
    };
    propagatedBuildInputs = [ XMLFilterBufferText XMLNamespaceSupport XMLSAXBase ];
    meta = {
      homepage = https://github.com/perigrin/xml-sax-writer;
      description = "SAX2 XML Writer";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSemanticDiff = buildPerlModule {
    name = "XML-SemanticDiff-1.0006";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/XML-SemanticDiff-1.0006.tar.gz;
      sha256 = "1z0lkb7xzhw9calz4pbwzry2lqqpy6pw6pvfn2gv70ry1xqycr0k";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  XMLSimple = buildPerlPackage {
    name = "XML-Simple-2.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz;
      sha256 = "1y6vh328zrh085d40852v4ij2l4g0amxykswxd1nfhd2pspds7sk";
    };
    propagatedBuildInputs = [ XMLSAXExpat ];
  };

  XMLTokeParser = buildPerlPackage rec {
    name = "XML-TokeParser-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/${name}.tar.gz";
      sha256 = "1hnpwb3lh6cbgwvjjgqzcp6jm4mp612qn6ili38adc9nhkwv8fc5";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Simplified interface to XML::Parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTreePP = buildPerlPackage rec {
    name = "XML-TreePP-0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAWASAKI/${name}.tar.gz";
      sha256 = "7fbe2d6430860059894aeeebf75d4cacf1bf8d7b75294eb87d8e1502f81bd760";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Pure Perl implementation for parsing/writing XML documents";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTwig = buildPerlPackage rec {
    name = "XML-Twig-3.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIROD/${name}.tar.gz";
      sha256 = "1bc0hrz4jp6199hi29sdxmb9gyy45whla9hd19yqfasgq8k5ixzy";
    };
    propagatedBuildInputs = [ XMLParser ];
    doCheck = false;  # requires lots of extra packages
  };

  XMLValidatorSchema = buildPerlPackage {
    name = "XML-Validator-Schema-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMTREGAR/XML-Validator-Schema-1.10.tar.gz;
      sha256 = "6142679580150a891f7d32232b5e31e2b4e5e53e8a6fa9cbeecb5c23814f1422";
    };
    propagatedBuildInputs = [ TreeDAGNode XMLFilterBufferText XMLSAX ];
    meta = {
      description = "Validate XML against a subset of W3C XML Schema";
    };
  };

  XMLWriter = buildPerlPackage rec {
    name = "XML-Writer-0.625";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOSEPHW/${name}.tar.gz";
      sha256 = "1gjzs570i67ywbv967g8ylb5sg59clwmyrl2yix3jl70dhn55070";
    };
  };

  XSLoader = buildPerlPackage {
    name = "XSLoader-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.24.tar.gz;
      sha256 = "0pyqr12jsqagna75fm2gijfzw06wy1hrh5chn9hwnmcfddda66g8";
    };
    meta = {
      homepage = https://metacpan.org/module/Math::BigInt;
      description = "Dynamically load C libraries into Perl code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XSObjectMagic = buildPerlPackage rec {
    name = "XS-Object-Magic-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "03fghj7hq0fiicmfdxhmzfm4mzv7s097pgkd32ji7jnljvhm9six";
    };
    buildInputs = [ ExtUtilsDepends TestFatal ];
    meta = {
      description = "XS pointer backed objects using sv_magic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAML = buildPerlPackage rec {
    name = "YAML-1.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TINITA/YAML-1.24.tar.gz;
      sha256 = "1dpzgnjbd8yvf94vf45cmyj5bc6vrm6bchhx9xqwxqd5f9d093dm";
    };

    buildInputs = [ TestBase TestYAML ];

    meta = {
      homepage = https://github.com/ingydotnet/yaml-pm/tree;
      description = "YAML Ain't Markup Language (tm)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLSyck = buildPerlPackage rec {
    name = "YAML-Syck-1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "1iwd4pbwg7m1vwc74s3f3hk9yyqmhn1ssrbh9466lmbnc4hl9cv2";
    };
    meta = {
      homepage = http://search.cpan.org/dist/YAML-Syck;
      description = "Fast, lightweight YAML loader and dumper";
      license = stdenv.lib.licenses.mit;
    };
  };

  YAMLTiny = buildPerlPackage rec {
    name = "YAML-Tiny-1.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0i3p4nz8ysrsrs6vlzc6gkjcfpcaf05xjc7lwbjkw7lg5shmycdw";
    };
  };

  YAMLLibYAML = buildPerlPackage rec {
    name = "YAML-LibYAML-0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/${name}.tar.gz";
      sha256 = "06msvj3vmjszl5zj1k7g47ll0kkds9gdb5sky0q27lh4zw1vlj33";
    };
    doCheck = false;
  };

  WebServiceLinode = buildPerlModule rec {
    name = "WebService-Linode-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEGRB/${name}.tar.gz";
      sha256 = "66a315016999c0d2043caae86e664dad10c6613708f33a2f56aae8030326c509";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ JSON LWPProtocolHttps ];
    meta = {
      homepage = https://github.com/mikegrb/WebService-Linode;
      description = "Perl Interface to the Linode.com API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

}; in self
