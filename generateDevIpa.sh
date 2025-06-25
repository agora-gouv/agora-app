#!/bin/sh

ROOT=$(git rev-parse --show-toplevel);
source "$ROOT/scripts/buildIPA.sh";

buildIPA --target=lib/main_dev.dart \
         --flavor=dev \
         --dart-define=app.flavor=Dev \
         --export-options-plist=ios/Params/ExportOptionsAdHoc.plist;
