#!/bin/sh

ROOT=$(git rev-parse --show-toplevel);
source "$ROOT/scripts/buildIPA.sh";

buildIPA --target=lib/main_sandbox.dart
         --flavor=sandbox
         --dart-define=app.flavor=Sandbox
         --export-options-plist=ios/Params/ExportOptionsAdHoc.plist;
