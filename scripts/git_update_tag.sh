#!/bin/bash

VERSION=""

# get parameters
while getopts v: flag; do
  case "${flag}" in
    v) VERSION=${OPTARG} ;;
  esac
done

# read the current version from version.txt or set to v0.1.0 if not present
CURRENT_VERSION=$(cat version.txt 2>/dev/null || echo "v0.1.0")

# remove 'v' prefix
CURRENT_VERSION=${CURRENT_VERSION#v}

# replace . with space so can split into an array
CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })

# get number parts
VNUM1=${CURRENT_VERSION_PARTS[0]}
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${CURRENT_VERSION_PARTS[2]}

if [[ $VERSION == 'major' ]]; then
  VNUM1=$((VNUM1 + 1))
elif [[ $VERSION == 'minor' ]]; then
  VNUM2=$((VNUM2 + 1))
elif [[ $VERSION == 'patch' ]]; then
  VNUM3=$((VNUM3 + 1))
else
  echo "No version type (https://semver.org/) or incorrect type specified, try: -v [major, minor, patch]"
  exit 1
fi

# create new version with 'v' prefix
NEW_VERSION="v$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_VERSION"

# store the new version into version.txt
echo "$NEW_VERSION" > version.txt

echo ::set-output name=new-version::$NEW_VERSION

exit 0
