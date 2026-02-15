print("hello world")
-- TODO: decouple mappings from descriptions and functions so they can be reused by different sandboxes
local function test_nvim_paste()
    local phase = -1 -- Don't stream
    local break_at_cr_and_clrf = false
    vim.api.nvim_paste([[
        test_nvim_paste
        test_nvim_paste_2
    ]], break_at_cr_and_clrf, phase)
end
vim.keymap.set('n','<leader>tu', function () test_nvim_paste() end,  { desc = "test nvim_paste" })

local function test_nvim_put()
    local after_cursor = false
    local place_cursor_at_end = true
    vim.api.nvim_put({
        'test_nvim_put',
        'test_nvim_put',
    }, "l", after_cursor, place_cursor_at_end)
end
vim.keymap.set('n','<leader>tj', function () test_nvim_put() end, { desc = "test nvim_put"})

local current_buffer = 0
local function test_nvim_buf_set_lines()
    print('test_nvim_buf_set_lines')
    local start_line = -1
    local end_line = -1
    local buffer = current_buffer
    vim.api.nvim_buf_set_lines(buffer, start_line, end_line, false, {"line1", "line2"})
end
vim.keymap.set('n','<leader>tk', function () test_nvim_buf_set_lines() end, { desc = "test nvim_buf_set_lines"})

local function test_nvim_buf_set_text()
    print('test_nvim_buf_set_text')
    local buffer = current_buffer
    local start_row = -1
    local start_col = 74
    local end_row = -1
    local end_col = 74
    vim.api.nvim_buf_set_text(buffer, start_row, start_col, end_row, end_col, {"replacement"} )
end
vim.keymap.set('n','<leader>ti', function () test_nvim_buf_set_text() end, { desc = "test nvim_buf_set_text"})
