local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED
--
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-a>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-s>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-z>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-x>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-`>", function() harpoon:list():next() end)
vim.keymap.set("n", "<C-1>", function() harpoon:list():prev() end)

