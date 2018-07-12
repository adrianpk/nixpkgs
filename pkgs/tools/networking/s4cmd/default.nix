{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "s4cmd";
  version = "2.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "14gfpnj4xa1sq3x3zd29drpzsygn998y32szwm069ma0w9jwjjz6";
  };

  propagatedBuildInputs = with python3Packages; [ boto3 pytz ];

  # The upstream package tries to install some bash shell completion scripts in /etc.
  # Setuptools is bugged and doesn't handle --prefix properly: https://github.com/pypa/setuptools/issues/130
  patchPhase = ''
    sed -i '/ data_files=/d' setup.py
    sed -i 's|os.chmod("/etc.*|pass|' setup.py
  '';

  # Replace upstream's s4cmd wrapper script with the built-in Nix wrapper
  postInstall = ''
    ln -fs $out/bin/s4cmd.py $out/bin/s4cmd
  '';

  # Test suite requires an S3 bucket
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bloomreach/s4cmd;
    description = "Super S3 command line tool";
    license = licenses.asl20;
    maintainers = [ maintainers.bhipple ];
  };
}
