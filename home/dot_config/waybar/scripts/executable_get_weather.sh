#!/usr/bin/env bash

location=${1:-}

for _ in {1..3}; do
  if text=$(curl --fail --silent --max-time 8 "https://wttr.in/${location}?format=1") &&
     tooltip=$(curl --fail --silent --max-time 8 "https://wttr.in/${location}?format=4"); then
    python3 -c 'import json, sys; print(json.dumps({"text": sys.argv[1].strip(), "tooltip": sys.argv[2].strip()}))' "$text" "$tooltip"
    exit 0
  fi
  sleep 1
done

printf '%s\n' '{"text":"󰖐  unavailable","tooltip":"Weather service unavailable","class":"error"}'
