{ stdenv, fetchurl, libxml2, findXMLCatalogs, python2
, cryptoSupport ? false
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
}:

assert pythonSupport -> python2 != null;
assert pythonSupport -> libxml2.pythonSupport;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.33";
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1j1q1swnsy8jgi9x7mclvkrqhfgn09886gdlr9wzk7a08i8n0dlf";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ] ++ stdenv.lib.optional pythonSupport "py";

  buildInputs = [ libxml2.dev ] ++ stdenv.lib.optionals pythonSupport [ libxml2.py python2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--with-libxml-prefix=${libxml2.dev}"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ] ++ optional pythonSupport "--with-python=${python2}"
    ++ optional (!cryptoSupport) "--without-crypto";

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput lib/python2.7 "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = with stdenv.lib; {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.eelco ];
  };
}
