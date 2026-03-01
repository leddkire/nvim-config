local T = MiniTest:new_set()
local expect = MiniTest.expect
local ts = vim.treesitter
local get_node_at_row = require("sandbox.get_node_at_row").get_node_at_row

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
T['single block with 1 line inside']['requesting row 3 will return the block'] = function ()
    local input = "if(true == true) then\n    local foo\nend"
    local parser = build_parser(input)

    local result_text = get_text_for_node_at_row(parser, 3)

    local expected ="if(true == true) then\n    local foo\nend"
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
