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
(cd /wesnoth && git sparse-checkout set data/tools/ data/core/**/*.cfg)

# Capturing Python script stdout.
exec 5>&1

echo
echo "Running wmllint..."
export lint=$(python /wesnoth/data/tools/wmllint $4 -d -S /wesnoth/data/core/ $1 2>&1 | tee >(cat - >&5))

echo
echo "Running wmlindent..."
export indent=$(python /wesnoth/data/tools/wmlindent $5 -d $1 2>&1 | tee >(cat - >&5))

if [[ "$3" = true ]]; then
    echo
    echo "Running wmllint with spellcheck..."
    export spellcheck=$(python /wesnoth/data/tools/wmllint -d -K -m $1 2>&1 | tee >(cat - >&5))
else
    export spellcheck=""
fi

python /verify.py

if [[ $? -eq 0 ]]; then
    echo
    echo "No issues found by wmllint and wmlindent within the project."
    exit 0
else
    echo
    echo "Found issues within the WML files."
    echo "See the logs from the wmllint and the wmlindent tools."
    exit 1
fi
