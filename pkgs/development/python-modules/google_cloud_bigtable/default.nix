{ stdenv
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "0.31.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0e66d7c9b37b0a7fc021f10ffaf848b10618a91060ac143ef7f615d682c97d5";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpc_google_iam_v1 google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
