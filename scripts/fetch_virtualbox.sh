#!/usr/bin/env bash

# If you are using a Mac OS X machine, you won't have a nice, simple command
# to magically get VirtualBox for you like you do on Ubuntu/Debian systems.
# This script attempts to get local copies of all the stuff you might need.

base_url='http://download.virtualbox.org/virtualbox'
desired_version="${1}"

if [ -z "${desired_version}" ]; then
    version="$(wget --quiet --output-document=- ${base_url}/LATEST.TXT)"
else
    version="${desired_version}"
fi

files="
SHA256SUMS
UserManual.pdf
Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack
VBoxGuestAdditions_${version}.iso
"

#if [ ! -d virtualbox ]; then mkdir virtualbox; fi
#pushd virtualbox

for file in ${files}; do
    wget --recursive --timestamping --no-directories --continue \
        ${base_url}/${version}/${file}
done

mv SHA256SUMS SHA256SUMS-VBoxGuestAdditions_${version}.txt
mv UserManual.pdf UserManual-${version}.pdf

# Some filenames have silly SVN revision ids in them like:
#VirtualBox-${version}-${revision}-OSX.dmg
#VirtualBox-${version}-${revision}-Linux_amd64.run

wget --recursive --timestamping --no-directories --continue \
    --level=1 --no-parent --accept '*.dmg' ${base_url}/${version}

wget --recursive --timestamping --no-directories --continue \
    --level=1 --no-parent --accept '*.amd64.run' ${base_url}/${version}

rm robots.txt

#popd
