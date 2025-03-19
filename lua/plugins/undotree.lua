if jit.os == "Windows" then
    vim.g.undotree_DiffCommand = "FC"
end

return {
    "mbbill/undotree",
}
