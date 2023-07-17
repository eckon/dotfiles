local M = {}

---Return true or fales depending on whether neovim should be started in minimal mode
---this is mainly as some things might not yet work on gigantic files,
---so we can manually disable them
---This is done via calling nvim with the var (see fish config)
---@return boolean
local function run_minimal()
  return vim.fn.exists("g:run_minimal") == 1
end

---Create user command with 'CC'-prefix for quick access
---@param name string
---@param cmd string|function
---@param options? table
local function custom_command(name, cmd, options)
  options = options or {}
  vim.api.nvim_create_user_command("CC" .. name, cmd, options)
end

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
local function command_complete_filter(completion_strings, passed_arguments)
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
local function augroup(name, options)
  return vim.api.nvim_create_augroup("eckon_augroup_" .. name, options or {})
end

---Create partial function to store mode and options
---Example: To get back a function with preset mode and options
---local nmap = bind_map("n")
---@param mode string|table
---@param outer_options? table
local function bind_map(mode, outer_options)
  ---Function to set a mapping of a given mode and a set of options
  ---@param lhs string
  ---@param rhs string|function
  ---@param inner_options? table
  return function(lhs, rhs, inner_options)
    local options = vim.tbl_extend("force", outer_options or {}, inner_options or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end
end

------------------------------------------------------------------------------------------
----- Experimental implementations

---Create async job for running external commands and calling a callback on the output
---@class JobOptions
---@field command string
---@field args table
---@field on_stdout fun(output: table)
---@field on_stderr fun(output: table)
---@field on_completion fun(stdout_output: table, stderr_output: table)
---@param options JobOptions
local function async_external_command(options)
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

    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
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

  vim.uv.read_start(stdout, combine_output_into_table(stdout_output))
  vim.uv.read_start(stderr, combine_output_into_table(stderr_output))
end

------------------------------------------------------------------------------------------

----- Basic
M.run_minimal = run_minimal
M.bind_map = bind_map
M.custom_command = custom_command
M.command_complete_filter = command_complete_filter
M.augroup = augroup

----- Experimental
M.async_external_command = async_external_command

return M
