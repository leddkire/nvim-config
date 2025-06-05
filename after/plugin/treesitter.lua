require'nvim-treesitter.configs'.setup {
    build=":TSUpdate",
    event= {"BufReadPre", "BufNewFile" },
    ensure_installed = {"vimdoc", "javascript", "typescript", "lua", "gdscript", "c", "nginx" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<M-i>", -- set to `false` to disable one of the mappings
            node_incremental = "<M-i>",
            scope_incremental = false,
            node_decremental = "<M-u>",
        },
    },
}

