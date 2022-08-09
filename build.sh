#!/bin/sh

set -e

setup_ndk() {
	wget -nv https://dl.google.com/android/repository/android-ndk-r25-linux.zip
	unzip -qo android-ndk-r25-linux.zip
	chmod -R 777 ./android-ndk-r25
	export PATH="$(pwd)/android-ndk-r25:$PATH"
}

if ! ndk-build --version; then setup_ndk; fi

SQLITE_URL=http://www.sqlite.org/$(wget -nv https://www.sqlite.org/download.html -O- | sed -n 's;.*,\(.*/sqlite-amalgamation-.*.zip\),.*;\1;p')
SQLITE_BASENAME="$(echo "$SQLITE_URL" | sed -n 's;.*/;;p' | sed -n 's/\.zip//p')"

rm -rf build
mkdir -p build output

wget -N -nv "$SQLITE_URL"
unzip -oj "$SQLITE_BASENAME" -d build
ndk-build

mv libs/arm64-v8a/sqlite3-static output/sqlite3-arm64
mv libs/armeabi-v7a/sqlite3-static output/sqlite3-arm
