#!/usr/bin/env bash
set -uo pipefail

if [[ $(checkupdates 2>/dev/null | wc -l) -gt 0 ]]; then
    presence="exists"
else
    presence="none"
fi

printf '{"alt": "%s"}\n' "$presence"
