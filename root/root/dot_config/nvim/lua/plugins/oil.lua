return {
    {
        "stevearc/oil.nvim",

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
