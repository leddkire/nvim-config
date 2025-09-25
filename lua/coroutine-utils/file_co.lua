local co = require("coroutine-utils.init")

local M = {}

local function fs_open_cb(cb, path, flags, mode)
    return vim.uv.fs_open(path, flags, mode, cb)
end
M.fs_open_co = co.cb_to_co(fs_open_cb)

local function fs_close_cb(cb, fd)
    return vim.uv.fs_close(fd, cb)
end
M.fs_close_co = co.cb_to_co(fs_close_cb)

local function fs_read_cb(cb, fd, size, offset)
    return vim.uv.fs_read(fd, size, offset, cb)
end
M.fs_read_co = co.cb_to_co(fs_read_cb)

M.read_file_co = function(path, signal_finished)
    --print(path)
    local err, fd = M.fs_open_co(path, "r", 666)
    if(err ~= nil) then
        print("error: " .. err)
    end
    --print("file descriptor: " .. fd)
    local data = ""
    local read_error, current_chunk = M.fs_read_co(fd, 1000, nil)
    if(err ~= nil) then
        print(read_error)
    end
    while current_chunk ~= "" do
        data = data .. current_chunk
        read_error, current_chunk = M.fs_read_co(fd, 1000, nil)
        if(err ~= nil) then
            print(read_error)
        end
    end
    M.fs_close_co(fd)
    --print("closed " .. fd .. ": " .. path)
    --print("data: " .. data)
    signal_finished(data)
end

local function read_all_cb(cb, files, transform)
    local active_threads = 0
    local all_data = {}

   for _, file in ipairs(files) do
        local thread = coroutine.create(M.read_file_co)
        local signal_finished = function (data)
            table.insert(all_data, transform(file, data))
            active_threads = active_threads - 1
            if(active_threads == 0) then
                --print("Finished all threads!")
                --print(vim.inspect(threads))
                cb(all_data)
            end
        end
        coroutine.resume(thread, file, signal_finished)
        active_threads = active_threads + 1
    end
    --print("Created all threads: " .. vim.inspect(threads))
end
M.read_all_co = co.cb_to_co(read_all_cb)

return M
