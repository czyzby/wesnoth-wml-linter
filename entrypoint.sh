#!/bin/bash -l

branch="${2:-master}"
echo "Cloning Wesnoth $branch."
git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    --single-branch --branch $branch \
    -c advice.detachedHead=false \
    https://github.com/wesnoth/wesnoth \
    /wesnoth
(cd /wesnoth && git sparse-checkout set --no-cone data/tools/ data/core/**/*.cfg)
echo "Wesnoth repository is ready."

# Capturing Python script stdout.
exec 5>&1

if [[ "$3" = true ]]; then
    spellcheck=""
else
    spellcheck="-S"
fi

echo
echo "Running wmllint..."
export lint=$(
    python /wesnoth/data/tools/wmllint $4 -d $spellcheck /wesnoth/data/core/ $1 2>&1 | \
    grep --line-buffered '^"[^/].*", line.*$' | \
    tee >(cat - >&5)
)

echo
echo "Running wmlindent..."
export indent=$(
    python /wesnoth/data/tools/wmlindent $5 -d $1 2>&1 | \
    grep --line-buffered '^wmlindent: "[^/].*", line.*$' | \
    tee >(cat - >&5)
)

python /report.py

if [[ -z $lint && -z $indent ]]; then
    echo
    echo "No issues found by wmllint and wmlindent within the project."
    exit 0
else
    echo
    echo "Found issues within the WML files."
    echo "See the logs from the wmllint and the wmlindent tools."
    exit 1
fi
