#!/bin/sh

ROOT=$(git rev-parse --show-toplevel);

("$ROOT/scripts/dev/generateBundle.sh");

source "$ROOT/scripts/extractApkFromBundle.sh";
RELEASE_ROOT="$ROOT/build/app/outputs/bundle/devRelease/";
RELEASE_FILE_NAME="app-dev-release"
extractApkFromBundle "$RELEASE_ROOT" "$RELEASE_FILE_NAME";

APP_ID="1:128862173768:android:e96bec772348b56fb3f67d"
CURRENT_DATE=$(LANG=fr_FR date "+%d %B %Y")
firebase appdistribution:distribute "$RELEASE_ROOT/$RELEASE_FILE_NAME.apk" --app "$APP_ID" --release-notes "$CURRENT_DATE"
