#!/usr/bin/env bash
set -euo pipefail

all=0
for arg in "$@"; do
    if [[ "$arg" == "--all" ]]; then
        all=1
    fi
done

if [[ "$all" -eq 1 ]]; then
    git add .
fi

amount=$(git status --porcelain | wc -l)
if [[ "$amount" -gt 0 ]]; then
    git commit -am "Auto-update 🚀"
    git push
fi
