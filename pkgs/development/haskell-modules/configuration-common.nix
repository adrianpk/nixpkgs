{ pkgs }:

with import ./lib.nix;

self: super: {

  # Some packages need a non-core version of Cabal.
  Cabal_1_20_0_3 = overrideCabal super.Cabal_1_20_0_3 (drv: { doCheck = false; });
  Cabal_1_22_0_0 = overrideCabal super.Cabal_1_22_0_0 (drv: { doCheck = false; });
  cabal-install = overrideCabal (super.cabal-install.override { Cabal = self.Cabal_1_22_0_0; }) (drv: { doCheck = false; });
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_20_0_3; };

  # Break infinite recursions.
  digest = super.digest.override { inherit (pkgs) zlib; };
  matlab = super.matlab.override { matlab = null; };

  # Doesn't compile with lua 5.2.
  hslua = super.hslua.override { lua = pkgs.lua5_1; };

  # "curl" means pkgs.curl
  git-annex = super.git-annex.override { inherit (pkgs) git rsync gnupg1 curl lsof openssh which bup perl wget; };

  # Depends on code distributed under a non-free license.
  yices-painless = overrideCabal super.yices-painless (drv: { hydraPlatforms = []; });

  # This package overrides the one from pkgs.gnome.
  gtkglext = super.gtkglext.override { inherit (pkgs.gnome) gtkglext; };

  # The test suite refers to its own library with an invalid version constraint.
  presburger = overrideCabal super.presburger (drv: { doCheck = false; });

  # Won't find it's header files without help.
  sfml-audio = overrideCabal super.sfml-audio (drv: { configureFlags = drv.configureFlags or [] ++ ["--extra-include-dirs=${pkgs.openal}/include/AL"]; });

  # https://github.com/haskell/time/issues/23
  time_1_5_0_1 = overrideCabal super.time_1_5_0_1 (drv: { doCheck = false; });

  # Hacks to make packages compile. Are these still necessary??? HELP!
  abstract-deque = overrideCabal super.abstract-deque (drv: { doCheck = false; });
  accelerate-cuda = overrideCabal super.accelerate-cuda (drv: { jailbreak = true; });
  accelerate = overrideCabal super.accelerate (drv: { jailbreak = true; });
  active = overrideCabal super.active (drv: { jailbreak = true; });
  aeson-utils = overrideCabal super.aeson-utils (drv: { jailbreak = true; });
  Agda = overrideCabal super.Agda (drv: { jailbreak = true; noHaddock = true; });
  amqp = overrideCabal super.amqp (drv: { doCheck = false; });
  arbtt = overrideCabal super.arbtt (drv: { jailbreak = true; });
  ariadne = overrideCabal super.ariadne (drv: { doCheck = false; });
  arithmoi = overrideCabal super.arithmoi (drv: { jailbreak = true; });
  asn1-encoding = overrideCabal super.asn1-encoding (drv: { doCheck = false; });
  assert-failure = overrideCabal super.assert-failure (drv: { jailbreak = true; });
  atto-lisp = overrideCabal super.atto-lisp (drv: { jailbreak = true; });
  attoparsec-conduit = overrideCabal super.attoparsec-conduit (drv: { noHaddock = true; });
  authenticate-oauth = overrideCabal super.authenticate-oauth (drv: { jailbreak = true; });
  aws = overrideCabal super.aws (drv: { doCheck = false; jailbreak = true; });
  base64-bytestring = overrideCabal super.base64-bytestring (drv: { doCheck = false; });
  benchpress = overrideCabal super.benchpress (drv: { jailbreak = true; });
  binary-conduit = overrideCabal super.binary-conduit (drv: { jailbreak = true; });
  bindings-GLFW = overrideCabal super.bindings-GLFW (drv: { doCheck = false; });
  bitset = overrideCabal super.bitset (drv: { doCheck = false; });
  blaze-builder-conduit = overrideCabal super.blaze-builder-conduit (drv: { noHaddock = true; });
  blaze-builder-enumerator = overrideCabal super.blaze-builder-enumerator (drv: { jailbreak = true; });
  blaze-svg = overrideCabal super.blaze-svg (drv: { jailbreak = true; });
  boundingboxes = overrideCabal super.boundingboxes (drv: { doCheck = false; });
  bson = overrideCabal super.bson (drv: { doCheck = false; });
  bytestring-progress = overrideCabal super.bytestring-progress (drv: { noHaddock = true; });
  cabal2ghci = overrideCabal super.cabal2ghci (drv: { jailbreak = true; });
  cabal-bounds = overrideCabal super.cabal-bounds (drv: { doCheck = false; jailbreak = true; });
  cabal-cargs = overrideCabal super.cabal-cargs (drv: { jailbreak = true; });
  cabal-lenses = overrideCabal super.cabal-lenses (drv: { jailbreak = true; });
  cabal-macosx = overrideCabal super.cabal-macosx (drv: { jailbreak = true; });
  cabal-meta = overrideCabal super.cabal-meta (drv: { doCheck = false; });
  cairo = overrideCabal super.cairo (drv: { jailbreak = true; });
  cautious-file = overrideCabal super.cautious-file (drv: { doCheck = false; });
  certificate = overrideCabal super.certificate (drv: { jailbreak = true; });
  Chart-cairo = overrideCabal super.Chart-cairo (drv: { jailbreak = true; });
  Chart-diagrams = overrideCabal super.Chart-diagrams (drv: { jailbreak = true; });
  Chart = overrideCabal super.Chart (drv: { jailbreak = true; });
  ChasingBottoms = overrideCabal super.ChasingBottoms (drv: { jailbreak = true; });
  cheapskate = overrideCabal super.cheapskate (drv: { jailbreak = true; });
  citeproc-hs = overrideCabal super.citeproc-hs (drv: { jailbreak = true; });
  clay = overrideCabal super.clay (drv: { jailbreak = true; });
  cmdtheline = overrideCabal super.cmdtheline (drv: { doCheck = false; });
  codex = overrideCabal super.codex (drv: { jailbreak = true; });
  command-qq = overrideCabal super.command-qq (drv: { doCheck = false; });
  comonads-fd = overrideCabal super.comonads-fd (drv: { noHaddock = true; });
  comonad-transformers = overrideCabal super.comonad-transformers (drv: { noHaddock = true; });
  concrete-typerep = overrideCabal super.concrete-typerep (drv: { doCheck = false; });
  conduit-extra = overrideCabal super.conduit-extra (drv: { doCheck = false; });
  conduit = overrideCabal super.conduit (drv: { doCheck = false; });
  CouchDB = overrideCabal super.CouchDB (drv: { doCheck = false; jailbreak = true; });
  criterion = overrideCabal super.criterion (drv: { doCheck = false; });
  crypto-conduit = overrideCabal super.crypto-conduit (drv: { doCheck = false; jailbreak = true; });
  crypto-numbers = overrideCabal super.crypto-numbers (drv: { doCheck = false; });
  cuda = overrideCabal super.cuda (drv: { doCheck = false; });
  data-accessor = overrideCabal super.data-accessor (drv: { jailbreak = true; });
  dataenc = overrideCabal super.dataenc (drv: { jailbreak = true; });
  data-fin = overrideCabal super.data-fin (drv: { jailbreak = true; });
  data-lens = overrideCabal super.data-lens (drv: { jailbreak = true; });
  data-pprint = overrideCabal super.data-pprint (drv: { jailbreak = true; });
  dbmigrations = overrideCabal super.dbmigrations (drv: { jailbreak = true; });
  dbus = overrideCabal super.dbus (drv: { doCheck = false; jailbreak = true; });
  deepseq-th = overrideCabal super.deepseq-th (drv: { doCheck = false; jailbreak = true; });
  diagrams-contrib = overrideCabal super.diagrams-contrib (drv: { jailbreak = true; });
  diagrams-core = overrideCabal super.diagrams-core (drv: { jailbreak = true; });
  diagrams-lib = overrideCabal super.diagrams-lib (drv: { jailbreak = true; });
  diagrams-postscript = overrideCabal super.diagrams-postscript (drv: { jailbreak = true; });
  diagrams-rasterific = overrideCabal super.diagrams-rasterific (drv: { jailbreak = true; });
  diagrams = overrideCabal super.diagrams (drv: { noHaddock = true; jailbreak = true; });
  diagrams-svg = overrideCabal super.diagrams-svg (drv: { jailbreak = true; });
  digestive-functors-heist = overrideCabal super.digestive-functors-heist (drv: { jailbreak = true; });
  digestive-functors-snap = overrideCabal super.digestive-functors-snap (drv: { jailbreak = true; });
  digestive-functors = overrideCabal super.digestive-functors (drv: { jailbreak = true; });
  directory-layout = overrideCabal super.directory-layout (drv: { doCheck = false; });
  distributed-process-platform = overrideCabal super.distributed-process-platform (drv: { doCheck = false; jailbreak = true; });
  distributed-process = overrideCabal super.distributed-process (drv: { jailbreak = true; });
  doctest = overrideCabal super.doctest (drv: { doCheck = false; });
  dom-selector = overrideCabal super.dom-selector (drv: { doCheck = false; });
  download-curl = overrideCabal super.download-curl (drv: { jailbreak = true; });
  dual-tree = overrideCabal super.dual-tree (drv: { jailbreak = true; });
  Dust-crypto = overrideCabal super.Dust-crypto (drv: { doCheck = false; });
  either = overrideCabal super.either (drv: { noHaddock = true; });
  ekg = overrideCabal super.ekg (drv: { jailbreak = true; });
  elm-get = overrideCabal super.elm-get (drv: { jailbreak = true; });
  elm-server = overrideCabal super.elm-server (drv: { jailbreak = true; });
  encoding = overrideCabal super.encoding (drv: { jailbreak = true; });
  enummapset = overrideCabal super.enummapset (drv: { jailbreak = true; });
  equational-reasoning = overrideCabal super.equational-reasoning (drv: { jailbreak = true; });
  equivalence = overrideCabal super.equivalence (drv: { doCheck = false; });
  errors = overrideCabal super.errors (drv: { jailbreak = true; });
  extensible-effects = overrideCabal super.extensible-effects (drv: { jailbreak = true; });
  failure = overrideCabal super.failure (drv: { jailbreak = true; });
  fay = overrideCabal super.fay (drv: { jailbreak = true; });
  fb = overrideCabal super.fb (drv: { doCheck = false; jailbreak = true; });
  filestore = overrideCabal super.filestore (drv: { doCheck = false; jailbreak = true; });
  force-layout = overrideCabal super.force-layout (drv: { jailbreak = true; });
  free-game = overrideCabal super.free-game (drv: { jailbreak = true; });
  free = overrideCabal super.free (drv: { jailbreak = true; });
  fsnotify = overrideCabal super.fsnotify (drv: { doCheck = false; });
  ghc-events = overrideCabal super.ghc-events (drv: { doCheck = false; jailbreak = true; });
  ghcid = overrideCabal super.ghcid (drv: { doCheck = false; });
  ghc-mod = overrideCabal super.ghc-mod (drv: { doCheck = false; });
  gitit = overrideCabal super.gitit (drv: { jailbreak = true; });
  git-vogue = overrideCabal super.git-vogue (drv: { doCheck = false; });
  glade = overrideCabal super.glade (drv: { jailbreak = true; });
  GLFW-b = overrideCabal super.GLFW-b (drv: { doCheck = false; });
  gloss-raster = overrideCabal super.gloss-raster (drv: { jailbreak = true; });
  gl = overrideCabal super.gl (drv: { noHaddock = true; });
  gnuplot = overrideCabal super.gnuplot (drv: { jailbreak = true; });
  Graphalyze = overrideCabal super.Graphalyze (drv: { jailbreak = true; });
  graphviz = overrideCabal super.graphviz (drv: { doCheck = false; jailbreak = true; });
  grid = overrideCabal super.grid (drv: { doCheck = false; });
  groupoids = overrideCabal super.groupoids (drv: { noHaddock = true; });
  gtk-traymanager = overrideCabal super.gtk-traymanager (drv: { jailbreak = true; });
  hakyll = overrideCabal super.hakyll (drv: { jailbreak = true; });
  hamlet = overrideCabal super.hamlet (drv: { noHaddock = true; });
  handa-gdata = overrideCabal super.handa-gdata (drv: { doCheck = false; });
  HandsomeSoup = overrideCabal super.HandsomeSoup (drv: { jailbreak = true; });
  happstack-server = overrideCabal super.happstack-server (drv: { doCheck = false; jailbreak = true; });
  hashable = overrideCabal super.hashable (drv: { doCheck = false; jailbreak = true; });
  hashed-storage = overrideCabal super.hashed-storage (drv: { doCheck = false; });
  haskell-docs = overrideCabal super.haskell-docs (drv: { doCheck = false; });
  haskell-names = overrideCabal super.haskell-names (drv: { doCheck = false; });
  haskell-src-exts = overrideCabal super.haskell-src-exts (drv: { doCheck = false; });
  haskell-src-meta = overrideCabal super.haskell-src-meta (drv: { jailbreak = true; });
  haskoin = overrideCabal super.haskoin (drv: { doCheck = false; jailbreak = true; });
  hasktags = overrideCabal super.hasktags (drv: { jailbreak = true; });
  hasql-postgres = overrideCabal super.hasql-postgres (drv: { doCheck = false; });
  haste-compiler = overrideCabal super.haste-compiler (drv: { noHaddock = true; });
  haxl = overrideCabal super.haxl (drv: { jailbreak = true; });
  HaXml = overrideCabal super.HaXml (drv: { noHaddock = true; });
  haxr = overrideCabal super.haxr (drv: { jailbreak = true; });
  hcltest = overrideCabal super.hcltest (drv: { jailbreak = true; });
  HDBC-odbc = overrideCabal super.HDBC-odbc (drv: { noHaddock = true; });
  hedis = overrideCabal super.hedis (drv: { doCheck = false; });
  heist = overrideCabal super.heist (drv: { jailbreak = true; });
  hindent = overrideCabal super.hindent (drv: { doCheck = false; });
  hi = overrideCabal super.hi (drv: { doCheck = false; });
  hjsmin = overrideCabal super.hjsmin (drv: { jailbreak = true; });
  hledger-web = overrideCabal super.hledger-web (drv: { doCheck = false; jailbreak = true; });
  HList = overrideCabal super.HList (drv: { doCheck = false; });
  hoauth2 = overrideCabal super.hoauth2 (drv: { jailbreak = true; });
  holy-project = overrideCabal super.holy-project (drv: { doCheck = false; });
  hoodle-core = overrideCabal super.hoodle-core (drv: { noHaddock = true; });
  hsbencher-fusion = overrideCabal super.hsbencher-fusion (drv: { doCheck = false; });
  hsbencher = overrideCabal super.hsbencher (drv: { doCheck = false; });
  hsc3-db = overrideCabal super.hsc3-db (drv: { noHaddock = true; });
  hsimport = overrideCabal super.hsimport (drv: { jailbreak = true; });
  hsini = overrideCabal super.hsini (drv: { jailbreak = true; });
  hspec-discover = overrideCabal super.hspec-discover (drv: { noHaddock = true; });
  hspec-expectations = overrideCabal super.hspec-expectations (drv: { doCheck = false; });
  hspec-meta = overrideCabal super.hspec-meta (drv: { doCheck = false; });
  hspec = overrideCabal super.hspec (drv: { doCheck = false; });
  hsyslog = overrideCabal super.hsyslog (drv: { noHaddock = true; });
  HTF = overrideCabal super.HTF (drv: { doCheck = false; });
  http-attoparsec = overrideCabal super.http-attoparsec (drv: { jailbreak = true; });
  http-client-conduit = overrideCabal super.http-client-conduit (drv: { noHaddock = true; });
  http-client-multipart = overrideCabal super.http-client-multipart (drv: { noHaddock = true; });
  http-client = overrideCabal super.http-client (drv: { doCheck = false; });
  http-client-tls = overrideCabal super.http-client-tls (drv: { doCheck = false; });
  http-conduit = overrideCabal super.http-conduit (drv: { doCheck = false; });
  httpd-shed = overrideCabal super.httpd-shed (drv: { jailbreak = true; });
  http-reverse-proxy = overrideCabal super.http-reverse-proxy (drv: { doCheck = false; });
  http-streams = overrideCabal super.http-streams (drv: { doCheck = false; jailbreak = true; });
  HTTP = overrideCabal super.HTTP (drv: { doCheck = false; });
  http-types = overrideCabal super.http-types (drv: { jailbreak = true; });
  idris = overrideCabal super.idris (drv: { jailbreak = true; });
  ihaskell = overrideCabal super.ihaskell (drv: { doCheck = false; jailbreak = true; });
  js-jquery = overrideCabal super.js-jquery (drv: { doCheck = false; });
  json-assertions = overrideCabal super.json-assertions (drv: { jailbreak = true; });
  json-rpc = overrideCabal super.json-rpc (drv: { jailbreak = true; });
  json-schema = overrideCabal super.json-schema (drv: { jailbreak = true; });
  kansas-lava = overrideCabal super.kansas-lava (drv: { jailbreak = true; });
  keys = overrideCabal super.keys (drv: { jailbreak = true; });
  language-c-quote = overrideCabal super.language-c-quote (drv: { jailbreak = true; });
  language-ecmascript = overrideCabal super.language-ecmascript (drv: { doCheck = false; jailbreak = true; });
  language-java = overrideCabal super.language-java (drv: { doCheck = false; });
  largeword = overrideCabal super.largeword (drv: { jailbreak = true; });
  libjenkins = overrideCabal super.libjenkins (drv: { doCheck = false; jailbreak = true; });
  libsystemd-journal = overrideCabal super.libsystemd-journal (drv: { jailbreak = true; });
  lifted-base = overrideCabal super.lifted-base (drv: { doCheck = false; });
  linear = overrideCabal super.linear (drv: { doCheck = false; });
  ListLike = overrideCabal super.ListLike (drv: { jailbreak = true; });
  list-tries = overrideCabal super.list-tries (drv: { jailbreak = true; });
  llvm-general-pure = overrideCabal super.llvm-general-pure (drv: { doCheck = false; });
  llvm-general = overrideCabal super.llvm-general (drv: { doCheck = false; });
  lzma-enumerator = overrideCabal super.lzma-enumerator (drv: { jailbreak = true; });
  machines-directory = overrideCabal super.machines-directory (drv: { jailbreak = true; });
  machines-io = overrideCabal super.machines-io (drv: { jailbreak = true; });
  mainland-pretty = overrideCabal super.mainland-pretty (drv: { jailbreak = true; });
  markdown-unlit = overrideCabal super.markdown-unlit (drv: { noHaddock = true; });
  math-functions = overrideCabal super.math-functions (drv: { doCheck = false; });
  MissingH = overrideCabal super.MissingH (drv: { doCheck = false; });
  MonadCatchIO-mtl = overrideCabal super.MonadCatchIO-mtl (drv: { jailbreak = true; });
  MonadCatchIO-transformers = overrideCabal super.MonadCatchIO-transformers (drv: { jailbreak = true; });
  monadloc-pp = overrideCabal super.monadloc-pp (drv: { jailbreak = true; });
  monad-par = overrideCabal super.monad-par (drv: { doCheck = false; });
  monoid-extras = overrideCabal super.monoid-extras (drv: { jailbreak = true; });
  mpppc = overrideCabal super.mpppc (drv: { jailbreak = true; });
  msgpack = overrideCabal super.msgpack (drv: { jailbreak = true; });
  multiplate = overrideCabal super.multiplate (drv: { jailbreak = true; });
  mwc-random = overrideCabal super.mwc-random (drv: { doCheck = false; });
  nanospec = overrideCabal super.nanospec (drv: { doCheck = false; });
  network-carbon = overrideCabal super.network-carbon (drv: { jailbreak = true; });
  network-conduit = overrideCabal super.network-conduit (drv: { noHaddock = true; });
  network-simple = overrideCabal super.network-simple (drv: { jailbreak = true; });
  network-transport-tcp = overrideCabal super.network-transport-tcp (drv: { doCheck = false; });
  network-transport-tests = overrideCabal super.network-transport-tests (drv: { jailbreak = true; });
  network-uri = overrideCabal super.network-uri (drv: { doCheck = false; });
  numeric-prelude = overrideCabal super.numeric-prelude (drv: { jailbreak = true; });
  ofx = overrideCabal super.ofx (drv: { jailbreak = true; });
  opaleye = overrideCabal super.opaleye (drv: { doCheck = false; jailbreak = true; });
  openssl-streams = overrideCabal super.openssl-streams (drv: { jailbreak = true; });
  options = overrideCabal super.options (drv: { doCheck = false; });
  optparse-applicative = overrideCabal super.optparse-applicative (drv: { jailbreak = true; });
  packunused = overrideCabal super.packunused (drv: { jailbreak = true; });
  pandoc-citeproc = overrideCabal super.pandoc-citeproc (drv: { doCheck = false; });
  pandoc = overrideCabal super.pandoc (drv: { doCheck = false; jailbreak = true; });
  parallel-io = overrideCabal super.parallel-io (drv: { jailbreak = true; });
  parsec = overrideCabal super.parsec (drv: { jailbreak = true; });
  permutation = overrideCabal super.permutation (drv: { doCheck = false; });
  persistent-postgresql = overrideCabal super.persistent-postgresql (drv: { jailbreak = true; });
  persistent-template = overrideCabal super.persistent-template (drv: { jailbreak = true; });
  pipes-aeson = overrideCabal super.pipes-aeson (drv: { jailbreak = true; doCheck = false; });
  pipes-binary = overrideCabal super.pipes-binary (drv: { jailbreak = true; });
  pipes-http = overrideCabal super.pipes-http (drv: { jailbreak = true; });
  pipes-network = overrideCabal super.pipes-network (drv: { jailbreak = true; });
  pipes-shell = overrideCabal super.pipes-shell (drv: { doCheck = false; jailbreak = true; });
  pipes = overrideCabal super.pipes (drv: { jailbreak = true; });
  pipes-text = overrideCabal super.pipes-text (drv: { jailbreak = true; });
  pointed = overrideCabal super.pointed (drv: { jailbreak = true; });
  pointfree = overrideCabal super.pointfree (drv: { jailbreak = true; });
  postgresql-simple = overrideCabal super.postgresql-simple (drv: { doCheck = false; });
  process-conduit = overrideCabal super.process-conduit (drv: { doCheck = false; });
  product-profunctors = overrideCabal super.product-profunctors (drv: { jailbreak = true; });
  prolog = overrideCabal super.prolog (drv: { jailbreak = true; });
  punycode = overrideCabal super.punycode (drv: { doCheck = false; });
  quickcheck-instances = overrideCabal super.quickcheck-instances (drv: { jailbreak = true; });
  Rasterific = overrideCabal super.Rasterific (drv: { doCheck = false; });
  reactive-banana-wx = overrideCabal super.reactive-banana-wx (drv: { jailbreak = true; });
  ReadArgs = overrideCabal super.ReadArgs (drv: { jailbreak = true; });
  reducers = overrideCabal super.reducers (drv: { jailbreak = true; });
  rematch = overrideCabal super.rematch (drv: { doCheck = false; });
  repa-algorithms = overrideCabal super.repa-algorithms (drv: { jailbreak = true; });
  repa-examples = overrideCabal super.repa-examples (drv: { jailbreak = true; });
  repa-io = overrideCabal super.repa-io (drv: { jailbreak = true; });
  RepLib = overrideCabal super.RepLib (drv: { noHaddock = true; });
  rest-core = overrideCabal super.rest-core (drv: { jailbreak = true; });
  rest-gen = overrideCabal super.rest-gen (drv: { jailbreak = true; });
  rest-stringmap = overrideCabal super.rest-stringmap (drv: { jailbreak = true; });
  rest-types = overrideCabal super.rest-types (drv: { jailbreak = true; });
  rethinkdb = overrideCabal super.rethinkdb (drv: { doCheck = false; jailbreak = true; });
  retry = overrideCabal super.retry (drv: { jailbreak = true; });
  rope = overrideCabal super.rope (drv: { jailbreak = true; });
  RSA = overrideCabal super.RSA (drv: { doCheck = false; });
  scientific = overrideCabal super.scientific (drv: { jailbreak = true; });
  scotty = overrideCabal super.scotty (drv: { doCheck = false; jailbreak = true; });
  sdl2 = overrideCabal super.sdl2 (drv: { noHaddock = true; });
  serialport = overrideCabal super.serialport (drv: { doCheck = false; });
  setenv = overrideCabal super.setenv (drv: { doCheck = false; });
  setlocale = overrideCabal super.setlocale (drv: { jailbreak = true; });
  shakespeare-css = overrideCabal super.shakespeare-css (drv: { noHaddock = true; });
  shakespeare-i18n = overrideCabal super.shakespeare-i18n (drv: { noHaddock = true; });
  shakespeare-js = overrideCabal super.shakespeare-js (drv: { noHaddock = true; });
  shakespeare-text = overrideCabal super.shakespeare-text (drv: { noHaddock = true; });
  simple-sendfile = overrideCabal super.simple-sendfile (drv: { doCheck = false; });
  singletons = overrideCabal super.singletons (drv: { noHaddock = true; });
  skein = overrideCabal super.skein (drv: { jailbreak = true; });
  snap-core = overrideCabal super.snap-core (drv: { jailbreak = true; });
  snaplet-acid-state = overrideCabal super.snaplet-acid-state (drv: { jailbreak = true; });
  snaplet-redis = overrideCabal super.snaplet-redis (drv: { jailbreak = true; });
  snaplet-stripe = overrideCabal super.snaplet-stripe (drv: { jailbreak = true; });
  snap-web-routes = overrideCabal super.snap-web-routes (drv: { jailbreak = true; });
  snowball = overrideCabal super.snowball (drv: { doCheck = false; });
  sparse = overrideCabal super.sparse (drv: { doCheck = false; });
  statistics = overrideCabal super.statistics (drv: { doCheck = false; });
  stm-containers = overrideCabal super.stm-containers (drv: { doCheck = false; });
  storable-record = overrideCabal super.storable-record (drv: { jailbreak = true; });
  Strafunski-StrategyLib = overrideCabal super.Strafunski-StrategyLib (drv: { jailbreak = true; });
  stripe = overrideCabal super.stripe (drv: { jailbreak = true; });
  symbol = overrideCabal super.symbol (drv: { jailbreak = true; });
  system-filepath = overrideCabal super.system-filepath (drv: { doCheck = false; });
  tabular = overrideCabal super.tabular (drv: { jailbreak = true; });
  tar = overrideCabal super.tar (drv: { noHaddock = true; });
  template-default = overrideCabal super.template-default (drv: { jailbreak = true; });
  temporary = overrideCabal super.temporary (drv: { jailbreak = true; });
  test-framework-quickcheck2 = overrideCabal super.test-framework-quickcheck2 (drv: { jailbreak = true; });
  text = overrideCabal super.text (drv: { doCheck = false; });
  th-desugar = overrideCabal super.th-desugar (drv: { doCheck = false; });
  these = overrideCabal super.these (drv: { jailbreak = true; });
  th-lift-instances = overrideCabal super.th-lift-instances (drv: { jailbreak = true; });
  th-orphans = overrideCabal super.th-orphans (drv: { jailbreak = true; });
  thread-local-storage = overrideCabal super.thread-local-storage (drv: { doCheck = false; });
  threads = overrideCabal super.threads (drv: { doCheck = false; });
  threepenny-gui = overrideCabal super.threepenny-gui (drv: { jailbreak = true; });
  thyme = overrideCabal super.thyme (drv: { doCheck = false; });
  timeparsers = overrideCabal super.timeparsers (drv: { jailbreak = true; });
  tls = overrideCabal super.tls (drv: { doCheck = false; });
  twitter-types = overrideCabal super.twitter-types (drv: { doCheck = false; });
  unordered-containers = overrideCabal super.unordered-containers (drv: { doCheck = false; });
  uri-encode = overrideCabal super.uri-encode (drv: { jailbreak = true; });
  usb = overrideCabal super.usb (drv: { jailbreak = true; });
  utf8-string = overrideCabal super.utf8-string (drv: { noHaddock = true; });
  uuid = overrideCabal super.uuid (drv: { doCheck = false; jailbreak = true; });
  vacuum-graphviz = overrideCabal super.vacuum-graphviz (drv: { jailbreak = true; });
  vault = overrideCabal super.vault (drv: { jailbreak = true; });
  vcswrapper = overrideCabal super.vcswrapper (drv: { jailbreak = true; });
  vty = overrideCabal super.vty (drv: { doCheck = false; });
  vty-ui = overrideCabal super.vty-ui (drv: { jailbreak = true; });
  wai-extra = overrideCabal super.wai-extra (drv: { jailbreak = true; });
  wai-logger = overrideCabal super.wai-logger (drv: { doCheck = false; });
  wai-middleware-static = overrideCabal super.wai-middleware-static (drv: { jailbreak = true; });
  wai-test = overrideCabal super.wai-test (drv: { noHaddock = true; });
  wai-websockets = overrideCabal super.wai-websockets (drv: { jailbreak = true; });
  warp = overrideCabal super.warp (drv: { doCheck = false; });
  webdriver = overrideCabal super.webdriver (drv: { doCheck = false; jailbreak = true; });
  websockets-snap = overrideCabal super.websockets-snap (drv: { jailbreak = true; });
  websockets = overrideCabal super.websockets (drv: { jailbreak = true; });
  wl-pprint-terminfo = overrideCabal super.wl-pprint-terminfo (drv: { jailbreak = true; });
  wl-pprint-text = overrideCabal super.wl-pprint-text (drv: { jailbreak = true; });
  wreq = overrideCabal super.wreq (drv: { doCheck = false; });
  wxc = overrideCabal super.wxc (drv: { noHaddock = true; });
  wxdirect = overrideCabal super.wxdirect (drv: { jailbreak = true; });
  xdot = overrideCabal super.xdot (drv: { jailbreak = true; });
  xml-conduit = overrideCabal super.xml-conduit (drv: { jailbreak = true; });
  xmlgen = overrideCabal super.xmlgen (drv: { doCheck = false; });
  xml-html-conduit-lens = overrideCabal super.xml-html-conduit-lens (drv: { jailbreak = true; });
  xml-lens = overrideCabal super.xml-lens (drv: { jailbreak = true; });
  xmonad-extras = overrideCabal super.xmonad-extras (drv: { jailbreak = true; });
  xournal-types = overrideCabal super.xournal-types (drv: { jailbreak = true; });
  yap = overrideCabal super.yap (drv: { jailbreak = true; });
  yesod-core = overrideCabal super.yesod-core (drv: { jailbreak = true; });
  yesod-static = overrideCabal super.yesod-static (drv: { doCheck = false; });
  yst = overrideCabal super.yst (drv: { jailbreak = true; });
  zeromq3-haskell = overrideCabal super.zeromq3-haskell (drv: { doCheck = false; });
  zip-archive = overrideCabal super.zip-archive (drv: { doCheck = false; });
  zlib-conduit = overrideCabal super.zlib-conduit (drv: { noHaddock = true; });

  amazonka-core = overrideCabal super.amazonka-core (drv: {
    # these are upstream
    patches = [ ./patches/amazonka-fixes.patch ];

    # brendanhay/amazonka#54
    doCheck = false;
  });

  amazonka = overrideCabal super.amazonka (drv: {
    # brendanhay/amazonka#56
    patches = [ ./patches/amazonka-new-monad-control.patch ];
  });

}
// {
  # Not on Hackage yet.
  cabal2nix = self.mkDerivation {
    pname = "cabal2nix";
    version = "2.0";
    src = pkgs.fetchgit {
      url = "git://github.com/NixOS/cabal2nix.git";
      sha256 = "b9dde970f8e64fd5faff9402f5788ee832874d7584a67210f59f2c5e504ce631";
      rev = "6398667f4ad670eb3aa3334044a65a06971494d0";
    };
    isLibrary = false;
    isExecutable = true;
    buildDepends = with self; [
      aeson base bytestring Cabal containers deepseq directory filepath
      hackage-db monad-par monad-par-extras mtl pretty process
      regex-posix SHA split transformers utf8-string
    ];
    testDepends = with self; [ base doctest ];
    homepage = "http://github.com/NixOS/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = pkgs.stdenv.lib.licenses.bsd3;
  };
}
