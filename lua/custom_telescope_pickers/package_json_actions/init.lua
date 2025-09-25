local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local fs = require "coroutine-utils.file_co"
local vim_co = require "coroutine-utils.vim_co"

local function find_package_json_actions_co()
    local result = vim_co.vim_system_co({'fd', 'package\\.json', '--type', 'file', '--exclude','node_modules'}, { text = true })
    return result
end

local function split(input, pattern)
    local output = {}
    for i in string.gmatch(input,"[^" .. pattern .. "]+") do
        table.insert(output, i)
    end
    return output
end

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

    local data = fs.read_all_co(files, transform)
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

--TODO: Load async once and store in memory
--TODO: Load again when cwd changes
--  coroutine.resume(async_get_commands, opts)
return function(opts)
    coroutine.resume(async_get_commands, opts)
end



