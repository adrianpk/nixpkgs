{ stdenv, fetchFromGitHub, autoreconfHook, expat, libaio, boost }:

stdenv.mkDerivation rec {
  name = "thin-provisioning-tools-${version}";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${version}";
    sha256 = "175mk3krfdmn43cjw378s32hs62gq8fmq549rjmyc651sz6jnj0g";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ expat libaio boost ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jthornber/thin-provisioning-tools/;
    description = "A suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
