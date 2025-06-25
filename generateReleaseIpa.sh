#!/bin/sh

source ./scripts/extractVersion.sh
PUBSPEC="./pubspec.yaml"
VERSION=$(getVersion $PUBSPEC)
BUILD_NUMBER=$(getBuildNumber $PUBSPEC)

flutter build ipa --target=lib/main_prod.dart --flavor=prod --dart-define=app.flavor=Prod --export-options-plist=ios/Params/ExportOptionsProd.plist --build-name="${VERSION}" --build-number=${BUILD_NUMBER}
