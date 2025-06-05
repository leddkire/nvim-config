local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    }
}

return { M }
