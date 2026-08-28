local function accept_and_move(key)
    return function(cmp)
        return cmp.accept({
            callback = function()
                local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
                vim.api.nvim_feedkeys(termcode, "n", false)
            end,
        })
    end
end

return {
    {
        "saghen/blink.cmp",
        version = "*",

        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        opts = {
            keymap = {
                preset = "enter",

                ["<Up>"] = { accept_and_move("<Up>"), "fallback" },
                ["<Down>"] = { accept_and_move("<Down>"), "fallback" },
                ["<Left>"] = { accept_and_move("<Left>"), "fallback" },
                ["<Right>"] = { accept_and_move("<Right>"), "fallback" },

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
