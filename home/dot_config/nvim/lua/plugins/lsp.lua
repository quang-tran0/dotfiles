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
    "autotools_ls",
    "slang_server",
    "verible",
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
            local publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
            local included_sv_cache = {}

            local function resolve_include(source_path, target, root_dir)
                local matches = {}

                local function add(path)
                    path = vim.fs.normalize(path)
                    local stat = vim.uv.fs_stat(path)
                    if stat and stat.type == "file" then
                        matches[path] = true
                    end
                end

                add(vim.fs.joinpath(vim.fs.dirname(source_path), target))
                add(vim.fs.joinpath(root_dir, target))

                local resolved
                for path in pairs(matches) do
                    if resolved then
                        return nil
                    end
                    resolved = path
                end
                return resolved
            end

            local function is_included_sv(uri, root_dir)
                if vim.fn.executable("rg") == 0 then
                    return false
                end

                if not included_sv_cache[root_dir] then
                    local included = {}
                    local result = vim.system({
                        "rg",
                        "--json",
                        "--glob",
                        "*.sv",
                        "--glob",
                        "*.svh",
                        "^[[:space:]]*`include[[:space:]]+\"[^\"]+\"",
                        root_dir,
                    }, { text = true }):wait(1000)

                    if result.code == 0 then
                        for line in result.stdout:gmatch("[^\n]+") do
                            local ok, event = pcall(vim.json.decode, line)
                            if ok and event.type == "match" then
                                local target = event.data.lines.text:match('^%s*`include%s+"([^"]+)"')
                                local source = event.data.path.text
                                local path = target and resolve_include(source, target, root_dir)
                                if path then
                                    included[path] = true
                                end
                            end
                        end
                    end

                    included_sv_cache[root_dir] = included
                end

                -- ponytail: this is lexical; remove it when slang-server maps included buffers
                -- back to their compilation unit and no longer needs this workaround.
                return included_sv_cache[root_dir][vim.fs.normalize(vim.uri_to_fname(uri))] == true
            end

            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.sv", "*.svh" },
                callback = function()
                    included_sv_cache = {}
                end,
            })

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

            vim.lsp.config("slang_server", {
                handlers = {
                    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
                        local client = vim.lsp.get_client_by_id(ctx.client_id)
                        if not err
                            and result
                            and result.uri
                            and client
                            and client.root_dir
                            and is_included_sv(result.uri, client.root_dir)
                        then
                            result = vim.tbl_extend("force", result, { diagnostics = {} })
                        end

                        return publish_diagnostics(err, result, ctx, config)
                    end,
                },
            })

            vim.lsp.config("verible", {
                on_attach = function(client)
                    client.server_capabilities.definitionProvider = false
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    client.server_capabilities.documentHighlightProvider = false
                    client.server_capabilities.documentSymbolProvider = false
                    client.server_capabilities.hoverProvider = false
                    client.server_capabilities.referencesProvider = false
                    client.server_capabilities.renameProvider = false
                end,
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
