local function is_verilog_family(ctx)
    local filetype = vim.bo[ctx.bufnr].filetype
    return filetype == "verilog" or filetype == "systemverilog"
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

                ["<Tab>"] = {
                    "select_next",
                    "snippet_forward",
                    "fallback",
                },

                ["<S-Tab>"] = {
                    "select_prev",
                    "snippet_backward",
                    "fallback",
                },
            },

            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
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
                    "buffer",
                    "snippets",
                    "path",
                },

                providers = {
                    lsp = {
                        fallbacks = function(ctx)
                            return is_verilog_family(ctx) and {} or { "buffer" }
                        end,
                    },
                    snippets = {
                        score_offset = function(ctx)
                            return is_verilog_family(ctx) and -8 or -1
                        end,
                    },
                },
            },
        },
    },
}
