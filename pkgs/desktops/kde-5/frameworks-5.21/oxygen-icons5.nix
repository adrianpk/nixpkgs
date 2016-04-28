{ kdeFramework
, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "oxygen-icons5";
  meta = {
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
}
