# WARNING: automatically generated file
# Generated by 'gem nix' command that comes from 'nix' gem
g: # Get dependencies from patched gems
{
  aliases = {
    actionmailer = g.actionmailer_3_1_3;
    actionpack = g.actionpack_3_1_3;
    activemodel = g.activemodel_3_1_3;
    activerecord = g.activerecord_3_1_3;
    activeresource = g.activeresource_3_1_3;
    activesupport = g.activesupport_3_1_3;
    arel = g.arel_2_2_1;
    atoulme_Antwrap = g.atoulme_Antwrap_0_7_1;
    builder = g.builder_3_0_0;
    buildr = g.buildr_1_4_6;
    bundler = g.bundler_1_0_21;
    diff_lcs = g.diff_lcs_1_1_3;
    erubis = g.erubis_2_7_0;
    highline = g.highline_1_5_1;
    hike = g.hike_1_2_1;
    hoe = g.hoe_2_3_3;
    i18n = g.i18n_0_6_0;
    json = g.json_1_6_4;
    json_pure = g.json_pure_1_6_4;
    mail = g.mail_2_3_0;
    mime_types = g.mime_types_1_17_2;
    minitar = g.minitar_0_5_3;
    multi_json = g.multi_json_1_0_4;
    net_sftp = g.net_sftp_2_0_4;
    net_ssh = g.net_ssh_2_2_2;
    nix = g.nix_0_1_1;
    polyglot = g.polyglot_0_3_3;
    rack = g.rack_1_4_0;
    rack_cache = g.rack_cache_1_1;
    rack_mount = g.rack_mount_0_8_3;
    rack_ssl = g.rack_ssl_1_3_2;
    rack_test = g.rack_test_0_6_1;
    rails = g.rails_3_1_3;
    railties = g.railties_3_1_3;
    rake = g.rake_0_9_2_2;
    rb_fsevent = g.rb_fsevent_0_4_3_1;
    rdoc = g.rdoc_3_12;
    rjb = g.rjb_1_3_8;
    rspec = g.rspec_2_1_0;
    rspec_core = g.rspec_core_2_1_0;
    rspec_expectations = g.rspec_expectations_2_1_0;
    rspec_mocks = g.rspec_mocks_2_1_0;
    rubyforge = g.rubyforge_2_0_4;
    rubyzip = g.rubyzip_0_9_4;
    sass = g.sass_3_1_12;
    sprockets = g.sprockets_2_0_3;
    thor = g.thor_0_14_6;
    tilt = g.tilt_1_3_3;
    treetop = g.treetop_1_4_10;
    tzinfo = g.tzinfo_0_3_31;
    xml_simple = g.xml_simple_1_0_12;
  };
  gem_nix_args = [ ''buildr'' ''nix'' ''rails'' ''rake'' ''rb-fsevent'' ''sass'' ];
  gems = {
    actionmailer_3_1_3 = {
      basename = ''actionmailer'';
      meta = {
        description = ''Email composition, delivery, and receiving framework (part of Rails).'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''Email on Rails. Compose, deliver, receive, and test emails using the familiar controller/view pattern. First-class support for multipart email and attachments.'';
      };
      name = ''actionmailer-3.1.3'';
      requiredGems = [ g.mail_2_3_0 ];
      sha256 = ''04qjgf8irg2srqa9j0ahxpydx42h9dymiabfiyzwy0h3wayg2qyj'';
    };
    actionpack_3_1_3 = {
      basename = ''actionpack'';
      meta = {
        description = ''Web-flow and rendering framework putting the VC in MVC (part of Rails).'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''Web apps on Rails. Simple, battle-tested conventions for building and testing MVC web applications. Works with any Rack-compatible server.'';
      };
      name = ''actionpack-3.1.3'';
      requiredGems = [ g.activemodel_3_1_3 g.rack_cache_1_1 g.rack_1_3_6 g.rack_test_0_6_1 g.rack_mount_0_8_3 g.sprockets_2_0_3 g.erubis_2_7_0 ];
      sha256 = ''1awhqxdfg2zcb0b34jwq3sm2favay94n4glqywqzrn85wkf47a2q'';
    };
    activemodel_3_1_3 = {
      basename = ''activemodel'';
      meta = {
        description = ''A toolkit for building modeling frameworks (part of Rails).'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''A toolkit for building modeling frameworks like Active Record and Active Resource. Rich support for attributes, callbacks, validations, observers, serialization, internationalization, and testing.'';
      };
      name = ''activemodel-3.1.3'';
      requiredGems = [ g.builder_3_0_0 g.i18n_0_6_0 ];
      sha256 = ''1kpkr1gwvjbxc8q3n1ps1j8zf7m1258swb9n5zm5igr6j0d803a3'';
    };
    activerecord_3_1_3 = {
      basename = ''activerecord'';
      meta = {
        description = ''Object-relational mapper framework (part of Rails).'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''Databases on Rails. Build a persistent domain model by mapping database tables to Ruby classes. Strong conventions for associations, validations, aggregations, migrations, and testing come baked-in.'';
      };
      name = ''activerecord-3.1.3'';
      requiredGems = [ g.arel_2_2_1 g.tzinfo_0_3_31 ];
      sha256 = ''0z2p51hm12alg6axih2mhxjsj8vmnvdqp3wwzcg9bbkp3fc368w0'';
    };
    activeresource_3_1_3 = {
      basename = ''activeresource'';
      meta = {
        description = ''REST modeling framework (part of Rails).'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''REST on Rails. Wrap your RESTful web app with Ruby classes and work with them like Active Record models.'';
      };
      name = ''activeresource-3.1.3'';
      requiredGems = [  ];
      sha256 = ''0hf3fi6zwk9zqzgk4rr95ax9mfzfkzpq28qw7fm2av6841wl54fg'';
    };
    activesupport_3_1_3 = {
      basename = ''activesupport'';
      meta = {
        description = ''A toolkit of support libraries and Ruby core extensions extracted from the Rails framework.'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''A toolkit of support libraries and Ruby core extensions extracted from the Rails framework. Rich support for multibyte strings, internationalization, time zones, and testing.'';
      };
      name = ''activesupport-3.1.3'';
      requiredGems = [ g.multi_json_1_0_4 ];
      sha256 = ''19na7857adshdsswsgygky30r985ng100z3n78scd65481zcgb9z'';
    };
    arel_2_2_1 = {
      basename = ''arel'';
      meta = {
        description = ''Arel is a SQL AST manager for Ruby'';
        homepage = ''http://github.com/rails/arel'';
        longDescription = ''Arel is a SQL AST manager for Ruby. It

1. Simplifies the generation complex of SQL queries
2. Adapts to various RDBMS systems

It is intended to be a framework framework; that is, you can build your own ORM
with it, focusing on innovative object and collection modeling as opposed to
database compatibility and query generation.'';
      };
      name = ''arel-2.2.1'';
      requiredGems = [  ];
      sha256 = ''19pz68pr9l8h2j2v3vqzhjvs94s0hwqwpb6m9sd6ncj18gaci8jy'';
    };
    atoulme_Antwrap_0_7_1 = {
      basename = ''atoulme_Antwrap'';
      meta = {
        description = ''A Ruby module that wraps the Apache Ant build tool. Antwrap can be used to invoke Ant Tasks from a Ruby or a JRuby script.'';
        homepage = ''http://rubyforge.org/projects/antwrap/'';
        longDescription = ''	A Ruby module that wraps the Apache Ant build tool. Antwrap can be used to invoke Ant Tasks from a Ruby or a JRuby script.

== FEATURES/PROBLEMS:

	Antwrap runs on the native Ruby interpreter via the RJB (Ruby Java Bridge gem) and on the JRuby interpreter. Antwrap is compatible with Ant versions 1.5.4, 
	1.6.5 and 1.7.0. For more information, 	see the Project Info (http://rubyforge.org/projects/antwrap/) page. 
	 
== SYNOPSIS:

	Antwrap is a Ruby library that can be used to invoke Ant tasks. It is being used in the Buildr (http://incubator.apache.org/buildr/) project to execute 
	Ant (http://ant.apache.org/) tasks in a Java project. If you are tired of fighting with Ant or Maven XML files in your Java project, take some time to 
	check out Buildr!'';
      };
      name = ''atoulme-Antwrap-0.7.1'';
      requiredGems = [ g.rjb_1_3_8 ];
      sha256 = ''0r9jy2asyma8h0878nhjfbi00qvb4yapc8glngvmkkj21zbx2mfy'';
    };
    builder_2_1_2 = {
      basename = ''builder'';
      meta = {
        description = ''Builders for MarkUp.'';
        homepage = ''http://onestepback.org'';
        longDescription = ''Builder provides a number of builder objects that make creating structured data simple to do.  Currently the following builder objects are supported:  * XML Markup * XML Events'';
      };
      name = ''builder-2.1.2'';
      requiredGems = [  ];
      sha256 = ''0hp5gsvp63mqqvi7dl95zwci916vj6l1slgz4crip1rijk3v2806'';
    };
    builder_3_0_0 = {
      basename = ''builder'';
      meta = {
        description = ''Builders for MarkUp.'';
        homepage = ''http://onestepback.org'';
        longDescription = ''Builder provides a number of builder objects that make creating structured data
simple to do.  Currently the following builder objects are supported:

* XML Markup
* XML Events
'';
      };
      name = ''builder-3.0.0'';
      requiredGems = [  ];
      sha256 = ''13k12jii9z1hma4xxk2dl74wsx985idl3cs9svvla8p0bmgf3lzv'';
    };
    buildr_1_4_6 = {
      basename = ''buildr'';
      meta = {
        description = ''Build like you code'';
        homepage = ''http://buildr.apache.org/'';
        longDescription = ''Apache Buildr is a build system for Java-based applications, including support
for Scala, Groovy and a growing number of JVM languages and tools.  We wanted
something that's simple and intuitive to use, so we only need to tell it what
to do, and it takes care of the rest.  But also something we can easily extend
for those one-off tasks, with a language that's a joy to use.
'';
      };
      name = ''buildr-1.4.6'';
      requiredGems = [ g.rake_0_8_7 g.builder_2_1_2 g.net_ssh_2_0_23 g.net_sftp_2_0_4 g.rubyzip_0_9_4 g.highline_1_5_1 g.json_pure_1_4_3 g.rubyforge_2_0_3 g.hoe_2_3_3 g.rjb_1_3_3 g.atoulme_Antwrap_0_7_1 g.diff_lcs_1_1_2 g.rspec_expectations_2_1_0 g.rspec_mocks_2_1_0 g.rspec_core_2_1_0 g.rspec_2_1_0 g.xml_simple_1_0_12 g.minitar_0_5_3 ];
      sha256 = ''11qwqrdnmzzi4zhgajfq1f1ckvd4kpfm9gyqrfjfalphs4gi0vxz'';
    };
    bundler_1_0_21 = {
      basename = ''bundler'';
      meta = {
        description = ''The best way to manage your application's dependencies'';
        homepage = ''http://gembundler.com'';
        longDescription = ''Bundler manages an application's dependencies through its entire life, across many machines, systematically and repeatably'';
      };
      name = ''bundler-1.0.21'';
      requiredGems = [  ];
      sha256 = ''0lcxz75vvgqib43wxzv6021qs5d7bxhnds4j4q27hzqs982cn0s6'';
    };
    diff_lcs_1_1_2 = {
      basename = ''diff_lcs'';
      meta = {
        description = ''Provides a list of changes that represent the difference between two sequenced collections.'';
        homepage = ''http://rubyforge.org/projects/ruwiki/'';
        longDescription = ''Diff::LCS is a port of Algorithm::Diff that uses the McIlroy-Hunt longest common subsequence (LCS) algorithm to compute intelligent differences between two sequenced enumerable containers. The implementation is based on Mario I. Wolczko's Smalltalk version (1.2, 1993) and Ned Konz's Perl version (Algorithm::Diff).'';
      };
      name = ''diff-lcs-1.1.2'';
      requiredGems = [  ];
      sha256 = ''1i5bfxh77whaasajhzd2qkm5zwy7ryb7pfc96m1fv9afwn6cg3yp'';
    };
    diff_lcs_1_1_3 = {
      basename = ''diff_lcs'';
      meta = {
        description = ''Diff::LCS is a port of Perl's Algorithm::Diff that uses the McIlroy-Hunt longest common subsequence (LCS) algorithm to compute intelligent differences between two sequenced enumerable containers'';
        longDescription = ''Diff::LCS is a port of Perl's Algorithm::Diff that uses the McIlroy-Hunt
longest common subsequence (LCS) algorithm to compute intelligent differences
between two sequenced enumerable containers. The implementation is based on
Mario I. Wolczko's {Smalltalk version 1.2}[ftp://st.cs.uiuc.edu/pub/Smalltalk/MANCHESTER/manchester/4.0/diff.st]
(1993) and Ned Konz's Perl version
{Algorithm::Diff 1.15}[http://search.cpan.org/~nedkonz/Algorithm-Diff-1.15/].

This is release 1.1.3, fixing several small bugs found over the years. Version
1.1.0 added new features, including the ability to #patch and #unpatch changes
as well as a new contextual diff callback, Diff::LCS::ContextDiffCallbacks,
that should improve the context sensitivity of patching.

This library is called Diff::LCS because of an early version of Algorithm::Diff
which was restrictively licensed. This version has seen a minor license change:
instead of being under Ruby's license as an option, the third optional license
is the MIT license.'';
      };
      name = ''diff-lcs-1.1.3'';
      requiredGems = [  ];
      sha256 = ''15wqs3md9slif6ag43vp6gw63r3a2zdqiyfapnnzkb7amgg930pv'';
    };
    erubis_2_7_0 = {
      basename = ''erubis'';
      meta = {
        description = ''a fast and extensible eRuby implementation which supports multi-language'';
        homepage = ''http://www.kuwata-lab.com/erubis/'';
        longDescription = ''  Erubis is an implementation of eRuby and has the following features:

  * Very fast, almost three times faster than ERB and about 10% faster than eruby.
  * Multi-language support (Ruby/PHP/C/Java/Scheme/Perl/Javascript)
  * Auto escaping support
  * Auto trimming spaces around '&lt;% %&gt;'
  * Embedded pattern changeable (default '&lt;% %&gt;')
  * Enable to handle Processing Instructions (PI) as embedded pattern (ex. '&lt;?rb ... ?&gt;')
  * Context object available and easy to combine eRuby template with YAML datafile
  * Print statement available
  * Easy to extend and customize in subclass
  * Ruby on Rails support
'';
      };
      name = ''erubis-2.7.0'';
      requiredGems = [  ];
      sha256 = ''1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3'';
    };
    highline_1_5_1 = {
      basename = ''highline'';
      meta = {
        description = ''HighLine is a high-level command-line IO library.'';
        homepage = ''http://highline.rubyforge.org'';
        longDescription = ''A high-level IO library that provides validation, type conversion, and more for command-line interfaces. HighLine also includes a complete menu system that can crank out anything from simple list selection to complete shells with just minutes of work.'';
      };
      name = ''highline-1.5.1'';
      requiredGems = [  ];
      sha256 = ''0sawb011sc1i5glr80a4iflr0vvn3s5c97a4jmrhj3palv4df19i'';
    };
    hike_1_2_1 = {
      basename = ''hike'';
      meta = {
        description = ''Find files in a set of paths'';
        homepage = ''http://github.com/sstephenson/hike'';
        longDescription = ''A Ruby library for finding files in a set of paths.'';
      };
      name = ''hike-1.2.1'';
      requiredGems = [  ];
      sha256 = ''1c78gja9i9nj76gdj65czhvwam6550l0w9ilnn8vysj9cwv0rg7b'';
    };
    hoe_2_3_3 = {
      basename = ''hoe'';
      meta = {
        description = ''Hoe is a rake/rubygems helper for project Rakefiles'';
        homepage = ''http://rubyforge.org/projects/seattlerb/'';
        longDescription = ''Hoe is a rake/rubygems helper for project Rakefiles. It helps generate
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

See class rdoc for help. Hint: ri Hoe'';
      };
      name = ''hoe-2.3.3'';
      requiredGems = [ g.rubyforge_2_0_4 g.rake_0_9_2_2 ];
      sha256 = ''06jlnbhimrn6znimaaxm7kh2269lapkbmnp3wssrjmw06ms7lq9m'';
    };
    i18n_0_6_0 = {
      basename = ''i18n'';
      meta = {
        description = ''New wave Internationalization support for Ruby'';
        homepage = ''http://github.com/svenfuchs/i18n'';
        longDescription = ''New wave Internationalization support for Ruby.'';
      };
      name = ''i18n-0.6.0'';
      requiredGems = [  ];
      sha256 = ''1pgmfhmh2wv409g7kla30mkp8jpslvp25vcmmim1figl87wpn3j0'';
    };
    json_1_6_4 = {
      basename = ''json'';
      meta = {
        description = ''JSON Implementation for Ruby'';
        homepage = ''http://flori.github.com/json'';
        longDescription = ''This is a JSON implementation as a Ruby extension in C.'';
      };
      name = ''json-1.6.4'';
      requiredGems = [  ];
      sha256 = ''1adka4y7z9v4lmd2zqyap21ghqdnjaivr1ghnqcnw3dmsdrgf39l'';
    };
    json_pure_1_4_3 = {
      basename = ''json_pure'';
      meta = {
        description = ''JSON Implementation for Ruby'';
        homepage = ''http://flori.github.com/json'';
        longDescription = ''This is a JSON implementation in pure Ruby.'';
      };
      name = ''json_pure-1.4.3'';
      requiredGems = [  ];
      sha256 = ''1xw357gkmk6712c94lhpsrq8j9v91mgc2nxlr1m6n20yl6sz2g9r'';
    };
    json_pure_1_6_4 = {
      basename = ''json_pure'';
      meta = {
        description = ''JSON Implementation for Ruby'';
        homepage = ''http://flori.github.com/json'';
        longDescription = ''This is a JSON implementation in pure Ruby.'';
      };
      name = ''json_pure-1.6.4'';
      requiredGems = [  ];
      sha256 = ''12i95k265gx4vy2cpxrb3z4slc4czsh3srgky2a6d5h3q6c1kvbf'';
    };
    mail_2_3_0 = {
      basename = ''mail'';
      meta = {
        description = ''Mail provides a nice Ruby DSL for making, sending and reading emails.'';
        homepage = ''http://github.com/mikel/mail'';
        longDescription = ''A really Ruby Mail handler.'';
      };
      name = ''mail-2.3.0'';
      requiredGems = [ g.mime_types_1_17_2 g.treetop_1_4_10 ];
      sha256 = ''1cnid9wn5wy0d2shx4ykvgd5jrvgq55yal8i51b47d4037n1yr53'';
    };
    mime_types_1_17_2 = {
      basename = ''mime_types'';
      meta = {
        description = ''This library allows for the identification of a file's likely MIME content type'';
        homepage = ''http://mime-types.rubyforge.org/'';
        longDescription = ''This library allows for the identification of a file's likely MIME content
type. This is release 1.17.2. The identification of MIME content type is based
on a file's filename extensions.

MIME::Types for Ruby originally based on and synchronized with MIME::Types for
Perl by Mark Overmeer, copyright 2001 - 2009. As of version 1.15, the data
format for the MIME::Type list has changed and the synchronization will no
longer happen.

Homepage::  http://mime-types.rubyforge.org/
GitHub::    http://github.com/halostatue/mime-types/
Copyright:: 2002 - 2011, Austin Ziegler
            Based in part on prior work copyright Mark Overmeer

:include: License.rdoc'';
      };
      name = ''mime-types-1.17.2'';
      requiredGems = [  ];
      sha256 = ''0i4pmx86xbnlrhbbm9znnyfglmb21vwjvh262c6qw3m19w6ifs6p'';
    };
    minitar_0_5_3 = {
      basename = ''minitar'';
      meta = {
        description = ''Provides POSIX tarchive management from Ruby programs.'';
        homepage = ''http://rubyforge.org/projects/ruwiki/'';
        longDescription = ''Archive::Tar::Minitar is a pure-Ruby library and command-line utility that provides the ability to deal with POSIX tar(1) archive files. The implementation is based heavily on Mauricio Ferna'ndez's implementation in rpa-base, but has been reorganised to promote reuse in other projects.'';
      };
      name = ''minitar-0.5.3'';
      requiredGems = [  ];
      sha256 = ''035vs1knnnjsb8arfp8vx75warvwcdpiljjwv38lqljai9v8fq53'';
    };
    multi_json_1_0_4 = {
      basename = ''multi_json'';
      meta = {
        description = ''A gem to provide swappable JSON backends.'';
        homepage = ''http://github.com/intridea/multi_json'';
        longDescription = ''A gem to provide swappable JSON backends utilizing Yajl::Ruby, the JSON gem, JSON pure, or a vendored version of okjson.'';
      };
      name = ''multi_json-1.0.4'';
      requiredGems = [  ];
      sha256 = ''0f2yrlxcdhdskkm4q11p2didwl26wikxycysb7i49ndp94rklvcr'';
    };
    net_sftp_2_0_4 = {
      basename = ''net_sftp'';
      meta = {
        description = ''A pure Ruby implementation of the SFTP client protocol'';
        homepage = ''http://net-ssh.rubyforge.org/sftp'';
        longDescription = ''A pure Ruby implementation of the SFTP client protocol'';
      };
      name = ''net-sftp-2.0.4'';
      requiredGems = [ g.net_ssh_2_2_2 ];
      sha256 = ''1f0ml1z7kjnd79avn42fmys8j0w2995j5lk30ak5n40bq805yvky'';
    };
    net_ssh_2_0_23 = {
      basename = ''net_ssh'';
      meta = {
        description = ''Net::SSH: a pure-Ruby implementation of the SSH2 client protocol.'';
        homepage = ''http://github.com/net-ssh/net-ssh'';
        longDescription = ''Net::SSH: a pure-Ruby implementation of the SSH2 client protocol.'';
      };
      name = ''net-ssh-2.0.23'';
      requiredGems = [  ];
      sha256 = ''1fllf6mgwc213m5mn266qwhl65zc84wl8rq9m3lvbggw9mh5ynrr'';
    };
    net_ssh_2_2_2 = {
      basename = ''net_ssh'';
      meta = {
        description = ''Net::SSH: a pure-Ruby implementation of the SSH2 client protocol.'';
        homepage = ''http://github.com/net-ssh/net-ssh'';
        longDescription = ''Net::SSH: a pure-Ruby implementation of the SSH2 client protocol.'';
      };
      name = ''net-ssh-2.2.2'';
      requiredGems = [  ];
      sha256 = ''11rlcb6w534g21x1g1jz1v1lvyj3zv6s621pf9cwl1aqbl6zh711'';
    };
    nix_0_1_1 = {
      basename = ''nix'';
      meta = {
        description = ''Nix package manager interface'';
        homepage = ''http://gitorious.org/ruby-nix'';
        longDescription = ''Adds 'gem nix' command that dumps given set of gems to format suitable for Nix package manager'';
      };
      name = ''nix-0.1.1'';
      requiredGems = [  ];
      sha256 = ''0kwrbkkg0gxibhsz9dpd5zabcf2wqsicg28yiazyb3dc9dslk26k'';
    };
    polyglot_0_3_3 = {
      basename = ''polyglot'';
      meta = {
        description = ''Augment 'require' to load non-Ruby file types'';
        homepage = ''http://github.com/cjheath/polyglot'';
        longDescription = ''
The Polyglot library allows a Ruby module to register a loader
for the file type associated with a filename extension, and it
augments 'require' to find and load matching files.'';
      };
      name = ''polyglot-0.3.3'';
      requiredGems = [  ];
      sha256 = ''082zmail2h3cxd9z1wnibhk6aj4sb1f3zzwra6kg9bp51kx2c00v'';
    };
    rack_1_3_6 = {
      basename = ''rack'';
      meta = {
        description = ''a modular Ruby webserver interface'';
        homepage = ''http://rack.rubyforge.org'';
        longDescription = ''Rack provides minimal, modular and adaptable interface for developing
web applications in Ruby.  By wrapping HTTP requests and responses in
the simplest way possible, it unifies and distills the API for web
servers, web frameworks, and software in between (the so-called
middleware) into a single method call.

Also see http://rack.rubyforge.org.
'';
      };
      name = ''rack-1.3.6'';
      requiredGems = [  ];
      sha256 = ''1qkhwsr1gz4k5rlf9d6ga4cwkw4lbxpcywxy0bkg92js413hy2fl'';
    };
    rack_1_4_0 = {
      basename = ''rack'';
      meta = {
        description = ''a modular Ruby webserver interface'';
        homepage = ''http://rack.rubyforge.org'';
        longDescription = ''Rack provides a minimal, modular and adaptable interface for developing
web applications in Ruby.  By wrapping HTTP requests and responses in
the simplest way possible, it unifies and distills the API for web
servers, web frameworks, and software in between (the so-called
middleware) into a single method call.

Also see http://rack.rubyforge.org.
'';
      };
      name = ''rack-1.4.0'';
      requiredGems = [  ];
      sha256 = ''15mqryky86fhx0h3kiab5x1lamq62hq6kc3knl6v10p1az4zpcq9'';
    };
    rack_cache_1_1 = {
      basename = ''rack_cache'';
      meta = {
        description = ''HTTP Caching for Rack'';
        homepage = ''http://tomayko.com/src/rack-cache/'';
        longDescription = ''HTTP Caching for Rack'';
      };
      name = ''rack-cache-1.1'';
      requiredGems = [ g.rack_1_4_0 ];
      sha256 = ''08jlym48qwfj7wddv0vpjj3vlc03q8wvbya24zbrjj8grgfgrvrl'';
    };
    rack_mount_0_8_3 = {
      basename = ''rack_mount'';
      meta = {
        description = ''Stackable dynamic tree based Rack router'';
        homepage = ''https://github.com/josh/rack-mount'';
        longDescription = ''    A stackable dynamic tree based Rack router.
'';
      };
      name = ''rack-mount-0.8.3'';
      requiredGems = [  ];
      sha256 = ''09a1qfaxxsll1kbgz7z0q0nr48sfmfm7akzaviis5bjpa5r00ld2'';
    };
    rack_ssl_1_3_2 = {
      basename = ''rack_ssl'';
      meta = {
        description = ''Force SSL/TLS in your app.'';
        homepage = ''https://github.com/josh/rack-ssl'';
        longDescription = ''    Rack middleware to force SSL/TLS.
'';
      };
      name = ''rack-ssl-1.3.2'';
      requiredGems = [  ];
      sha256 = ''1h9pfn5c95qigkm1vb5nbla7fwjl86q887w57iiqp4kdvrjh9wrn'';
    };
    rack_test_0_6_1 = {
      basename = ''rack_test'';
      meta = {
        description = ''Simple testing API built on Rack'';
        homepage = ''http://github.com/brynary/rack-test'';
        longDescription = ''Rack::Test is a small, simple testing API for Rack apps. It can be used on its
own or as a reusable starting point for Web frameworks and testing libraries
to build on. Most of its initial functionality is an extraction of Merb 1.0's
request helpers feature.'';
      };
      name = ''rack-test-0.6.1'';
      requiredGems = [  ];
      sha256 = ''0hq5q8fjhbb7szzrj7k0l21z025c4qsxqzd5qmgivikhymw10ws0'';
    };
    rails_3_1_3 = {
      basename = ''rails'';
      meta = {
        description = ''Full-stack web application framework.'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. It encourages beautiful code by favoring convention over configuration.'';
      };
      name = ''rails-3.1.3'';
      requiredGems = [ g.activesupport_3_1_3 g.actionpack_3_1_3 g.activerecord_3_1_3 g.activeresource_3_1_3 g.actionmailer_3_1_3 g.railties_3_1_3 g.bundler_1_0_21 ];
      sha256 = ''07p8agfarj5nz8v1nlg1rfqy1cnqxhpakxhadfhk4sqrzlp2a5z8'';
    };
    railties_3_1_3 = {
      basename = ''railties'';
      meta = {
        description = ''Tools for creating, working with, and running Rails applications.'';
        homepage = ''http://www.rubyonrails.org'';
        longDescription = ''Rails internals: application bootup, plugins, generators, and rake tasks.'';
      };
      name = ''railties-3.1.3'';
      requiredGems = [ g.thor_0_14_6 g.rack_ssl_1_3_2 g.rdoc_3_12 ];
      sha256 = ''07kgr9nzvgwpjqwssiknlqds1a9mj74g1hqpwsj6720x4pk9r13h'';
    };
    rake_0_8_7 = {
      basename = ''rake'';
      meta = {
        description = ''Ruby based make-like utility.'';
        homepage = ''http://rake.rubyforge.org'';
        longDescription = ''Rake is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax.'';
      };
      name = ''rake-0.8.7'';
      requiredGems = [  ];
      sha256 = ''03z1zm7xwl2r9v945ambwbd9sn2smbi34xldmac7qjcmsvd7pcqh'';
    };
    rake_0_9_2_2 = {
      basename = ''rake'';
      meta = {
        description = ''Ruby based make-like utility.'';
        homepage = ''http://rake.rubyforge.org'';
        longDescription = ''Rake is a Make-like program implemented in Ruby. Tasks and dependencies arespecified in standard Ruby syntax.'';
      };
      name = ''rake-0.9.2.2'';
      requiredGems = [  ];
      sha256 = ''19n4qp5gzbcqy9ajh56kgwqv9p9w2hnczhyvaqz0nlvk9diyng6q'';
    };
    rb_fsevent_0_4_3_1 = {
      basename = ''rb_fsevent'';
      meta = {
        description = ''Very simple &amp; usable FSEvents API'';
        homepage = ''http://rubygems.org/gems/rb-fsevent'';
        longDescription = ''FSEvents API with Signals catching (without RubyCocoa)'';
      };
      name = ''rb-fsevent-0.4.3.1'';
      requiredGems = [  ];
      sha256 = ''043w4695j7f9n0hawy9y0yci36linivsbp23v52v2qg64ji7hsiw'';
    };
    rdoc_3_12 = {
      basename = ''rdoc'';
      meta = {
        description = ''RDoc produces HTML and command-line documentation for Ruby projects'';
        homepage = ''http://docs.seattlerb.org/rdoc'';
        longDescription = ''RDoc produces HTML and command-line documentation for Ruby projects.  RDoc
includes the +rdoc+ and +ri+ tools for generating and displaying online
documentation.

See RDoc for a description of RDoc's markup and basic use.'';
      };
      name = ''rdoc-3.12'';
      requiredGems = [ g.json_1_6_4 ];
      sha256 = ''0cd4hrkba7zr675m62yb87l7hpf0sp2qw8ccc2s0y2fa2fxdxdkp'';
    };
    rjb_1_3_3 = {
      basename = ''rjb'';
      meta = {
        description = ''Ruby Java bridge'';
        homepage = ''http://rjb.rubyforge.org/'';
        longDescription = ''RJB is a bridge program that connect between Ruby and Java with Java Native Interface.
'';
      };
      name = ''rjb-1.3.3'';
      requiredGems = [  ];
      sha256 = ''0jhj1y84yzdr11li784m255jvc191vs8d3zck21rfqv4z4zpifz6'';
    };
    rjb_1_3_8 = {
      basename = ''rjb'';
      meta = {
        description = ''Ruby Java bridge'';
        homepage = ''http://rjb.rubyforge.org/'';
        longDescription = ''RJB is a bridge program that connect between Ruby and Java with Java Native Interface.
'';
      };
      name = ''rjb-1.3.8'';
      requiredGems = [  ];
      sha256 = ''0cwc3zh9ydwzvc176vjin7jpf8riisyjdwbywrmvc426kjyrrwwr'';
    };
    rspec_2_1_0 = {
      basename = ''rspec'';
      meta = {
        description = ''rspec-2.1.0'';
        homepage = ''http://github.com/rspec/rspec'';
        longDescription = ''Meta-gem that depends on the other rspec gems'';
      };
      name = ''rspec-2.1.0'';
      requiredGems = [  ];
      sha256 = ''16h7s8wr969wiig4qahr03ln144pz39jindlc3z11d064zvzhiza'';
    };
    rspec_core_2_1_0 = {
      basename = ''rspec_core'';
      meta = {
        description = ''rspec-core-2.1.0'';
        homepage = ''http://github.com/rspec/rspec-core'';
        longDescription = ''RSpec runner and example groups'';
      };
      name = ''rspec-core-2.1.0'';
      requiredGems = [  ];
      sha256 = ''1fs9c8dafg7v948wzxjhhzf0djr1rjva7lymah32rlj3x5xm9zmh'';
    };
    rspec_expectations_2_1_0 = {
      basename = ''rspec_expectations'';
      meta = {
        description = ''rspec-expectations-2.1.0'';
        homepage = ''http://github.com/rspec/rspec-expectations'';
        longDescription = ''rspec expectations (should[_not] and matchers)'';
      };
      name = ''rspec-expectations-2.1.0'';
      requiredGems = [ g.diff_lcs_1_1_3 ];
      sha256 = ''0p7gs3zsj70fz30209961fzdgia1qyrpg54v0ywhqmvc5kl0q8lc'';
    };
    rspec_mocks_2_1_0 = {
      basename = ''rspec_mocks'';
      meta = {
        description = ''rspec-mocks-2.1.0'';
        homepage = ''http://github.com/rspec/rspec-mocks'';
        longDescription = ''RSpec's 'test double' framework, with support for stubbing and mocking'';
      };
      name = ''rspec-mocks-2.1.0'';
      requiredGems = [  ];
      sha256 = ''1qhznpj0wq08z31i1rcv99dwx2abl4rlx2338ly0dcql54s8mma4'';
    };
    rubyforge_2_0_3 = {
      basename = ''rubyforge'';
      meta = {
        description = ''A script which automates a limited set of rubyforge operations'';
        homepage = ''http://codeforpeople.rubyforge.org/rubyforge/'';
        longDescription = ''A script which automates a limited set of rubyforge operations.

* Run 'rubyforge help' for complete usage.
* Setup: For first time users AND upgrades to 0.4.0:
  * rubyforge setup (deletes your username and password, so run sparingly!)
  * edit ~/.rubyforge/user-config.yml
  * rubyforge config
* For all rubyforge upgrades, run 'rubyforge config' to ensure you have latest.'';
      };
      name = ''rubyforge-2.0.3'';
      requiredGems = [ g.json_pure_1_6_4 ];
      sha256 = ''1ck9hkad55dy25819v4gd1nmnpvcrb3i4np3hc03h1j6q8qpxg5p'';
    };
    rubyforge_2_0_4 = {
      basename = ''rubyforge'';
      meta = {
        description = ''A script which automates a limited set of rubyforge operations'';
        homepage = ''http://codeforpeople.rubyforge.org/rubyforge/'';
        longDescription = ''A script which automates a limited set of rubyforge operations.

* Run 'rubyforge help' for complete usage.
* Setup: For first time users AND upgrades to 0.4.0:
  * rubyforge setup (deletes your username and password, so run sparingly!)
  * edit ~/.rubyforge/user-config.yml
  * rubyforge config
* For all rubyforge upgrades, run 'rubyforge config' to ensure you have latest.'';
      };
      name = ''rubyforge-2.0.4'';
      requiredGems = [  ];
      sha256 = ''1wdaa4nzy39yzy848fa1rybi72qlyf9vhi1ra9wpx9rpi810fwh1'';
    };
    rubyzip_0_9_4 = {
      basename = ''rubyzip'';
      meta = {
        description = ''rubyzip is a ruby module for reading and writing zip files'';
        homepage = ''http://rubyzip.sourceforge.net/'';
      };
      name = ''rubyzip-0.9.4'';
      requiredGems = [  ];
      sha256 = ''1lc67ssqyz49rm1jms5sdvy6x41h070razxlmvj4j5q6w3qixx41'';
    };
    sass_3_1_12 = {
      basename = ''sass'';
      meta = {
        description = ''A powerful but elegant CSS compiler that makes CSS fun again.'';
        homepage = ''http://sass-lang.com/'';
        longDescription = ''      Sass makes CSS fun again. Sass is an extension of CSS3, adding
      nested rules, variables, mixins, selector inheritance, and more.
      It's translated to well-formatted, standard CSS using the
      command line tool or a web-framework plugin.
'';
      };
      name = ''sass-3.1.12'';
      requiredGems = [  ];
      sha256 = ''10n2aic53290xsa3y3d63523s8xc78w5q5gqpns6cbljkdwb0ndy'';
    };
    sprockets_2_0_3 = {
      basename = ''sprockets'';
      meta = {
        description = ''Rack-based asset packaging system'';
        homepage = ''http://getsprockets.org/'';
        longDescription = ''Sprockets is a Rack-based asset packaging system that concatenates and serves JavaScript, CoffeeScript, CSS, LESS, Sass, and SCSS.'';
      };
      name = ''sprockets-2.0.3'';
      requiredGems = [ g.hike_1_2_1 g.tilt_1_3_3 ];
      sha256 = ''1az22a7vjfhfglbn02np8lci6ww1lzgzs0i9qlfwx87ybp2227bi'';
    };
    thor_0_14_6 = {
      basename = ''thor'';
      meta = {
        description = ''A scripting framework that replaces rake, sake and rubigen'';
        homepage = ''http://github.com/wycats/thor'';
        longDescription = ''A scripting framework that replaces rake, sake and rubigen'';
      };
      name = ''thor-0.14.6'';
      requiredGems = [  ];
      sha256 = ''18qmgv38gfw9clhq6szyw5kcxkkk8xr7c0klp3pk3cyznzbapif7'';
    };
    tilt_1_3_3 = {
      basename = ''tilt'';
      meta = {
        description = ''Generic interface to multiple Ruby template engines'';
        homepage = ''http://github.com/rtomayko/tilt/'';
        longDescription = ''Generic interface to multiple Ruby template engines'';
      };
      name = ''tilt-1.3.3'';
      requiredGems = [  ];
      sha256 = ''18qdl8nllbgwipa2ab9df3wlfgvsc8ml78hbypwc17b9qwv9bbs8'';
    };
    treetop_1_4_10 = {
      basename = ''treetop'';
      meta = {
        description = ''A Ruby-based text parsing and interpretation DSL'';
        homepage = ''http://functionalform.blogspot.com'';
      };
      name = ''treetop-1.4.10'';
      requiredGems = [ g.polyglot_0_3_3 ];
      sha256 = ''01f4w7fm6phhdbkx7bp0b58hrk3x4b0a63p2vvjbxm5gi2gv9ap2'';
    };
    tzinfo_0_3_31 = {
      basename = ''tzinfo'';
      meta = {
        description = ''Daylight-savings aware timezone library'';
        homepage = ''http://tzinfo.rubyforge.org/'';
        longDescription = ''TZInfo is a Ruby library that uses the standard tz (Olson) database to provide daylight savings aware transformations between times in different time zones.'';
      };
      name = ''tzinfo-0.3.31'';
      requiredGems = [  ];
      sha256 = ''1kwc25c1x8cvryjhpp8sx20vrd8h9g9gsl7p5393a88544qy41hb'';
    };
    xml_simple_1_0_12 = {
      basename = ''xml_simple'';
      meta = {
        description = ''A simple API for XML processing.'';
        homepage = ''http://xml-simple.rubyforge.org'';
      };
      name = ''xml-simple-1.0.12'';
      requiredGems = [  ];
      sha256 = ''0m7z3l8ccm3zd22gyx40fnfl0nah61jaigb4bkmplq0hdazyj60y'';
    };
  };
}
