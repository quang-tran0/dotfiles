return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            current_line_blame = true,
        },
    },

    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "┆" },
            scope = { enabled = true, highlight = "IblScope", show_start = false },
        },
    },
}
