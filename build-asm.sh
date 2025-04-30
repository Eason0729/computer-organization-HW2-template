#!/bin/bash
mkdir -p build/casm

for file in assembly/*.s; do
    filename=$(basename "$file" .s)

    output="build/casm/${filename}.c"

    {
        while IFS= read -r line; do
            printf '"%s\\n"\n' "$line"
        done
    } < "$file" > "$output"
done
