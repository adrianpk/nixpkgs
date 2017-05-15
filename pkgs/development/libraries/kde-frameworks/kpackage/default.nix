{
  mkDerivation, fetchurl, lib, copyPathsToStore,
  extra-cmake-modules, kdoctools,
  karchive, kconfig, kcoreaddons, ki18n
}:

mkDerivation {
  name = "kpackage";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ karchive kconfig kcoreaddons ki18n ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
