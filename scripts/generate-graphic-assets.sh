#!/bin/bash

# generate Parrot's graphic assets based on the defaults Microsoft provides
set -e

# env vars
IN_DIR="Assets"
OUT_DIR="ParrotAssets"

IMG_IMG="parrot_graphics/parrot-logo.png"
TXT_IMG="parrot_graphics/parrot-text.png"
FULL_IMG="parrot_graphics/parrot-wide.png"

# CATEGORIES:
#
# - LargeTile		> square - img+txt
# - SmallTile		> square - img
# - SplashScreen	> wide - img
# - Square44		> square - img
# - Square150		> square - img
# - StoreLogo		> square - img
# - WideLogo		> wide - img+txt
# It all boils down to:
# - Large/Wide
# - Small/Square/Store
# - Splash

# runtime checks
[ -z "$(which convert 2>/dev/null)" ] && (echo "This script requires ImageMagick's utility 'convert'. Please install it." ; exit 1)
[ -d $IN_DIR ] || (echo "Input directory '$IN_DIR' does not exist! Please set up variables before running" ; exit 1)
[ -d $OUT_DIR ] || mkdir -p $OUT_DIR

for asset in $(ls ./$IN_DIR) ; do

	# choose the image type to select
	case $asset in

		Large*|Wide*)
			IMG_PRESET=$FULL_IMG
			;;
		Small*|Square*|Store*)
			IMG_PRESET=$IMG_IMG
			;;
		Splash*)
			IMG_PRESET=$IMG_IMG
			;;

	esac

	# create a copy of the original
	echo "Generating $asset..."
	convert $IMG_PRESET -resize $(file $IN_DIR/$asset | awk -F "," '{print$2}' | sed 's/ //g') ./$OUT_DIR/$asset
	unset IMG_PRESET

done
echo "Done."
