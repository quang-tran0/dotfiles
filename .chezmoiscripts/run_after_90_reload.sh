#!/bin/bash

echo "Reloading desktop configuration..."

if command -v hyprctl >/dev/null 2>&1 &&
    [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    echo "Reloading Hyprland..."
    hyprctl reload
fi

if command -v noctalia >/dev/null 2>&1 &&
    noctalia msg status >/dev/null 2>&1; then
    echo "Reloading Noctalia..."
    noctalia msg config-reload
fi

echo "Desktop configuration reloaded."
