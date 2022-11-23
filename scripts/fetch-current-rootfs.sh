#!/bin/bash

# this is only for amd64 now, will configure for other architectures once
# the amd64 build is stable
set -e

# temporarily hard-coded links to latest rootfs
URL="https://download.parrot.sh/parrot/iso"
VERSION="5.1.1"
ROOTFS="Parrot-rootfs-5.1.1_amd64.tar.xz"
CHECKSUMS="signed-hashes.txt"

# clean up on exit
cleanup () {
	echo "Cleaning up..."
	rm -rf ./$TMP_DIR
	exit 1
}; trap cleanup SIGINT; trap cleanup SIGTERM

# do it
TMP_DIR=".tmp"
mkdir -p $TMP_DIR
echo "Downloading..."
wget -c $URL/$VERSION/$ROOTFS -P ./$TMP_DIR
echo "Checking checksums..."
curl -sSL $URL/$VERSION/$CHECKSUMS | awk '/sha256/,/sha384/' | grep $ROOTFS | sed -e "s|Parrot|${TMP_DIR}/Parrot|g" | sha256sum -c || (echo "Checksums don't match!" ; cleanup)
mv ./$TMP_DIR/$ROOTFS ./$TMP_DIR/install.tar.xz
echo "Unpacking..."
tar xJf ./$TMP_DIR/install.tar.xz -C ./$TMP_DIR/
echo "Repacking..."
tar czf install.tar.gz -C ./$TMP_DIR/parrot-amd64 .
cleanup
