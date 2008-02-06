args: with args;

rec {
  alsaLib = (import ./common.nix) {
    aName = "lib";
    sha256 = "1k96razf5h7blidh5ib54plcrfnbysvwm7vhvz28b4cy20zv66df";
  } args;

  alsaUtils = (import ./common.nix) {
    aName = "utils";
    sha256 = "10bj4pw2hp3f6qzkxsrlnvsxjlpqha696fn10gzdnnzym072skzb";
    buildInputs = [alsaLib ncurses gettext];
  } args;
}
0rb5rc8ppxjrpg5bcb5fw24v7gm5983zphz9762i8is5q2hbcqif
