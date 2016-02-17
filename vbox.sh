#!/usr/bin/env bash

PACKER_CACHE_DIR=${HOME}/packer_cache CHECKPOINT_DISABLE=1 \
packer build -only=virtualbox ${@}
