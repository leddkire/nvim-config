local ts_utils = require 'nvim-treesitter.ts_utils'
local ts = vim.treesitter

local parser = ts.get_parser()
local tree = parser:parse()[1]
local root = tree:root()
local lang = parser:lang()
-- Exercise: show in a separate buffer which variables are in scope under the cursor
-- Once we can do that, we'll be able to generate a print statement with those values
vim.keymap.set('n', '<leader>t1', function ()
    local ts_node = ts_utils.get_node_at_cursor()
    T(ts_node)
end)

local win
local buf
vim.keymap.set('n', '<leader>t2', function ()
    if win ~= nil then
       vim.api.nvim_win_close(win, true)
       win = nil
       vim.api.nvim_buf_delete(buf, { force = true })
       buf = nil
       return
    end
    buf = vim.api.nvim_create_buf(false, true)
    local opts = {
        relative =  'cursor',
        width =  10,
        height =  2,
        col =  0,
        row =  1,
        anchor =  'NW',
        style =  'minimal'
    }
    win = vim.api.nvim_open_win(buf, false, opts)

end)

-- I can create treesitter queries and execute them to get the information I need as well. I should investigate how to do that too.
