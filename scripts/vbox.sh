#!/usr/bin/env bash

packer_cache_dir="packer_cache"

if [ ! -d "${packer_cache_dir}" ]; then
    mkdir -p "${packer_cache_dir}"
fi

#PACKER_LOG=1 PACKER_LOG_PATH=vbox.log \
PACKER_CACHE_DIR="${packer_cache_dir}" CHECKPOINT_DISABLE=1 \
packer build -only=virtualbox ${@}
