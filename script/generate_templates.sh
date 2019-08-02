#!/usr/bin/env bash

if [ "" == "$(which ruby)" ]; then
    echo 'Ruby was not found in your path'
    exit 1
fi

for input in $(find source -name '*.yaml'); do
    output="${input/source/template}"

    if [ ! -d $(dirname ${output}) ]; then
        mkdir -p $(dirname ${output})
    fi

    echo "Generating '${output/yaml/json}' from '${input}'"

    ./script/yaml2json.rb < "${input}" > "${output/yaml/json}"

    CHECKPOINT_DISABLE=1 packer fix "${output/yaml/json}" \
        > "${output/yaml/json}.new"

    # Save the original just in case we want to diff it later:
    mv "${output/yaml/json}" "${output/yaml/json}.orig"

    mv "${output/yaml/json}.new" "${output/yaml/json}"

    CHECKPOINT_DISABLE=1 packer validate "${output/yaml/json}"
done
