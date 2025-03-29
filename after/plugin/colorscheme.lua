require('onedark').setup({
    style = 'light'
})

vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
    group = vim.api.nvim_create_augroup('Color', {}),
    pattern = "*",
    callback = function ()
        vim.api.nvim_set_hl(0, "MatchParen", {bold=true, underline=true,bg = "#d5d7e0"})
    end
})
