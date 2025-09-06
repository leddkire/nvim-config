require("refactoring").setup({ })

vim.keymap.set("x", "<leader>re", ":Refactor extract ", {desc="Refactor: extract"})
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", {desc = "Refactor: extract to file"})

vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Refactor: extract variable" })

vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Refactor: inline variable" })

vim.keymap.set( "n", "<leader>rI", ":Refactor inline_func", { desc = "Refactor: inline func" })

vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Refactor: extract block" })
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", { desc = "Refactor extract block to file" })


-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.keymap.set(
	"n",
	"<leader>rp",
	function() require('refactoring').debug.printf({below = false}) end
, { desc = "Add debug print statement" })

-- Print var

vim.keymap.set({"x", "n"}, "<leader>rpv", function() require('refactoring').debug.print_var() end, { desc = "Add debug print statement with variables" })
-- Supports both visual and normal mode

vim.keymap.set("n", "<leader>rpc", function() require('refactoring').debug.cleanup({}) end, { desc = "Clean-up debug print statements" })
-- Supports only normal mode
