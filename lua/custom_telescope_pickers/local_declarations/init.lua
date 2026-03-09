local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_utils = require "telescope.actions.utils"
local utils = require "telescope.utils"
local make_entry = require "telescope.make_entry"

-- This function initally was a copy of the pre-picker construction of the builtin.treesitter picker
-- located in ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/builtin/__files.lua
function fetch_results(opts)
    P(opts)
    opts.show_line = vim.F.if_nil(opts.show_line, true)
    opts.bufnr = vim.F.if_nil(opts.bufnr, 0)
    local ts = vim.treesitter
    local ft = vim.bo[opts.bufnr].filetype
    local lang = ts.language.get_lang(ft)

    if not (lang and ts.language.add(lang)) then
        utils.notify("builtin.treesitter", {
            msg = "No parser for the current buffer",
            level = "ERROR",
        })
        return
    end
    local query = ts.query.get(lang, "locals")
    if not query then
        utils.notify("builtin.treesitter", {
            msg = "No locals query for the current buffer",
            level = "ERROR",
        })
        return
    end

    local parser = assert(ts.get_parser(opts.bufnr))
    parser:parse()
    local root = parser:trees()[1]:root()

    local results = {}
    for id, node, _ in query:iter_captures(root, opts.bufnr) do
        local kind = query.captures[id]

        if node and vim.startswith(kind, "local.definition") then
            table.insert(results, { kind = kind:gsub("^local%.definition", ""):gsub("^%.", ""), node = node })
        end
    end

    return utils.filter_symbols(results, opts)
end

local local_declarations = function(opts)
    opts = opts or {}
    local results = fetch_results(opts)

    pickers.new(opts, {
        prompt_title = "Print local declarations",
        finder = finders.new_table {
            results = results,
            entry_maker = opts.entry_maker or make_entry.gen_from_treesitter(opts),
        },
        previewer = conf.grep_previewer(opts),
        sorter = conf.prefilter_sorter {
            tag = "kind",
            sorter = conf.generic_sorter(opts),
        },
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local selected_entries = { selection.text }
                local formatted_string = selection.text
                action_utils.map_selections(prompt_bufnr, function(entry, index)
                    table.insert(selected_entries, entry.text)
                    formatted_string = formatted_string .. "," .. entry.text
                end)
                actions.close(prompt_bufnr)
                vim.api.nvim_put({ "print(" .. formatted_string .. ")" }, "l", false, true)
            end)
            return true
        end,
    }):find()
end
-- to execute the function
local themes = require "telescope.themes"

local_declarations()
return function(opts)
    local_declarations(opts)
end
