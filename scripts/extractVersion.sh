#!/bin/sh

getBuildNumber () {
  local FILE=${1:-"../pubspec.yaml"}
  sed -nE "s/version:[[:space:]][0-9]+\.[0-9]+\.[0-9]+\+(.+)/\1/p" $FILE
}

getVersion () {
  local FILE=${1:-"../pubspec.yaml"}
  sed -nE "s/version:[[:space:]]([0-9]+\.[0-9]+\.[0-9]+)\+.+/\1/p" $FILE
}
