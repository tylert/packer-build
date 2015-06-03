#!/usr/bin/env bash

# Attempt to install the proprietary VM guest additions/tools thing.

iso_name="${HOME}/linux.iso"
mount_location="/media/vmwf_tmp"
tmp_location="${HOME}/vmwf_tmp"

# Don't try to install anything if stuff isn't available.
if [ ! -r ${iso_name} ]; then exit; fi

# Mount the ISO file so we can extract files from it.
mkdir --parents ${mount_location}
mount --options loop ${iso_name} ${mount_location}

# Extra step required because the installer expects things to be writeable.
cp --recursive ${mount_location} ${tmp_location}
chmod --recursive u+w ${tmp_location}

# Dismiss the ISO file now that we're done with it.
umount ${mount_location}
rm --recursive --force ${mount_location}
rm --force ${iso_name}

# Extra extra step required to uncompress the contents of the installer blob.
pushd ${tmp_location}
tar xvfz *.tar.gz
popd

# Interact with the extremely chatty installer.
# http://irouble.blogspot.ca/2011/03/get-vmware-installpl-to-automatically.html
${tmp_location}/vmware-tools-distrib/vmware-install.pl --default

# More cleanup required after the silly extra steps.
rm --recursive --force ${tmp_location}
