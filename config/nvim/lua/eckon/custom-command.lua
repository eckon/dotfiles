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
    local selected_command = M.custom_command.get(command)
    if selected_command == nil or selected_command.callback == nil then
      return
    end

    local cb = selected_command.callback
    if type(cb) == "string" then
      vim.cmd(cb)
    elseif type(cb) == "function" then
      cb()
    end
  end,

  ---Open a menu to select a custom command
  open_select = function()
    local longest_name_len = 0
    for _, name in ipairs(M.custom_command.keys()) do
      if #name > longest_name_len then
        longest_name_len = #name
      end
    end

    vim.ui.select(M.custom_command.keys(), {
      prompt = "Custom Command",
      format_item = function(item)
        -- pad command name with spaces to align the description
        local padded_item = ("%-" .. longest_name_len .. "s"):format(item)
        local formatted_item = padded_item .. "   " .. M.custom_command.get(item).desc

        -- truncate to not run over the selection window
        local max_len = 80
        if #formatted_item > max_len then
          formatted_item = formatted_item:sub(1, max_len) .. "…"
        end

        return formatted_item
      end,
    }, function(choice)
      if choice == nil then
        return
      end

      M.custom_command.execute(choice)
    end)
  end,
}

return M
