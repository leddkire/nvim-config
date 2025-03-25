vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc="Open file's directory in new window"})

--- move selection up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--- Keep cursor at beginning of line when joining lines
vim.keymap.set("n", "J", "mzJ`z")

--- Keep cursor in the middle while jumping / searching
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--- System clipboard yanking
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop>")

-- Quick-fix list. Must learn tool
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next item in the quickfix list" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Previous item in the quickfix list" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Next item in the quickfix list (use current window location list)" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Previous item in the quickfix list (use current window location list)" })

vim.keymap.set("n","<leader>c",
  function ()
      vim.cmd.sp("~/.config/nvim")
        --- :help :lcd
      vim.cmd.lcd("~/.config/nvim")
  end
, { desc="Open nvim config in new window+buffer and change directory for that window"})



