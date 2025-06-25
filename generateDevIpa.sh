#!/bin/sh

source ./scripts/extractVersion.sh
PUBSPEC="./pubspec.yaml"
VERSION=$(getVersion $PUBSPEC)
BUILD_NUMBER=$(getBuildNumber $PUBSPEC)

flutter build ipa --target=lib/main_dev.dart --flavor=dev --dart-define=app.flavor=Dev --export-options-plist=ios/Params/ExportOptionsAdHoc.plist --build-name="${VERSION}" --build-number=${BUILD_NUMBER}
