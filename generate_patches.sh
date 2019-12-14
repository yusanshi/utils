#!/bin/bash
# Generate patches for all submodule

# For submodule /path/to/foo/bar,
# execute `cd /path/to/foo/bar && git add . && git diff --cached > ../bar.patch`
# So patch for it would be located in /path/to/foo/bar.patch

wd=$(pwd)
for i in $(git submodule foreach --quiet 'echo $path'); do
    cd "$wd"/"$i"
    git add .
    diff=$(git diff --cached)
    if [[ -n $diff ]]; then
        patch=${PWD##*/}.patch
        echo "$diff" >../"$patch"
        echo "Patch file $patch generated"
    fi
done
