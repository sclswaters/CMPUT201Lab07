#!/bin/bash

all_ok=yes

for i in 1 2 3 4; do
    dir="Testcase$i"
    outdir="Testcase${i}Diff"
    ok=yes
    diffs=0

    for file1 in "$dir"/*.1.txt; do
        name=$(basename "$file1" .1.txt)
        file2="$dir/$name.2.txt"
        outfile="$outdir/${name}Diff.txt"

        if diff -q "$file1" "$file2" > /dev/null; then
            if [ -f "$outfile" ]; then
                echo "unexpected $outfile" >&2
                ok=no
            fi
        else
            diffs=$((diffs + 1))
            if [ ! -f "$outfile" ]; then
                echo "missing $outfile" >&2
                ok=no
            elif ! cmp -s <(tail -n +3 "$outfile") <(diff -u "$file1" "$file2" | tail -n +3); then
                echo "wrong contents in $outfile" >&2
                ok=no
            fi
        fi
    done

    if [ "$diffs" -gt 0 ] && [ ! -d "$outdir" ]; then
        echo "missing directory $outdir" >&2
        ok=no
    fi
    if [ "$diffs" -eq 0 ] && [ -d "$outdir" ]; then
        echo "$outdir should not exist" >&2
        ok=no
    fi

    if [ "$ok" = yes ]; then
        echo "$dir: PASS"
    else
        echo "$dir: FAIL"
        all_ok=no
    fi
done

if [ "$all_ok" = yes ]; then
    exit 0
else
    exit 1
fi
