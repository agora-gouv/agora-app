#!/bin/sh

source ./scripts/extractVersion.sh
PUBSPEC="./pubspec.yaml"
VERSION=$(getVersion $PUBSPEC)
BUILD_NUMBER=$(getBuildNumber $PUBSPEC)

flutter build ipa --target=lib/main_sandbox.dart --flavor=sandbox --dart-define=app.flavor=Sandbox --export-options-plist=ios/Params/ExportOptionsAdHoc.plist --build-name="${VERSION}" --build-number=${BUILD_NUMBER}
