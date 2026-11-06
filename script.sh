#!/bin/bash

for dir in Testcase*; do
    [[ "$dir" == *Diff ]] && continue

    outdir="${dir}Diff"
    rm -rf "$outdir"

    for file1 in "$dir"/*.1.txt; do
        name=$(basename "$file1" .1.txt)
        file2="$dir/$name.2.txt"

        if ! diff -u "$file1" "$file2" > /dev/null; then
            mkdir -p "$outdir"
            diff -u "$file1" "$file2" > "$outdir/${name}Diff.txt"
        fi
    done
done
