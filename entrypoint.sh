#!/bin/bash

set -m

echo "Running wmllint."
lint=$(python /data/wesnoth/data/tools/wmllint -d -S . 2>&1)
printf "%s\n" "${lint[@]}" | tac

echo "Running wmlindent."
indent=$(python /data/wesnoth/data/tools/wmlindent -d . 2>&1)
printf "%s\n" "${indent[@]}" | tac

if [[ -z $indent && -z $lint ]]; then
    exit 0
else
    exit 1
fi
