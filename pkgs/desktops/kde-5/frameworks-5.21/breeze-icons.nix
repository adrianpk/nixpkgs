{ kdeFramework
, extra-cmake-modules
, qtsvg
}:

kdeFramework {
  name = "breeze-icons";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtsvg ];
}
