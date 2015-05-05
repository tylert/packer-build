#!/usr/bin/env bash

username='ghost'

# Make the user a member of the sudo group.
usermod -a -G sudo ${username}

# Establish sudo password bypass for memebers of the user's group.
echo "%${username} ALL=NOPASSWD:ALL" > /etc/sudoers.d/99vagrant
chmod 0440 /etc/sudoers.d/99vagrant
