-- Auto-command to customize chat buffer behavior
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

vim.keymap.set({'n', 'i', 'v', 'x'}, '<F10>', function ()
    vim.cmd.CopilotChatToggle()
end)
