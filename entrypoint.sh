#!/bin/bash -l

echo "Cloning Wesnoth ${2:-master}."
git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    --single-branch --branch ${2:-master} \
    -c advice.detachedHead=false \
    https://github.com/wesnoth/wesnoth \
    /wesnoth
(cd /wesnoth && git sparse-checkout set data/tools/)

# Capturing Python script stdout.
exec 5>&1

echo "Running wmllint."
lint=$(python /wesnoth/data/tools/wmllint -d -S $1 2>&1 | tee >(cat - >&5))

echo "Running wmlindent."
indent=$(python /wesnoth/data/tools/wmlindent -d $1 2>&1 | tee >(cat - >&5))

if [[ -z $indent && -z $lint ]]; then
    exit 0
else
    echo "Found issues within the WML files."
    echo "See the logs from the wmllint and the wmlindent tools."
    exit 1
fi
