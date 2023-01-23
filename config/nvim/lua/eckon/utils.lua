local M = {}

---Create user command with 'CC'-prefix for quick access
---@param name string
---@param cmd string|function
---@param options? table
local function custom_command(name, cmd, options)
  options = options or {}
  vim.api.nvim_create_user_command("CC" .. name, cmd, options)
end

---Command completion function, to sort and filter passed complete values
---@param completion_strings table
---@param passed_arguments table
---@return table
local function command_complete_filter(completion_strings, passed_arguments)
  -- filter completions out, which the caller did not type on the command line
  local filtered_completion_strings = vim.tbl_filter(
    function(s) return s:sub(1, #passed_arguments) == passed_arguments end,
    completion_strings
  )

  table.sort(filtered_completion_strings)

  return filtered_completion_strings
end

M.custom_command = custom_command
M.command_complete_filter = command_complete_filter

---Create async job for running external commands and calling a callback on the output
---@class JobOptions
---@field command string
---@field args table
---@field on_stdout fun(output: table)
---@field on_stderr fun(output: table)
---@field on_completion fun(stdout_output: table, stderr_output: table)
---@param options JobOptions
local function async_external_command(options)
  local uv = vim.loop
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local stdout_output = {}
  local stderr_output = {}

  local args_string = ""
  vim.tbl_map(function(a) args_string = args_string .. " " .. a end, options.args)

  local handle
  handle, _ = uv.spawn(options.command, {
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

  uv.read_start(stdout, combine_output_into_table(stdout_output))
  uv.read_start(stderr, combine_output_into_table(stderr_output))
end

M.async_external_command = async_external_command

---Create partial function to store mode and options
---@param mode string|table
---@param outer_options? table
local function bind_map(mode, outer_options)
  outer_options = outer_options or { noremap = true }

  ---Function to set a mapping of a given mode and a set of options
  ---@param lhs string
  ---@param rhs string|function
  ---@param inner_options? table
  return function(lhs, rhs, inner_options)
    local options = vim.tbl_extend("force", outer_options, inner_options or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end
end

M.nmap = bind_map("n", { noremap = false })
M.noremap = bind_map({ "n", "v", "o" })

M.nnoremap = bind_map("n")
M.inoremap = bind_map("i")
M.vnoremap = bind_map("v")

M.onoremap = bind_map("o")
M.xnoremap = bind_map("x")

return M
