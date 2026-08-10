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
    hl.dsp.exec_cmd("(zsh -ic 'chezmoi push' || zenity --question --title='Chezmoi push failed' --text='Chezmoi push failed. Do you still want to log out?' --ok-label='Log Out' --cancel-label='Cancel') && loginctl terminate-session \"$XDG_SESSION_ID\"")
)
hl.bind(
    mainMod .. " + SHIFT + U",
    hl.dsp.exec_cmd("(zsh -ic 'chezmoi push' || zenity --question --title='Chezmoi push failed' --text='Chezmoi push failed. Do you still want to shut down?' --ok-label='Shut Down' --cancel-label='Cancel') && systemctl poweroff")
)
