/* libraries and applications from rubyforge

  run
    $gem nix $EXSTING_TARGETS new-target-package

  EXSTING_TARGETS can be looked up below after "has been generated by "

  Don't forget add
  export GEM_PATH=~/.nix/profile
  export RUBYLIB=~/.nix-profile/gems/rubygems-update-1.3.4/lib/
  export RUBYOPT=rubygems
  to your .bashrc
*/

{pkgs, stdenv}:
let libs =
  let 
    inherit (pkgs) fetchurl;
    ruby = pkgs.ruby; # select ruby version here
    rubygems = pkgs.rubygemsFun ruby; # for bootstrapping
    inherit (pkgs.lib) mergeAttrsByFuncDefaults optional;
    inherit (builtins) hasAttr getAttr;

    # these settings are merged into the automatically generated settings
    # either the nameNoVersion or name must match
    patches = {
      sup = {
        buildInputs = [ pkgs.ncurses libs.rubygems_update ];
      };
      ncurses = { buildInputs = [ pkgs.ncurses ]; };
      nokogiri = {
      
        buildFlags=["--with-xml2-dir=${pkgs.libxml2} --with-xml2-include=${pkgs.libxml2}/include/libxml2"
                    "--with-xslt-dir=${pkgs.libxslt}" ]; };
      rubygems_update = {
        postInstall = ''
          cd $out/gems/*; patch -p 1 < ${./gem_nix_command.patch}; echo
        '';
      };
    };

    rubyDerivation = args :
      let completeArgs = (mergeAttrsByFuncDefaults 
          ([{
            buildInputs = [rubygems pkgs.makeWrapper];
            unpackPhase = ":";
            configurePhase=":";
            bulidPhase=":";
            # TODO add some abstraction for this kind of env path concatenation. It's used multiple times
            installPhase = ''
              ensureDir "$out/nix-support"
              export HOME=$TMP/home; mkdir "$HOME"

              gem install -E -i "$out" "$src" -- $buildFlags
              rm -fr $out/cache # don't keep the .gem file here

              THIS_RUBY_LIB=$out/gems/$name/lib
              THIS_GEM_PATH=$out

              cat >> $out/nix-support/setup-hook << EOF 
                declare -A RUBYLIB_HASH # using bash4 hashs
                declare -A GEM_PATH_HASH # using bash4 hashs

                RUBYLIB_HASH["$THIS_RUBY_LIB"]=
                for path in \''${!RUBYLIB_HASH[@]}; do
                  export RUBYLIB=\''${RUBYLIB}\''${RUBYLIB:+:}\$path
                done
                GEM_PATH_HASH["$THIS_GEM_PATH"]=
                for path in \''${!GEM_PATH_HASH[@]}; do
                  export GEM_PATH=\''${GEM_PATH_HASH}\''${GEM_PATH:+:}\$path
                done
              EOF
              . $out/nix-support/setup-hook
              for prog in $out/gems/*/bin/*; do
                sed -i '1s@.*@#!  ${ruby}/bin/ruby@' "$prog"
                t="$out/bin/$(basename "$prog")"
                cat >> "$t" << EOF
              #!/bin/sh
              export GEM_PATH=$GEM_PATH:\$GEM_PATH
              #export RUBYLIB=$RUBYLIB:\$RUBYLIB
              exec ruby $prog "\$@"
              EOF
                chmod +x "$t"
              done

              runHook postInstall
            '';
          } args ]
            ++ optional (hasAttr args.name patches) (getAttr args.name patches)
            ++ optional (hasAttr args.nameNoVersion patches) (getAttr args.nameNoVersion patches)
          )); in stdenv.mkDerivation (removeAttrs completeArgs ["mergeAttrBy"]);
  in
  rec {

  # ================ START automatically generated code ================

           # WARNING: automatically generated CODE
           # This section has been generated by
           # $ gem nix sup chronic rubygems-update
           # both rubygems (all-packages.nix) and rubygems_update are patched
           # adding the nix command
        
    rubygems_update_1_3_4 = rubyDerivation {
       name = "ruby-rubygems-update-1.3.4"; # full_name
       nameNoVersion = "rubygems_update";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rubygems-update-1.3.4.gem";
         sha256 = "1y7svhxpr1bfzdpwlaqymm71sbvbhyf3yyifnxadkwd0zqp3chqp";
       };
       meta = {
         homepage = "http://rubygems.rubyforge.org";
         license = []; # one of ?
         description = "RubyGems is a package management framework for Ruby  This gem is an update for the RubyGems software.  You must have an i"; # cut to 120 chars
         longDescription = "RubyGems is a package management framework for Ruby.

  This gem is an update for the RubyGems software.  You must have an
  installation of RubyGems before this update can be applied.
  ";
       };
    };

    rexical_1_0_4 = rubyDerivation {
       name = "ruby-rexical-1.0.4"; # full_name
       nameNoVersion = "rexical";
       propagatedBuildInputs = [ hoe_2_3_2 ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rexical-1.0.4.gem";
         sha256 = "1jfhrlnilb422jvhlbc6dqs25ba45hb2wz5yxdpk27yb0dn9ihid";
       };
       meta = {
         homepage = "http://github.com/tenderlove/rexical/tree/master";
         license = []; # one of ?
         description = "Rexical is a lexical scanner generator It is written in Ruby itself, and generates Ruby program. It is designed for use w"; # cut to 120 chars
         longDescription = "Rexical is a lexical scanner generator.
  It is written in Ruby itself, and generates Ruby program.
  It is designed for use with Racc.";
       };
    };

    ferret_0_11_6 = rubyDerivation {
       name = "ruby-ferret-0.11.6"; # full_name
       nameNoVersion = "ferret";
       propagatedBuildInputs = [ rake_0_8_7 ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/ferret-0.11.6.gem";
         sha256 = "0q0zdrmfm41ijf1n19s85vg34b1a558x5cnwmbb8fc8kzxklzbih";
       };
       meta = {
         homepage = "http://ferret.davebalmain.com/trac";
         license = []; # one of ?
         description = "Ferret is a port of the Java Lucene project[...]";
         longDescription = "Ferret is a port of the Java Lucene project. It is a powerful indexing and search library.";
       };
    };

    rake_0_8_7 = rubyDerivation {
       name = "ruby-rake-0.8.7"; # full_name
       nameNoVersion = "rake";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rake-0.8.7.gem";
         sha256 = "03z1zm7xwl2r9v945ambwbd9sn2smbi34xldmac7qjcmsvd7pcqh";
       };
       meta = {
         homepage = "http://rake.rubyforge.org";
         license = []; # one of ?
         description = "Rake is a Make-like program implemented in Ruby[...]";
         longDescription = "Rake is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax.";
       };
    };

    racc_1_4_6 = rubyDerivation {
       name = "ruby-racc-1.4.6"; # full_name
       nameNoVersion = "racc";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/racc-1.4.6.gem";
         sha256 = "0y43s36bbn96pksf7dbpgjyyd9qsyyn77cl7hnfjwldhfvbfcxsq";
       };
       meta = {
         homepage = "http://racc.rubyforge.org/";
         license = []; # one of ?
         description = "Racc is a LALR(1) parser generator[...]";
         longDescription = "Racc is a LALR(1) parser generator. It is written in Ruby itself, and generates Ruby program.";
       };
    };

    chronic_0_2_3 = rubyDerivation {
       name = "ruby-chronic-0.2.3"; # full_name
       nameNoVersion = "chronic";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/chronic-0.2.3.gem";
         sha256 = "0gm4i9iwpvsk07nzvy8fmyad4y7i284vvdrxrlbgb23lr17qpl17";
       };
       meta = {
         homepage = "	http://chronic.rubyforge.org/";
         license = []; # one of ?
         description = "Chronic is a natural language date/time parser written in pure Ruby[...]";
         longDescription = "Chronic is a natural language date/time parser written in pure Ruby. See below for the wide variety of formats Chronic will parse.";
       };
    };

    nokogiri_1_3_2 = rubyDerivation {
       name = "ruby-nokogiri-1.3.2"; # full_name
       nameNoVersion = "nokogiri";
       propagatedBuildInputs = [ racc_1_4_6 rexical_1_0_4 rake_compiler_0_5_0  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/nokogiri-1.3.2.gem";
         sha256 = "1j5w39nriyw8ly1pzn7giw6wd9r5wclj4r1933z5ximss7l7ih15";
       };
       meta = {
         homepage = "http://nokogiri.org/";
         license = []; # one of ?
         description = "Nokogiri (&#37624;) is an HTML, XML, SAX, and Reader parser many features is the ability to search documents via XPath or"; # cut to 120 chars
         longDescription = "Nokogiri (&#37624;) is an HTML, XML, SAX, and Reader parser.  Among Nokogiri's
  many features is the ability to search documents via XPath or CSS3 selectors.

  XML is like violence - if it doesn&#8217;t solve your problems, you are not using
  enough of it.";
       };
    };

    archive_tar_minitar_0_5_2 = rubyDerivation {
       name = "ruby-archive-tar-minitar-0.5.2"; # full_name
       nameNoVersion = "archive_tar_minitar";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/archive-tar-minitar-0.5.2.gem";
         sha256 = "1j666713r3cc3wb0042x0wcmq2v11vwwy5pcaayy5f0lnd26iqig";
       };
       meta = {
         homepage = "http://rubyforge.org/projects/ruwiki/";
         license = []; # one of ?
         description = "Archive::Tar::Minitar is a pure-Ruby library and command-line utility that provides the ability to deal with POSIX tar(1)"; # cut to 120 chars
         longDescription = "Archive::Tar::Minitar is a pure-Ruby library and command-line utility that provides the ability to deal with POSIX tar(1) archive files. The implementation is based heavily on Mauricio Ferna'ndez's implementation in rpa-base, but has been reorganised to promote reuse in other projects.";
       };
    };

    rubyforge_1_0_3 = rubyDerivation {
       name = "ruby-rubyforge-1.0.3"; # full_name
       nameNoVersion = "rubyforge";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rubyforge-1.0.3.gem";
         sha256 = "0pwhb8mrnmcr5yybh13csfn658s1r1y978wj5m3mn85cbvwrrkyz";
       };
       meta = {
         homepage = "http://codeforpeople.rubyforge.org/rubyforge/";
         license = []; # one of ?
         description = "A script which automates a limited set of rubyforge operations[...]";
         longDescription = "A script which automates a limited set of rubyforge operations.  * Run 'rubyforge help' for complete usage. * Setup: For first time users AND upgrades to 0.4.0: * rubyforge setup (deletes your username and password, so run sparingly!) * edit ~/.rubyforge/user-config.yml * rubyforge config * For all rubyforge upgrades, run 'rubyforge config' to ensure you have latest. * Don't forget to login!  logging in will store a cookie in your .rubyforge directory which expires after a time.  always run the login command before any operation that requires authentication, such as uploading a package.";
       };
    };

    ncurses_0_9_1 = rubyDerivation {
       name = "ruby-ncurses-0.9.1"; # full_name
       nameNoVersion = "ncurses";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/ncurses-0.9.1.gem";
         sha256 = "18qxp33imgrp337p7zrk0c008ydw08g73x1gxiqclhgvyqxa42v3";
       };
       meta = {
         homepage = "http://ncurses-ruby.berlios.de/";
         license = []; # one of ?
         description = "[...]";
         longDescription = "";
       };
    };

    fastthread_1_0_7 = rubyDerivation {
       name = "ruby-fastthread-1.0.7"; # full_name
       nameNoVersion = "fastthread";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/fastthread-1.0.7.gem";
         sha256 = "003ngap8rmwsl4bvf44hz8q4ajm9d0sbn38pm28dajng3pm8q6mx";
       };
       meta = {
         homepage = "";
         license = []; # one of ?
         description = "Optimized replacement for thread[...]";
         longDescription = "Optimized replacement for thread.rb primitives";
       };
    };

    hoe_2_3_2 = rubyDerivation {
       name = "ruby-hoe-2.3.2"; # full_name
       nameNoVersion = "hoe";
       propagatedBuildInputs = [   ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/hoe-2.3.2.gem";
         sha256 = "1asip0l73cp6xxn5dx4vxzsq3qlw5asdnj6jr0cs00nf8a5k341s";
       };
       meta = {
         homepage = "http://rubyforge.org/projects/seattlerb/";
         license = []; # one of ?
         description = "Hoe is a rake/rubygems helper for project Rakefiles rubygems and includes a dynamic plug-in system allowing for easy exte"; # cut to 120 chars
         longDescription = "Hoe is a rake/rubygems helper for project Rakefiles. It helps generate
  rubygems and includes a dynamic plug-in system allowing for easy
  extensibility. Hoe ships with plug-ins for all your usual project
  tasks including rdoc generation, testing, packaging, and deployment.

  Plug-ins Provided:

  * Hoe::Clean
  * Hoe::Debug
  * Hoe::Deps
  * Hoe::Flay
  * Hoe::Flog
  * Hoe::Inline
  * Hoe::Package
  * Hoe::Publish
  * Hoe::RCov
  * Hoe::Signing
  * Hoe::Test

  See class rdoc for help. Hint: ri Hoe";
       };
    };

    rake_compiler_0_5_0 = rubyDerivation {
       name = "ruby-rake-compiler-0.5.0"; # full_name
       nameNoVersion = "rake_compiler";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rake-compiler-0.5.0.gem";
         sha256 = "03l6hgyv9z2bc1p16c2mai5n1ylhzcnw053x0x0nc94p4297m2jv";
       };
       meta = {
         homepage = "http://github.com/luislavena/rake-compiler";
         license = []; # one of ?
         description = "Provide a standard and simplified way to build and package Ruby C extensions using Rake as glue[...]";
         longDescription = "Provide a standard and simplified way to build and package
  Ruby C extensions using Rake as glue.";
       };
    };

    lockfile_1_4_3 = rubyDerivation {
       name = "ruby-lockfile-1.4.3"; # full_name
       nameNoVersion = "lockfile";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/lockfile-1.4.3.gem";
         sha256 = "0cxbyvxr3s5xsx85yghcs69d4lwwj0pg5la5cz2fp12hkk2szab3";
       };
       meta = {
         homepage = "http://codeforpeople.com/lib/ruby/lockfile/";
         license = []; # one of ?
         description = "[...]";
         longDescription = "";
       };
    };

    locale_2_0_4 = rubyDerivation {
       name = "ruby-locale-2.0.4"; # full_name
       nameNoVersion = "locale";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/locale-2.0.4.gem";
         sha256 = "1fy0bsrxmskmsw3wrl2dis57rgs1jr1dmlp3xm9z8w1phaqh3c8v";
       };
       meta = {
         homepage = "http://locale.rubyforge.org/";
         license = []; # one of ?
         description = "Ruby-Locale is the pure ruby library which provides basic APIs for localization[...]";
         longDescription = "Ruby-Locale is the pure ruby library which provides basic APIs for localization.";
       };
    };

    rcov_0_8_1_2_0 = rubyDerivation {
       name = "ruby-rcov-0.8.1.2.0"; # full_name
       nameNoVersion = "rcov";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rcov-0.8.1.2.0.gem";
         sha256 = "0mbm0n48yvgiibyvdc3gn4h70c82pn7z3hns9jinak7hyfmb5q5p";
       };
       meta = {
         homepage = "http://eigenclass.org/hiki.rb?rcov";
         license = []; # one of ?
         description = "rcov is a code coverage tool for Ruby[...]";
         longDescription = "rcov is a code coverage tool for Ruby. It is commonly used for viewing overall test unit coverage of target code.  It features fast execution (20-300 times faster than previous tools), multiple analysis modes, XHTML and several kinds of text reports, easy automation with Rake via a RcovTask, fairly accurate coverage information through code linkage inference using simple heuristics, colorblind-friendliness...";
       };
    };

    echoe_3_1_1 = rubyDerivation {
       name = "ruby-echoe-3.1.1"; # full_name
       nameNoVersion = "echoe";
       propagatedBuildInputs = [ rubyforge_1_0_3  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/echoe-3.1.1.gem";
         sha256 = "1vy4jc8j8fq89r7fg2x37ybagghpw82qbqivc9pjk5fwyrxcvqha";
       };
       meta = {
         homepage = "http://blog.evanweaver.com/files/doc/fauna/echoe/";
         license = []; # one of ?
         description = "A Rubygems packaging tool that provides Rake tasks for documentation, extension compiling, testing, and deployment[...]";
         longDescription = "A Rubygems packaging tool that provides Rake tasks for documentation, extension compiling, testing, and deployment.";
       };
    };

    mime_types_1_16 = rubyDerivation {
       name = "ruby-mime-types-1.16"; # full_name
       nameNoVersion = "mime_types";
       propagatedBuildInputs = [ archive_tar_minitar_0_5_2 nokogiri_1_3_2 rcov_0_8_1_2_0  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/mime-types-1.16.gem";
         sha256 = "1slp7g2xv9ygcapqv13qgh3g6ipx5k5c3imb5sdyh0b9ip5s34y3";
       };
       meta = {
         homepage = "http://mime-types.rubyforge.org/";
         license = []; # one of ?
         description = "MIME::Types for Ruby originally based on and synchronized with MIME::Types for Perl by Mark Overmeer, copyright 2001 - 20"; # cut to 120 chars
         longDescription = "MIME::Types for Ruby originally based on and synchronized with MIME::Types for Perl by Mark Overmeer, copyright 2001 - 2009. As of version 1.15, the data format for the MIME::Type list has changed and the synchronization will no longer happen.";
       };
    };

    net_ssh_2_0_11 = rubyDerivation {
       name = "ruby-net-ssh-2.0.11"; # full_name
       nameNoVersion = "net_ssh";
       propagatedBuildInputs = [ echoe_3_1_1 ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/net-ssh-2.0.11.gem";
         sha256 = "1j1mpnhpnb0d9l3jfk7g02syqjanc51lm076llzmjydy30x2n2f7";
       };
       meta = {
         homepage = "http://net-ssh.rubyforge.org/ssh";
         license = []; # one of ?
         description = "a pure-Ruby implementation of the SSH2 client protocol[...]";
         longDescription = "a pure-Ruby implementation of the SSH2 client protocol";
       };
    };

    highline_1_5_1 = rubyDerivation {
       name = "ruby-highline-1.5.1"; # full_name
       nameNoVersion = "highline";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/highline-1.5.1.gem";
         sha256 = "0sawb011sc1i5glr80a4iflr0vvn3s5c97a4jmrhj3palv4df19i";
       };
       meta = {
         homepage = "http://highline.rubyforge.org";
         license = []; # one of ?
         description = "A high-level IO library that provides validation, type conversion, and more for command-line interfaces[...]";
         longDescription = "A high-level IO library that provides validation, type conversion, and more for command-line interfaces. HighLine also includes a complete menu system that can crank out anything from simple list selection to complete shells with just minutes of work.";
       };
    };

    gettext_2_0_4 = rubyDerivation {
       name = "ruby-gettext-2.0.4"; # full_name
       nameNoVersion = "gettext";
       propagatedBuildInputs = [ locale_2_0_4 ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/gettext-2.0.4.gem";
         sha256 = "1hdj91qg5858ss3wsdjbi4yxmwixqin5vv550fkvf4514yyc9gk0";
       };
       meta = {
         homepage = "http://gettext.rubyforge.org/";
         license = []; # one of ?
         description = "Ruby-GetText-Package is a GNU GetText-like program for Ruby[...]";
         longDescription = "Ruby-GetText-Package is a GNU GetText-like program for Ruby. The catalog file(po-file) is same format with GNU GetText. So you can use GNU GetText tools for maintaining.";
       };
    };

    sup_0_8_1 = rubyDerivation {
       name = "ruby-sup-0.8.1"; # full_name
       nameNoVersion = "sup";
       propagatedBuildInputs = [ ferret_0_11_6 ncurses_0_9_1 rmail_1_0_0 highline_1_5_1 net_ssh_2_0_11 trollop_1_14 lockfile_1_4_3 mime_types_1_16 gettext_2_0_4 fastthread_1_0_7 ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/sup-0.8.1.gem";
         sha256 = "0q7s63s43mf35j0372g3qpfhsnsys4fbsb8xkshpwrjsd4lb90l2";
       };
       meta = {
         homepage = "http://sup.rubyforge.org/";
         license = []; # one of ?
         description = "Sup is a console-based email client for people with a lot of email[...]";
         longDescription = "Sup is a console-based email client for people with a lot of email. It supports tagging, very fast full-text search, automatic contact-list management, and more. If you're the type of person who treats email as an extension of your long-term memory, Sup is for you.  Sup makes it easy to: - Handle massive amounts of email.  - Mix email from different sources: mbox files (even across different machines), Maildir directories, IMAP folders, POP accounts, and GMail accounts.  - Instantaneously search over your entire email collection. Search over body text, or use a query language to combine search predicates in any way.  - Handle multiple accounts. Replying to email sent to a particular account will use the correct SMTP server, signature, and from address.  - Add custom code to handle certain types of messages or to handle certain types of text within messages.  - Organize email with user-defined labels, automatically track recent contacts, and much more!  The goal of Sup is to become the email client of choice for nerds everywhere.";
       };
    };

    trollop_1_14 = rubyDerivation {
       name = "ruby-trollop-1.14"; # full_name
       nameNoVersion = "trollop";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/trollop-1.14.gem";
         sha256 = "15jsdlnq6fj3q3g47qswi73gx91rw1yvssi8zkwf6svkd55ri3f7";
       };
       meta = {
         homepage = "http://trollop.rubyforge.org";
         license = []; # one of ?
         description = "Documentation quickstart: See Trollop::options (for some reason rdoc isn't linking that; it's in the top right of the scr"; # cut to 120 chars
         longDescription = "Documentation quickstart: See Trollop::options (for some reason rdoc isn't linking that; it's in the top right of the screen if you're browsing online) and then Trollop::Parser#opt. Also see the examples at http://trollop.rubyforge.org/.  == DESCRIPTION  == REQUIREMENTS  * A burning desire to write less code.  == INSTALL  * gem install trollop  == LICENSE  Copyright (c) 2008 William Morgan. Trollop is distributed under the same terms as Ruby.";
       };
    };

    rmail_1_0_0 = rubyDerivation {
       name = "ruby-rmail-1.0.0"; # full_name
       nameNoVersion = "rmail";
       propagatedBuildInputs = [  ];
       src = fetchurl {
         url = "http://gems.rubyforge.org/gems/rmail-1.0.0.gem";
         sha256 = "0nsg7yda1gdwa96j4hlrp2s0m06vrhcc4zy5mbq7gxmlmwf9yixp";
       };
       meta = {
         homepage = "http://www.rfc20.org/rubymail";
         license = []; # one of ?
         description = "RMail is a lightweight mail library containing various utility classes and modules that allow ruby scripts to parse, modi"; # cut to 120 chars
         longDescription = "RMail is a lightweight mail library containing various utility classes and modules that allow ruby scripts to parse, modify, and generate MIME mail messages.";
       };
    };

# aliases
  rmail=rmail_1_0_0;
  fastthread=fastthread_1_0_7;
  highline=highline_1_5_1;
  rake=rake_0_8_7;
  rubygems_update=rubygems_update_1_3_4;
  sup=sup_0_8_1;
  mime_types=mime_types_1_16;
  echoe=echoe_3_1_1;
  rubyforge=rubyforge_1_0_3;
  rake_compiler=rake_compiler_0_5_0;
  ferret=ferret_0_11_6;
  net_ssh=net_ssh_2_0_11;
  rcov=rcov_0_8_1_2_0;
  ncurses=ncurses_0_9_1;
  trollop=trollop_1_14;
  gettext=gettext_2_0_4;
  archive_tar_minitar=archive_tar_minitar_0_5_2;
  locale=locale_2_0_4;
  hoe=hoe_2_3_2;
  chronic=chronic_0_2_3;
  racc=racc_1_4_6;
  lockfile=lockfile_1_4_3;
  nokogiri=nokogiri_1_3_2;
  rexical=rexical_1_0_4;

  # ================ END automatically generated code ================
  }; in libs
