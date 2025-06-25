#!/bin/sh

generateIPA () {
  local FLAVOR=$1;
  local PUBSPEC=${2:-"../pubspec.yaml"};

  source ./scripts/extractVersion.sh;
  local VERSION=$(getVersion $PUBSPEC);
  local BUILD_NUMBER=$(getBuildNumber $PUBSPEC);

  flutter build ipa \
    --target=lib/main_dev.dart \
    --flavor=${(L)FLAVOR} \
    --dart-define=app.flavor=${(C)FLAVOR} \
    --export-options-plist=ios/Params/ExportOptionsAdHoc.plist \
    --build-name="${VERSION}" \
    --build-number=${BUILD_NUMBER};
}
