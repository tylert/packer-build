#!/usr/bin/env bash

# Attempt to install the proprietary VM guest additions/tools thing.

iso_name="/tmp/VBoxGuestAdditions_$(cat /tmp/.vbox_version).iso"
mount_location="/media/vbox_tmp"

# Don't try to install anything if stuff isn't available.
if [ ! -r ${iso_name} ]; then exit; fi

# Mount the ISO file so we can extract files from it.
mkdir --parents ${mount_location}
mount --options loop ${iso_name} ${mount_location}

# Run the installer.
echo "yes" | bash ${mount_location}/VBoxLinuxAdditions.run

# Dismiss the ISO file now that we're done with it.
umount ${mount_location}
rm --recursive --force ${mount_location}
rm --force ${iso_name}
