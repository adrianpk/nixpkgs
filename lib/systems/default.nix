{ lib }:
  let inherit (lib.attrsets) mapAttrs; in

rec {
  doubles = import ./doubles.nix { inherit lib; };
  forMeta = import ./for-meta.nix { inherit lib; };
  parse = import ./parse.nix { inherit lib; };
  inspect = import ./inspect.nix { inherit lib; };
  platforms = import ./platforms.nix { inherit lib; };
  examples = import ./examples.nix { inherit lib; };

  # Elaborate a `localSystem` or `crossSystem` so that it contains everything
  # necessary.
  #
  # `parsed` is inferred from args, both because there are two options with one
  # clearly prefered, and to prevent cycles. A simpler fixed point where the RHS
  # always just used `final.*` would fail on both counts.
  elaborate = args: let
    final = {
      # Prefer to parse `config` as it is strictly more informative.
      parsed = parse.mkSystemFromString (if args ? config then args.config else args.system);
      # Either of these can be losslessly-extracted from `parsed` iff parsing succeeds.
      system = parse.doubleFromSystem final.parsed;
      config = parse.tripleFromSystem final.parsed;
      # Just a guess, based on `system`
      platform = platforms.selectBySystem final.system;
      # Derived meta-data
      libc =
        /**/ if final.isDarwin              then "libSystem"
        else if final.isMinGW               then "msvcrt"
        else if final.isMusl                then "musl"
        else if final.isUClibc              then "uclibc"
        else if final.isAndroid             then "bionic"
        else if final.isLinux /* default */ then "glibc"
        else if final.isAvr                 then "avrlibc"
        else if final.isNetBSD              then "nblibc"
        # TODO(@Ericson2314) think more about other operating systems
        else                                     "native/impure";
      extensions = {
        sharedLibrary =
          /**/ if final.isDarwin  then ".dylib"
          else if final.isWindows then ".dll"
          else                         ".so";
        executable =
          /**/ if final.isWindows then ".exe"
          else                         "";
      };
      # Misc boolean options
      useAndroidPrebuilt = false;
      useiOSPrebuilt = false;

      # Output from uname
      uname = {
        # uname -s
        system = {
          "linux" = "Linux";
          "windows" = "Windows";
          "darwin" = "Darwin";
          "netbsd" = "NetBSD";
          "freebsd" = "FreeBSD";
          "openbsd" = "OpenBSD";
          "wasm" = "Wasm";
        }.${final.parsed.kernel.name} or null;

         # uname -p
         processor = final.parsed.cpu.name;

         # uname -r
         release = null;
      };

      qemuArch =
        if final.isArm then "arm"
        else if final.isx86_64 then "x86_64"
        else if final.isx86 then "i386"
        else {
          "powerpc" = "ppc";
          "powerpc64" = "ppc64";
          "powerpc64le" = "ppc64";
          "mips64" = "mips";
          "mipsel64" = "mipsel";
        }.${final.parsed.cpu.name} or final.parsed.cpu.name;

      emulator = pkgs: let
        qemu-user = pkgs.qemu.override {
          smartcardSupport = false;
          spiceSupport = false;
          openGLSupport = false;
          virglSupport = false;
          vncSupport = false;
          gtkSupport = false;
          sdlSupport = false;
          pulseSupport = false;
          smbdSupport = false;
          seccompSupport = false;
          hostCpuTargets = ["${final.qemuArch}-linux-user"];
        };
        wine-name = "wine${toString final.parsed.cpu.bits}";
        wine = (pkgs.winePackagesFor wine-name).minimal;
      in
        if final.parsed.kernel.name == pkgs.stdenv.hostPlatform.parsed.kernel.name &&
           (final.parsed.cpu.name == pkgs.stdenv.hostPlatform.parsed.cpu.name ||
            (final.isi686 && pkgs.stdenv.hostPlatform.isx86_64))
        then pkgs.runtimeShell
        else if final.isWindows
        then "${wine}/bin/${wine-name}"
        else if final.isLinux && pkgs.stdenv.hostPlatform.isLinux
        then "${qemu-user}/bin/qemu-${final.qemuArch}"
        else throw "Don't know how to run ${final.config} executables.";

    } // mapAttrs (n: v: v final.parsed) inspect.predicates
      // args;
  in assert final.useAndroidPrebuilt -> final.isAndroid;
     assert lib.foldl
       (pass: { assertion, message }:
         if assertion final
         then pass
         else throw message)
       true
       (final.parsed.abi.assertions or []);
    final;
}
