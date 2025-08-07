local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local async = require "plenary.async"
local control = require "plenary.async.control"
local file = require "custom_telescope_pickers.package_json_actions.file"

local notify_read_finished, await_extract_script  = control.channel.mpsc()
local notify_get_commands_finished, await_get_commands = control.channel.oneshot()

local get_commands = function()
    local find_package_json = io.popen("find . -name package.json -not -path '*/node_modules/*'")
    local files = {}
    --print("find_package_json:", find_package_json)
    if find_package_json then
        for l in find_package_json:lines() do
            table.insert(files, l)
        end
        find_package_json:close()
    else
        print("Failed to find package.json files")
    end


    --TODO: data can't be accumulated in this async context
    -- figure out how to accumulate the data for the picker
    local file_count = table.getn(files)
    if(file_count ~= 0) then
        async.run(function ()
            for i in pairs(files) do
                local fileName = files[i]
                async.run(function ()
                    --print("Getting file ", fileName)
                    local fileData = file.get_file_contents_async(fileName)
                    local result = {}
                    result.file_data = fileData
                    result.file_name = fileName
                    return result
                end, function (result)
                    local json = vim.json.decode(result.file_data)
                    --print(vim.inspect(json))
                    local scripts = json.scripts
                    local data = {}
                    data.scripts = scripts
                    data.file_name = result.file_name
                    notify_read_finished.send(data)
                end)
            end
        end)
    else
        print("No package.json files found")
    end

    local data = {}
    async.run(function ()
        for i=1,file_count do
            local received = await_extract_script.recv()
            print(vim.inspect(received))
            for idx,v in pairs(received.scripts) do
                print(idx, v)
                local script_data = {
                    file_name = received.file_name,
                    script_name = idx,
                    script_contents = v,
                }
                print("inserting data: ", vim.inspect(script_data))
                table.insert(data, script_data)
            end
            print("received data: ", vim.inspect(data))
        end
    end, function ()
        print("get_commands data: ", vim.inspect(data))
        notify_get_commands_finished(data)
    end)
end

local colors = function(opts, commands)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "package.json actions",
        finder = finders.new_table {
            results = commands,
            entry_maker = function(entry)
                print(vim.inspect(entry))
                return {
                    value = entry,
                    display = entry.script_name .. ": " .. entry.file_name,
                    ordinal = entry.script_name .. ": " .. entry.file_name,
                }
            end
        },

        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.api.nvim_put({ selection.value[1] }, "", false, true)
          end)
          return true
        end,
    }):find()
end

local themes = require("telescope.themes")
-- async.run(function ()
--    get_commands()
--    local data = await_get_commands()
--    vim.schedule(function () colors({}, data) end)
-- end)
--TODO: return the function here with the theme
return function(opts)
end
