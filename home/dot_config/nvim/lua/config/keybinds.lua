vim.g.mapleader = " "

vim.keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })

for tab = 1, 9 do
    vim.keymap.set("n", "<leader>" .. tab, tab .. "gt", { desc = "Go to tab " .. tab })
end
