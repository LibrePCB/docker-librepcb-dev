#!/usr/bin/env bash

# set shell settings (see https://sipb.mit.edu/doc/safe-shell/)
set -eu -o pipefail

# Usage:
#
#   ./build.sh <tag> <version> [--push]
#
# Example:
#
#   ./build.sh ubuntu-18.04 2 --push

TAG="$1"
VERSION="$2"
FLAG="${3-}"

docker build -t librepcb/librepcb-dev:$TAG-$VERSION $TAG

if [ "$FLAG" = "--push" ]
then
  docker push librepcb/librepcb-dev:$TAG-$VERSION
fi
