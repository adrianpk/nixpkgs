{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  postFixup = ''
    moveToOutput "bin/qdbus" "$out"
    moveToOutput "bin/qtpaths" "$out"
  '';
}
