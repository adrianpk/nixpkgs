/* Automatically generated by `update-gcc.sh', do not edit.
   For GCC 4.6.4.  */
{ fetchurl, optional, version, langC, langCC, langFortran, langJava, langAda,
  langGo }:

assert version == "4.6.4";
optional /* langC */ true (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
  sha256 = "48b566f1288f099dff8fba868499a320f83586245ec69b8c82a9042566a5bf62";
}) ++
optional langCC (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
  sha256 = "4eaa347f9cd3ab7d5e14efbb9c5c03009229cd714b558fc55fa56e8996b74d42";
}) ++
optional langFortran (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
  sha256 = "4f402e0d27995a02354570f0a63047f27463c72c62f1ba3c08ef5a7c6c9c3d1c";
}) ++
optional langJava (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
  sha256 = "4441d0c3cc04f2162f981c6b4bf29cdd9f6c16d294ce24c6bc4a05d8277abf28";
}) ++
optional langAda (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-ada-${version}.tar.bz2";
  sha256 = "2a09bbf942b2557839722d4807e67559123037356f5cb1a3b12f44539968d0ad";
}) ++
[]
