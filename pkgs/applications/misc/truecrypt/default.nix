/*
Requirements for Building TrueCrypt for Linux and Mac OS X:
-----------------------------------------------------------

- GNU Make
- GNU C++ Compiler 4.0 or compatible
- Apple XCode (Mac OS X only)
- pkg-config
- wxWidgets 2.8 library source code (available at http://www.wxwidgets.org)
- FUSE library (available at http://fuse.sourceforge.net and
  http://code.google.com/p/macfuse)


Instructions for Building TrueCrypt for Linux and Mac OS X:
-----------------------------------------------------------

1) Change the current directory to the root of the TrueCrypt source code.

2) Run the following command to configure the wxWidgets library for TrueCrypt
   and to build it:

   $ make WX_ROOT=/usr/src/wxWidgets wxbuild

   The variable WX_ROOT must point to the location of the source code of the
   wxWidgets library. Output files will be placed in the './wxrelease/'
   directory.

3) To build TrueCrypt, run the following command:

   $ make

4) If successful, the TrueCrypt executable should be located in the directory
   'Main'.

By default, a universal executable supporting both graphical and text user
interface is built. To build a console-only executable, which requires no GUI
library, use the 'NOGUI' parameter:

   $ make NOGUI=1 WX_ROOT=/usr/src/wxWidgets wxbuild
   $ make NOGUI=1
*/

{ fetchurl, stdenv, pkgconfig, fuse, wxGTK, devicemapper,
  wxGUI ? true
}:

stdenv.mkDerivation {
  name = "truecrypt-6.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.sfr-fresh.com/unix/misc/TrueCrypt_6.3_Source.tar.gz;
    sha256 = "0vgyng5zmdjdqlhai0szzapfm14njr3swamnw6yyb6pnjdncd0jq";
  };

  pkcs11h = fetchurl {
    url = ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/pkcs11.h;
    sha256 = "1563d877b6f8868b8eb8687358162bfb7f868104ed694beb35ae1c5cf1a58b9b";
  };

  pkcs11th = fetchurl {
    url = ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/pkcs11t.h;
    sha256 = "8ce68616304684f92a7e267bcc8f486441e92a5cbdfcfd97e69ac9a0b436fb7b";
  };

  pkcs11fh = fetchurl {
    url = ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/pkcs11f.h;
    sha256 = "5ae6a4f32ca737e02def3bf314c9842fb89be82bf00b6f4022a97d8d565522b8";
  };

  buildInputs = [ pkgconfig fuse devicemapper wxGTK ]; 
  makeFlags = if (wxGUI) then "" else "NOGUI=1";

  meta = {
    description = "Free Open-Source filesystem on-the-fly encryption";
    homepage = http://www.truecrypt.org/;
    license = "TrueCrypt License Version 2.6";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
