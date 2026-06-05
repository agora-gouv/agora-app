#!/bin/sh

ROOT=$(git rev-parse --show-toplevel);
source "$ROOT/scripts/extractApkFromBundle.sh";

extractApkFromBundle "$ROOT/build/app/outputs/bundle/prodRelease/" "app-prod-release";
