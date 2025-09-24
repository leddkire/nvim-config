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
    end
    vim.system({"godot", "--path", project_root, path})
end

vim.keymap.set("n", "<leader>1", function () M.run_main_scene() end, {desc = "Run godot main scene" })
vim.keymap.set("n", "<leader>2", function ()
    local scene_path = vim.api.nvim_buf_get_name(0)
    M.run_scene(scene_path)
end
, {desc = "Run a specific godot scene" })

return M
