require("customconfig")
require("config.lazy")

vim.opt.tabstop=8
vim.opt.softtabstop=8
vim.opt.shiftwidth=4
vim.opt.smarttab=true
vim.opt.expandtab=true
vim.opt.smartindent=true
vim.opt.number=true

vim.opt.statusline ="%{FugitiveStatusline()}"
