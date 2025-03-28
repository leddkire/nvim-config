local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
--- vim.keymap.set('n', '<leader>fs', function()
	--- builtin.grep_string({ search = vim.fn.input("Grep > ") });
--- end)
vim.keymap.set('n', '<leader>fw', builtin.grep_string)
vim.keymap.set('n', '<leader>fr', builtin.git_files, { desc = 'Telescope git files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = 'Telescope man pages' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope list old files'})
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = 'Telescope list colorschemes'})
vim.keymap.set('n', '<leader>fC', builtin.commands, { desc = 'Telescope list commands'})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope list keymaps'})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Telescope find symbols in open document'})
vim.keymap.set('n', '<leader>fdw', builtin.diagnostics, { desc = 'Telescope find workspace diagnostic (warning/error/etc.)'})
vim.keymap.set('n', '<leader>fdb', function ()
   builtin.diagnostics({bufnr = 0})
end, { desc = 'Telescope find buffer diagnostic (warning/error/etc.)'})

local project_dirs={ os.getenv("PROJECT_DIRS")}
vim.keymap.set('n', '<leader>fp', function() builtin.find_files({search_dirs=project_dirs}) end, { desc = 'Find files in the paths in PROJECT_DIRS'})

