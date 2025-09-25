local co = require("coroutine-utils.init")
local M = {}
local function vim_system_cb(cb, cmd, opts)
    vim.system(cmd, opts, cb)
end
M.vim_system_co = co.cb_to_co(vim_system_cb)
return M
