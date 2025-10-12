vim.g.gdscript_recommended_style = 0

local M = {}

M.run_main_scene = function ()
    print(vim.cmd.pwd())
    local project_root = vim.fs.root(0, { "project.godot" })
    if(project_root == nil) then
        print("No project.godot file found, can't run main scene")
    else
        vim.system({"godot"})
    end
end

M.run_scene = function(path)
    print("Running scene: ", path)
    local project_root = vim.fs.root(path, { "project.godot" })
    P({"project_root: ", project_root})
    if(project_root == nil) then
        print("No project.godot file found, can't run scene: ", path)
    else
        vim.system({"godot", "--path", project_root, path})
    end
end

M.run_tests = function ()
    local project_root = vim.fs.root(0, { "project.godot" })
    if(project_root == nil) then
        print("No project.godot file found, can't run tests")
    else
        local test_script = vim.fs.find({'runtest.sh'}, { type = 'file' , path = project_root .. '/addons/gdUnit4/'})
        P(test_script)
        if(#test_script == 0) then
            print("no test script found, ensure that gdunit extension is installed")
        else
            print("running ", test_script[1])
            local cmd ={test_script[1], "--ignoreHeadlessMode", "--headless", "--continue", "-a", project_root}
            vim.cmd.vs()
            vim.cmd.terminal(cmd)
            vim.cmd.normal("i")
        end
    end
end

vim.keymap.set("n", "<leader>1", function () M.run_main_scene() end, {desc = "Run godot main scene" })
vim.keymap.set("n", "<leader>2", function ()
    local scene_path = vim.api.nvim_buf_get_name(0)
    M.run_scene(scene_path)
end
, {desc = "Run a specific godot scene" })

vim.keymap.set("n", "<leader>q",
    function () M.run_tests() end,
    {desc = "Run all unit tests"}
)
vim.keymap.set("n", "<leader>w",
    function () print("not implemented") end,
    {desc = "Run tests in current file"}
)
vim.keymap.set("n", "<leader>e",
    function () print("not implemented") end,
    {desc = "Run test / tests under cursor scope"}
)

return M
