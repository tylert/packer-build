#!/usr/bin/env bash

packer_cache_dir="${HOME}/packer_cache"

if [ ! -d "${packer_cache_dir}" ]; then
    mkdir -p "${packer_cache_dir}"
fi

PACKER_CACHE_DIR="${packer_cache_dir}" CHECKPOINT_DISABLE=1 \
packer build -only=virtualbox ${@}
