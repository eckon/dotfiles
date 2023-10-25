local M = {}

---Return true or false depending on whether neovim should be started in minimal mode
---this is mainly as some things might not yet work on gigantic files,
---so we can manually disable them
---This is done via calling neovim with the var (see fish config)
---@return boolean
M.run_minimal = function()
  return vim.fn.exists("g:run_minimal") == 1
end

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

---Command completion function, to sort and filter passed complete values
---Example: As an config param in command
---{
---  nargs = "?",
---  complete = function(arg)
---    local names = {}
---    -- iterate and append names
---    --    table.insert(names, some_item)
---    return command_complete_filter(names, arg)
---  end,
---})
---@param completion_strings table
---@param passed_arguments table
---@return table
M.command_complete_filter = function(completion_strings, passed_arguments)
  -- filter completions out, which the caller did not type on the command line
  local filtered_completion_strings = vim.tbl_filter(function(s)
    return s:sub(1, #passed_arguments) == passed_arguments
  end, completion_strings)

  table.sort(filtered_completion_strings)

  return filtered_completion_strings
end

---Create augroup with my unique prefix
---@param name string
---@param options? table
---@return integer
M.augroup = function(name, options)
  return vim.api.nvim_create_augroup("eckon_augroup_" .. name, options or {})
end

---Create partial function to store mode and options
---Example: To get back a function with preset mode and options
---local nmap = bind_map("n")
---@param mode string|table
---@param outer_options? table
M.bind_map = function(mode, outer_options)
  ---Function to set a mapping of a given mode and a set of options
  ---@param lhs string
  ---@param rhs string|function
  ---@param inner_options? table
  return function(lhs, rhs, inner_options)
    local options = vim.tbl_extend("force", outer_options or {}, inner_options or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end
end

---Extend the treesitter foldtext to enhance it with custom information
---Like: Number of lines folded
---@return string|{ [1]: string, [2]: string[] }[]
M.foldtext = function()
  local ts_foldtext = vim.treesitter.foldtext()
  local line_counter = string.format("  --- [%s lines]", vim.v.foldend - vim.v.foldstart + 1)
  local formatted_foldtext = { line_counter, "Folded" }

  -- not yet sure when this happens, but added to be type-safe
  if type(ts_foldtext) == "string" then
    local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
    return { { line, "Normal" }, formatted_foldtext }
  end

  table.insert(ts_foldtext, formatted_foldtext)
  return ts_foldtext
end

---Get start and end positions of current visual selection
---@return { visual_start: { row: integer, column: integer }, visual_end: { row: integer, column: integer } }
M.get_visual_selection = function()
  -- both have the linenumber in 2nd place and rownumber in 3rd place
  local current_cursor = vim.fn.getpos(".") or {}
  local tail_visual_selection = vim.fn.getpos("v") or {}

  local start_position = current_cursor
  local end_position = tail_visual_selection

  if start_position[2] > end_position[2] then
    start_position, end_position = end_position, start_position
  end

  -- in case both are on the same line
  if start_position[2] == end_position[2] and start_position[3] > end_position[3] then
    start_position, end_position = end_position, start_position
  end

  return {
    visual_start = {
      row = start_position[2],
      column = start_position[3],
    },
    visual_end = {
      row = end_position[2],
      column = end_position[3],
    },
  }
end

---Save and restore the current cursor position
---This is useful for things that move the cursor but the user does want to keep it at the same position
---@return function restore callback to restore the previous cursor position
M.save_cursor_position = function()
  local initial_cursor_position = vim.api.nvim_win_get_cursor(0)
  return function()
    vim.api.nvim_win_set_cursor(0, initial_cursor_position)
  end
end

---List of mason packages to be installed later
---@type string[]
local to_ensured_packages = {}

---Structure to handle the installation of mason packages
M.ensure_package_installed = {
  ---Add a package to be installed later
  ---@param package_identifier string[]
  add = function(package_identifier)
    vim.tbl_map(function(p)
      if vim.tbl_contains(to_ensured_packages, p) then
        return
      end

      table.insert(to_ensured_packages, p)
    end, package_identifier)
  end,

  ---Execute the installation of all given packages once (in lsp config)
  execute = function()
    local function deferred_function()
      if #to_ensured_packages == 0 then
        vim.notify("No packages were provided to be installed - maybe the loading-order is wrong?")
        return
      end

      local registry = require("mason-registry")
      local lspconfig = require("mason-lspconfig")

      for _, package_identifier in ipairs(to_ensured_packages) do
        package_identifier = lspconfig.get_mappings().lspconfig_to_mason[package_identifier] or package_identifier

        local ok, pkg = pcall(registry.get_package, package_identifier)
        if ok then
          if not pkg:is_installed() then
            registry.refresh(function()
              vim.notify("Installing " .. package_identifier)
              pkg:install()
            end)
          end
        else
          vim.notify("Package " .. package_identifier .. " not found")
        end
      end
    end

    -- sometimes the registry is not yet loaded, so we defer the function
    -- not entirely sure why this works, but it is being done by other repos as well
    vim.defer_fn(deferred_function, 0)
  end,
}

------------------------------------------------------------------------------------------
----- Experimental implementations

---Create async job for running external commands and calling a callback on the output
---@class JobOptions
---@field command string
---@field args table
---@field on_stdout? fun(output: table)
---@field on_stderr? fun(output: table)
---@field on_completion? fun(stdout_output: table, stderr_output: table)
---@param options JobOptions
M.async_external_command = function(options)
  local stdout = vim.uv.new_pipe(false)
  local stderr = vim.uv.new_pipe(false)
  local stdout_output = {}
  local stderr_output = {}

  local args_string = ""
  vim.tbl_map(function(a)
    args_string = args_string .. " " .. a
  end, options.args)

  local handle
  handle, _ = vim.uv.spawn(options.command, {
    args = options.args,
    stdio = { nil, stdout, stderr },
    detached = true,
  }, function()
    vim.schedule(function()
      vim.notify('Execution of "' .. options.command .. args_string .. '" done')

      if type(options.on_stdout) == "function" then
        options.on_stdout(stdout_output)
      end
      if type(options.on_stderr) == "function" then
        options.on_stderr(stderr_output)
      end
      if type(options.on_completion) == "function" then
        options.on_completion(stdout_output, stderr_output)
      end
    end)

    if stdout ~= nil then
      stdout:read_stop()
      stdout:close()
    end

    if stderr ~= nil then
      stderr:read_stop()
      stderr:close()
    end

    if handle ~= nil then
      handle:close()
    end
  end)

  local combine_output_into_table = function(output_table)
    return function(err, data)
      assert(not err, err)
      if not data then
        return
      end
      table.insert(output_table, data)
    end
  end

  if stdout ~= nil then
    vim.uv.read_start(stdout, combine_output_into_table(stdout_output))
  end

  if stderr ~= nil then
    vim.uv.read_start(stderr, combine_output_into_table(stderr_output))
  end
end

return M
