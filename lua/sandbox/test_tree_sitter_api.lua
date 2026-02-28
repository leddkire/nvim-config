local new_set = MiniTest.new_set
local expect = MiniTest.expect
local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

--- Check  how offset query directive works. it might help getting the range for obtaining the correct node with --- The offset directive allows me to apply an offset, not to get the identation of the row.
local content = [[
    if 1 == 2 then
        local bar
    end
    if 1 == 2 then
        local foo
    end]]
T = new_set()
T['named_node_for_range on row 0'] = function ()
    local parser = ts.get_string_parser(content, "lua")
    parser:parse({1,0,1,0})
    local expected = trim([[
    if 1 == 2 then
        local bar
    end
    if 1 == 2 then
        local foo
    end
    ]])
    local node = parser:named_node_for_range({0, 0, 0, 0})
    expect.equality(ts.get_node_text(node, content), expected)
end
T['named_node_for_range on row 1'] = function ()
    local parser = ts.get_string_parser(content, "lua")
    parser:parse({1,0,1,0})
    local expected = trim([[
        local bar
    ]])
    -- We need to specify the starting column correctly, which is 8 (indent matters)
    -- The end column could be the same value but it can't surpass the row's last character
    local node = parser:named_node_for_range({1, 8, 1, 8})
    expect.equality(ts.get_node_text(node, content), expected)
end
-- it seems that startcol is inclusive and encol is exclusive? starting from 0
T['named_node_for_range on all rows'] = function ()
    local parser = ts.get_string_parser(content, "lua")
    parser:parse({1,0,1,0})
    local expected = trim([[
    if 1 == 2 then
        local bar
    end
    if 1 == 2 then
        local foo
    end
    ]])
    for i = 1, 10 do
        for j = 1, 18 do
                local params = {1,i,1,j}
                local node = parser:named_node_for_range(params)
                if(node ~= nil) then
                    P("node text: " .. ts.get_node_text(node, content))
                    local row_start, col_start, row_end, col_end = ts.get_node_range(node)
                    P("range: " .. vim.inspect({row_start, col_start, row_end, col_end}))
                    P("----------------------------")
            end
        end
    end
    expect.equality(true, true)
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return T
