{ pkgs }:

let
  removeLibraryHaskellDepends = pnames: depends:
    builtins.filter (e: !(builtins.elem (e.pname or "") pnames)) depends;
in

with import ./lib.nix { inherit pkgs; };

self: super: {

  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

  inherit (pkgs.haskell.packages.ghc7102) jailbreak-cabal alex happy gtk2hs-buildtools;

  # This is the list of packages that are built into a booted ghcjs installation
  # It can be generated with the command:
  # nix-shell -p haskell.packages.ghcjs.ghc --command "ghcjs-pkg list | sed -n 's/^    \(.*\)-\([0-9.]*\)$/\1_\2/ p' | sed 's/\./_/g' | sed 's/-\(.\)/\U\1/' | sed 's/^\([^_]*\)\(.*\)$/\1 = null;/'"
  Cabal = null;
  aeson = null;
  array = null;
  async = null;
  attoparsec = null;
  base = null;
  binary = null;
  rts = null;
  bytestring = null;
  case-insensitive = null;
  containers = null;
  deepseq = null;
  directory = null;
  dlist = null;
  extensible-exceptions = null;
  filepath = null;
  ghc-prim = null;
  ghcjs-base = null;
  ghcjs-prim = null;
  hashable = null;
  integer-gmp = null;
  mtl = null;
  old-locale = null;
  old-time = null;
  parallel = null;
  pretty = null;
  primitive = null;
  process = null;
  scientific = null;
  stm = null;
  syb = null;
  template-haskell = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  unordered-containers = null;
  vector = null;

  # These packages are core libraries in GHC 7.10.x, but not here.
  bin-package-db = null;
  haskeline = self.haskeline_0_7_2_1;
  hoopl = self.hoopl_3_10_2_1;
  hpc = self.hpc_0_6_0_2;
  terminfo = self.terminfo_0_4_0_1;
  xhtml = self.xhtml_3000_2_1;

  pqueue = overrideCabal super.pqueue (drv: {
    postPatch = ''
      sed -i -e '12s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '64s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '32s|null|Data.PQueue.Internals.null|' Data/PQueue/Min.hs
      sed -i -e '32s|null|Data.PQueue.Max.null|' Data/PQueue/Max.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Internals.null|' Data/PQueue/Prio/Min.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Max.null|' Data/PQueue/Prio/Max.hs
    '';
  });

  transformers-compat = overrideCabal super.transformers-compat (drv: {
    configureFlags = [];
  });

  profunctors = overrideCabal super.profunctors (drv: {
    preConfigure = ''
      sed -i 's/^{-# ANN .* #-}//' src/Data/Profunctor/Unsafe.hs
    '';
  });

  ghcjs-dom = overrideCabal super.ghcjs-dom (drv: {
    libraryHaskellDepends =
      removeLibraryHaskellDepends [
        "glib" "gtk" "gtk3" "webkitgtk" "webkitgtk3"
      ] drv.libraryHaskellDepends;
  });

  ghc-paths = overrideCabal super.ghc-paths (drv: {
    patches = [ ./patches/ghc-paths-nix-ghcjs.patch ];
  });

  # reflex 0.3, made compatible with the newest GHCJS.
  reflex = overrideCabal super.reflex (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "ryantrinkle";
      repo = "reflex";
      rev = "cc62c11a6cde31412582758c236919d4bb766ada";
      sha256 = "1j4vw0636bkl46lj8ry16i04vgpivjc6bs3ls54ppp1wfp63q7w4";
    };
  });

  # reflex-dom 0.2, made compatible with the newest GHCJS.
  reflex-dom = overrideCabal super.reflex-dom (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "ryantrinkle";
      repo = "reflex-dom";
      rev = "639d9ca13c2def075e83344c9afca6eafaf24219";
      sha256 = "0166ihbh3dbfjiym9w561svpgvj0x4i8i8ws70xaafi0cmpsxrar";
    };
    libraryHaskellDepends =
      removeLibraryHaskellDepends [
        "glib" "gtk3" "webkitgtk3" "webkitgtk3-javascriptcore" "raw-strings-qq" "unix"
      ] drv.libraryHaskellDepends;
  });

}
