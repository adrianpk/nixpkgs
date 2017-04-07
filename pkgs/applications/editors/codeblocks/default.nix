{ stdenv, fetchurl, autoreconfHook, libtool, pkgconfig, file, zip, wxGTK, gtk2
, contribPlugins ? false, hunspell, gamin, boost
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "${pname}-${stdenv.lib.optionalString contribPlugins "full-"}${version}";
  version = "16.01";
  pname = "codeblocks";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks_${version}.tar.gz";
    sha256 = "00sskm91r20ywydwqwx6v7z3nwn9lyh5297c5wp3razldlh9vyrh";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool file zip ];
  buildInputs = [ wxGTK gtk2 ]
    ++ optionals contribPlugins [ hunspell gamin boost ];
  enableParallelBuilding = true;
  patches = [ ./writable-projects.patch ];
  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";
  postConfigure = optionalString stdenv.isLinux "substituteInPlace libtool --replace ldconfig ${stdenv.cc.libc.bin}/bin/ldconfig";
  configureFlags = [ "--enable-pch=no" ]
    ++ optional contribPlugins "--with-contrib-plugins";

  # Fix boost 1.59 compat
  # Try removing in the next version
  #CPPFLAGS = "-DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED";

  meta = {
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
    description = "The open source, cross platform, free C, C++ and Fortran IDE";
    longDescription =
      ''
        Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
        It is designed to be very extensible and fully configurable.
        Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
      '';
    homepage = http://www.codeblocks.org;
    license = licenses.gpl3;
  };
}
