local co = require("lua.coroutine-utils.init")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

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

local function fs_read_cb(cb, fd, size, offset)
    return vim.uv.fs_read(fd, size, offset, cb)
end
local fs_read_co = co.cb_to_co(fs_read_cb)

local function read_file_co(path, signal_finished)
    --print(path)
    local err, fd = fs_open_co(path, "r", 666)
    if(err ~= nil) then
        print("error: " .. err)
    end
    --print("file descriptor: " .. fd)
    local data = ""
    local read_error, current_chunk = fs_read_co(fd, 1000, nil)
    if(err ~= nil) then
        print(read_error)
    end
    while current_chunk ~= "" do
        data = data .. current_chunk
        read_error, current_chunk = fs_read_co(fd, 1000, nil)
        if(err ~= nil) then
            print(read_error)
        end
    end
    fs_close_co(fd)
    --print("closed " .. fd .. ": " .. path)
    --print("data: " .. data)
    signal_finished(data)
end

-- transform: function that transforms the file contents before returning it
local function find_all_cb(cb, files, transform)
    local active_threads = 0
    local all_data = {}

   for _, file in ipairs(files) do
        local thread = coroutine.create(read_file_co)
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
local find_all_co = co.cb_to_co(find_all_cb)

local function find_co()
    local result = find_package_json_actions_co()
    --print("find command result: \n", result.stdout)
    local files = {}
    if result then
        files = split(result.stdout, "\n")
    end

    local transform = function(file_name, file_string)
        local json = vim.json.decode(file_string)
        local scripts = json.scripts
        local data = {}
        data.scripts = scripts
        data.file_name = file_name
        data.application_name = json.name
        return data
    end

    local data = find_all_co(files, transform)
    local output = {}
    for _, value in pairs(data) do
        --print("checking: ", vim.inspect(value))
        for script_name, script_contents in pairs(value.scripts) do
            local entry_data = {
                file_name = value.file_name,
                script_name = script_name,
                script_contents = script_contents,
                application_name = value.application_name
            }
            table.insert(output, entry_data)
        end
    end
    --print(vim.inspect(output))
    return output
end

-- co.fire_and_forget(find_co)

local commands_picker = function(opts, commands)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "package.json actions",
        finder = finders.new_table {
            results = commands,
            entry_maker = function(entry)
                --print(vim.inspect(entry))
                return {
                    value = entry,
                    display = entry.application_name .. ": " .. entry.script_name .. ": " .. entry.file_name,
                    ordinal = entry.application_name .. ": " .. entry.script_name,
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            --print("Selection: ", vim.inspect(selection))
            -- Send command to terminal and execute it
            -- vim.api.nvim_put({ "pnpm " .. selection.value.script_name }, "", false, true)
            vim.cmd.vs()
            local dir = vim.fs.dirname(selection.value.file_name)
            local script = selection.value.script_name
            vim.cmd.terminal("pnpm --dir " .. dir .. " " .. script)
            vim.cmd.normal("i")
          end)
          return true
        end,
    }):find()
end

local themes = require("telescope.themes")
local async_get_commands = coroutine.create(function (opts)
    local theme_opts = themes.get_dropdown(opts)
    local data = find_co()
    vim.schedule(function () commands_picker(theme_opts, data) end)
end)

--async_get_commands({})
--TODO: Load async once and store in memory
--TODO: Load again when cwd changes
coroutine.resume(async_get_commands, {})
return function(opts)
    coroutine.resume(async_get_commands, opts)
end



