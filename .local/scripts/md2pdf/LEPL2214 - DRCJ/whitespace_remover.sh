#!/usr/bin/env bash

for f in *; do
  [[ "$f" == *" "* ]] && mv -- "$f" "${f// /_}"
done

