return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",

        config = function()
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                "vim",
                                "hl",
                            },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            })
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = {
                "lua_ls",
                "html",
                "cssls",
                "ts_ls",
                "clangd",
                "pyright",
                "intelephense",
            },
        },
    },
}
