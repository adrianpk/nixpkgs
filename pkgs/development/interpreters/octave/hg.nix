args@{ stdenv, openblas, ghostscript ? null, texinfo

     , # These are arguments that shouldn't be passed to the
       # octave package.
       texlive, tex ? texlive.combined.scheme-small
     , epstool, pstoedit, transfig
     , lib, fetchhg, callPackage
     , autoconf, automake, libtool
     , bison, librsvg, icoutils, gperf

     , # These are options that can be passed in addition to the ones
       # octave usually takes.
       # - rev is the HG revision.  Use "tip" for the bleeding edge.
       # - docs can be set to false to skip building documentation.
       rev ? "23269", docs ? true

     , # All remaining arguments will be passed to the octave package.
       ...
     }:

with stdenv.lib;
let
  octaveArgs = removeAttrs args
    [ "texlive" "tex"
      "epstool" "pstoedit" "transfig"
      "lib" "fetchhg" "callPackage"
      "autoconf" "automake" "libtool"
      "bison" "librsvg" "icoutils" "gperf"
      "rev" "docs"
    ];
  octave = callPackage ./default.nix octaveArgs;

  # List of hashes for known HG revisions.
  sha256s = {
    "23269" = "87f560e873ad1454fdbcdd8aca65f9f0b1e605bdc00aebbdc4f9d862ca72ff1d";
  };

in lib.overrideDerivation octave (attrs: rec {
  version = "4.3.0pre${rev}";
  name = "octave-${version}";

  src = fetchhg {
    url = http://www.octave.org/hg/octave;
    inherit rev;

    sha256 =
      if builtins.hasAttr rev sha256s
      then builtins.getAttr rev sha256s
      else null;

    fetchSubrepos = true;
  };

  # Octave's test for including this flag seems to be broken in 4.3.
  F77_INTEGER_8_FLAG = optional openblas.blas64 "-fdefault-integer-8";

  # This enables texinfo to find the files it needs.
  TEXINPUTS = ".:build-aux:${texinfo}/texmf-dist/tex/generic/epsf:";

  disableDocs = !docs || ghostscript == null;

  nativeBuildInputs = attrs.nativeBuildInputs
    ++ [ autoconf automake libtool bison librsvg icoutils gperf ]
    ++ optionals (!disableDocs) [ tex epstool pstoedit transfig ];

  # Run bootstrap before any other patches, as other patches may refer
  # to files that are generated by the bootstrap.
  prePatch = ''
    patchShebangs bootstrap
    ./bootstrap
  '' + attrs.prePatch;

  configureFlags = attrs.configureFlags ++
    optional disableDocs "--disable-docs";
})
