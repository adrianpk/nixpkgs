/* Automatically generated by `update-gcc.sh', do not edit.
   For GCC 4.4.2.  */
{ fetchurl, optional, version, langC, langCC, langFortran, langJava }:

assert version == "4.4.2";
optional /* langC */ true (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
  sha256 = "03cgv3b9bqhap4bks5wfg7nyj64l5c3qyn1igpqc6gk60bxm9wym";
}) ++
optional langCC (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
  sha256 = "0al23gnx4v50j1y6xb23by34m2qhavm2xxn3f1v8kis7ajlbm1j1";
}) ++
optional langFortran (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
  sha256 = "0zk3j5r1cc5ahm0njxba1xfvv2h39d17aqakgg354pig4hpjkidc";
}) ++
optional langJava (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
  sha256 = "0ydk0qyhi1fdyz2xvj6m6l7cav4wg3962a1jxpf2j3nppm0p1dvp";
}) ++
[]
