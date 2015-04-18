#!/bin/bash
#
# Build the Csound 32-bit float libraries and update the AudioKit framework for OS X
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

if ! test -d ${AK_ROOT}; then
    echo "Destination AudioKit OSX root does not exist: $AK_ROOT"
    exit 1
fi

echo "Building Csound (float) for ${BUILD_TYPE} ..."
cp Custom-ak.cmake ../../Custom.cmake

rm -rf ios
mkdir ios
cd ios

#cmake ../../.. -G Xcode -DCMAKE_TOOLCHAIN_FILE=../iOS.cmake -DUSE_GETTEXT=0 -DUSE_DOUBLE=0 -DBUILD_STATIC_LIBRARY=1 -DBUILD_CSOUND_AC=1 -DBUILD_RELEASE=1 -DBUILD_TESTS=0 -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DUSE_CURL=0 -DBUILD_IMAGE_OPCODES=0 || exit 1
cmake ../../.. -G Xcode  -DUSE_GETTEXT=0 -DUSE_DOUBLE=0 -DBUILD_STATIC_LIBRARY=1 -DBUILD_CSOUND_AC=1 -DBUILD_RELEASE=1 -DBUILD_TESTS=0 -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DUSE_CURL=0 -DBUILD_IMAGE_OPCODES=0 -DIOS=1 || exit 1
xcodebuild -sdk iphoneos -xcconfig ../device.xcconfig -target CsoundLib-static -configuration $BUILD_TYPE || exit 1
cp $BUILD_TYPE/libCsoundLib.a ./libcsound-device.a
xcodebuild -sdk iphonesimulator -xcconfig ../simulator.xcconfig -target CsoundLib-static -configuration $BUILD_TYPE || exit 1 
lipo -create libcsound-device.a $BUILD_TYPE/libCsoundLib.a -output ../libcsound.a

# Copy new libraries and headers for Csound and its opcodes to the AudioKit framework

echo "... finished."
