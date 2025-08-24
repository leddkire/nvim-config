vim.g.python3_host_prog = '/usr/local/var/pyenv/versions/py3nvim_3_7_17/bin/python'
vim.g.python_host_prog = '/usr/local/var/pyenv/versions/py3nvim_3_7_17/bin/python'
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.schedule(function ()
    vim.o.clipboard = 'unnamedplus'
end)

require("customconfig")
require("config.lazy")

-- Example for calling a lua function using vimscript in the statusline
-- function testLuaToVim()
--     return "hello world"
-- end
-- vim.opt.statusline = "%{v:lua.testLuaToVim()}"

vim.o.tabstop=8

vim.o.softtabstop=8
vim.o.shiftwidth=4
vim.o.smarttab=true
vim.o.expandtab=true
vim.o.smartindent=true
vim.o.number=true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 10

vim.opt.colorcolumn = "80"

vim.o.breakindent = true
vim.o.linebreak = true

vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true
vim.o.background = 'light'
vim.cmd.colorscheme 'onedark'
vim.cmd.language 'en_US'
vim.o.guicursor= 'i-ci:ver30-iCursor,a:blinkwait200-blinkon100-blinkoff100'
vim.o.foldmethod='expr'
vim.o.foldlevel = 20
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
-- vim.o.list = true
-- vim.opt.listchars = { tab = '->', trail = '+', nbsp = '?' }

vim.o.inccommand = 'split'

vim.o.cursorline = true
