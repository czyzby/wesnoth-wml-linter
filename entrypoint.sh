#!/bin/bash -l

# Capturing Python script stdout.
exec 5>&1

echo "Running wmllint."
lint=$(python /wesnoth/data/tools/wmllint -d -S . 2>&1 | tee >(cat - >&5))

echo "Running wmlindent."
indent=$(python /wesnoth/data/tools/wmlindent -d . 2>&1 | tee >(cat - >&5))

if [[ -z $indent && -z $lint ]]; then
    exit 0
else
    echo "Found issues within the WML files."
    echo "See the logs from the wmllint and the wmlindent tools."
    exit 1
fi
