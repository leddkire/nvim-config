local T = MiniTest:new_set()
local expect = MiniTest.expect
local ts = vim.treesitter

-- row is 1-indexed
---@param parser vim.treesitter.LanguageTree
---@param row number
local get_node_at_row = function (parser, row)
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

T['no blocks'] = MiniTest:new_set()
T['no blocks']['empty input returns empty text'] = function ()
    local input = ""
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 1)

    expect.equality(result_text, "")
end
T['no blocks']['single line with row 1 returns that node'] = function ()
    local input = "local foo"
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 1)

    expect.equality(result_text, "local foo")
end
T['no blocks']['two lines with row 1 returns the first line'] = function ()
    local input = "local foo\nlocal bar"
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 1)

    expect.equality(result_text, "local foo")
end
T['no blocks']['two lines with row 2 returns the second line'] = function ()
    local input = "local foo\nlocal bar"
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 2)

    expect.equality(result_text, "local bar")
end

T['single block with 1 line inside'] = MiniTest:new_set()
T['single block with 1 line inside']['requesting row 1 will return the block'] = function ()
    local input = "if(true == true) then\n    local foo\nend"
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 1)

    local expected ="if(true == true) then\n    local foo\nend"
    expect.equality(result_text, expected)
end
T['single block with 1 line inside']['requesting row 2 will return the local declaration'] = function ()
    local input = "if(true == true) then\n    local foo\nend"
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 2)

    local expected ="local foo"
    expect.equality(result_text, expected)
end

function get_text_for_node_at_row(parser, row)
    local result = get_node_at_row(parser, row)
    return ts.get_node_text(result, parser:source())
end

function build_parser(content)
    local parser = ts.get_string_parser(content, "lua")
    parser:parse()
    return parser
end

return T
