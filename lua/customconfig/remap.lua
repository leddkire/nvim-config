vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil, { desc="Open file's directory in new window"})

--- move selection up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--- Keep cursor at beginning of line when joining lines
-- vim.keymap.set("n", "J", "mzJ`z")

--- Keep cursor in the middle while jumping / searching
--- I've commented these lines because it breaks mini-animate scrolling.
--- Instead of jumping to the next match, it would sometimes stay at the current match
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

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
    local jit_os = jit.os
      if jit_os ~= "Windows" then
          vim.cmd.sp("~/.config/nvim")
            --- :help :lcd
          vim.cmd.lcd("~/.config/nvim")
      else
          local home = (os.getenv("HomeDrive") .. os.getenv("HomePath"))
          vim.cmd.sp(home .. "\\AppData\\Local\\nvim")
            --- :help :lcd
          vim.cmd.lcd(home .. "\\AppData\\Local\\nvim")
      end
  end
, { desc="Open nvim config in new window+buffer and change directory for that window"})

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

local buf = vim.api.nvim_create_buf(false, true)
local window
vim.keymap.set('n', '<leader><F1>', function ()
    --TODO: Move this to a module so it can be used in other cases
    local messages = vim.split(vim.fn.execute("messages", "silent"), "\n")
    if(buf == nil) then
        buf = vim.api.nvim_create_buf(false, true)
    end
    vim.api.nvim_buf_set_lines(buf, 0,-1, false, messages)
    if(window ~= nil and vim.api.nvim_win_is_valid(window)) then
        vim.api.nvim_win_close(window, false)
    end
    window = vim.api.nvim_open_win(buf, true, { split='below' })
    vim.cmd.normal('G')
end, {desc = "Opens a window the contents of :messages"})
