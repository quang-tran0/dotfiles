return {
    {
        "stevearc/oil.nvim",

        keys = {
            { "<leader>cd", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },

        opts = {
            keymaps = {
                ["<Right>"] = "actions.select",
                ["<Left>"] = "actions.parent",
            },

            view_options = {
                show_hidden = true,
            },
        },

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
}
