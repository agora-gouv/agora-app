#!/bin/sh

buildIPA () {
  local ROOT=$(git rev-parse --show-toplevel);

  source "$ROOT/scripts/extractVersion.sh";
  local VERSION=$(getVersion);
  local BUILD_NUMBER=$(getBuildNumber);

  flutter build ipa \
    --build-name="${VERSION}" \
    --build-number=${BUILD_NUMBER} \
    "$@";
}
