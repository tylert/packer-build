#!/usr/bin/env bash

# Fetch and install the latest known released versions of some Hashicorp
# binaries.

hc_server='https://releases.hashicorp.com'

function fetch_hc_binary {
    local hc_binary="${1}"
    local hc_version="${2}"
    local target_location="${3}"

    wget --continue ${hc_server}/${hc_binary}/${hc_version}/${hc_binary}_${hc_version}_SHA256SUMS
    wget --continue ${hc_server}/${hc_binary}/${hc_version}/${hc_binary}_${hc_version}_SHA256SUMS.sig
    wget --continue ${hc_server}/${hc_binary}/${hc_version}/${hc_binary}_${hc_version}_linux_amd64.zip

    gpg --verify ${hc_binary}_${hc_version}_SHA256SUMS.sig \
        ${hc_binary}_${hc_version}_SHA256SUMS
    sha256sum --check <(grep ${hc_binary}_${hc_version}_linux_amd64.zip \
        ${hc_binary}_${hc_version}_SHA256SUMS)

    unzip -o ${hc_binary}_${hc_version}_linux_amd64.zip
    sudo cp --verbose ${hc_binary}{,_v${hc_version}_x4} ${target_location}
}

function fetch_hc_vagrant {
    local hc_binary="${1}"
    local hc_version="${2}"

    wget --continue ${hc_server}/${hc_binary}/${hc_version}/${hc_binary}_${hc_version}_SHA256SUMS
    wget --continue ${hc_server}/${hc_binary}/${hc_version}/${hc_binary}_${hc_version}_SHA256SUMS.sig
    wget --continue ${hc_server}/${hc_binary}/${hc_version}/${hc_binary}_${hc_version}_x86_64.deb

    gpg --verify ${hc_binary}_${hc_version}_SHA256SUMS.sig \
        ${hc_binary}_${hc_version}_SHA256SUMS
    sha256sum --check <(grep ${hc_binary}_${hc_version}_x86_64.deb \
        ${hc_binary}_${hc_version}_SHA256SUMS)

    sudo dpkg --install ${hc_binary}_${hc_version}_x86_64.deb
}

# Fetch binaries and install them locally
fetch_hc_binary   'packer'   '1.1.0'  '/usr/local/bin'
fetch_hc_vagrant  'vagrant'  '2.0.0'
