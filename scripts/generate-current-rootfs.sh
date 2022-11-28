#!/bin/bash
VERSION=$1
VERSION="5.1.1" # latest is 5.1.1

# customized version of Parrot's rootfs builder for WSL deployment

function bootstrap {
	ARCH=$1
	EDITION=parrot
	echo "Building $EDITION-$ARCH"
	rm -r $EDITION-$ARCH/ || true
#	debootstrap --arch=$ARCH --components=main,contrib,non-free --include=gnupg2,nano,base-files --exclude=parrot-core $EDITION $EDITION-$ARCH https://deb.parrot.sh/direct/parrot/
	debootstrap --arch=$ARCH --components=main,contrib,non-free --include=gnupg2,nano,base-files,sudo --exclude=parrot-core $EDITION $EDITION-$ARCH https://deb.parrot.sh/direct/parrot/
	rm -rf $EDITION-$ARCH/var/cache/apt/* $EDITION-$ARCH/var/lib/apt/lists/*
	echo "Customizing $EDITION-$ARCH"
	echo "Done $EDITION-$ARCH"
}


mkdir -p images
#for arch in amd64 i386 arm64 armhf; do
for arch in amd64; do
    bootstrap $arch
#    tar cvfp - parrot-$arch/ | xz -q -c --best --extreme - > images/Parrot-rootfs-${VERSION}_$arch.tar.xz
    tar cvfp - parrot-$arch/ | gzip -q -c --best - > images/Parrot-rootfs-${VERSION}_$arch.tar.xz
    rm -rf parrot-$arch
done
