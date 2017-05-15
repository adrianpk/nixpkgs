{
  mkDerivation, lib,
  extra-cmake-modules, qttools,
  kcoreaddons, kwidgetsaddons, qtx11extras
}:

mkDerivation {
  name = "kjobwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ kcoreaddons kwidgetsaddons qtx11extras ];
}
