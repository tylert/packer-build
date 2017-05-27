#!/usr/bin/env bash

if [ "" == "$(which ruby)" ]; then
    echo 'Ruby was not found in your path'
    exit 1
fi

for template in $(find {debian,ubuntu} -name '*.yaml'); do
    if [ ! -f "${template}" ]; then continue; fi
    echo "Generating ${template/yaml/json}"
    ./scripts/yaml2json.rb < "${template}" > "${template/yaml/json}"
    CHECKPOINT_DISABLE=1 packer fix "${template/yaml/json}" \
        > "${template/yaml/json}.new"
    mv "${template/yaml/json}.new" "${template/yaml/json}"
done
