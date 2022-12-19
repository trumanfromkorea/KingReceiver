DIRNAME=${PWD##*/}

rm -rf build

xcodebuild archive -scheme $DIRNAME -archivePath "./build/ios.xcarchive" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme $DIRNAME -archivePath "./build/ios_sim.xcarchive" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
-framework "./build/ios.xcarchive/Products/Library/Frameworks/$DIRNAME.framework" \
-framework "./build/ios_sim.xcarchive/Products/Library/Frameworks/$DIRNAME.framework" \
-output "./build/$DIRNAME.xcframework"

echo "프레임워크 빌드 완료"
