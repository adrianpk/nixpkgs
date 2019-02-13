{ docker
, fetchFromGitLab
, python
, lib }:

python.pkgs.buildPythonApplication rec {
  version = "1.1.1";
  pname = "fdroidserver";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = version;
    sha256 = "0m618rvjh8h8hnbafrxsdkw8m5r2wnkz7whqnh60jh91h3yr0kzs";
  };

  patchPhase = ''
    substituteInPlace fdroidserver/common.py --replace "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
    substituteInPlace setup.py --replace "pyasn1-modules == 0.2.1" "pyasn1-modules"
  '';

  preConfigure = ''
    ${python.interpreter} setup.py compile_catalog
  '';
  postInstall = ''
    install -m 0755 gradlew-fdroid $out/bin
  '';

  buildInputs = [ python.pkgs.Babel ];

  propagatedBuildInputs = with python.pkgs; [
    androguard
    clint
    defusedxml
    docker
    docker-py
    GitPython
    libcloud
    mwclient
    paramiko
    pillow
    pyasn1
    pyasn1-modules
    python-vagrant
    pyyaml
    qrcode
    requests
    ruamel_yaml
  ];

  meta = with lib; {
    homepage = https://f-droid.org;
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3;
    maintainers = [ lib.maintainers.pmiddend ];
  };

}
