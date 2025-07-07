local telescope = require('telescope')
telescope.setup({
    defaults = {
        layout_strategy = 'flex',
        layout_config = {
            vertical = {
                mirror = true,
                prompt_position = 'top'
            },
            flex = {
                flip_columns = 120
            }
        }
    }
})

telescope.load_extension("package_json_actions")

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files , { desc = 'Telescope find files'})
vim.keymap.set('n', '<leader>fa', function ()
    builtin.find_files({hidden=true})
end, { desc = 'Telescope find files (including hidden)'})
--- vim.keymap.set('n', '<leader>fs', function()
	--- builtin.grep_string({ search = vim.fn.input("Grep > ") });
--- end)
vim.keymap.set('n', '<leader>gdb', builtin.git_bcommits, {desc= 'Telescope buffer commits'})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {desc= 'Telescope grep current word'})
vim.keymap.set('n', '<leader>fr', builtin.git_files, { desc = 'Telescope git files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.current_buffer_fuzzy_find, { desc = 'Telescope search current buffer' })
vim.keymap.set('n', '<leader>fB', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = 'Telescope man pages' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope list old files'})
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = 'Telescope list colorschemes'})
vim.keymap.set('n', '<leader>fC', builtin.commands, { desc = 'Telescope list commands'})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope list keymaps'})
vim.keymap.set('n', '<leader>fvo', builtin.vim_options, { desc = 'Telescope vim options'})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Telescope find symbols in open document'})
vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Telescope find symbols in workspace'})
vim.keymap.set('n', '<leader>fdw', builtin.diagnostics, { desc = 'Telescope find workspace diagnostic (warning/error/etc.)'})
vim.keymap.set('n', '<leader>fdb', function ()
   builtin.diagnostics({bufnr = 0})
end, { desc = 'Telescope find buffer diagnostic (warning/error/etc.)'})

local project_dirs={ os.getenv("PROJECT_DIRS")}
vim.keymap.set('n', '<leader>fp', function() builtin.find_files({search_dirs=project_dirs}) end, { desc = 'Telescope find files in the paths in PROJECT_DIRS'})

vim.keymap.set('n', '<leader>f<leader>', function() builtin.resume() end, { desc = 'Telescope resume last search'})


