#!/bin/bash
set -euo pipefail

APP_NAME="MDma"
VERSION="1.0"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
BUILD_DIR="/tmp/${APP_NAME}-release"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DMG_STAGING="/tmp/${APP_NAME}-dmg-staging"

echo "==> Building ${APP_NAME} (Release)..."
xcodebuild -project "${PROJECT_DIR}/${APP_NAME}.xcodeproj" \
    -scheme "$APP_NAME" \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR" \
    build -quiet

APP_PATH="${BUILD_DIR}/Build/Products/Release/${APP_NAME}.app"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: ${APP_NAME}.app not found at ${APP_PATH}"
    exit 1
fi

echo "==> Preparing DMG contents..."
rm -rf "$DMG_STAGING"
mkdir -p "$DMG_STAGING"
cp -R "$APP_PATH" "$DMG_STAGING/"
ln -s /Applications "$DMG_STAGING/Applications"

echo "==> Creating ${DMG_NAME}..."
rm -f "${PROJECT_DIR}/${DMG_NAME}"
hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$DMG_STAGING" \
    -ov \
    -format UDZO \
    "${PROJECT_DIR}/${DMG_NAME}"

rm -rf "$DMG_STAGING"
rm -rf "$BUILD_DIR"

echo "==> Done: ${PROJECT_DIR}/${DMG_NAME}"
