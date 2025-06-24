local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local colors = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "package.json actions",
        finder = finders.new_table {
            results = {
                {"red","#ff0000"},
                {"yellow","#00ff00"},
                {"blue", "#0000ff"},
            },
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry[1],
                    ordinal = entry[1],
                }
            end
        },

        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            print(vim.inspect(selection))
            vim.api.nvim_put({ selection.value[2] }, "", false, true)
          end)
          return true
        end,
    }):find()
end

local themes = require("telescope.themes")
return function(opts)
    colors(themes.get_dropdown(opts))
end

