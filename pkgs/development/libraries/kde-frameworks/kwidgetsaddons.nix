{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools
}:

mkDerivation {
  name = "kwidgetsaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
