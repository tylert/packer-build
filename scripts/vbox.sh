#!/usr/bin/env bash

packer_cache_dir="packer_cache"

if [ ! -d "${packer_cache_dir}" ]; then
    mkdir -p "${packer_cache_dir}"
fi

# PACKER_CONFIG="${HOME}/.packerconfig" \
# PACKER_LOG=1 \
# PACKER_LOG_PATH=vbox.log \
# PACKER_NO_COLOR=false \
# PACKER_PLUGIN_MAX_PORT=25000 \
# PACKER_PLUGIN_MIN_PORT=10000 \
# PACKER_TMP_DIR=/tmp/packer.d \
# TMPDIR=/tmp \
CHECKPOINT_DISABLE=1 \
PACKER_CACHE_DIR="${packer_cache_dir}" \
packer build -only=vbox ${@}
