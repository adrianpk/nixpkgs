{ stdenv, buildPackages, lib
, fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
, zlib, openssl, gdbm, ncurses, readline, groff, libyaml, libffi, autoreconfHook, bison
, autoconf, libiconv, libobjc, libunwind, Foundation
, buildEnv, bundler, bundix
} @ args:

let
  op = lib.optional;
  ops = lib.optionals;
  opString = lib.optionalString;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix { inherit fetchFromSavannah; };
  rubygemsSrc = import ./rubygems-src.nix { inherit fetchurl; };
  rubygemsPatch = fetchpatch {
    url = "https://github.com/zimbatm/rubygems/compare/v2.6.6...v2.6.6-nix.patch";
    sha256 = "0297rdb1m6v75q8665ry9id1s74p9305dv32l95ssf198liaihhd";
  };
  unpackdir = obj:
    lib.removeSuffix ".tgz"
      (lib.removeSuffix ".tar.gz" obj.name);

  # Contains the ruby version heuristics
  rubyVersion = import ./ruby-version.nix { inherit lib; };

  # Needed during postInstall
  buildRuby =
    if stdenv.hostPlatform == stdenv.buildPlatform
    then "$out/bin/ruby"
    else "${buildPackages.ruby}/bin/ruby";

  generic = { version, sha256 }: let
    ver = version;
    tag = ver.gitTag;
    isRuby20 = ver.majMin == "2.0";
    isRuby21 = ver.majMin == "2.1";
    isRuby25 = ver.majMin == "2.5";
    baseruby = self.override { useRailsExpress = false; };
    self = lib.makeOverridable (
      { stdenv, buildPackages, lib
      , fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
      , useRailsExpress ? true
      , zlib, zlibSupport ? true
      , openssl, opensslSupport ? true
      , gdbm, gdbmSupport ? true
      , ncurses, readline, cursesSupport ? true
      , groff, docSupport ? false
      , libyaml, yamlSupport ? true
      , libffi, fiddleSupport ? true
      , autoreconfHook, bison, autoconf
      , buildEnv, bundler, bundix
      , libiconv, libobjc, libunwind, Foundation
      }:
      let rubySrc =
        if useRailsExpress then fetchFromGitHub {
          owner  = "ruby";
          repo   = "ruby";
          rev    = tag;
          sha256 = sha256.git;
        } else fetchurl {
          url = "http://cache.ruby-lang.org/pub/ruby/${ver.majMin}/ruby-${ver}.tar.gz";
          sha256 = sha256.src;
        };
      in
      stdenv.mkDerivation rec {
        name = "ruby-${version}";

        srcs = [ rubySrc rubygemsSrc ];
        sourceRoot =
          if useRailsExpress then
            rubySrc.name
          else
            unpackdir rubySrc;

        # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
        NROFF = if docSupport then "${groff}/bin/nroff" else null;

        nativeBuildInputs =
             ops useRailsExpress [ autoreconfHook bison ]
          ++ ops (stdenv.buildPlatform != stdenv.hostPlatform) [
               buildPackages.ruby
             ];
        buildInputs =
             (op fiddleSupport libffi)
          ++ (ops cursesSupport [ ncurses readline ])
          ++ (op docSupport groff)
          ++ (op zlibSupport zlib)
          ++ (op opensslSupport openssl)
          ++ (op gdbmSupport gdbm)
          ++ (op yamlSupport libyaml)
          ++ (op isRuby25 autoconf)
          # Looks like ruby fails to build on darwin without readline even if curses
          # support is not enabled, so add readline to the build inputs if curses
          # support is disabled (if it's enabled, we already have it) and we're
          # running on darwin
          ++ op (!cursesSupport && stdenv.isDarwin) readline
          ++ ops stdenv.isDarwin [ libiconv libobjc libunwind Foundation ];

        enableParallelBuilding = true;

        patches =
          (import ./patchsets.nix {
            inherit patchSet useRailsExpress ops;
            patchLevel = ver.patchLevel;
          })."${ver.majMinTiny}";

        postUnpack = ''
          cp -r ${unpackdir rubygemsSrc} ${sourceRoot}/rubygems
          pushd ${sourceRoot}/rubygems
          patch -p1 < ${rubygemsPatch}
          popd
        '';

        postPatch = if isRuby25 then ''
          sed -i configure.ac -e '/config.guess/d'
          cp ${config}/config.guess tool/
          cp ${config}/config.sub tool/
        ''
        else opString useRailsExpress ''
          sed -i configure.in -e '/config.guess/d'
          cp ${config}/config.guess tool/
          cp ${config}/config.sub tool/
        '';

        configureFlags = ["--enable-shared" "--enable-pthread"]
          ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby"
          ++ op (!docSupport) "--disable-install-doc"
          ++ ops stdenv.isDarwin [
            # on darwin, we have /usr/include/tk.h -- so the configure script detects
            # that tk is installed
            "--with-out-ext=tk"
            # on yosemite, "generating encdb.h" will hang for a very long time without this flag
            "--with-setjmp-type=setjmp"
          ]
          ++ op (stdenv.hostPlatform != stdenv.buildPlatform)
             "--with-baseruby=${buildRuby}";

        # fails with "16993 tests, 2229489 assertions, 105 failures, 14 errors, 89 skips"
        # mostly TZ- and patch-related tests
        # TZ- failures are caused by nix sandboxing, I didn't investigate others
        doCheck = false;

        preInstall = ''
          # Ruby installs gems here itself now.
          mkdir -pv "$out/${passthru.gemPath}"
          export GEM_HOME="$out/${passthru.gemPath}"
        '';

        installFlags = stdenv.lib.optionalString docSupport "install-doc";
        # Bundler tries to create this directory
        postInstall = ''
          # Update rubygems
          pushd rubygems
          ${buildRuby} setup.rb
          popd

          # Remove unnecessary groff reference from runtime closure, since it's big
          sed -i '/NROFF/d' $out/lib/ruby/*/*/rbconfig.rb

          # Bundler tries to create this directory
          mkdir -p $out/nix-support
          cat > $out/nix-support/setup-hook <<EOF
          addGemPath() {
            addToSearchPath GEM_PATH \$1/${passthru.gemPath}
          }

          addEnvHooks "$hostOffset" addGemPath
          EOF
        '' + opString useRailsExpress ''
          rbConfig=$(find $out/lib/ruby -name rbconfig.rb)

          # Prevent the baseruby from being included in the closure.
          sed -i '/^  CONFIG\["BASERUBY"\]/d' $rbConfig
          sed -i "s|'--with-baseruby=${baseruby}/bin/ruby'||" $rbConfig
        '';

        meta = with stdenv.lib; {
          description = "The Ruby language";
          homepage    = http://www.ruby-lang.org/en/;
          license     = licenses.ruby;
          maintainers = with maintainers; [ vrthra manveru ];
          platforms   = platforms.all;
        };

        passthru = rec {
          version = ver;
          rubyEngine = "ruby";
          baseRuby = baseruby;
          libPath = "lib/${rubyEngine}/${ver.libDir}";
          gemPath = "lib/${rubyEngine}/gems/${ver.libDir}";
          devEnv = import ./dev.nix {
            inherit buildEnv bundler bundix;
            ruby = self;
          };

          # deprecated 2016-09-21
          majorVersion = ver.major;
          minorVersion = ver.minor;
          teenyVersion = ver.tiny;
          patchLevel = ver.patchLevel;
        };
      }
    ) args; in self;

in {
  ruby_2_3 = generic {
    version = rubyVersion "2" "3" "7" "";
    sha256 = {
      src = "0zvx5kdp1frjs9n95n7ba7dy0alax33wi3nj8034m3ppvnf39k9m";
      git = "11wbzw2ywwfnvlkg3qjg0as2pzk5zyk63y2iis42d91lg1l2flrk";
    };
  };

  ruby_2_4 = generic {
    version = rubyVersion "2" "4" "4" "";
    sha256 = {
      src = "0nmfr2lijik6cykk0zbj11zcapcrvmdvq83k3r6q3k74g4d1qkr5";
      git = "103cs7hz1v0h84lbrippl87s4lawi20m406rs5dgxl2gr2wyjpy5";
    };
  };

  ruby_2_5 = generic {
    version = rubyVersion "2" "5" "1" "";
    sha256 = {
      src = "1c99k0fjaq7k09104h1b1cqx6mrk2b14ic1jjnxc6yav68i1ij6s";
      git = "1j0fd16aq9x98n0kq9c3kfp2sh6xcsq8q4733p0wfqjh3vz50kyj";
    };
  };
}
