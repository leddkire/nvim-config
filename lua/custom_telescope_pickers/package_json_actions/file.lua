local async = require "plenary.async"
local get_file_contents_async = function(path)
    local err, fd = async.uv.fs_open(path, "r", 438)
    assert(not err, err)

    local err, stat = async.uv.fs_fstat(fd)
    assert(not err, err)

    local err, data = async.uv.fs_read(fd, stat.size, 0)
    assert(not err, err)

    err = async.uv.fs_close(fd)
    assert(not err, err)

    return data
end

-- For testing
-- async.run(function()
--     local data = get_file_contents("./init.lua")
--     print(data)
-- end)
local file = {}
file['get_file_contents_async'] = get_file_contents_async
return file
