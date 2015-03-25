#!/usr/bin/env bash

# Attempt to install the proprietary VM guest additions/tools thing.

iso_name="${HOME}/linux.iso"
mount_location="/media/vmwf_tmp"

# Don't try to install anything if stuff isn't available.
if [ ! -r ${iso_name} ]; then exit; fi

# Pull in an entire development environment just to make the installer happy.
apt-get --yes install build-essential linux-headers-$(uname -r)

mkdir --parents ${mount_location}
mount --options loop ${iso_name} ${mount_location}

#run install thingy and interact with the extremely chatty installer

umount ${mount_location}
rm --recursive --force ${mount_location}
rm --force ${iso_name}
