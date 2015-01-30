#!/usr/bin/env bash

apt-get clean

dd if=/dev/zero of=/zerofill bs=4M
sync

rm /zerofill
sync
