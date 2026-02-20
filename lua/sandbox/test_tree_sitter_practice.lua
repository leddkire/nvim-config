local new_set = MiniTest.new_set
local expect = MiniTest.expect
local ts = vim.treesitter
local tree_sitter_practice = require('sandbox.tree_sitter_practice')

T = new_set()
T['base cases'] = new_set()
T['base cases']['returns the local variable declaration before the cursor'] = function ()
    expect.equality(1, 2)
          --   local content = [[
          --   local foo = 2
          --   print("hello")
          -- ]]
          -- local language_trees = ts.get_string_parser(content, "lua")
          -- local tree = language_trees[1]
          -- P(tree)
          -- local query = [[
          --   (function_call (identifier) @name (#eq? @name "print"))
          -- ]]
          -- P(query)
          -- local parsed_query = ts.query.parse("lua", query)
          -- for _id, node, _metadata, _match in parsed_query:iter_matches(tree:root(), content) do
          --     T(node)
          --     local local_declarations = tree_sitter_practice.get_local_declarations(node, tree)
          --     assert.array_equals(local_declarations, {"foo"})
          -- end
end

return T
