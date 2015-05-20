#!/usr/bin/env bash

dd if=/dev/zero of=/zerofill bs=4M
sync

rm /zerofill
sync
