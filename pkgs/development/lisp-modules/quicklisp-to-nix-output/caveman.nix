args @ { fetchurl, ... }:
rec {
  baseName = ''caveman'';
  version = ''20171019-git'';

  description = ''Web Application Framework for Common Lisp'';

  deps = [ args."alexandria" args."anaphora" args."babel" args."babel-streams" args."bordeaux-threads" args."circular-streams" args."cl-annot" args."cl-ansi-text" args."cl-colors" args."cl-emb" args."cl-fad" args."cl-ppcre" args."cl-project" args."cl-syntax" args."cl-syntax-annot" args."cl-utilities" args."clack-v1-compat" args."dexador" args."do-urlencode" args."http-body" args."lack" args."let-plus" args."local-time" args."map-set" args."marshal" args."myway" args."named-readtables" args."prove" args."quri" args."split-sequence" args."trivial-backtrace" args."trivial-features" args."trivial-gray-streams" args."trivial-types" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/caveman/2017-10-19/caveman-20171019-git.tgz'';
    sha256 = ''0yjhjhjnq7l6z4fj9l470hgsa609adm216fss5xsf43pljv2h5ra'';
  };

  packageName = "caveman";

  asdFilesToKeep = ["caveman.asd"];
  overrides = x: x;
}
/* (SYSTEM caveman DESCRIPTION Web Application Framework for Common Lisp SHA256
    0yjhjhjnq7l6z4fj9l470hgsa609adm216fss5xsf43pljv2h5ra URL
    http://beta.quicklisp.org/archive/caveman/2017-10-19/caveman-20171019-git.tgz
    MD5 41318d26a0825e504042fa693959feaf NAME caveman FILENAME caveman DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME babel FILENAME babel) (NAME babel-streams FILENAME babel-streams)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME circular-streams FILENAME circular-streams)
     (NAME cl-annot FILENAME cl-annot)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-emb FILENAME cl-emb)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-project FILENAME cl-project) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME clack-v1-compat FILENAME clack-v1-compat)
     (NAME dexador FILENAME dexador) (NAME do-urlencode FILENAME do-urlencode)
     (NAME http-body FILENAME http-body) (NAME lack FILENAME lack)
     (NAME let-plus FILENAME let-plus) (NAME local-time FILENAME local-time)
     (NAME map-set FILENAME map-set) (NAME marshal FILENAME marshal)
     (NAME myway FILENAME myway)
     (NAME named-readtables FILENAME named-readtables)
     (NAME prove FILENAME prove) (NAME quri FILENAME quri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-types FILENAME trivial-types)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria anaphora babel babel-streams bordeaux-threads circular-streams
     cl-annot cl-ansi-text cl-colors cl-emb cl-fad cl-ppcre cl-project
     cl-syntax cl-syntax-annot cl-utilities clack-v1-compat dexador
     do-urlencode http-body lack let-plus local-time map-set marshal myway
     named-readtables prove quri split-sequence trivial-backtrace
     trivial-features trivial-gray-streams trivial-types usocket)
    VERSION 20171019-git SIBLINGS
    (caveman-middleware-dbimanager caveman-test caveman2-db caveman2-test
     caveman2)
    PARASITES NIL) */
