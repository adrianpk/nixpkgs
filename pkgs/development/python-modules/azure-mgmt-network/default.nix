{ pkgs
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, python
}:

buildPythonPackage rec {
  version = "2.4.0";
  pname = "azure-mgmt-network";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "19h8fjw5ficbqvz1kzhgf3aqs729hs3haayn2qrg2ny53q9irh9p";
  };

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  propagatedBuildInputs = [ azure-mgmt-common ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
