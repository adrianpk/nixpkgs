{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.26.2";
  cargoVersion = "1.26.2";
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "0047ais0fvmqvngqkdsxgrzhb0kljg8wy85b01kbbjc88hqcz7pv";
  };
in rec {
  rustc = callPackage ./rustc.nix {
    inherit stdenv llvm targets targetPatches targetToolchains rustPlatform version src;

    patches = [
      ./patches/net-tcp-disable-tests.patch
      ./patches/stdsimd-disable-doctest.patch
      # Fails on hydra - not locally; the exact reason is unknown.
      # Comments in the test suggest that some non-reproducible environment
      # variables such $RANDOM can make it fail.
      ./patches/disable-test-inherit-env.patch
    ];

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    # 1. Upstream is not running tests on aarch64:
    # see https://github.com/rust-lang/rust/issues/49807#issuecomment-380860567
    # So we do the same.
    # 2. Tests run out of memory for i686
    doCheck = !stdenv.isAarch64 && !stdenv.isi686;
  };

  cargo = callPackage ./cargo.nix rec {
    version = cargoVersion;
    inherit src;
    inherit stdenv;
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
