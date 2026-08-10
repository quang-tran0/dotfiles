#!/usr/bin/env bash

pkill -x waybar 2>/dev/null
exec waybar --config /home/quang-tran/.config/waybar/config.jsonc \
  --style /home/quang-tran/.config/waybar/style.css
