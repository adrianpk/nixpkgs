{pkgs, system, nodejs, stdenv}:

let
  nodePackages = import ./composition-v10.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages // {

  pnpm = nodePackages.pnpm.override {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = let
      pnpmLibPath = stdenv.lib.makeBinPath [
        nodejs.passthru.python
        nodejs
      ];
    in ''
      for prog in $out/bin/*; do
        wrapProgram "$prog" --prefix PATH : ${pnpmLibPath}
      done
    '';
  };

}
