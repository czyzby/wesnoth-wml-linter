#!/bin/bash -l

# Capturing Python script stdout.
exec 5>&1

echo "Running wmllint."
lint=$(python /data/wesnoth/data/tools/wmllint -d -S . 2>&1 | tee >(cat - >&5))

echo "Running wmlindent."
indent=$(python /data/wesnoth/data/tools/wmlindent -d . 2>&1 | tee >(cat - >&5))

if [[ -z $indent && -z $lint ]]; then
    exit 0
else
    exit 1
fi
