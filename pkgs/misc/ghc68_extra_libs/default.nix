# contains libraries and maybe applications in the future. That's why I'm putting it into misc. Feel free to move it somewhere else
args : ghc: with args;
rec {

    #   name (using lowercase letters everywhere because using installing packages having different capitalization is discouraged) - this way there is not that much to remember?

    cabal_darcs_name = "cabal-darcs";

    # introducing p here to speed things up.
    # It merges derivations (defined below) and additional inputs. I hope that using as few nix functions as possible results in greates speed?
    # unfortunately with x; won't work because it forces nix to evaluate all attributes of x which would lead to infinite recursion
    pkgs = let x = ghc.core_libs // derivations;
               inherit (bleedingEdgeRepos) sourceByName;
           in {
        # ghc extra packages 
        mtl     = { name="mtl-1.1.0.0";     srcDir="libraries/mtl";    p_deps=[ x.base ]; src = ghc.extra_src; };
        parsec  = { name="parsec-2.1.0.0";  srcDir="libraries/parsec"; p_deps=[ x.base ];       src = ghc.extra_src; };
        network = { name="network-2.1.0.0"; srcDir="libraries/network"; p_deps=[ x.base x.parsec x.haskell98 ];       src = ghc.extra_src; };
        regex_base = { name="regex-base-0.72.0.1"; srcDir="libraries/regex-base"; p_deps=[ x.base x.array x.bytestring x.haskell98 ]; src = ghc.extra_src; };
        regex_posix = { name="regex-posix-0.72.0.2"; srcDir="libraries/regex-posix"; p_deps=[ x.regex_base x.haskell98 ]; src = ghc.extra_src; };
        regex_compat = { name="regex-compat-0.71.0.1"; srcDir="libraries/regex-compat"; p_deps=[ x.base x.regex_posix x.regex_base x.haskell98 ]; src = ghc.extra_src; };
        stm = { name="stm-2.1.1.0"; srcDir="libraries/stm"; p_deps=[ x.base x.array ]; src = ghc.extra_src; };
        hunit = { name="HUnit-1.2.0.0"; srcDir="libraries/HUnit"; p_deps=[ x.base ]; src = ghc.extra_src; };
        quickcheck = { name="QuickCheck-1.1.0.0"; srcDir="libraries/QuickCheck"; p_deps=[x.base x.random]; src = ghc.extra_src; };


        # other pacakges  (hackage etc)
        binary = rec { name = "binary-0.4.1"; p_deps = [ x.base x.bytestring x.containers x.array ];
                         src = fetchurl { url = "http://hackage.haskell.org/packages/archive/binary/0.4.1/binary-0.4.1.tar.gz";
                                      sha256 = "0jg5i1k5fz0xp1piaaf5bzhagqvfl3i73hlpdmgs4gc40r1q4x5v"; };
               };
        # using different name to not clash with postgresql
        postgresql_bindings = rec { name = "PostgreSQL-0.2"; p_deps = [x.base x.mtl postgresql x.haskell98];
                        src = fetchurl { url = "http://hackage.haskell.org/packages/archive/PostgreSQL/0.2/PostgreSQL-0.2.tar.gz";
                                     sha256 = "0p5q3yc8ymgzzlc600h4mb9w86ncrgjdbpqfi49b2jqvkcx5bwrr"; };
                        pass = {
                           inherit postgresql;
                           patchPhase = "echo 'extensions: MultiParamTypeClasses ForeignFunctionInterface EmptyDataDecls GeneralizedNewtypeDeriving FlexibleInstances UndecidableInstances' >> PostgreSQL.cabal
                                         echo \"extra-lib-dirs: \$postgresql/lib\" >> PostgreSQL.cabal
                                         echo \"extra-libraries: pq\" >> PostgreSQL.cabal
                                        ";

                        };
              };
        #wash = rec { name = "WashNGo-2.12"; p_deps = [x.base x.mtl x.haskell98 ];
        #                src = fetchurl { url = "http://www.informatik.uni-freiburg.de/~thiemann/WASH/WashNGo-2.12.tgz";
        #                             sha256 = "1dyc2062jpl3xdlm0n7xkz620h060g2i5ghnb32cn95brcj9fgrz"; };
        #           patches = ../misc/WASHNGo_Patch_ghc682;
        #      };

        #hsql = rec { name = "hsql-1.7"; p_deps = [x.base x.mtl x.haskell98  x.old_time ];
        #               src = fetchurl { url = "http://hackage.haskell.org/packages/archive/hsql/1.7/hsql-1.7.tar.gz";
        #                            sha256 = "0j2lkvg5c0x5gf2sy7zmmgrda0c3l73i9d6hyka2f15d5n1rfjc9"; };
        #             patchPhase = "echo \"extra-lib-dirs: \$postgresql/lib\" >> *.cabal
        #                           echo 'build-depends: old-locale, old-time' >> *.cabal";
        #     };


        # 1.13 is stable. There are more recent non stable versions
        haxml = rec { name = "HaXml-1.13.3"; p_deps = [ x.base x.rts x.directory x.process x.pretty x.containers x.filepath x.haskell98 ];
                     src = fetchurl { url = "http://www.haskell.org/HaXml/${name}.tar.gz";
                                      sha256 = "08d9wy0rg9m66dd10x0zvkl74l25vxdakz7xp3j88s2gd31jp1v0"; };
               };
        xhtml = rec { name = "xhtml-3000.0.2.2"; p_deps = [ x.base ];
                     src = fetchurl { url = "http://hackage.haskell.org/packages/archive/xhtml/3000.0.2.2/xhtml-3000.0.2.2.tar.gz";
                                      sha256 = "112mbq26ksh7r22y09h0xvm347kba3p4ns12vj5498fqqj333878"; };
               };
        html = rec { name = "html-1.0.1.1"; p_deps = [ x.base ];
                     src = fetchurl { url = "http://hackage.haskell.org/packages/archive/html/1.0.1.1/html-1.0.1.1.tar.gz";
                                      sha256 = "10fayfm18p83zlkr9ikxlqgnzxg1ckdqaqvz6wp1xj95fy3p6yl1"; };
               };
        crypto = rec { name = "crypto-4.1.0"; p_deps = [ x.base x.array x.pretty x.quickcheck x.random x.hunit ];
                     src = fetchurl { url = "http://hackage.haskell.org/packages/archive/Crypto/4.1.0/Crypto-4.1.0.tar.gz";
                                      sha256 = "13rbpbn6p1da6qa9m6f7dmkzdkmpnx6jiyyndzaz99nzqlrwi109"; };
               };
        hslogger = rec { name = "hslogger-1.0.4"; p_deps = [ x.containers x.directory x.mtl x.network x.process];
                     src = fetchurl { url = "http://hackage.haskell.org/packages/archive/hslogger/1.0.4/hslogger-1.0.4.tar.gz";
                                      sha256 = "0kmz8xs1q41rg2xwk22fadyhxdg5mizhw0r4d74y43akkjwj96ar"; };
               };
        parsep = { name = "parsep-0.1"; p_deps = [ x.base x.mtl x.bytestring ];
                       src = fetchurl { url = "http://twan.home.fmf.nl/parsep/parsep-0.1.tar.gz";
                                      sha256 = "1y5pbs5mzaa21127cixsamahlbvmqzyhzpwh6x0nznsgmg2dpc9q"; };
                       pass = { patchPhase = "pwd; sed -i 's/fps/bytestring/' *.cabal"; };
               };
        time = { name = "time-1.1.2.0"; p_deps = [ x.base x.old_locale ];
                       src = fetchurl { url = "http://hackage.haskell.org/packages/archive/time/1.1.2.0/time-1.1.2.0.tar.gz";
                                      sha256 = "0zm4qqczwbqzy2pk7wz5p1virgylwyzd9zxp0406s5zvp35gvl89"; };
                };


      # HAPPS - Libraries
        http_darcs = { name="http-darcs"; p_deps = [x.network x.parsec];
                src = sourceByName "http";
                 #src = fetchdarcs { url = "http://darcs.haskell.org/http/"; md5 = "4475f858cf94f4551b77963d08d7257c"; };
               };
        syb_with_class_darcs = { name="syb-with-class-darcs"; p_deps = [x.template_haskell x.bytestring ];
                 src =
                  # fetchdarcs { url = "http://happs.org/HAppS/syb-with-class"; md5 = "b42336907f7bfef8bea73bc36282d6ac"; };
                   sourceByName "syb_with_class"; # { url = "http://happs.org/HAppS/syb-with-class"; md5 = "b42336907f7bfef8bea73bc36282d6ac"; };
               };

      happs_data_darcs = { name="HAppS-Data-darcs"; p_deps=[ x.base x.mtl x.template_haskell x.syb_with_class_darcs x.haxml x.happs_util_darcs x.regex_compat x.bytestring x.pretty x.binary ];
                  src = sourceByName "happs_data"; # fetchdarcs { url = "http://happs.org/repos/HAppS-Data"; md5 = "10c505dd687e9dc999cb187090af9ba7"; };
                  };
      happs_util_darcs = { name="HAppS-Util-darcs"; p_deps=[ x.base x.mtl x.hslogger x.template_haskell x.array x.bytestring x.old_time x.process x.directory ];
                  src = sourceByName "happs_util"; # fetchdarcs { url = "http://happs.org/repos/HAppS-Util"; md5 = "693cb79017e522031c307ee5e59fc250"; };
                  };
    
      happs_state_darcs = { name="HAppS-State-darcs"; p_deps=[ x.base x.haxml
                    x.mtl x.network x.stm x.template_haskell x.hslogger
                      x.happs_util_darcs x.happs_data_darcs x.bytestring x.containers
                      x.random x.old_time x.old_locale x.unix x.directory x.binary ];
                    src = sourceByName "happs_state";
                    #src = fetchdarcs { url = "http://happs.org/repos/HAppS-State"; 
                    #                   md5 = "956e5c293b60f4a98148fedc5fa38acc"; 
                    #                 };
                  };
      # there is no .cabal yet 
      #happs_smtp_darcs = { name="HAppS-smtp-darcs"; p_deps=[];
                  #src = fetchdarcs { url = "http://happs.org/repos/HAppS-smtp"; md5 = "5316917e271ea1ed8ad261080bcb47db"; };
                  #};

      happs_ixset_darcs = { name="HAppS-IxSet-darcs"; p_deps=[ x.base x.mtl
                        x.hslogger x.happs_util_darcs x.happs_state_darcs x.happs_data_darcs
                        x.template_haskell x.syb_with_class_darcs x.containers ];
                  src = sourceByName "happs_ixset";
                  #src = fetchdarcs { url = "http://happs.org/repos/HAppS-IxSet"; 
                                     #md5 = "fa6b24517f09aa16e972f087430967fd"; 
                                     #tag = "0.9.2";
                                      # no tag
                                     #md5 = "fa6b24517f09aa16e972f087430967fd"; 
                                   #};
                  };
      happs_server_darcs = { name="HAppS-Server-darcs"; p_deps=[x.haxml x.parsec x.mtl
              x.network x.regex_compat x.hslogger x.happs_data_darcs
                x.happs_util_darcs x.happs_state_darcs x.happs_ixset_darcs x.http_darcs
                x.template_haskell x.xhtml x.html x.bytestring x.random
                x.containers x.old_time x.old_locale x.directory x.unix];
                  #src = fetchdarcs { url = "http://happs.org/repos/HAppS-HTTP"; md5 = "e1bb17eb30a39d30b8c34dffbf80edc2"; };
                  src = sourceByName "happs_server";
                  };
      # we need recent version of cabal (because only this supports --pkg-config properly) Thu Feb  7 14:54:07 CET 2008
      # cabal_darcs is added to propagatedBuildInputs automatically below
      cabal_darcs = 
      { name=cabal_darcs_name; p_deps = with ghc.core_libs; [base rts directory process pretty containers filepath];
                src = sourceByName "cabal";
        #fetchdarcs { url = "http://darcs.haskell.org/cabal"; md5 = "8b0bc3c7f2676ce642f98b1568794cd6"; };
      };
    };
    toDerivation = attrs : with attrs;
    # result is { mtl = <deriv>;
      addHasktagsTaggingInfo (ghcCabalDerivation {
          inherit (attrs) name src;
          propagatedBuildInputs = p_deps ++ (lib.optional (attrs.name != cabal_darcs_name) derivations.cabal_darcs );
          srcDir = if attrs ? srcDir then attrs.srcDir else ".";
          patches = if attrs ? patches then attrs.patches else [];
          # add cabal, take deps either from this list or from ghc.core_libs 
          pass = if attrs ? pass then attrs.pass else {};
      });
    derivations = with lib; builtins.listToAttrs (lib.concatLists ( lib.mapRecordFlatten 
              ( n : attrs : let d = (toDerivation attrs); in [ (nv n d) (nv attrs.name d) ] ) pkgs ) );
  }.derivations
