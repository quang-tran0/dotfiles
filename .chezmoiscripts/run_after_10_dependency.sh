#!/bin/bash

CHEZMOI_DIR="$(chezmoi source-path)"
packages_file="$CHEZMOI_DIR/packages.txt"

helper=$(command -v paru || command -v yay)

if [ -z "$helper" ]; then
    echo "No supported AUR helper found (paru or yay)."
    exit 1
fi

mapfile -t packages < <(
    sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$packages_file"
)

mapfile -t missing < <(
    pacman -T "${packages[@]}"
)

if [ ${#missing[@]} -eq 0 ]; then
    echo "All dependencies are installed."
    exit 0
fi

echo "Missing dependencies:"
printf '  - %s\n' "${missing[@]}"

"$helper" -S --needed --noconfirm "${missing[@]}"
