#!/bin/bash
set -e

rm -rf ../Pods

PLIST_PATH="Secrets.plist"

if [ -z "${INFURA_KEY}" ]; then
    echo "Error: The INFURA_KEY environment variable is not set or empty."
    exit 1
fi

/usr/libexec/PlistBuddy -c "Set :InfuraKey ${INFURA_KEY}" "${PLIST_PATH}"

echo "INFURA_KEY has been written to ${PLIST_PATH}"

brew install cocoapods
pod install

exit 0
