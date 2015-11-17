/* This function provides a generic Python package builder.  It is
   intended to work with packages that use `distutils/setuptools'
   (http://pypi.python.org/pypi/setuptools/), which represents a large
   number of Python packages nowadays.  */

{ python, setuptools, unzip, wrapPython, lib, bootstrapped-pip }:

{ name

# by default prefix `name` e.g. "python3.3-${name}"
, namePrefix ? python.libPrefix + "-"

, buildInputs ? []

# propagate build dependencies so in case we have A -> B -> C,
# C can import propagated packages by A
, propagatedBuildInputs ? []

# passed to "python setup.py build"
# https://github.com/pypa/pip/issues/881
, setupPyBuildFlags ? []

# enable tests by default
, doCheck ? true

# DEPRECATED: use propagatedBuildInputs
, pythonPath ? []

# used to disable derivation, useful for specific python versions
, disabled ? false

, meta ? {}

# Execute before shell hook
, preShellHook ? ""

# Execute after shell hook
, postShellHook ? ""

# Additional arguments to pass to the makeWrapper function, which wraps
# generated binaries.
, makeWrapperArgs ? []

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled
then throw "${name} not supported for interpreter ${python.executable}"
else

let
  setuppy = "import setuptools, tokenize;__file__='setup.py';exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\\r\\n', '\\n'), __file__, 'exec'))";
in
python.stdenv.mkDerivation (builtins.removeAttrs attrs ["disabled"] // {
  inherit doCheck;

  name = namePrefix + name;

  buildInputs = [ wrapPython bootstrapped-pip ] ++ buildInputs ++ pythonPath
    ++ (lib.optional (lib.hasSuffix "zip" attrs.src.name or "") unzip);

  # propagate python/setuptools to active setup-hook in nix-shell
  propagatedBuildInputs = propagatedBuildInputs ++ [ python setuptools ];

  pythonPath = pythonPath;

  configurePhase = attrs.configurePhase or ''
    runHook preConfigure

    # patch python interpreter to write null timestamps when compiling python files
    # this way python doesn't try to update them when we freeze timestamps in nix store
    export DETERMINISTIC_BUILD=1

    runHook postConfigure
  '';

  checkPhase = attrs.checkPhase or ''
    runHook preCheck
    ${python.interpreter} -c "${setuppy}" test
    runHook postCheck
  '';

  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    ${python.interpreter} -c "${setuppy}" bdist_wheel
    runHook postBuild
  '';

  installPhase = attrs.installPhase or ''
    runHook preInstall

    mkdir -p "$out/${python.sitePackages}"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    pushd dist
    ${bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out
    popd

    runHook postInstall
  '';

  postFixup = attrs.postFixup or ''
    wrapPythonPrograms
  '';

  shellHook = attrs.shellHook or ''
    ${preShellHook}
    if test -e setup.py; then
       tmp_path=$(mktemp -d)
       export PATH="$tmp_path/bin:$PATH"
       export PYTHONPATH="$tmp_path/${python.sitePackages}:$PYTHONPATH"
       ${python.interpreter} setup.py develop --prefix $tmp_path
    fi
    ${postShellHook}
  '';

  meta = with lib.maintainers; {
    # default to python's platforms
    platforms = python.meta.platforms;
  } // meta // {
    # add extra maintainer(s) to every package
    maintainers = (meta.maintainers or []) ++ [ chaoflow iElectric ];
  };
})
