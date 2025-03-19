require("customconfig")
require("config.lazy")
require("project_config")

--- vim.opt.statusline ="%{FugitiveStatusline()}"

vim.o.tabstop=8



vim.o.softtabstop=8
vim.o.shiftwidth=4
vim.o.smarttab=true
vim.o.expandtab=true
vim.o.smartindent=true
vim.o.number=true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.o.termguicolors = true
vim.o.background = 'light'
vim.cmd.colorscheme 'onedark'
