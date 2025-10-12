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

local find_project_root = function ()
    local project_root = vim.fs.root(0, { "project.godot" })
    if(project_root == nil) then
        print("No project.godot file found")
    end
    return project_root
end

local run_in_terminal = function (opts)
    vim.cmd.vs()
    vim.cmd.terminal(opts.cmd)
    vim.cmd.normal("i")
end

M.run_tests = function ()
    local project_root = find_project_root()
    if(project_root == nil) then
        return
    end

    local cmd = {"godot", "--headless", "-d", "-s", "--path", project_root, "addons/gut/gut_cmdln.gd", "-gexit", "-gdir", project_root}
    run_in_terminal({ cmd = cmd, project_root = project_root, test_path = project_root })
end

M.run_test_file = function (path)
    local project_root = find_project_root()
    if(project_root == nil) then
        return
    end

    local cmd = {"godot", "--headless", "-s", "--path", project_root, "addons/gut/gut_cmdln.gd", "-gtest="..path, "-gexit"}
    run_in_terminal({ cmd = cmd })
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
    function ()
        local test_path = vim.api.nvim_buf_get_name(0)
        M.run_test_file(test_path)
    end,
    {desc = "Run tests in current file"}
)
vim.keymap.set("n", "<leader>e",
    function ()
        local test_path = vim.api.nvim_buf_get_name(0)

    end,
    {desc = "Run test / tests under cursor scope"}
)

return M
