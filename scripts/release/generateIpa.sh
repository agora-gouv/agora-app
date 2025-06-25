#!/bin/sh

ROOT=$(git rev-parse --show-toplevel);
source "$ROOT/scripts/buildIPA.sh";

buildIPA --target=lib/main_prod.dart \
         --flavor=prod \
         --dart-define=app.flavor=Prod \
         --export-options-plist=ios/Params/ExportOptionsProd.plist;
