# This file has been generated by node2nix 1.5.2. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {
    "abbrev-1.1.1" = {
      name = "abbrev";
      packageName = "abbrev";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz";
        sha512 = "38s4f3id97wsb0rg9nm9zvxyq0nvwrmrpa5dzvrkp36mf5ibs98b4z6lvsbrwzzs0sbcank6c7gpp06vcwp9acfhp41rzlhi3ybsxwy";
      };
    };
    "async-2.1.5" = {
      name = "async";
      packageName = "async";
      version = "2.1.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/async/-/async-2.1.5.tgz";
        sha1 = "e587c68580994ac67fc56ff86d3ac56bdbe810bc";
      };
    };
    "balanced-match-1.0.0" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    };
    "brace-expansion-1.1.11" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "1.1.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha512 = "248cnpbbf0p32h53rd3g8wzpgrkaj4p078ra1g6l16f82i6bzkvmhwqan5rk88apbll9ly1476kngd7f7z27i3b3zxpbb3064f8yaw8";
      };
    };
    "browser-stdout-1.3.0" = {
      name = "browser-stdout";
      packageName = "browser-stdout";
      version = "1.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/browser-stdout/-/browser-stdout-1.3.0.tgz";
        sha1 = "f351d32969d32fa5d7a5567154263d928ae3bd1f";
      };
    };
    "cli-table-0.3.1" = {
      name = "cli-table";
      packageName = "cli-table";
      version = "0.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/cli-table/-/cli-table-0.3.1.tgz";
        sha1 = "f53b05266a8b1a0b934b3d0821e6e2dc5914ae23";
      };
    };
    "colors-1.0.3" = {
      name = "colors";
      packageName = "colors";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
        sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
      };
    };
    "commander-2.11.0" = {
      name = "commander";
      packageName = "commander";
      version = "2.11.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/commander/-/commander-2.11.0.tgz";
        sha512 = "2yi2hwf0bghfnv1fdgd4wvh7s0acjrgqbgww97ncm6i6s6ffs1zahnj48f6gqpqj6fsf0jigvnr0civ25k2160c38281r80wvg7jkkg";
      };
    };
    "commander-2.9.0" = {
      name = "commander";
      packageName = "commander";
      version = "2.9.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
        sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
      };
    };
    "concat-map-0.0.1" = {
      name = "concat-map";
      packageName = "concat-map";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    };
    "core-util-is-1.0.2" = {
      name = "core-util-is";
      packageName = "core-util-is";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    };
    "debug-3.1.0" = {
      name = "debug";
      packageName = "debug";
      version = "3.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-3.1.0.tgz";
        sha512 = "3g1hqsahr1ks2kpvdxrwzr57fj90nnr0hvwwrw8yyyzcv3i11sym8zwibxx67bl1mln0acddrzpkkdjjxnc6n2cm9fazmgzzsl1fzrr";
      };
    };
    "diff-3.3.1" = {
      name = "diff";
      packageName = "diff";
      version = "3.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/diff/-/diff-3.3.1.tgz";
        sha512 = "31pj7v5gg5igmvwzk6zxw1wbvwjg6m9sfl0h3bs1x4q6idcw98vr8z8wcqk2603q0blpqkmkxp659kjj91wksr03yr8xlh16djcg8rh";
      };
    };
    "escape-string-regexp-1.0.5" = {
      name = "escape-string-regexp";
      packageName = "escape-string-regexp";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    };
    "findup-sync-0.3.0" = {
      name = "findup-sync";
      packageName = "findup-sync";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/findup-sync/-/findup-sync-0.3.0.tgz";
        sha1 = "37930aa5d816b777c03445e1966cc6790a4c0b16";
      };
    };
    "fs.realpath-1.0.0" = {
      name = "fs.realpath";
      packageName = "fs.realpath";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
      };
    };
    "glob-5.0.15" = {
      name = "glob";
      packageName = "glob";
      version = "5.0.15";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-5.0.15.tgz";
        sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
      };
    };
    "glob-7.1.2" = {
      name = "glob";
      packageName = "glob";
      version = "7.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-7.1.2.tgz";
        sha512 = "08vjxzixc9dwc1hn5pd60yyij98krk2pr758aiga97r02ncvaqx1hidi95wk470k1v84gg4alls9bm52m77174z128bgf13b61x951h";
      };
    };
    "graceful-fs-4.1.11" = {
      name = "graceful-fs";
      packageName = "graceful-fs";
      version = "4.1.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.11.tgz";
        sha1 = "0e8bdfe4d1ddb8854d64e04ea7c00e2a026e5658";
      };
    };
    "graceful-readlink-1.0.1" = {
      name = "graceful-readlink";
      packageName = "graceful-readlink";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
    };
    "growl-1.10.3" = {
      name = "growl";
      packageName = "growl";
      version = "1.10.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/growl/-/growl-1.10.3.tgz";
        sha512 = "3aibvz85l13j140w4jjdk8939q6r7dnf8ay2licxgkaaldk7wbm093c1p5g7k5cg80rl0xslmczyraawfgdr82hhxn7rfsm1rn6rac4";
      };
    };
    "grunt-known-options-1.1.0" = {
      name = "grunt-known-options";
      packageName = "grunt-known-options";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/grunt-known-options/-/grunt-known-options-1.1.0.tgz";
        sha1 = "a4274eeb32fa765da5a7a3b1712617ce3b144149";
      };
    };
    "has-flag-2.0.0" = {
      name = "has-flag";
      packageName = "has-flag";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/has-flag/-/has-flag-2.0.0.tgz";
        sha1 = "e8207af1cc7b30d446cc70b734b5e8be18f88d51";
      };
    };
    "he-1.1.1" = {
      name = "he";
      packageName = "he";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/he/-/he-1.1.1.tgz";
        sha1 = "93410fd21b009735151f8868c2f271f3427e23fd";
      };
    };
    "inflight-1.0.6" = {
      name = "inflight";
      packageName = "inflight";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    };
    "inherits-2.0.3" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    };
    "isarray-1.0.0" = {
      name = "isarray";
      packageName = "isarray";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    };
    "lodash-4.17.5" = {
      name = "lodash";
      packageName = "lodash";
      version = "4.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash/-/lodash-4.17.5.tgz";
        sha512 = "11hikgyas884mz8a58vyixaahxbpdwljdw4cb6qp15xa3sfqikp2mm6wgv41jsl34nzsv1hkx9kw3nwczvas5p73whirmaz4sxggwmj";
      };
    };
    "minimatch-3.0.4" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "3.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz";
        sha512 = "1879a3j85h92ypvb7lpv1dqpcxl49rqnbgs5la18zmj1yqhwl60c2m74254wbr5pp3znckqpkg9dvjyrz6hfz8b9vag5a3j910db4f8";
      };
    };
    "minimist-0.0.8" = {
      name = "minimist";
      packageName = "minimist";
      version = "0.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    };
    "mkdirp-0.5.1" = {
      name = "mkdirp";
      packageName = "mkdirp";
      version = "0.5.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
      };
    };
    "ms-2.0.0" = {
      name = "ms";
      packageName = "ms";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    };
    "nopt-3.0.6" = {
      name = "nopt";
      packageName = "nopt";
      version = "3.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz";
        sha1 = "c6465dbf08abcd4db359317f79ac68a646b28ff9";
      };
    };
    "once-1.4.0" = {
      name = "once";
      packageName = "once";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    };
    "optparse-1.0.5" = {
      name = "optparse";
      packageName = "optparse";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/optparse/-/optparse-1.0.5.tgz";
        sha1 = "75e75a96506611eb1c65ba89018ff08a981e2c16";
      };
    };
    "path-is-absolute-1.0.1" = {
      name = "path-is-absolute";
      packageName = "path-is-absolute";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    };
    "process-nextick-args-2.0.0" = {
      name = "process-nextick-args";
      packageName = "process-nextick-args";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.0.tgz";
        sha512 = "0rw8xpqqkhs91722slvzf8icxfaimqp4w8zb3840jxr7r8n8035byl6dhdi5bm0yr6x7sdws0gf3m025fg6hqgaklwlbl4d7bah5l9j";
      };
    };
    "readable-stream-2.3.4" = {
      name = "readable-stream";
      packageName = "readable-stream";
      version = "2.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.4.tgz";
        sha512 = "1jpffi1v0l7pkzrhh8i9c6cbswa9npyx114cbfncfnzl9d7w9p08k9n703hq5xr2c3rg86qiq023sl1x8y6mawgsxgggy8ccrwk3rmy";
      };
    };
    "readdirp-2.1.0" = {
      name = "readdirp";
      packageName = "readdirp";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/readdirp/-/readdirp-2.1.0.tgz";
        sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
      };
    };
    "resolve-1.1.7" = {
      name = "resolve";
      packageName = "resolve";
      version = "1.1.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz";
        sha1 = "203114d82ad2c5ed9e8e0411b3932875e889e97b";
      };
    };
    "safe-buffer-5.1.1" = {
      name = "safe-buffer";
      packageName = "safe-buffer";
      version = "5.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.1.tgz";
        sha512 = "1p28rllll1w65yzq5azi4izx962399xdsdlfbaynn7vmp981hiss05jhiy9hm7sbbfk3b4dhlcv0zy07fc59mnc07hdv6wcgqkcvawh";
      };
    };
    "set-immediate-shim-1.0.1" = {
      name = "set-immediate-shim";
      packageName = "set-immediate-shim";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
        sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
      };
    };
    "slasp-0.0.4" = {
      name = "slasp";
      packageName = "slasp";
      version = "0.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/slasp/-/slasp-0.0.4.tgz";
        sha1 = "9adc26ee729a0f95095851a5489f87a5258d57a9";
      };
    };
    "string_decoder-1.0.3" = {
      name = "string_decoder";
      packageName = "string_decoder";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/string_decoder/-/string_decoder-1.0.3.tgz";
        sha512 = "22vw5mmwlyblqc2zyqwl39wyhyahhpiyknim8iz5fk6xi002x777gkswiq8fh297djs5ii4pgrys57wq33hr5zf3xfd0d7kjxkzl0g0";
      };
    };
    "supports-color-4.4.0" = {
      name = "supports-color";
      packageName = "supports-color";
      version = "4.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/supports-color/-/supports-color-4.4.0.tgz";
        sha512 = "1flwwfdd7gg94xrc0b2ard3qjx4cpy600q49gx43y8pzvs7j56q78bjhv8mk18vgbggr4fd11jda8ck5cdrkc5jcjs04nlp7kwbg85c";
      };
    };
    "util-deprecate-1.0.2" = {
      name = "util-deprecate";
      packageName = "util-deprecate";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    };
    "wrappy-1.0.2" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    };
  };
in
{
  bower = nodeEnv.buildNodePackage {
    name = "bower";
    packageName = "bower";
    version = "1.8.2";
    src = fetchurl {
      url = "https://registry.npmjs.org/bower/-/bower-1.8.2.tgz";
      sha1 = "adf53529c8d4af02ef24fb8d5341c1419d33e2f7";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "The browser package manager";
      homepage = http://bower.io/;
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
  coffee-script = nodeEnv.buildNodePackage {
    name = "coffee-script";
    packageName = "coffee-script";
    version = "1.12.7";
    src = fetchurl {
      url = "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.7.tgz";
      sha512 = "29mq40padyvizg4f141b00p0p74hx9v06d7gxk84ggsiyw6rf5bb65gnfwk1i02r276jwqybmi5hx98s943slyazjnqd69jmj389dvw";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "Unfancy JavaScript";
      homepage = http://coffeescript.org/;
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
  grunt-cli = nodeEnv.buildNodePackage {
    name = "grunt-cli";
    packageName = "grunt-cli";
    version = "1.2.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.2.0.tgz";
      sha1 = "562b119ebb069ddb464ace2845501be97b35b6a8";
    };
    dependencies = [
      sources."abbrev-1.1.1"
      sources."balanced-match-1.0.0"
      sources."brace-expansion-1.1.11"
      sources."concat-map-0.0.1"
      sources."findup-sync-0.3.0"
      sources."glob-5.0.15"
      sources."grunt-known-options-1.1.0"
      sources."inflight-1.0.6"
      sources."inherits-2.0.3"
      sources."minimatch-3.0.4"
      sources."nopt-3.0.6"
      sources."once-1.4.0"
      sources."path-is-absolute-1.0.1"
      sources."resolve-1.1.7"
      sources."wrappy-1.0.2"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "The grunt command line interface";
      homepage = "https://github.com/gruntjs/grunt-cli#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
  mocha = nodeEnv.buildNodePackage {
    name = "mocha";
    packageName = "mocha";
    version = "5.0.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/mocha/-/mocha-5.0.1.tgz";
      sha512 = "2975gb84ixyiin9mdahnmpxxqmn9zmc7d07hh6kv0bnl3mqf6slj83r1f44hvk9f5qk247ajfdmynbyinabrbfi0j8za4v776i3572a";
    };
    dependencies = [
      sources."balanced-match-1.0.0"
      sources."brace-expansion-1.1.11"
      sources."browser-stdout-1.3.0"
      sources."commander-2.11.0"
      sources."concat-map-0.0.1"
      sources."debug-3.1.0"
      sources."diff-3.3.1"
      sources."escape-string-regexp-1.0.5"
      sources."fs.realpath-1.0.0"
      sources."glob-7.1.2"
      sources."growl-1.10.3"
      sources."has-flag-2.0.0"
      sources."he-1.1.1"
      sources."inflight-1.0.6"
      sources."inherits-2.0.3"
      sources."minimatch-3.0.4"
      sources."minimist-0.0.8"
      sources."mkdirp-0.5.1"
      sources."ms-2.0.0"
      sources."once-1.4.0"
      sources."path-is-absolute-1.0.1"
      sources."supports-color-4.4.0"
      sources."wrappy-1.0.2"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "simple, flexible, fun test framework";
      homepage = https://mochajs.org/;
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
  nijs = nodeEnv.buildNodePackage {
    name = "nijs";
    packageName = "nijs";
    version = "0.0.25";
    src = fetchurl {
      url = "https://registry.npmjs.org/nijs/-/nijs-0.0.25.tgz";
      sha1 = "04b035cb530d46859d1018839a518c029133f676";
    };
    dependencies = [
      sources."optparse-1.0.5"
      sources."slasp-0.0.4"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "An internal DSL for the Nix package manager in JavaScript";
      homepage = "https://github.com/svanderburg/nijs#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
  semver = nodeEnv.buildNodePackage {
    name = "semver";
    packageName = "semver";
    version = "5.5.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/semver/-/semver-5.5.0.tgz";
      sha512 = "0h32zh035y8m6dzcqhcymbhwgmc8839fa1hhj0jfh9ivp9kmqfj1sbwnsnkzcn9qm3sqn38sa8ys2g4c638lpnmzjr0a0qndmv7f8p1";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "The semantic version parser used by npm.";
      homepage = "https://github.com/npm/node-semver#readme";
      license = "ISC";
    };
    production = true;
    bypassCache = true;
  };
  sloc = nodeEnv.buildNodePackage {
    name = "sloc";
    packageName = "sloc";
    version = "0.2.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/sloc/-/sloc-0.2.0.tgz";
      sha1 = "b42d3da1a442a489f454c32c628e8ebf0007875c";
    };
    dependencies = [
      sources."async-2.1.5"
      sources."balanced-match-1.0.0"
      sources."brace-expansion-1.1.11"
      sources."cli-table-0.3.1"
      sources."colors-1.0.3"
      sources."commander-2.9.0"
      sources."concat-map-0.0.1"
      sources."core-util-is-1.0.2"
      sources."graceful-fs-4.1.11"
      sources."graceful-readlink-1.0.1"
      sources."inherits-2.0.3"
      sources."isarray-1.0.0"
      sources."lodash-4.17.5"
      sources."minimatch-3.0.4"
      sources."process-nextick-args-2.0.0"
      sources."readable-stream-2.3.4"
      sources."readdirp-2.1.0"
      sources."safe-buffer-5.1.1"
      sources."set-immediate-shim-1.0.1"
      sources."string_decoder-1.0.3"
      sources."util-deprecate-1.0.2"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "sloc is a simple tool to count SLOC (source lines of code)";
      homepage = "https://github.com/flosse/sloc#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
}