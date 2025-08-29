local co = require("lua.coroutine-utils.init")

vim.cmd.messages("clear")

local function vim_system_cb(cb, cmd, opts)
    vim.system(cmd, opts, cb)
end
local vim_system_co = co.cb_to_co(vim_system_cb)

local function find_package_json_actions_co()
    local result = vim_system_co({'find', '.', '-name', 'package.json', '-not', '-path', '*/node_modules/*'}, { text = true })
    return result
end

local function split(input, pattern)
    local output = {}
    for i in string.gmatch(input,"[^" .. pattern .. "]+") do
        table.insert(output, i)
    end
    return output
end

local function fs_open_cb(cb, path, flags, mode)
    return vim.uv.fs_open(path, flags, mode, cb)
end
local fs_open_co = co.cb_to_co(fs_open_cb)

local function fs_close_cb(cb, fd)
    return vim.uv.fs_close(fd, cb)
end
local fs_close_co = co.cb_to_co(fs_close_cb)

local function read_file_co(path, signal_finished)
    print(path)
    local err, fd = fs_open_co(path, "r", 666)
    if(err ~= nil) then
        print("error: " .. err)
    end
    print("file descriptor: " .. fd)
    fs_close_co(fd)
    print("closed " .. fd .. ": " .. path)
    signal_finished()
end

local function find_co()
    local result = find_package_json_actions_co()
    print("find command result: \n", result.stdout)
    local files = {}
    if result then
        files = split(result.stdout, "\n")
    end
    --print(vim.inspect(files))
    local threads = {}
    local active_threads = 0
    local remove_thread = function(thread)
        print("number of active threads: " .. active_threads)
        print("received signal to end thread: " .. vim.inspect(thread))
        for i in pairs(threads) do
            if(i == thread) then
                active_threads = active_threads - 1
            end
        end
        if(active_threads == 0) then
            print("Finished all threads!")
            print(vim.inspect(threads))
        end
    end

    for i, file in ipairs(files) do
        local thread = coroutine.create(read_file_co)
        threads[thread] = "true"
        local signal_finished = function ()
            remove_thread(thread)
        end
        coroutine.resume(thread, file, signal_finished)
        active_threads = active_threads + 1
    end
    print("Created all threads: " .. vim.inspect(threads))
    --Create results table
end

co.fire_and_forget(find_co)



