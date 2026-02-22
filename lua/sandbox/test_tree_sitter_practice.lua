local new_set = MiniTest.new_set
local expect = MiniTest.expect
local ts = vim.treesitter
-- Module must be loaded this way in order to test any changes made to it.
-- If instead we use require, then I would need to add some fancy module reloading on
--   a child neovim instance
dofile('lua/sandbox/tree_sitter_practice.lua')

T = new_set()
T['cursor at end of file'] = new_set()

T['cursor at end of file']['returns and empty array when content is empty'] = function()
    local content = ""
    local result = M.get_local_declarations(content)
    expect.equality(result, {})
end

T['cursor at end of file']['returns the local declaration if it is the only line'] = function()
    local content = "local foo = 1"
    local result = M.get_local_declarations(content)
    expect.equality(result, { "foo" })
end

T['cursor at end of file']['returns both declarations if they are in the same line'] = function()
    local content = "local foo, bar = 1, 2"
    local result = M.get_local_declarations(content)
    expect.equality(result, { "foo", "bar" })
end

T['cursor at end of file']['returns both declarations if they are in different lines'] = function()
    local content = [[
        local foo = 1
        local bar = 2
    ]]
    local result = M.get_local_declarations(content)
    expect.equality(result, { "foo", "bar" })
end
T['cursor at end of file']['does not include print statement'] = function()
    local content = [[
        print("hi")
    ]]
    local result = M.get_local_declarations(content)
    expect.equality(result, {})
end
T['cursor at end of file']['returns locally defined variable without assignment'] = function()
    local content = [[
        local foo
    ]]
    local result = M.get_local_declarations(content)
    expect.equality(result, {"foo"})
end

T['cursor at end of file']['returns the local variable declaration before the cursor'] = function()
    -- local content = [[
    --         local foo = 2
    --         print("hello")
    --       ]]
    -- local parser = ts.get_string_parser(content, "lua")
    -- local tree = parser:parse()[1]
    -- local root = tree:root()
    -- local query = [[
    --         (function_call (identifier) @name (#eq? @name "print"))
    --       ]]
    -- P(query)
    -- local parsed_query = ts.query.parse("lua", query)
    -- local results = {}
    -- for _id, node, _metadata, _match in parsed_query:iter_matches(root, content) do
    --     T(node)
    --     local local_declarations = tree_sitter_practice.get_local_declarations(node, tree)
    --     for elem in local_declarations do
    --         table.insert(results, elem)
    --     end
    -- end
    -- expect.equality(results, { "foo" })
end

return T
