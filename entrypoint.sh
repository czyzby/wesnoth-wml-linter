#!/bin/bash

set -m

echo "Running wmllint."
lint=$(python data/tools/wmllint -d . 2>&1 | tee /dev/stdout)
echo "Running wmlindent."
indent=$(python data/tools/wmlindent -d . 2>&1 | tee /dev/stdout)

if [[ -z $indent && -z $lint ]]; then
    exit 0
else
    exit 1
fi
