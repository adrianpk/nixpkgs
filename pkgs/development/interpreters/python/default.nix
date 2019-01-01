{ pkgs, lib }:

with pkgs;

(let

  # Common passthru for all Python interpreters.
  passthruFun =
    { implementation
    , libPrefix
    , executable
    , sourceVersion
    , pythonVersion
    , packageOverrides
    , sitePackages
    , pythonForBuild
    , self
    }: let
      pythonPackages = callPackage ../../../top-level/python-packages.nix {
        python = self;
        overrides = packageOverrides;
      };
    in rec {
        sitePackages = "lib/${libPrefix}/site-packages";
        isPy27 = pythonVersion == "2.7";
        isPy33 = pythonVersion == "3.3"; # TODO: remove
        isPy34 = pythonVersion == "3.4"; # TODO: remove
        isPy35 = pythonVersion == "3.5";
        isPy36 = pythonVersion == "3.6";
        isPy37 = pythonVersion == "3.7";
        isPy3k = lib.strings.substring 0 1 pythonVersion == "3";
        isPyPy = interpreter == "pypy";

        buildEnv = callPackage ./wrapper.nix { python = self; inherit (pythonPackages) requiredPythonModules; };
        withPackages = import ./with-packages.nix { inherit buildEnv pythonPackages;};
        pkgs = pythonPackages;
        interpreter = "${self}/bin/${executable}";
        inherit executable implementation libPrefix pythonVersion;
        inherit sourceVersion;
        pythonAtLeast = lib.versionAtLeast pythonVersion;
        pythonOlder = lib.versionOlder pythonVersion;
        inherit pythonForBuild;

        majorVersion = pythonVersion; # Backwards compatibility. Should be dropped.
  };

in {

  python27 = callPackage ./cpython/2.7 {
    self = python27;
    sourceVersion = {
      major = "2";
      minor = "7";
      patch = "15";
      suffix = "";
    };
    sha256 = "0x2mvz9dp11wj7p5ccvmk9s0hzjk2fa1m462p395l4r6bfnb3n92";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python35 = callPackage ./cpython {
    self = python35;
    sourceVersion = {
      major = "3";
      minor = "5";
      patch = "6";
      suffix = "";
    };
    sha256 = "0pqmf51zy2lzhbaj4yya2py2qr653j9152d0rg3p7wi1yl2dwp7m";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python36 = callPackage ./cpython {
    self = python36;
    sourceVersion = {
      major = "3";
      minor = "6";
      patch = "8";
      suffix = "";
    };
    sha256 = "14qi6n5gpcjnwy165wi9hkfcmbadc95ny6bxxldknxwmx50n4i1m";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "2";
      suffix = "";
    };
    sha256 = "1fzi9d2gibh0wzwidyckzbywsxcsbckgsl05ryxlifxia77fhgyq";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  pypy27 = callPackage ./pypy {
    self = pypy27;
    sourceVersion = {
      major = "6";
      minor = "0";
      patch = "0";
    };
    sha256 = "1qjwpc8n68sxxlfg36s5vn1h2gdfvvd6lxvr4lzbvfwhzrgqahsw";
    pythonVersion = "2.7";
    db = db.override { dbmSupport = true; };
    python = python27;
    inherit passthruFun;
  };

  pypy3 = callPackage ./pypy {
    self = pypy3;
    sourceVersion = {
      major = "6";
      minor = "0";
      patch = "0";
    };
    sha256 = "0lwq8nn0r5yj01bwmkk5p7xvvrp4s550l8184mkmn74d3gphrlwg";
    pythonVersion = "3.5";
    db = db.override { dbmSupport = true; };
    python = python27;
    inherit passthruFun;
  };

})