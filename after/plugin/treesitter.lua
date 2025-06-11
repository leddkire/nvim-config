require('nvim-treesitter.configs').setup {
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

    move = {
        enable=true,
        set_jumps=true,

    },
    textobjects = {
        move = {
            enable=true,
            set_jumps=true,
            goto_next_start = {
                ["]z"] = { query="@fold", query_group="folds", desc = "Start of next fold"},
                ["]m"] = "@function.outer"
            },
            goto_next_end = {
                ["]Z"] = { query="@fold", query_group="folds", desc = "End of next fold"},
                ["]M"] = "@function.outer"
            },
            goto_previous_start = {
                ["[z"] = { query="@fold", query_group="folds", desc = "Start of previous fold"},
                ["[m"] = "@function.outer"
            },
            goto_previous_end = {
                ["[Z"] = { query="@fold", query_group="folds", desc = "End of previous fold"},
                ["[M"] = "@function.outer"
            }
        },
        select = {
            enable=true,
            lookahead=true,
            keymaps = {
                ["af"] = "@call.outer",
                ["if"] = "@call.inner",
                ["am"] = "@function.inner",
                ["im"] = "@function.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["aa"] = "@parameter.inner",
                ["ia"] = "@parameter.inner",
            }
        },
    },
}

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
