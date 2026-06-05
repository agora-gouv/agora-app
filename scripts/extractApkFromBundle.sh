#!/bin/sh

extractApkFromBundle () {
  local RELEASE_ROOT=${1:?"An output folder is required: extractApkFromBundle path/to/folder [output-file-name]."}
  local OUTPUT_FILE_NAME=${2:-"release"}

  local TARGET="$RELEASE_ROOT/$OUTPUT_FILE_NAME.apks"
  local BUNDLE="$RELEASE_ROOT/$OUTPUT_FILE_NAME.aab"

  rm "$TARGET";
  bundletool build-apks --bundle="$BUNDLE" --output="$TARGET" --mode=universal
  tar -xzvf "$TARGET" -C "$RELEASE_ROOT"
  mv "$RELEASE_ROOT/universal.apk" "$RELEASE_ROOT/$OUTPUT_FILE_NAME.apk"
}

