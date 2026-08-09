local neo_tree_visible

local function is_neo_tree_open()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buffer = vim.api.nvim_win_get_buf(win)
        if vim.bo[buffer].filetype == "neo-tree" and vim.b[buffer].neo_tree_source == "filesystem" then
            return true
        end
    end

    return false
end

local function set_neo_tree_visible(visible)
    neo_tree_visible = visible
    require("neo-tree.command").execute({
        action = visible and "show" or "close",
        source = "filesystem",
        position = "left",
    })
end

local function sync_neo_tree()
    if neo_tree_visible ~= nil and is_neo_tree_open() ~= neo_tree_visible then
        set_neo_tree_visible(neo_tree_visible)
    end
end

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,

        init = function()
            vim.api.nvim_create_autocmd("TabEnter", {
                group = vim.api.nvim_create_augroup("SyncNeoTreeTabs", { clear = true }),
                callback = sync_neo_tree,
            })
        end,

        keys = {
            {
                "<leader>tn",
                function()
                    vim.cmd.tabnew()
                    set_neo_tree_visible(neo_tree_visible ~= false)
                end,
                desc = "New tab with synchronized Neo-tree",
            },
            {
                "<leader>cd",
                function()
                    set_neo_tree_visible(not is_neo_tree_open())
                end,
                desc = "Toggle Neo-tree in all tabs",
            },
        },

        opts = {
            close_if_last_window = true,
            filesystem = {
                bind_to_cwd = true,
                cwd_target = {
                    sidebar = "global",
                    current = "window",
                },
                hijack_netrw_behavior = "open_default",
                filtered_items = {
                    visible = true,
                },
            },
        },

        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
