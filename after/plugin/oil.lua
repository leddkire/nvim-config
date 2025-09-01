require("oil").setup({
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-r>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["<C-p>"] = {"actions.preview", opts={horizontal=true, split="botright"}},
        ["<C-s>"] = {"actions.select", opts={horizontal=true, split="botright"}},
        ["<C-v>"] = {"actions.select", opts={vertical=true}},
    },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
})

