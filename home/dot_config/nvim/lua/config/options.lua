vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.whichwrap:append("<,>,[,],h,l")

vim.opt.clipboard = "unnamedplus"

if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
    vim.g.clipboard = "osc52"
end
