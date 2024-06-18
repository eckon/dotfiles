local M = {}

---Hidden reference for all custom commands and how to execute them
---@type { [string]: { desc: string, callback: string | function } }
local custom_command_list = {}

---Structure to create and execute custom commands
M.custom_command = {
  ---Add/Overwrite a custom command
  ---@param name string
  ---@param opts { desc: string, callback: string | function }
  add = function(name, opts)
    custom_command_list[name] = opts
  end,

  ---Get all custom command names
  ---@return string[]
  keys = function()
    local keys = vim.tbl_keys(custom_command_list)
    table.sort(keys)
    return keys
  end,

  ---Get a specific custom command by name
  ---@param name string
  ---@return { desc: string, callback: string|function } | nil
  get = function(name)
    return custom_command_list[name]
  end,

  ---Execute a custom command by name
  ---@param command string
  execute = function(command)
    local selected_command = custom_command_list[command]
    local callback = selected_command.callback
    if selected_command == nil or callback == nil then
      return
    end

    if type(callback) == "string" then
      vim.cmd(callback)
    elseif type(callback) == "function" then
      callback()
    end
  end,
}

return M
