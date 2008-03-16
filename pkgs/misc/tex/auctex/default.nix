{ stdenv, fetchurl, emacs, tetex }:
 
stdenv.mkDerivation ( rec {
  pname = "auctex";
  version = "11.85";
  name = "${pname}-${version}";

  meta = {
    description = "AUCTeX is an extensible package for writing and formatting TeX files in GNU Emacs and XEmacs.";
    homepage = http://www.gnu.org/software/auctex;
  };

  src = fetchurl {
    url = "http://ftp.gnu.org/pub/gnu/${pname}/${name}.tar.gz";
    sha256 = "aebbea00431f8fd1e6be6519d9cc28e974942000737f956027da2c952a6d304e";
  };

  buildInputs = [ emacs tetex ];

  configureFlags = [
    "--with-lispdir=\${out}/emacs/site-lisp"
    "--disable-preview"
  ];
})
