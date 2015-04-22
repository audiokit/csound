#!/bin/bash
#
# Build the Csound 32-bit float libraries and update the AudioKit framework for iOS 
#
# (c) 2015 Stephane Peter
#

#
# Note: libsndfile needs to be installed on the system for this compilation to succeed.
# Easy way using Fink: fink install libsndfile1-dev
# Then copy the universal libraries already contained from the AudioKit CsoundFile.framework/lib/lib*.dylib to /sw/lib/
# This should allow the compilation to finish successfully.
#


# Default: AudioKit in the same parent directory as csound
AK_ROOT=${AK_ROOT:-$PWD/../../../AudioKit/AudioKit/Platforms/iOS}
BUILD_TYPE=${BUILD_TYPE:-Release}

# Path to the audiokit/libsndfile library with built libraries
SNDFILE=$HOME/src/ak/libsndfile

# Use xcpretty to beautify xcodebuild output if it is available
if which xcpretty >/dev/null 2>&1; then
   XCPRETTY=xcpretty
else
   XCPRETTY=cat
fi

if ! test -d ${AK_ROOT}; then
    echo "Destination AudioKit iOS root does not exist: $AK_ROOT"
    exit 1
fi


rm -rf ios
mkdir ios
cd ios

FLAGS="-DUSE_GETTEXT=0 -DUSE_DOUBLE=0 -DUSE_OPEN_MP=0 \
	-DBUILD_STATIC_LIBRARY=0 -DBUILD_CSOUND_AC=1 -DBUILD_RELEASE=1 -DBUILD_TESTS=0 \
	-DBUILD_CSOUND_AC_PYTHON_INTERFACE=0 -DBUILD_CSOUND_AC_LUA_INTERFACE=0 \
	-DCMAKE_BUILD_TYPE=$BUILD_TYPE -DUSE_CURL=0 -DBUILD_IMAGE_OPCODES=0 -DIOS=1 -DSNDFILE_DIR=$SNDFILE"

echo "Building Csound (float) for ${BUILD_TYPE} ..."
echo "Using flags: $FLAGS"

cmake ../../.. -G Xcode $FLAGS || exit 1
(xcodebuild -sdk iphoneos -xcconfig ../device.xcconfig -target CsoundLib -configuration $BUILD_TYPE | $XCPRETTY ) || exit 1
cp $BUILD_TYPE/CsoundLib.framework/CsoundLib CsoundLib-dev.dylib
(xcodebuild -sdk iphonesimulator -xcconfig ../simulator.xcconfig -target CsoundLib -configuration $BUILD_TYPE | $XCPRETTY ) || exit 1
cp $BUILD_TYPE/CsoundLib.framework/CsoundLib CsoundLib-sim.dylib

lipo -create CsoundLib-dev.dylib CsoundLib-sim.dylib -output $BUILD_TYPE/CsoundLib.framework/CsoundLib || exit 1
install_name_tool -change `otool -LX CsoundLib |grep libsndfile.1|awk '{print $1}'` @rpath/CsoundLib.framework/libs/libsndfile.1.dylib $BUILD_TYPE/CsoundLib.framework/CsoundLib || exit 1

# Copy new libraries for Csound to the AudioKit framework for iOS
cp $BUILD_TYPE/CsoundLib.framework/CsoundLib $AK_ROOT/CsoundLib.framework/

echo "... finished."
