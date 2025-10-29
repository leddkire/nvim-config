P = function (v)
    print(vim.inspect(v))
    return v
end

DumpCmd = function (cmd, split_direction)
    if(split_direction == 'v') then
        vim.cmd.vs()
    else
        vim.cmd.sp()
    end
    vim.cmd.enew()
    vim.cmd("put=execute('" .. cmd .. "')")
end

