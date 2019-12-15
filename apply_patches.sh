#!/bin/bash
# Apply patches for all submodules

# How it works:
# For submodule /path/to/foo/bar,
# execute `cd /path/to/foo/bar && git apply ../bar.batch`

if [ "$1" = "-h" -o "$1" = "--help" ]; then
    echo "Apply patches for all submodules."
    echo ""
    echo "For submodule /path/to/foo/bar, patch file for it must be located"
    echo "in /path/to/foo/bar.patch (generate_patches.sh would do this)."
    exit 0
fi

wd=$(pwd)
for i in $(git submodule foreach --quiet 'echo $path'); do
    cd "$wd"/"$i"
    patch=${PWD##*/}.patch
    if [ -e ../"$patch" ]; then
        git apply ../"$patch"
        echo "Patch file $patch applyed"
    fi
done
