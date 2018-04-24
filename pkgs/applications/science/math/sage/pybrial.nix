{ stdenv
, fetchFromGitHub
, buildPythonPackage
}:
# This has a cyclic dependency with sage. I don't include sage in the
# buildInputs and let python figure it out at runtime. Because of this,
# I don't include the package in the main nipxkgs tree. It wouldn't be useful
# outside of sage anyways (as you could just directly depend on sage and use
# it).
buildPythonPackage rec {
    pname = "pyBRiAl";
    version = "1.2.3";

    # included with BRiAl source
    src = fetchFromGitHub {
      owner = "BRiAl";
      repo = "BRiAl";
      rev = "${version}";
      sha256 = "0qy4cwy7qrk4zg151cmws5cglaa866z461cnj9wdnalabs7v7qbg";
    };

    sourceRoot = "source/sage-brial";

    meta = with stdenv.lib; {
      description = "python implementation of BRiAl";
      license = licenses.gpl2;
      maintainers = with maintainers; [ timokau ];
    };
}
