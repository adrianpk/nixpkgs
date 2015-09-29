{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, ki18n
, kio
, kjobwidgets
, kparts
, kservice
, kwallet
, qtwebkit
}:

kdeFramework {
  name = "kdewebkit";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kcoreaddons ki18n kio kjobwidgets kparts kservice kwallet ];
  propagatedBuildInputs = [ qtwebkit ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
