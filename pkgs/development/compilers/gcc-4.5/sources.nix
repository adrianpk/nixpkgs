/* Automatically generated by `update-gcc.sh', do not edit.
   For GCC 4.5.1.  */
{ fetchurl, optional, version, langC, langCC, langFortran, langJava, langAda }:

assert version == "4.5.1";
optional /* langC */ true (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
  sha256 = "0sjjw3qfcpdk0fs5d2rhl0xqcaclg86ifbq45dbk9ca072l3fyxm";
}) ++
optional langCC (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
  sha256 = "0j6ffb96b3r75hrjshg52llv21ax7r8jdx44hhj0maiisnl9wd55";
}) ++
optional langFortran (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
  sha256 = "0xgwjc3h5fc5c100bnw24c35255il33lj5qbgpxf0zl8di2q13aw";
}) ++
optional langJava (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
  sha256 = "0mh37q4ibg05h1hdh39pkj1hycvdg6i79m4698knw7pppm14ax8q";
}) ++
optional langAda (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-ada-${version}.tar.bz2";
  sha256 = "11chdbl7h046lnl83k79vj7dvgxz6kq7cnmwx94z644vaiflg153";
}) ++
[]
