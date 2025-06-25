#!/bin/sh

getBuildNumber () {
  local ROOT=$(git rev-parse --show-toplevel)
  local FILE=${1:-"$ROOT/pubspec.yaml"}
  sed -nE "s/version:[[:space:]][0-9]+\.[0-9]+\.[0-9]+\+(.+)/\1/p" $FILE
}

getVersion () {
  local ROOT=$(git rev-parse --show-toplevel)
  local FILE=${1:-"$ROOT/pubspec.yaml"}
  sed -nE "s/version:[[:space:]]([0-9]+\.[0-9]+\.[0-9]+)\+.+/\1/p" $FILE
}
