vim.keymap.set('i', '<C-Q>', 'copilot#Accept("")', {
    expr = true,
    replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
vim.cmd.Copilot("disable")

local copilot_enabled = false
-- Todo: Create statusline module with API for adding items to the status line
-- Then require the module here and add a 'GH' at the end of the statusline when
-- copilot is enabled.
vim.keymap.set({'n', 'i'}, '<F9>', function ()
    if copilot_enabled then
        vim.cmd.Copilot("disable")
        copilot_enabled = false
    else
        vim.cmd.Copilot("enable")
        copilot_enabled = true
    end
end)

