{
  mkDerivation, lib,
  extra-cmake-modules,
  akonadi, kdbusaddons, kio, kitemmodels, kmime
}:

mkDerivation {
  name = "akonadi-mime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ akonadi kdbusaddons kio kitemmodels kmime ];
}
