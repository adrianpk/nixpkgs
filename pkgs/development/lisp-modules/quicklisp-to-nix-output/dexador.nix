args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20171130-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."chipz" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-cookie" args."cl-fad" args."cl-ppcre" args."cl-reexport" args."cl-utilities" args."fast-http" args."fast-io" args."flexi-streams" args."local-time" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-mimes" args."usocket" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-11-30/dexador-20171130-git.tgz'';
    sha256 = ''0qg8jxij1s5j7jm2hxick9bvgc5nvq7fjalaah0rarynq70z61bd'';
  };

  packageName = "dexador";

  asdFilesToKeep = ["dexador.asd"];
  overrides = x: x;
}
/* (SYSTEM dexador DESCRIPTION Yet another HTTP client for Common Lisp SHA256
    0qg8jxij1s5j7jm2hxick9bvgc5nvq7fjalaah0rarynq70z61bd URL
    http://beta.quicklisp.org/archive/dexador/2017-11-30/dexador-20171130-git.tgz
    MD5 e1b5154f2169708e2f351707a2bc135f NAME dexador FILENAME dexador DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME chipz FILENAME chipz) (NAME chunga FILENAME chunga)
     (NAME cl+ssl FILENAME cl_plus_ssl) (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-cookie FILENAME cl-cookie) (NAME cl-fad FILENAME cl-fad)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME local-time FILENAME local-time)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-mimes FILENAME trivial-mimes)
     (NAME usocket FILENAME usocket) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel chipz chunga cl+ssl
     cl-base64 cl-cookie cl-fad cl-ppcre cl-reexport cl-utilities fast-http
     fast-io flexi-streams local-time proc-parse quri smart-buffer
     split-sequence static-vectors trivial-features trivial-garbage
     trivial-gray-streams trivial-mimes usocket xsubseq)
    VERSION 20171130-git SIBLINGS (dexador-test) PARASITES NIL) */
