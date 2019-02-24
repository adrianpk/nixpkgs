{ buildPythonPackage, fetchFromGitHub, lib, isPyPy, isPy3k, pythonOlder
, pycrypto, ecdsa # TODO
, enum34, mock
, withOptionalDeps ? true, tcpdump, ipython
, withCryptography ? true, cryptography
, withVoipSupport ? true, sox
, withPlottingSupport ? true, matplotlib
, withGraphicsSupport ? false, pyx, texlive, graphviz, imagemagick
, withManufDb ? false, wireshark
# 2D/3D graphics and graphs TODO: VPython
# TODO: nmap, numpy
}:

buildPythonPackage rec {
  pname = "scapy";
  version = "2.4.2";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "secdev";
    repo = "scapy";
    rev = "v${version}";
    sha256 = "03xzjklvc6y4d87k0rqpx5h112ld5nvgfldrbd8c4mx6f9mmd11n";
  };

  # TODO: Temporary workaround
  patches = [ ./fix-version.patch ];

  postPatch = ''
    sed -i "s/NIXPKGS_SCAPY_VERSION/${version}/" \
      setup.py scapy/__init__.py
  '' + lib.optionalString withManufDb ''
    substituteInPlace scapy/data.py --replace "/opt/wireshark" "${wireshark}"
  '';

  propagatedBuildInputs = [ pycrypto ecdsa ]
    ++ lib.optional withOptionalDeps [ tcpdump ipython ]
    ++ lib.optional withCryptography [ cryptography ]
    ++ lib.optional withVoipSupport [ sox ]
    ++ lib.optional withPlottingSupport [ matplotlib ]
    ++ lib.optional withGraphicsSupport [ pyx texlive.combined.scheme-minimal graphviz imagemagick ]
    ++ lib.optional (isPy3k && pythonOlder "3.4") [ enum34 ]
    ++ lib.optional doCheck [ mock ];

  # Tests fail with Python 3.6 (seems to be an upstream bug, I'll investigate)
  doCheck = if isPy3k then false else true;

  meta = with lib; {
    description = "Powerful interactive network packet manipulation program";
    homepage = https://scapy.net/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos bjornfor ];
  };
}
