-- dnote view tree_sitter_practice
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
    expect.equality(result, { "foo" })
end

T['cursor not at the end or beginning'] = new_set()
T['cursor not at the end or beginning']['only returns declarations before or at the specified line'] = function()
    local content = [[
    local foo
    local bar = 2
    local zip = "hey"
    ]]
    local row = 2
    local result = M.get_local_declarations(content, row)
    expect.equality(result, { "foo", "bar" })
end
T['if statements'] = new_set()
T['if statements']['Provide declarations within an if statement'] = function()
    local content = [[
    if 1 == 2 then
        local foo
    end
    ]]
    local result = M.get_local_declarations(content)
    expect.equality(result, { "foo" })
end
T['if statements']['Provide declarations within an if statement and all declarations before it'] = function()
    local content = [[
    local bar
    if 1 == 2 then
        local foo
        local zap
    end
    local hi
    ]]
    local row = 3
    local result = M.get_local_declarations(content, row)
    expect.equality(result, { "bar", "foo" })
end
T['if statements']['Dont provide declarations that are on a sibling if statement (not a parent)'] = function()
    local content = [[
    if 1 == 2 then
        local bar
    end
    if 1 == 2 then
        local foo
    end
    ]]
    local row = 5
    local result = M.get_local_declarations(content, row)
    expect.equality(result, { "foo" })
end

-- T['cursor at end of file']['returns the local variable declaration before the cursor'] = function()
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
-- end

return T
