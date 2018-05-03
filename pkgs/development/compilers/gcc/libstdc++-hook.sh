# The `hostOffset` describes how the host platform of the dependencies are slid
# relative to the depending package. It is brought into scope of the setup hook
# defined as the role of the dependency whose hooks is being run.
case $hostOffset in
    -1) local role='BUILD_' ;;
    0)  local role='' ;;
    1)  local role='TARGET_' ;;
    *)  echo "cc-wrapper: Error: Cannot be used with $hostOffset-offset deps" >2;
        return 1 ;;
esac

export NIX_${role}CXXSTDLIB_COMPILE+=" -isystem $(echo -n @gcc@/include/c++/*) -isystem $(echo -n @gcc@/include/c++/*)/$(@gcc@/bin/gcc -dumpmachine)"
export NIX_${role}CXXSTDLIB_LINK=" -stdlib=libstdc++"
