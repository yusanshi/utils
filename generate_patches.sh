#!/bin/bash
# Generate patches for all submodules

# How it works:
# For submodule /path/to/foo/bar,
# execute `cd /path/to/foo/bar && git add . && git diff --cached > ../bar.patch`
# So patch for it would be located in /path/to/foo/bar.patch

if [ "$1" = "-h" -o "$1" = "--help" ]; then
    echo "Generate patches for all submodules."
    echo ""
    echo "Usage: generate_patches.sh [options]"
    echo ""
    echo "Options:"
    echo -e "--help | -h\t\tShow this message, then exit."
    echo -e "--manual | -m\t\tManually choose whether add binary files for every submodule. "
    echo -e "\t\t\tDefault mode is auto mode, which automatically process all submodules,"
    echo -e "\t\t\tignoring binary files them."
    exit 0
fi

wd=$(pwd)
for i in $(git submodule foreach --quiet 'echo $path'); do
    cd "$wd"/"$i"
    if [[ $(git status --porcelain) ]]; then
        git add .
        patch=${PWD##*/}.patch
        if [ "$1" = "-m" -o "$1" = "--manual" ]; then
            read -p "Add binary files for submodule $i? [yN]" choice
            case $choice in
            [Yy]*)
                echo "$(git diff --cached --binary)" >../"$patch"
                # Add a \n in the end as it will be missed using above line.
                echo "" >>../"$patch"
                ;;
            *)
                echo "$(git diff --cached)" >../"$patch"
                ;;
            esac
        else
            echo "$(git diff --cached)" >../"$patch"
        fi
        echo "Patch file $patch generated"
    else
        echo "No change for submodule $i. Skipped."
    fi
done
