#!/bin/bash

# This script builds the ROP address #define headers included via the gcc -include option in the Makefile.
# The tool from here is required: https://github.com/yellows8/ropgadget_patternfinder
# Usage: generate_smashbrosrop_addrs.sh {path}
# {path} must contain <region> directory/directories, which contain the following for each title-version: <v{displayed eshop update version}>/*exefs/code.bin
# {path} shouldn't have any trailing directory slash.

mkdir -p smashbrosrop

if [ ! -d "$1" ]; then
	echo "The \"$1\" directory doesn't exist."
	exit 1
fi

for regiondir in $1/*
do
	region=$(basename "$regiondir")
	mkdir -p smashbrosrop/$region
	for dir in $regiondir/*
	do
		version=$(basename "$dir")
		version=${version:1}
		echo "$region $version"
		ropgadget_patternfinder $dir/*exefs/code.bin --script=smashbros_ropgadget_script --baseaddr=0x100000 --patterntype=sha256 > "smashbrosrop/$region/$version"

		if [[ $? -ne 0 ]]; then
			echo "ropgadget_patternfinder returned an error, output from it(which will be deleted after this):"
			cat "smashbrosrop/$region/$version"
			rm "smashbrosrop/$region/$version"
		fi
	done
done

cp -R smashbrosrop/USA/* prebuilt_smashbrosrop/USA/
cp -R smashbrosrop/EUR/* prebuilt_smashbrosrop/gameother/

