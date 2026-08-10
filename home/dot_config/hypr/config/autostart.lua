-- Autostart applications launched once Hyprland starts.
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function ()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("fcitx5 -d")

    -- Chezmoi Autostart
    hl.exec_cmd("sleep 5 && chezmoi update")
end)

hl.on("hyprland.shutdown", function ()

end)
