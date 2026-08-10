-- App-launcher keybindings (terminal, browser, file manager, menu, shutdown helper).

local mainMod = require("config.keybindings.modkey")
local vars = require("config.variables")

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(vars.menu))

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(
    mainMod .. " + SHIFT + L",
    hl.dsp.exec_cmd("zsh -ic 'chezmoi push' && (command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit)")
)
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.exec_cmd("zsh -ic 'chezmoi push' && systemctl poweroff"))
