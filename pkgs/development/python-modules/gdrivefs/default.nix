{ stdenv
, buildPythonPackage
, fetchurl
, isPy3k
, gipc
, greenlet
, httplib2
, six
, dateutil
, fusepy
, google_api_python_client
}:

buildPythonPackage rec {
  version = "0.14.9";
  pname = "gdrivefs";
  disabled = isPy3k;

  src = fetchurl {
    url = "https://github.com/dsoprea/GDriveFS/archive/${version}.tar.gz";
    sha256 = "1mc2r35nf5k8vzwdcdhi0l9rb97amqd5xb53lhydj8v8f4rndk7a";
  };

  buildInputs = [ gipc greenlet httplib2 six ];
  propagatedBuildInputs = [ dateutil fusepy google_api_python_client ];

  patchPhase = ''
    substituteInPlace gdrivefs/resources/requirements.txt \
      --replace "==" ">="
  '';

  meta = with stdenv.lib; {
    description = "Mount Google Drive as a local file system";
    longDescription = ''
      GDriveFS is a FUSE wrapper for Google Drive developed. Design goals:
      - Thread for monitoring changes via "changes" functionality of API.
      - Complete stat() implementation.
      - Seamlessly work around duplicate-file allowances in Google Drive.
      - Seamlessly manage file-type versatility in Google Drive
        (Google Doc files do not have a particular format).
      - Allow for the same file at multiple paths.
    '';
    homepage = https://github.com/dsoprea/GDriveFS;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

}
