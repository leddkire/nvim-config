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
vim.cmd.language 'en_US'
vim.o.guicursor= 'i-ci:ver30-iCursor,a:blinkwait200-blinkon100-blinkoff100'
vim.o.foldmethod='expr'
vim.o.foldlevel = 20
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'


