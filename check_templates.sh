#!/usr/bin/env bash

for template in $(find {debian,ubuntu} -name '*.json'); do
    echo "Verifying ${template}"
    packer fix ${template} > ${template}.new
    mv ${template}.new ${template}
done
