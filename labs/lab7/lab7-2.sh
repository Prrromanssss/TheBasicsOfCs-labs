#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

grep -rn -E --include=\*.c --include=\*.h '^\S+$' "$1" | wc -l