local languages = {
    "lua",
    "json",
    "html",
    "javascript",
    "typescript",
    "tsx",
    "php",
    "rust",
    "bash",
    "c",
    "cpp",
    "make",
    "systemverilog",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    init = function()
        vim.env.PATH = vim.fn.expand("~/.cargo/bin") .. ":" .. vim.env.PATH
    end,

    dependencies = {
        "windwp/nvim-ts-autotag",
    },

    config = function()
        require("nvim-treesitter").install(languages)
        vim.treesitter.language.register("systemverilog", "verilog")

        vim.api.nvim_create_autocmd("FileType", {
            pattern = vim.list_extend({ "verilog", "automake", "typescriptreact" }, languages),
            callback = function()
                vim.treesitter.start()

                if vim.bo.filetype ~= "verilog"
                    and vim.bo.filetype ~= "systemverilog"
                    and vim.bo.filetype ~= "make"
                    and vim.bo.filetype ~= "automake"
                then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })

        require("nvim-ts-autotag").setup({
            opts = {
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = false,
            },
        })
    end,
}
