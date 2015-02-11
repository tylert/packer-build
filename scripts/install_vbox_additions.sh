#!/usr/bin/env bash

iso_name="${HOME}/VBoxGuestAdditions_$(cat ${HOME}/.vbox_version).iso"
mount_location="/media/vbox_tmp"

# Don't try to install anything if stuff isn't available.
if [ ! -r ${iso_name} ]; then exit; fi

# Put a full kernel build environment here just to make virtualbox happy.
apt-get -y install build-essential dkms

mkdir -p ${mount_location}
mount -o loop ${iso_name} ${mount_location}

echo "yes" | bash ${mount_location}/VBoxLinuxAdditions.run

umount ${mount_location}
rm -rf ${mount_location}
rm ${iso_name}
