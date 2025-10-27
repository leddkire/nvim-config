local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED
--
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-o>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-p>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-[>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-]>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<M-p>", function() harpoon:list():next() end)
-- vim.keymap.set("n", "<M-o>", function() harpoon:list():prev() end)

