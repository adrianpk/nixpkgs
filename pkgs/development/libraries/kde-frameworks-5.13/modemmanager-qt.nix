{ mkDerivation, lib
, extra-cmake-modules
, modemmanager
}:

mkDerivation {
  name = "modemmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ modemmanager ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
