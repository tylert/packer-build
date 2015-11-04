#!/usr/bin/env bash

# If you are using a Mac OS X machine, you won't have a nice, simple command
# to magically get VirtualBox for you like you do on Ubuntu/Debian systems.
# This script attempts to get local copies of all the stuff you might need.

base_url='http://download.virtualbox.org/virtualbox'

if [ -z "${1}" ]; then
    version="$(wget --quiet --output-document=- ${base_url}/LATEST.TXT)"
else
    version="${1}"
fi

files="
Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack
SHA256SUMS
UserManual.pdf
VBoxGuestAdditions_${version}.iso
"

if [ ! -d virtualbox ]; then mkdir virtualbox; fi
pushd virtualbox

for file in ${files}; do
    wget --recursive --timestamping --no-directories --continue \
        ${base_url}/${version}/${file}
done

mv SHA256SUMS SHA256SUMS-${version}.txt
mv UserManual.pdf UserManual-${version}.pdf

# Fetch filenames that have silly SVN revision ids in them like:
#VirtualBox-${version}-${revision}-OSX.dmg
wget --recursive --timestamping --no-directories --continue \
    --level=1 --no-parent --accept '*.dmg' ${base_url}/${version}

popd
