{ stdenv, bazaar }: 
{ url, revision, sha256 }:

stdenv.mkDerivation {
  name = "bzr-export";

  builder = ./builder.sh;
  buildInputs = [ bazaar ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;
  
  inherit url revision;
}
