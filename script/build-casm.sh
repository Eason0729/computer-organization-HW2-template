#!/bin/bash
mkdir -p build/casm

for file in assembly/*.s; do
    filename=$(basename "$file" .s)

    output="build/casm/${filename}.c"

    {
        while IFS= read -r line; do
            line=$(printf '%s' "$line" | sed -E 's/(\/\/|#).*//; s/[[:space:]]+$//')

            [[ -z "$line" ]] && continue

            printf '"%s\\n"\n' "$line"
        done
    } < "$file" > "$output"
done
