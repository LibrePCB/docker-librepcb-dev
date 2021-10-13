#!/usr/bin/env bash

# set shell settings (see https://sipb.mit.edu/doc/safe-shell/)
set -eu -o pipefail

# Usage:
#
#   ./build.sh <name> <version> [--push] [--tag]
#
# Example:
#
#   ./build.sh ubuntu-18.04 2 --push

NAME="$1"
VERSION="$2"
DO_PUSH=0
DO_TAG=0
for i in "$@"
do
case $i in
  --push)
  DO_PUSH=1
  shift
  ;;
  --tag)
  DO_TAG=1
  shift
  ;;
esac
done

echo "Build image $NAME-$VERSION..."
docker build --pull -t librepcb/librepcb-dev:$NAME-$VERSION $NAME

if [ "$DO_PUSH" == 1 ]
then
  # Fail if the corresponding Git tag exists, since this means that the
  # image was already released and we must not overwrite released images.
  if git rev-parse "$NAME-$VERSION" >/dev/null 2>&1
  then
    echo "ERROR: This image is already released (Git tag exists)!"
    exit 1
  fi

  echo "Push image $NAME-$VERSION..."
  docker push librepcb/librepcb-dev:$NAME-$VERSION
fi

if [ "$DO_TAG" == 1 ]
then
  # Fail if a branch other than master is checked out since we should create
  # releases only from the master branch.
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$BRANCH" != "master" ]]
  then
    echo "ERROR: Releases must be created on master branch, not $BRANCH!"
    exit 1
  fi

  echo "Create Git tag $NAME-$VERSION..."
  git tag "$NAME-$VERSION"
  git push origin "$NAME-$VERSION"
fi
