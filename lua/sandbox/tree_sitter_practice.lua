local ts_utils = require 'nvim-treesitter.ts_utils'
local ts = vim.treesitter

-- Exercise: show in a separate buffer which variables are in scope under the cursor
-- Once we can do that, we'll be able to generate a print statement with those values
-- We want to capture:
--  local declarations that appear at or before the cursor
--  function parameters (if the cursor is within one)
--  declarations on outer scope that appear before the cursor
--    outer scope function parameters
-- use child_with_descendant
-- Filtering for those matches that are above the current cursor node could be achieved by:
--   If the node has a child with the current cursor node as a descendant, then we can capture all local declarations in its children.
--   If the node had function parameters and has a child that is a direct descendant of the current cursore node, then we add those function parameters to the list of captures.
--
-- One idea is to get the current node and navigate from the root to it.
-- For each step we can run a query that captures the local declarations and filter out those that are declared after the current node.

local build_print_string = function(arg_list)
    local printstring = "P({"
    local varstring = ""
    for i in ipairs(arg_list) do
        if #varstring ~= 0 then
            varstring = varstring .. ","
        end
        varstring = varstring .. arg_list[i]
    end

    printstring = printstring .. varstring .. "})"
    return printstring
end

local get_updated_tree_root = function()
    local tree = parser:parse()[1]
    return tree:root()
end

vim.keymap.set('n', '<leader>t1', function()
    local parser = ts.get_parser()
    local query = ts.query.parse('lua', [[
	(variable_declaration
	  [
	   (assignment_statement
	    (variable_list
	      (identifier) @var_id
	      )
	    )
	    (variable_list
	      (identifier) @var_id
	      )
	  ]
	  )
	]])
    local root = get_updated_tree_root()
    local varlist = {}
    for id, node, metadata in query:iter_captures(root, 0) do
        local node_text = ts.get_node_text(node, vim.api.nvim_get_current_buf())
        table.insert(varlist, node_text)
    end
    local output = build_print_string(varlist)
    vim.api.nvim_put({ output }, "l", true, true)
end, { desc = "gets all local declarations in current buffer" })

vim.keymap.set('n', '<leader>t2', function()
    local parser = ts.get_parser()
    local query = ts.query.parse('lua', [[
	(variable_declaration
	  [
	   (assignment_statement
	    (variable_list
	      (identifier) @var_id
	      )
	    )
	    (variable_list
	      (identifier) @var_id
	      )
	  ]
	  )
	]])
    local root = get_updated_tree_root()
    local current_node = ts_utils.get_node_at_cursor()
    local child = root:child_with_descendant(current_node)
    local buffer = vim.api.nvim_get_current_buf()
    local child_text = ts.get_node_text(child, buffer)
    local varlist = {}
    for id, node, metadata in query:iter_captures(root, 0) do
        local node_text = ts.get_node_text(node, buffer)
        table.insert(varlist, node_text)
    end
    local output = build_print_string(varlist)
    vim.api.nvim_put({ child_text }, "l", true, true)
    vim.api.nvim_put({ output }, "l", true, true)
end)

local win
local buf
vim.keymap.set('n', '<leader>tw', function()
    if win ~= nil then
        vim.api.nvim_win_close(win, true)
        win = nil
        vim.api.nvim_buf_delete(buf, { force = true })
        buf = nil
        return
    end
    buf = vim.api.nvim_create_buf(false, true)
    local opts = {
        relative = 'cursor',
        width = 10,
        height = 2,
        col = 0,
        row = 1,
        anchor = 'NW',
        style = 'minimal'
    }
    win = vim.api.nvim_open_win(buf, false, opts)
end)

-- I can create treesitter queries and execute them to get the information I need as well. I should investigate how to do that too.

M = {}
M.get_local_declarations = function(content)
    if content == "" then
        return {}
    end

    local foo
    local parser = ts.get_string_parser(content, "lua")
    local tree = parser:parse()[1]
    local root = tree:root()
    local query_string = [[
        (
            [
            (variable_declaration (
                assignment_statement (
                    variable_list (
                        identifier
                    ) @local_identifier
                )
            ))
            (variable_declaration (
                variable_list (
                    identifier
                ) @local_identifier
            ) )
            ]
        )
    ]]
    local query = ts.query.parse("lua", query_string)

    local declaration_list = {}
    ---@diagnostic disable-next-line: unused-local
    for id, node, metadata in query:iter_captures(root, 0) do
        local node_text = ts.get_node_text(node, content)
        table.insert(declaration_list, node_text)
    end

    return declaration_list
end
return M
