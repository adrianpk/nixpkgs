{ stdenv, buildPythonPackage, fetchzip, pyopenssl }:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "0.6.5";
  name = "${pname}-${version}";

  # Tests aren't included in PyPI tarball.
  src = fetchzip {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/python-nbxmpp/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "0b7jw07s4mnp20gcg8raw4bhw2h1hxf75cbn4f2ynj69fbpfr38h";
  };

  propagatedBuildInputs = [ pyopenssl ];

  checkPhase = ''
    # Disable tests requiring networking
    echo "" > test/unit/test_xmpp_transports_nb2.py
    python test/runtests.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
