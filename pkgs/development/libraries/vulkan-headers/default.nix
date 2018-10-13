{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "vulkan-headers-${version}";
  version = "1.1.85";

  buildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    sha256 = "0cj4bd396qddh3nxvr7grnpfz89g3sbvm21cx4k3ga52sp1rslpb";
  };

  meta = with stdenv.lib; {
    description = "Vulkan Header files and API registry";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
