local uname = (vim.uv or vim.loop).os_uname()
local is_linux_arm = uname.sysname == "Linux"
    and (uname.machine == "aarch64" or uname.machine:match("^arm") ~= nil)

local mason_servers = {
    "lua_ls",
    "html",
    "cssls",
    "jsonls",
    "marksman",
    "ts_ls",
    "pyright",
    "intelephense",
}

if not is_linux_arm then
    table.insert(mason_servers, "clangd")
end

return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",

        config = function()
            local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = format_group,
                callback = function(args)
                    local method = vim.lsp.protocol.Methods.textDocument_formatting
                    local clients = vim.lsp.get_clients({ bufnr = args.buf, method = method })

                    if #clients > 0 then
                        vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 3000 })
                    end
                end,
            })

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

            if is_linux_arm and vim.fn.executable("clangd") == 1 then
                vim.lsp.enable("clangd")
            end
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = mason_servers,
        },
    },
}
