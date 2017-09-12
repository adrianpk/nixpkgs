{ stdenv, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "piexif";
  version = "1.0.12";

  # pillow needed for unit tests
  buildInputs = [ pillow ];

  postPatch = ''
    # incompatibility with pillow => 4.2.0
    # has been resolved in https://github.com/hMatoba/Piexif/commit/c3a8272f5e6418f223b25f6486d8ddda201bbdf1
    # remove this in the next version
    sed -i -e 's/RGBA/RGB/' tests/s_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "15dvdr7b5xxsbsq5k6kq8h0xnzrkqzc08dzlih48a21x27i02bii";
  };

  meta = with stdenv.lib; {
    description = "Simplify Exif manipulations with Python";
    homepage = https://github.com/hMatoba/Piexif;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
