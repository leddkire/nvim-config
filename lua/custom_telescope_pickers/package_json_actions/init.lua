local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local async = require "plenary.async"
local control = require "plenary.async.control"
local file = require "custom_telescope_pickers.package_json_actions.file"

local notify_get_commands_finished, await_get_commands = control.channel.oneshot()

local get_commands = function()
    notify_get_commands_finished, await_get_commands = control.channel.oneshot()
    local notify_read_finished, await_extract_script  = control.channel.mpsc()
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
                    data.application_name = json.name
                    notify_read_finished.send(data)
                end)
            end
        end)
    else
        print("No package.json files found")
    end

    local data = {}
    async.run(function ()
        for _=1,file_count do
            local received = await_extract_script.recv()
            print(vim.inspect(received))
            for idx,v in pairs(received.scripts) do
                print(idx, v)
                -- TODO: Create command field which concatenates the script_name with the pnpm command
                -- Also detect the cwd directory and switch to the selected commands package.json directory before running
                -- Later on it will detect the correct package manager 
                local script_data = {
                    file_name = received.file_name,
                    script_name = idx,
                    script_contents = v,
                    application_name = received.application_name
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

local commands_picker = function(opts, commands)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "package.json actions",
        finder = finders.new_table {
            results = commands,
            entry_maker = function(entry)
                print(vim.inspect(entry))
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
            print("Selection: ", vim.inspect(selection))
            -- Send command to terminal and execute it
            vim.api.nvim_put({ "pnpm " .. selection.value.script_name }, "", false, true)
          end)
          return true
        end,
    }):find()
end
local themes = require("telescope.themes")
local async_get_commands = function (opts)
    local theme_opts = themes.get_dropdown(opts)
    async.run(function ()
       get_commands()
       local data = await_get_commands()
       vim.schedule(function () commands_picker(theme_opts, data) end)
    end)
end

async_get_commands({})
return function(opts)
    async_get_commands(opts)
end
