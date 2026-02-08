print("hello world")
function test_nvim_paste()
    print('test_nvim_paste')
end
vim.keymap.set('n','<leader>tu', function () test_nvim_paste() end)
function test_nvim_put()
    print('test_nvim_put')
end
vim.keymap.set('n','<leader>tj', function () test_nvim_put() end)
function test_nvim_buf_set_lines()
    print('test_nvim_buf_set_lines')
end
vim.keymap.set('n','<leader>tk', function () test_nvim_buf_set_lines() end)
function test_nvim_buf_set_text()
    print('test_nvim_buf_set_text')
end
vim.keymap.set('n','<leader>ti', function () test_nvim_buf_set_text() end)
