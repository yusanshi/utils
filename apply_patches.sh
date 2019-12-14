#!/bin/bash
# Apply patches for all submodule

# For submodule /path/to/foo/bar,
# execute `cd /path/to/foo/bar && git apply ../bar.batch`

wd=$(pwd)
for i in $(git submodule foreach --quiet 'echo $path'); do
    cd "$wd"/"$i"
    patch=${PWD##*/}.patch
    if [ -e ../"$patch" ]; then
        git apply ../"$patch"
        echo "Patch file $patch applyed"
    fi
done
