print("hello world")
-- TODO: decouple mappings from descriptions and functions so they can be reused by different sandboxes
function test_nvim_paste()
    local phase = -1 -- Don't stream
    local break_at_cr_and_clrf = false
    vim.api.nvim_paste([[
        test_nvim_paste
        test_nvim_paste_2
    ]], break_at_cr_and_clrf, phase)
end
vim.keymap.set('n','<leader>tu', function () test_nvim_paste() end,  { desc = "test nvim_paste" })

function test_nvim_put()
    local after_cursor = false
    local place_cursor_at_end = true
    vim.api.nvim_put({
        'test_nvim_put',
        'test_nvim_put',
    }, "l", after_cursor, place_cursor_at_end)
end
vim.keymap.set('n','<leader>tj', function () test_nvim_put() end, { desc = "test nvim_put"})

function test_nvim_buf_set_lines()
    print('test_nvim_buf_set_lines')
end
vim.keymap.set('n','<leader>tk', function () test_nvim_buf_set_lines() end, { desc = "test nvim_buf_set_lines"})

function test_nvim_buf_set_text()
    print('test_nvim_buf_set_text')
end
vim.keymap.set('n','<leader>ti', function () test_nvim_buf_set_text() end, { desc = "test nvim_buf_set_text"})

