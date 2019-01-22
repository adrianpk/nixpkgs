{ callPackage }:

let
  mkScons = args: callPackage (import ./common.nix args) { };
in {
  scons_3_0_1 = mkScons {
    version = "3.0.1";
    sha256 = "0wzid419mlwqw9llrg8gsx4nkzhqy16m4m40r0xnh6cwscw5wir4";
  };
  scons_latest = mkScons {
    version = "3.0.4";
    sha256 = "1jzvcbn77ayibd7zhzs7vz316f34mxb8akfrxccjni6i09mpv96n";
  };
}
