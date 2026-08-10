return {
    {
        "saghen/blink.cmp",
        version = "*",

        opts = {
            keymap = {
                preset = "enter",

                ["<Tab>"] = {
                    function(cmp)
                        if cmp.is_menu_visible() then
                            return cmp.select_next({ auto_insert = true })
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },

                ["<Space>"] = {
                    function(cmp)
                        return cmp.accept({
                            callback = function()
                                vim.api.nvim_feedkeys(" ", "n", false)
                            end,
                        })
                    end,
                    "fallback",
                },

                ["<CR>"] = {
                    "select_and_accept",
                    "fallback",
                },
            },

            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                },
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },
        },
    },
}
