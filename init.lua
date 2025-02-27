require("customconfig")
require("config.lazy")

vim.opt.statusline ="%{FugitiveStatusline()}"

vim.o.tabstop=8
vim.o.softtabstop=8
vim.o.shiftwidth=4
vim.o.smarttab=true
vim.o.expandtab=true
vim.o.smartindent=true
vim.o.number=true

vim.o.termguicolors = true
vim.o.background = 'light'
vim.cmd.colorscheme 'onedark'
