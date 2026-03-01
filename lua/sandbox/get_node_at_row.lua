local ts = vim.treesitter
local M = {}
-- row is 1-indexed
---@param parser vim.treesitter.LanguageTree
---@param row number
M.get_node_at_row = function (parser, row)
    P("input string: " .. parser:source())
    local requested_row = row-1
    local input_range = {requested_row, 0, requested_row, 0}
    P("starting node search with range: " .. vim.inspect(input_range))
    local node = parser:named_node_for_range(input_range)
    if(node == nil) then
        P("ERROR get_node_at_row: got a nil value when looking for a named node in range: " .. vim.inspect(input_range))
        return nil
    end
    local row_start, col_start, row_end, col_end = ts.get_node_range(node)
    local range_table = { row_start, col_start, row_end, col_end }
    P("first search result has range: " .. vim.inspect(range_table))
    if(input_range[1] ~= row_start) then
        -- either keep requesting named_node_for_range with increasing colstart
        -- or iterate over children until we find one with the same requested row
        print("The node isn't on the requested row, starting to narrow down columns... requested_row=" .. requested_row .. ", node_row=" .. row_start)
        local col_max = 1000
        for i = col_start, col_max, 1 do
            print("checking column: " .. i)
            local check_range = {requested_row, i, requested_row, i}
            local check_node = parser:named_node_for_range(check_range)
            local node_row = ts.get_node_range(check_node)
            if(node_row == requested_row) then
                print("found the node")
                local node_text = ts.get_node_text(check_node, parser:source())
                print(node_text)
                node = check_node
                break
            end
        end

    end
    return node
end

return M
