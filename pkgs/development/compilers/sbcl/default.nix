a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.0.28" a; 
  buildInputs = with a; [
    clisp makeWrapper
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/sbcl/sbcl-${version}-source.tar.bz2";
    sha256 = "0jzi6zw73pll44fjllamiwvq5dihig2dcw3hl9h5a37948wnn0h4";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doFixTests" "doBuild" "doInstall" "doWrap"];
      
  setVars = a.fullDepEntry (''
    export INSTALL_ROOT=$out
  '') ["minInit"];

  doWrap = a.fullDepEntry (''
    wrapProgram "$out/bin/sbcl" --set "SBCL_HOME" "$out/lib/sbcl"
  '') ["minInit" "addInputs"];

  doFixTests = a.fullDepEntry (''
    sed -e 's/"sys"/"wheel"/' -i contrib/sb-posix/posix-tests.lisp
  '') ["minInit" "doUnpack"];

  doBuild = a.fullDepEntry (''
    sh make.sh clisp
  '') ["minInit" "doUnpack" "addInputs"];

  doInstall = a.fullDepEntry (''
    sh install.sh
  '') ["doBuild" "minInit" "addInputs"];

  name = "sbcl-" + version;
  meta = {
    description = "Lisp compiler";
  };
}
