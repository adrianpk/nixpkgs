{ kdeFramework, lib
, extra-cmake-modules
, hunspell, qtbase, qttools
}:

kdeFramework {
  name = "sonnet";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ hunspell qtbase ];
}
